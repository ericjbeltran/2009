using System;
using System.Globalization;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using GalleryServerPro.Business;
using GalleryServerPro.Business.Interfaces;
using GalleryServerPro.Web.Controller;

namespace GalleryServerPro.Web.gs.pages.task
{
	public partial class editcaptions : Pages.TaskPage
	{
		#region Event Handlers

		protected void Page_Init(object sender, EventArgs e)
		{
			this.TaskHeaderPlaceHolder = phTaskHeader;
			this.TaskFooterPlaceHolder = phTaskFooter;
		}

		protected void Page_Load(object sender, EventArgs e)
		{
			this.CheckUserSecurity(SecurityActions.EditMediaObject);

			if (!IsPostBack)
			{
				ConfigureControls();
			}
		}

		protected override bool OnBubbleEvent(object source, EventArgs args)
		{
			//An event from a control has bubbled up.  If it's the Ok button, then run the
			//code to synchronize; otherwise ignore.
			Button btn = source as Button;
			if ((btn != null) && (((btn.ID == "btnOkTop") || (btn.ID == "btnOkBottom"))))
			{
				Message msg = btnOkClicked();

				if (msg == Message.None)
					this.RedirectToAlbumViewPage();
				else
					this.RedirectToAlbumViewPage("msg={0}", ((int)msg).ToString(CultureInfo.InvariantCulture));
			}

			return true;
		}

		#endregion

		#region Private Methods

		private void ConfigureControls()
		{
			this.TaskHeaderText = Resources.GalleryServerPro.Task_Edit_Captions_Header_Text;
			this.TaskBodyText = String.Format(CultureInfo.CurrentCulture, Resources.GalleryServerPro.Task_Edit_Captions_Body_Text, GalleryServerPro.Configuration.ConfigManager.GetGalleryServerProConfigSection().DataStore.MediaObjectTitleLength);
			this.OkButtonText = Resources.GalleryServerPro.Task_Edit_Captions_Ok_Button_Text;
			this.OkButtonToolTip = Resources.GalleryServerPro.Task_Edit_Captions_Ok_Button_Tooltip;

			this.PageTitle = Resources.GalleryServerPro.Task_Edit_Captions_Page_Title;

			IGalleryObjectCollection albumChildren = this.GetAlbum().GetChildGalleryObjects(GalleryObjectType.MediaObject, true);

			if (albumChildren.Count > 0)
			{
				const int textareaWidthBuffer = 30; // Extra width padding to allow room for the caption.
				const int textareaHeightBuffer = 72; // Extra height padding to allow room for the caption.
				SetThumbnailCssStyle(albumChildren, textareaWidthBuffer, textareaHeightBuffer);

				rptr.DataSource = albumChildren;
				rptr.DataBind();
			}
			else
			{
				this.RedirectToAlbumViewPage("msg={0}", ((int)Message.CannotEditCaptionsNoEditableObjectsExistInAlbum).ToString(CultureInfo.InvariantCulture));
			}
		}

		private Message btnOkClicked()
		{
			return saveCaptions();
		}

		private Message saveCaptions()
		{
			// Iterate through all the textboxes, saving any captions that have changed.
			// The media object IDs are stored in a hidden input tag.
			HtmlTextArea ta;
			HtmlInputHidden gc;
			IGalleryObject mo;
			string newTitle, previousTitle;
			Message msg = Message.None;
			int maxTitleLength = GalleryServerPro.Configuration.ConfigManager.GetGalleryServerProConfigSection().DataStore.MediaObjectTitleLength;

			if (!IsUserAuthorized(SecurityActions.EditMediaObject))
				return msg;

			try
			{
				HelperFunctions.BeginTransaction();

				// Loop through each item in the repeater control. If an item is checked, extract the ID.
				foreach (RepeaterItem rptrItem in rptr.Items)
				{
					ta = (HtmlTextArea)rptrItem.Controls[1]; // The <TEXTAREA> tag
					gc = (HtmlInputHidden)rptrItem.Controls[3]; // The hidden <input> tag

					// Retrieve new title. Since the Value property of <TEXTAREA> HTML ENCODEs the text,
					// and we want to store the actual text, we must decode to get back to the original.
					newTitle = Util.HtmlDecode(ta.Value);

					mo = Factory.LoadMediaObjectInstance(Convert.ToInt32(gc.Value, CultureInfo.InvariantCulture));
					previousTitle = mo.Title;

					mo.Title = Util.CleanHtmlTags(newTitle);

					if (mo.Title.Length > maxTitleLength)
					{
						// This caption exceeds the maximum allowed length. Set message ID so that user
						// can be notified. This caption will be truncated when saved to the databse.
						msg = Message.OneOrMoreCaptionsExceededMaxLength;
					}

					if (mo.Title != previousTitle)
						GalleryObjectController.SaveGalleryObject(mo);
				}
				HelperFunctions.CommitTransaction();
			}
			catch
			{
				HelperFunctions.RollbackTransaction();
				throw;
			}

			HelperFunctions.PurgeCache();

			return msg;
		}

		#endregion
	}
}