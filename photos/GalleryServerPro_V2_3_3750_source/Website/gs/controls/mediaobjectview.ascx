<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="mediaobjectview.ascx.cs"
	Inherits="GalleryServerPro.Web.Controls.mediaobjectview" %>
<%@ Register namespace="ComponentArt.Web.UI" assembly="ComponentArt.Web.UI" tagPrefix="ComponentArt" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Import Namespace="GalleryServerPro.Web" %>

<script type="text/javascript">
	Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(moViewPageLoad);
</script>
<div id="divMoView" style="width: <% =MediaObjectContainerWidth %>px;" class="gsp_addleftpadding1">
	<table id="toolbarContainer" style="width: <% = ToolbarContainerWidth.ToString() %>px;">
		<tr>
			<td style="width: 42px;">
				<img id="imgPrevious" src="<%= Util.GalleryRoot %>/images/left_arrow.png" class="gsp_navleft gsp_addpadding2"
					onclick="showPrevMediaObject();" alt='<asp:Literal runat="server" Text="<%$ Resources:GalleryServerPro, UC_MediaObjectView_Previous_Text%>" />'
					title='<asp:Literal runat="server" Text="<%$ Resources:GalleryServerPro, UC_MediaObjectView_Previous_Tooltip%>" />' />
			</td>
			<td id="toolbarCell" style="width: 100%;">
				<ComponentArt:ToolBar ID="tbMediaObjectActions" runat="server" Style="display:block;" EnableViewState="true" AutoPostBackOnSelect="false"
					AutoPostBackOnCheckChanged="false"
					DefaultItemTextImageSpacing="2" DefaultItemTextImageRelation="ImageOnly" DefaultItemImageHeight="16"
					DefaultItemImageWidth="16" ItemSpacing="1" Orientation="Horizontal" UseFadeEffect="false"
					OnItemCommand="tbMediaObjectActions_ItemCommand" CssClass="gsp_toolbar gsp_rounded10" DefaultItemCssClass="gsp_item"
					DefaultItemHoverCssClass="gsp_itemHover" DefaultItemActiveCssClass="gsp_itemActive" DefaultItemCheckedCssClass="gsp_itemChecked"
					DefaultItemCheckedHoverCssClass="gsp_itemActive">
					<ClientEvents>
						<ItemSelect EventHandler="tbMediaObjectActions_onItemSelect" />
						<ItemCheckChange EventHandler="tbMediaObjectActions_onItemCheckChange" />
					</ClientEvents>
				</ComponentArt:ToolBar>
			</td>
			<td class="gsp_textright gsp_nowrap">
				<asp:PlaceHolder ID="phPosition" runat="server" />
			</td>
			<td style="width: 42px;">
				<img id="imgNext" src="<%= Util.GalleryRoot %>/images/right_arrow.png" class="gsp_navright gsp_addpadding2"
					onclick="showNextMediaObject();" alt='<asp:Literal runat="server" Text="<%$ Resources:GalleryServerPro, UC_MediaObjectView_Next_Text %>" />'
					title='<asp:Literal runat="server" Text="<%$ Resources:GalleryServerPro, UC_MediaObjectView_Next_Tooltip %>" />' />
			</td>
		</tr>
	</table>
	<div id="divPermalink" class="permalinkContainer gsp_invisible">
		<p>
			<asp:Literal ID="litPermalinkHeaderText" runat="server" Text="<%$ Resources:GalleryServerPro, UC_MediaObjectView_Permalink_Header_Text %>" /></p>
		<p id="permaLinkUrlTag" class="gsp_fs">
		</p>
	</div>
	<div id="mediaObjectInfoContainer">
	</div>
	<asp:Panel ID="pnlMediaObject" runat="server" CssClass="moContainer" />
	<asp:Panel ID="pnlMediaObjectTitle" runat="server">
		<div id="moTitle" runat="server" class="mediaObjectTitle">
		</div>
	</asp:Panel>
</div>
<ComponentArt:Dialog ID="dgMediaObjectInfo" runat="server" Title="Details" RenderOverWindowedObjects="true"
	AnimationType="Outline" AnimationDirectionElement="toolbarCell" AlignmentElement="mediaObjectInfoContainer"
	CloseTransition="Fade" ShowTransition="Fade" AnimationSlide="Linear" AnimationPath="Direct"
	AnimationDuration="400" TransitionDuration="400" Icon="info.png" AllowResize="True"
	ContentCssClass="dg2ContentCss" HeaderCssClass="dg2HeaderCss gsp_roundedtop6" CssClass="gsp_dg2DialogCss gsp_ns gsp_roundedtop10"
	OffsetX="5" Width="400" Height="480">
	<HeaderTemplate>
		<div onmousedown="dgMediaObjectInfo.StartDrag(event);">
			<img id="dg0DialogCloseImage" onclick="dgMediaObjectInfo.Close('cancelled');" src="<%= Util.GalleryRoot %>/images/componentart/dialog/close.gif"
				style="width: 28px; height: 15px;" alt="Close" /><img id="dg0DialogIconImage" src="<%= Util.GalleryRoot %>/images/componentart/dialog/info.png"
					style="width: 16px; height: 16px;" alt="" />
			<asp:Literal ID="l1" runat="server" Text="<%$ Resources:GalleryServerPro, UC_MediaObjectView_Info_Dialog_Title_Text %>" />
		</div>
	</HeaderTemplate>
	<ContentTemplate>
		<ComponentArt:Grid ID="gdmeta" runat="server" RunningMode="Client"
			FillContainer="true" ColumnResizeDistributeWidth="true" AllowPaging="false" ShowFooter="false"
			EmptyGridText="No data available" CssClass="gdInfoGrid" EnableViewState="false">
			<ClientEvents>
				<Load EventHandler="gdmeta_onLoad" />
			</ClientEvents>
			<Levels>
				<ComponentArt:GridLevel DataKeyField="MediaObjectMetadataId" AllowGrouping="False" AllowReordering="true"
					ColumnReorderIndicatorImageUrl="reorder.gif" HeadingCellCssClass="gdInfoHeadingCell"
					HeadingRowCssClass="gdInfoHeadingRow" DataCellCssClass="gdInfoDataCell" SortAscendingImageUrl="asc.gif"
					SortDescendingImageUrl="desc.gif" SortImageWidth="10" SortImageHeight="10">
					<Columns>
						<ComponentArt:GridColumn DataField="Description" HeadingCellCssClass="gdInfoFirstHeadingCell"
							HeadingText="<%$ Resources:GalleryServerPro, UC_MediaObjectView_Info_Dialog_Description_Header_Text %>"
							DataCellCssClass="gdInfoFirstDataCell" TextWrap="true" AllowReordering="False" />
						<ComponentArt:GridColumn DataField="Value" TextWrap="true" AllowReordering="False" HeadingText="<%$ Resources:GalleryServerPro, UC_MediaObjectView_Info_Dialog_Value_Header_Text %>" />
					</Columns>
				</ComponentArt:GridLevel>
			</Levels>
		</ComponentArt:Grid>
	</ContentTemplate>
	<ClientEvents>
		<OnClose EventHandler="dgMediaObjectInfo_OnClose" />
	</ClientEvents>
</ComponentArt:Dialog>
<asp:PlaceHolder ID="phDialogContainer" runat="server" />
<cc1:AnimationExtender runat="server" ID="dummyAnimator" TargetControlID="pnlMediaObject" />