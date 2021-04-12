using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Social.Manager.RNSocialManager
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNSocialManagerModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNSocialManagerModule"/>.
        /// </summary>
        internal RNSocialManagerModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNSocialManager";
            }
        }
    }
}
