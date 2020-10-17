# Sample App - Cisco DNA Spaces SDK for IOS

This sample App implements the main methods of the Cisco DNA Spaces SDK. Feel free to use its code to build your own application.

## App features

* <ins>**Initialization:**</ins> Initialization is done via the **registerSDK** method

* <ins>**Initial screen:**</ins> allows associating the user’s identity to the CIsco DNA Spaces backend. For exemplification purpose, the App implements the three forms of the **associateUser** method (Server Auth Code based, Webview based and UserId based). In a real application, only one of these methods will be used.

* <ins>**Profile installation:**</ins> Once the user is associated, the **installProfile** method is called to deploy the profile. From that moment, the device is able automatically connect to a WiFi network that is part of the OpenRoaming federation (a OpenRoaming network is available at the device WiFi settings).

* <ins>**Usage statistics:**</ins> Once the user has been associated and the profile installed, the sample App displays a screen with the user’s usage statistics (**getUsageStatistic** method).

* <ins>**Other features:**</ins> The Usage screen also features the Account button. Selecting this button, a screen is presented from which the user can:

  * Modify the options regarding privacy (**getPrivacySettings** and **setPrivacySettings** methods are implemented) and receive or not push notification (associatePushIdentifier and dissociatePushIdentifier methods are implemented)

  * Update his/her account data (**getUserDetails** and **updateUserDetails** methods are implemented)

  * Uninstall the profile, which will also disassociate the user identity (**deleteUserAccount** or **deleteProfile** method)

  * Display the last push notification received, if any.

## Cisco DNA Spaces SDK

This Sample App is already prepared to download an integrate Cisco DNA Spaces SDK XCFramework as described here: https://github.com/CiscoDevNet/DNASpacesSDK-IOS. No further action is required related to this. Refer to the Cisco DNA Spaces SDK git hub for instructions on how to integrate the SDK XCFramewlrk to your app. 

## How to download and prepare the environment to use the Sample App

* Install IDE for Swift language (Xcode version 12 is required)
  * [Download Xcode from Apple Store](https://apps.apple.com/br/app/xcode/id497799835?mt=12)
* Install CocoaPods (package manager)
  * [CocoaPods site](https://cocoapods.org/)
* Download the sample App code
* Go to OpenRoaming folder in terminal and execute cocoapod install command
  * `$ pod install`
* Open App.xcworkspace (white icon)
* Build and Run the project
  * If you have chosen to run on a simulator, some features may not work, such as connecting to wi-fi for example.
