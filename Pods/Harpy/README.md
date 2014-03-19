# Harpy
### Notify users when a new version of your app is available, and prompt them with the App Store link.

---
### About
**Harpy** is a utility that checks a user's currently installed version of your iOS application against the version that is currently available in the App Store. If a new version is available, an instance of UIAlertView is presented to the user informing them of the newer version, and giving them the option to update the application.

### Changelog (v2.5.2)
- Updated Slovenian Localization

### Features
- Cocoapods Support
- Three types of alerts to present to the end-user (see **Screenshots** section)
- Optional delegate and delegate methods (see **Optional Delegate** section)
- Check for Supported Devices (see **Supported Devices Compatibility** section)
- Localized for 15 languages: Basque, Chinese (Simplified), Chinese (Traditional), Danish, Dutch, English, French, German, Italian, Japanese, Korean, Portuguese, Russian, Slovenian, Spanish
	- Optional ability to override an iOS device's default language to force the localization of your choice (see **Force Localization** section)

### Screenshots

- The **left picture** forces the user to update the app.
- The **center picture** gives the user the option to update the app.
- The **right picture** gives the user the option to skip the current update.
- These options are controlled by the `HarpyAlertType` struct that is found in `Harpy.h`.
 
![Forced Update](https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picForcedUpdate.png?raw=true "Forced Update") 
![Optional Update](https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picOptionalUpdate.png?raw=true "Optional Update")
![Skipped Update](https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picSkippedUpdate.png?raw=true "Optional Update")

### Installation Instructions

#### CocoaPods Installation
```
pod 'Harpy'
```

#### Manual Installation

Copy the 'Harpy' folder into your Xcode project. It contains the Harpy.h and Harpy.m files.

### Setup Instructions	
1. Import **Harpy.h** into your AppDelegate or Pre-Compiler Header (.pch)
1. In your `AppDelegate`, set the **appID**, and optionally, you can set the **alertType**.
1. In your `AppDelegate`, call **only one** of the `checkVersion` methods, as all three perform a check on your application's first launch. Use either:
    - `checkVersion` in `application:didFinishLaunchingWithOptions:`
    - `checkVersionDaily` in `applicationDidBecomeActive:`.
    - `checkVersionWeekly` in `applicationDidBecomeActive:`.


``` obj-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

	// Present Window before calling Harpy
	[self.window makeKeyAndVisible]
	
	// Set the App ID for your app
	[[Harpy sharedInstance] setAppID:@"<#app_id#>"];
	
	// (Optional) Set the App Name for your app
	[[Harpy sharedInstance] setAppName:@"<#app_name#>"];
	
	/* (Optional) Set the Alert Type for your app 
	 By default, the Singleton is initialized to HarpyAlertTypeOption */
	[[Harpy sharedInstance] setAlertType:<#alert_type#>];
	
	/* (Optional) If your application is not availabe in the U.S. App Store, you must specify the two-letter
	 country code for the region in which your applicaiton is available. */
	[[Harpy sharedInstance] setCountryCode:@"<#country_code#>"]; 
	
	/* (Optional) Overides system language to predefined language. 
	 Please use the HarpyLanguage constants defined inHarpy.h. */
	[[Harpy sharedInstance] setForceLanguageLocalization<#HarpyLanguageConstant#>];
	
	// Perform check for new version of your app 
	[[Harpy sharedInstance] checkVersion]; 
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	 
	/*
	 Perform daily check for new version of your app
	 Useful if user returns to you app from background after extended period of time
 	 Place in applicationDidBecomeActive:
 	 
 	 Also, performs version check on first launch.
 	*/
	[[Harpy sharedInstance] checkVersionDaily];

	/*
	 Perform weekly check for new version of your app
	 Useful if you user returns to your app from background after extended period of time
	 Place in applicationDidBecomeActive:
	 
	 Also, performs version check on first launch.
	 */
	[[Harpy sharedInstance] checkVersionWeekly];
    
}
```

And you're all set!

### Optional Delegate and Delegate Methods
If you'd like to handle or track the end-user's behavior, four delegate methods have been made available to you:

```	obj-c
	// User presented with update dialog
	- (void)harpyDidShowUpdateDialog;
	
	// User did click on button that launched App Store.app
	- (void)harpyUserDidLaunchAppStore;
	
	// User did click on button that skips version update
	- (void)harpyUserDidSkipVersion;
	
	// User did click on button that cancels update dialog
	- (void)harpyUserDidCancel;
```

### Force Localization
There are some situations where a developer may want to the update dialog to *always* appear in a certain language, irrespective of the devices/system default language (e.g. apps released in a specific country). As of v2.5.0, this feature has been added to Harpy (see [Issue #41](https://github.com/ArtSabintsev/Harpy/issues/41)). Please set the `forceLanguageLocalization` property using the `HarpyLanugage` string constants defined in `Harpy.h` if you would like override the system's default lanuage for the Harpy alert dialogs.

``` obj-c 
[[Harpy sharedInstance] setForceLanguageLocalization<#HarpyLanguageConstant#>];
```

### Supported Devices Compatibility
Every new release of iOS deprecates support for one or more older device models. As of v2.4.0, Harpy checks to make sure that a user's current device supports the new version of your app. If it it does, the `UIAlertView	` pops up as usual. If it does not, no alert is shown. This extra check was added into Harpy after a [lengthy discussion](https://github.com/ArtSabintsev/Harpy/issues/35).

A new helper utility, [UIDevice+SupportedDevices](https://github.com/ArtSabintsev/UIDevice-SupportedDevices), came out of this discussion and is included with Harpy.

### Important Note on App Store Submissions
- The App Store reviewer will **not** see the alert. 

### Project Contributors
- **v1.0.1**
	- [Pius Uzamere](https://github.com/pius)
- **v1.5.0**
	- [Aaron Brager](http://www.github.com/getaaron)
- **v2.0.0**
	- [Claas Lange](https://github.com/claaslange)
	- [Josh T. Brown](https://github.com/joshuatbrown)
- **v2.3.0**
	- [David Keegan](https://github.com/kgn)
- **v2.3.1**
	- [Rui Perese](https://github.com/RuiAAPeres)
- **v2.3.2**
	- [Mark Rickert](https://github.com/markrickert)
- **v2.3.3**
	- [Erick](https://github.com/dexcell0)
- **v2.3.4**
	- [Ercillagorka](https://github.com/ercillagorka)
- **v2.3.5**
	- [TrentW](https://github.com/trentw)
- **v2.3.6**
	- [Jamie Ly](http://github,com/jamiely)
- **v2.3.8**
	- [Thomas Hempel](https://github.com/thomashempel)
- **v2.4.0**
	- [Aaron Brager](http://www.github.com/getaaron)
	- [Borut Tomažin](https://github.com/borut-t)
- **v2.5.0**
	- [Borut Tomažin](https://github.com/borut-t)
- **v2.5.1**
	- [Bertie Liu](https://github.com/https://github.com/aceisScope)
- **v2.5.2**
	- [Borut Tomažin](https://github.com/borut-t)
	

### Created and maintained by
- [Arthur Ariel Sabintsev](http://www.sabintsev.com/) 

### License
The MIT License (MIT)
Copyright (c) 2012-2014 Arthur Ariel Sabintsev

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
