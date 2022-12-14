using System;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace GalleryServerPro.Business
{
	/// <summary>
	/// A singleton class that contains a list of the hash keys for all media objects in the current gallery.
	/// </summary>
	public class MediaObjectHashKeys
	{
		#region Static fields

		private static MediaObjectHashKeys _instance;
		private static object sharedLock = new object();

		#endregion

		#region Private fields

		private StringCollection _allHashKeys;

		#endregion

		#region Constructors

		private MediaObjectHashKeys()
		{
			Initialize();
		}

		#endregion

		#region Public Properties

		/// <summary>
		/// Gets the hash keys for all media objects in the current gallery.
		/// </summary>
		/// <value>The hash keys for all media objects in the current gallery.</value>
		public StringCollection HashKeys
		{
			get { return _allHashKeys; }
		}

		/// <summary>
		/// Gets a reference to the <see cref="MediaObjectHashKeys" /> singleton instance.
		/// </summary>
		/// <value>The <see cref="MediaObjectHashKeys" /> singleton instance.</value>
		public static MediaObjectHashKeys Instance
		{
			get 
			{
				if (_instance == null)
				{
					lock (sharedLock)
					{
						if (_instance == null)
						{
							MediaObjectHashKeys tempHashKeys = new MediaObjectHashKeys();
							// Ensure that writes related to instantiation are flushed.
							System.Threading.Thread.MemoryBarrier();
							_instance = tempHashKeys;
						}
					}
				}
				return _instance;
			}
		}
	

		#endregion

		#region Public methods

		/// <summary>
		/// Nulls out the singleton instance so that the next time it is requested, the latest set of hash keys are extracted
		/// from the data store.
		/// </summary>
		public static void Clear()
		{
			_instance = null;
		}

		#endregion


		#region Private methods

		private void Initialize()
		{
			_allHashKeys = new StringCollection();

			System.Data.IDataReader drHashKeys = null;
			try
			{
				using (drHashKeys = Factory.GetDataProvider().MediaObject_GetAllHashKeys(GalleryServerPro.Configuration.ConfigManager.GetGalleryServerProConfigSection().Core.GalleryId))
				{
					while (drHashKeys.Read())
					{
						_allHashKeys.Add(drHashKeys[0].ToString());
					}
				}
			}
			finally
			{
				if (drHashKeys != null) drHashKeys.Close();
			}

		} 

		#endregion
	}
}
