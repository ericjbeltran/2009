using System;
using System.Configuration.Provider;
using System.Collections.Generic;

namespace GalleryServerPro.Provider
{
	/// <summary>
	/// Represents a collection of provider objects that inherit from <see cref="ProviderCollection"/>. 
	/// </summary>
	public class DataProviderCollection : ProviderCollection, IEnumerable<ProviderBase>
	{
		/// <summary>
		/// Gets the <see cref="GalleryServerPro.Provider.DataProvider"/> with the specified name.
		/// </summary>
		/// <value>The <see cref="GalleryServerPro.Provider.DataProvider"/> with the specified name.</value>
		public new DataProvider this[string name]
		{
			get { return (DataProvider)base[name]; }
		}

		/// <summary>
		/// Adds a provider to the collection.
		/// </summary>
		/// <param name="provider">The provider to be added.</param>
		/// <exception cref="T:System.NotSupportedException">
		/// The collection is read-only.
		/// </exception>
		/// <exception cref="T:System.ArgumentNullException">
		/// 	<paramref name="provider"/> is null.
		/// </exception>
		/// <exception cref="T:System.ArgumentException">
		/// The <see cref="P:System.Configuration.Provider.ProviderBase.Name"/> of <paramref name="provider"/> is null.
		/// - or -
		/// The length of the <see cref="P:System.Configuration.Provider.ProviderBase.Name"/> of <paramref name="provider"/> is less than 1.
		/// </exception>
		/// <PermissionSet>
		/// 	<IPermission class="System.Security.Permissions.SecurityPermission, mscorlib, Version=2.0.3600.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" version="1" Flags="UnmanagedCode, ControlEvidence"/>
		/// </PermissionSet>
		public override void Add(ProviderBase provider)
		{
			if (provider == null)
				throw new ArgumentNullException("provider");

			if (!(provider is DataProvider))
				throw new ArgumentException("The provider parameter must be of type DataProvider.", "provider");

			base.Add(provider);
		}

		/// <summary>
		/// Copies to.
		/// </summary>
		/// <param name="array">The array.</param>
		/// <param name="index">The index.</param>
		public void CopyTo(DataProvider[] array, int index)
		{
			base.CopyTo(array, index);
		}

		/// <summary>
		/// Returns an enumerator that iterates through the collection.
		/// </summary>
		/// <returns>
		/// A <see cref="T:System.Collections.Generic.IEnumerator`1"/> that can be used to iterate through the collection.
		/// </returns>
		public new IEnumerator<ProviderBase> GetEnumerator()
		{
			System.Collections.IEnumerator itr = base.GetEnumerator();

			while (itr.MoveNext())
			{
				yield return (ProviderBase) itr.Current;
			}
		}
	}
}
