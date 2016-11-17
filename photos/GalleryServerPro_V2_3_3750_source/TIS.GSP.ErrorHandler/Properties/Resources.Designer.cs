﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30128.1
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace GalleryServerPro.ErrorHandler.Properties {
    using System;
    
    
    /// <summary>
    ///   A strongly-typed resource class, for looking up localized strings, etc.
    /// </summary>
    // This class was auto-generated by the StronglyTypedResourceBuilder
    // class via a tool like ResGen or Visual Studio.
    // To add or remove a member, edit your .ResX file then rerun ResGen
    // with the /str option, or rebuild your VS project.
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("System.Resources.Tools.StronglyTypedResourceBuilder", "4.0.0.0")]
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    internal class Resources {
        
        private static global::System.Resources.ResourceManager resourceMan;
        
        private static global::System.Globalization.CultureInfo resourceCulture;
        
        [global::System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
        internal Resources() {
        }
        
        /// <summary>
        ///   Returns the cached ResourceManager instance used by this class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Resources.ResourceManager ResourceManager {
            get {
                if (object.ReferenceEquals(resourceMan, null)) {
                    global::System.Resources.ResourceManager temp = new global::System.Resources.ResourceManager("GalleryServerPro.ErrorHandler.Properties.Resources", typeof(Resources).Assembly);
                    resourceMan = temp;
                }
                return resourceMan;
            }
        }
        
        /// <summary>
        ///   Overrides the current thread's CurrentUICulture property for all
        ///   resource lookups using this strongly typed resource class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Globalization.CultureInfo Culture {
            get {
                return resourceCulture;
            }
            set {
                resourceCulture = value;
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Gallery Server Pro has not been properly initialized. This can happen when the initialization code that must run during application startup does not successfully complete, perhaps due to a failure to connect to the data store or another exception. For the web version of Gallery Server Pro, the startup code is invoked from any of the application entry points: the constructor of the GalleryPage class (GalleryPage.cs), the static constructor of the web services class (Gallery.asmx.cs), or one of the HTTP handl [rest of string was truncated]&quot;;.
        /// </summary>
        internal static string ApplicationNotInitialized_Ex_Msg {
            get {
                return ResourceManager.GetString("ApplicationNotInitialized_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to An error has occurred in the GalleryServerPro.Business namespace..
        /// </summary>
        internal static string Business_Ex_Msg {
            get {
                return ResourceManager.GetString("Business_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Cannot send e-mail.
        /// </summary>
        internal static string Cannot_Send_Email_Lbl {
            get {
                return ResourceManager.GetString("Cannot_Send_Email_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Cannot delete album.
        /// </summary>
        internal static string CannotDeleteAlbum_Ex_Msg {
            get {
                return ResourceManager.GetString("CannotDeleteAlbum_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Cannot delete album: The album {0} cannot be deleted..
        /// </summary>
        internal static string CannotDeleteAlbum_Ex_Msg2 {
            get {
                return ResourceManager.GetString("CannotDeleteAlbum_Ex_Msg2", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Cannot move album: The operating system won&apos;t allow the directory containing the album to be moved. This can occur when the web server user account has insufficient permissions, or the directory contents are being displayed in another window..
        /// </summary>
        internal static string CannotMoveDirectoryException_Ex_msg {
            get {
                return ResourceManager.GetString("CannotMoveDirectoryException_Ex_msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Gallery Server Pro cannot read from a directory. This may be due to insufficient permissions. Check that the directory exists and that the web application has read permission for it. By default, the IIS worker process runs under the ASPNET user in IIS 5 and 5.1, Network Service in IIS 6 and 7, and IIS AppPool\DefaultAppPool in IIS 7.5. NOTE: You may need to restart the IIS application pool to force your changes to take effect..
        /// </summary>
        internal static string CannotReadFromDirectory_Ex_Msg {
            get {
                return ResourceManager.GetString("CannotReadFromDirectory_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Gallery Server Pro cannot read from the directory &quot;{0}&quot;. This may be due to insufficient permissions. Check that the directory exists and that the web application has read permission for it. By default, the IIS worker process runs under the ASPNET user in IIS 5 and 5.1, Network Service in IIS 6 and 7, and IIS AppPool\DefaultAppPool in IIS 7.5. NOTE: You may need to restart the IIS application pool to force your changes to take effect..
        /// </summary>
        internal static string CannotReadFromDirectory_Ex_Msg2 {
            get {
                return ResourceManager.GetString("CannotReadFromDirectory_Ex_Msg2", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Cannot move or copy album: The destination album is contained within the source album. No objects were transferred..
        /// </summary>
        internal static string CannotTransferAlbumToNestedDirectoryException_Ex_msg {
            get {
                return ResourceManager.GetString("CannotTransferAlbumToNestedDirectoryException_Ex_msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Gallery Server Pro cannot write to a directory. This may be due to insufficient permissions. Check that the directory exists and that the web application has read, write and modify permission to it. If the application is running at less than Full Trust, the path must be within the web application. By default, the IIS worker process runs under the ASPNET user in IIS 5 and 5.1, Network Service in IIS 6 and 7, and IIS AppPool\DefaultAppPool in IIS 7.5. NOTE: You may need to restart the IIS application pool to  [rest of string was truncated]&quot;;.
        /// </summary>
        internal static string CannotWriteToDirectory_Ex_Msg {
            get {
                return ResourceManager.GetString("CannotWriteToDirectory_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Gallery Server Pro cannot write to the directory &quot;{0}&quot;. This may be due to insufficient permissions. Check that the directory exists and that the web application has read, write and modify permission to it. If the application is running at less than Full Trust, the path must be within the web application.  By default, the IIS worker process runs under the ASPNET user in IIS 5 and 5.1, Network Service in IIS 6 and 7, and IIS AppPool\DefaultAppPool in IIS 7.5. NOTE: You may need to restart the IIS application [rest of string was truncated]&quot;;.
        /// </summary>
        internal static string CannotWriteToDirectory_Ex_Msg2 {
            get {
                return ResourceManager.GetString("CannotWriteToDirectory_Ex_Msg2", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to An error has occurred in the GalleryServerPro.Data namespace..
        /// </summary>
        internal static string Data_Ex_Msg {
            get {
                return ResourceManager.GetString("Data_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to &lt;no directory specified&gt;.
        /// </summary>
        internal static string DefaultDirectoryPath {
            get {
                return ResourceManager.GetString("DefaultDirectoryPath", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to &lt;no file specified&gt;.
        /// </summary>
        internal static string DefaultFilename {
            get {
                return ResourceManager.GetString("DefaultFilename", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Error:.
        /// </summary>
        internal static string Email_Subject_Prefix_When_Ex_Type_Present {
            get {
                return ResourceManager.GetString("Email_Subject_Prefix_When_Ex_Type_Present", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Error Report.
        /// </summary>
        internal static string Email_Subject_When_No_Ex_Type_Present {
            get {
                return ResourceManager.GetString("Email_Subject_When_No_Ex_Type_Present", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to App Error ID.
        /// </summary>
        internal static string Err_AppErrorId_Lbl {
            get {
                return ResourceManager.GetString("Err_AppErrorId_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Cookies.
        /// </summary>
        internal static string Err_Cookies_Lbl {
            get {
                return ResourceManager.GetString("Err_Cookies_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to This error report was generated by Gallery Server Pro..
        /// </summary>
        internal static string Err_Email_Body_Prefix {
            get {
                return ResourceManager.GetString("Err_Email_Body_Prefix", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Exception Data.
        /// </summary>
        internal static string Err_ExceptionData_Lbl {
            get {
                return ResourceManager.GetString("Err_ExceptionData_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Exception Type.
        /// </summary>
        internal static string Err_ExceptionType_Lbl {
            get {
                return ResourceManager.GetString("Err_ExceptionType_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Form Variables.
        /// </summary>
        internal static string Err_FormVariables_Lbl {
            get {
                return ResourceManager.GetString("Err_FormVariables_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Gallery ID.
        /// </summary>
        internal static string Err_GalleryId_Lbl {
            get {
                return ResourceManager.GetString("Err_GalleryId_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to HTTP User Agent.
        /// </summary>
        internal static string Err_HttpUserAgent_Lbl {
            get {
                return ResourceManager.GetString("Err_HttpUserAgent_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Inner Ex Data.
        /// </summary>
        internal static string Err_InnerExData_Lbl {
            get {
                return ResourceManager.GetString("Err_InnerExData_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Inner Ex Message.
        /// </summary>
        internal static string Err_InnerExMessage_Lbl {
            get {
                return ResourceManager.GetString("Err_InnerExMessage_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Inner Ex Source.
        /// </summary>
        internal static string Err_InnerExSource_Lbl {
            get {
                return ResourceManager.GetString("Err_InnerExSource_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Inner Ex Stack Trace.
        /// </summary>
        internal static string Err_InnerExStackTrace_Lbl {
            get {
                return ResourceManager.GetString("Err_InnerExStackTrace_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Inner Ex Target Site.
        /// </summary>
        internal static string Err_InnerExTargetSite_Lbl {
            get {
                return ResourceManager.GetString("Err_InnerExTargetSite_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Inner Ex Type.
        /// </summary>
        internal static string Err_InnerExType_Lbl {
            get {
                return ResourceManager.GetString("Err_InnerExType_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Message.
        /// </summary>
        internal static string Err_Message_Lbl {
            get {
                return ResourceManager.GetString("Err_Message_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to &lt;unknown&gt;.
        /// </summary>
        internal static string Err_Missing_Data_Txt {
            get {
                return ResourceManager.GetString("Err_Missing_Data_Txt", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Error:.
        /// </summary>
        internal static string Err_Msg_Label {
            get {
                return ResourceManager.GetString("Err_Msg_Label", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to &lt;none&gt;.
        /// </summary>
        internal static string Err_No_Data_Txt {
            get {
                return ResourceManager.GetString("Err_No_Data_Txt", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Server Variables.
        /// </summary>
        internal static string Err_ServerVariables_Lbl {
            get {
                return ResourceManager.GetString("Err_ServerVariables_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Session Variables.
        /// </summary>
        internal static string Err_SessionVariables_Lbl {
            get {
                return ResourceManager.GetString("Err_SessionVariables_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Source.
        /// </summary>
        internal static string Err_Source_Lbl {
            get {
                return ResourceManager.GetString("Err_Source_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Stack Trace.
        /// </summary>
        internal static string Err_StackTrace_Lbl {
            get {
                return ResourceManager.GetString("Err_StackTrace_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Error Summary.
        /// </summary>
        internal static string Err_Summary {
            get {
                return ResourceManager.GetString("Err_Summary", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Target Site.
        /// </summary>
        internal static string Err_TargetSite_Lbl {
            get {
                return ResourceManager.GetString("Err_TargetSite_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Timestamp.
        /// </summary>
        internal static string Err_Timestamp_Lbl {
            get {
                return ResourceManager.GetString("Err_Timestamp_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Url.
        /// </summary>
        internal static string Err_Url_Lbl {
            get {
                return ResourceManager.GetString("Err_Url_Lbl", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to You not have authorization to perform the requested action. This could be because of limited permissions granted to anonymous users or, if you are logged in, you do not belong to a role that authorizes the requested action, or none of the roles to which you belong allow the action for the requested album..
        /// </summary>
        internal static string GallerySecurity_Ex_Msg {
            get {
                return ResourceManager.GetString("GallerySecurity_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Invalid Album: An Album ID was omitted or, if specified, does not represent a valid album..
        /// </summary>
        internal static string InvalidAlbum_Ex_Msg {
            get {
                return ResourceManager.GetString("InvalidAlbum_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Invalid Album ID: {0} does not represent a valid album..
        /// </summary>
        internal static string InvalidAlbum_Ex_Msg2 {
            get {
                return ResourceManager.GetString("InvalidAlbum_Ex_Msg2", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Invalid Gallery Server Role: The specified role name does not match an existing role. If you were creating a new role, a role with the desired name may already exist..
        /// </summary>
        internal static string InvalidGalleryServerRole_Ex_Msg {
            get {
                return ResourceManager.GetString("InvalidGalleryServerRole_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Gallery Server Pro does not have a valid license or you are attempting to perform an action that violates the current license. You can purchase a license at www.galleryserverpro.com..
        /// </summary>
        internal static string InvalidLicenseException_Ex_Msg {
            get {
                return ResourceManager.GetString("InvalidLicenseException_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Invalid Media Object: A media object ID was omitted or, if specified, does not represent a valid media object..
        /// </summary>
        internal static string InvalidMediaObject_Ex_Msg {
            get {
                return ResourceManager.GetString("InvalidMediaObject_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Invalid Media Object ID: {0} does not represent a valid media object..
        /// </summary>
        internal static string InvalidMediaObject_Ex_Msg2 {
            get {
                return ResourceManager.GetString("InvalidMediaObject_Ex_Msg2", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Invalid media object directory: Gallery Server Pro cannot find or does not have permission to access the media object directory. Verify that the setting corresponds to a valid directory and that the web application has read, write and modify permission to this location. The media object directory is specified in the configuration file galleryserverpro.config..
        /// </summary>
        internal static string InvalidMediaObjectsDirectory_Ex_Msg {
            get {
                return ResourceManager.GetString("InvalidMediaObjectsDirectory_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Invalid media object directory: Gallery Server Pro cannot find or does not have permission to access the media object directory &quot;{0}&quot;. Verify that the setting corresponds to a valid directory and that the web application has read, write and modify permission to this location. The media object directory is specified in the configuration file galleryserverpro.config..
        /// </summary>
        internal static string InvalidMediaObjectsDirectory_Ex_Msg2 {
            get {
                return ResourceManager.GetString("InvalidMediaObjectsDirectory_Ex_Msg2", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to A synchronization is already in progress..
        /// </summary>
        internal static string SynchronizationInProgress_Ex_Msg {
            get {
                return ResourceManager.GetString("SynchronizationInProgress_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to The end user has requested the cancellation of a currently executing synchronization. The synchronization has been cancelled per the request..
        /// </summary>
        internal static string SynchronizationTerminationRequested_Ex_Msg {
            get {
                return ResourceManager.GetString("SynchronizationTerminationRequested_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Invalid Form Data: The form data for this web page contains unexpected data..
        /// </summary>
        internal static string UnexpectedFormData_Ex_Msg {
            get {
                return ResourceManager.GetString("UnexpectedFormData_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Invalid Query String: The query string contains unexpected data..
        /// </summary>
        internal static string UnexpectedQueryString_Ex_Msg {
            get {
                return ResourceManager.GetString("UnexpectedQueryString_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Unsupported image: The .NET Framework is unable to loaded an image file into the System.Drawing.Bitmap class. This is probably because it is corrupted, not an image supported by the .NET Framework, or the server does not have enough memory to process the image..
        /// </summary>
        internal static string UnsupportedImageType_Ex_Msg {
            get {
                return ResourceManager.GetString("UnsupportedImageType_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Unsupported image: the file {0} cannot be loaded into the .NET Framework&apos;s System.Drawing.Bitmap class. This is probably because it is corrupted, not an image supported by the .NET Framework, or the server does not have enough memory to process the image..
        /// </summary>
        internal static string UnsupportedImageType_Ex_Msg2 {
            get {
                return ResourceManager.GetString("UnsupportedImageType_Ex_Msg2", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to The gallery does not allow files of this type to be added to the gallery..
        /// </summary>
        internal static string UnsupportedMediaObjectType_Ex_Msg {
            get {
                return ResourceManager.GetString("UnsupportedMediaObjectType_Ex_Msg", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Files of this type ({0}) are not allowed to be added to the gallery..
        /// </summary>
        internal static string UnsupportedMediaObjectType_Ex_Msg2 {
            get {
                return ResourceManager.GetString("UnsupportedMediaObjectType_Ex_Msg2", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to An error has occurred in the GalleryServerPro.Web namespace..
        /// </summary>
        internal static string Web_Ex_Msg {
            get {
                return ResourceManager.GetString("Web_Ex_Msg", resourceCulture);
            }
        }
    }
}
