## Adding the SDK package to your project

1. On Xcode, go to File > Swift Packages > Add Package Dependency
1. On Choose Project window, select which project you want to install OpenRoaming SDK package and click Next
1. On Choose Package Repository window, insert the SSH of the repository where OpenRoaming SDK is located and click Next. Example:
    1. `git@bitbucket.org:fit-tecnologia/openroaming-sdk-ios.git`

> It might take a while for Xcode to verify the repository.

1. After Xcode verified the repository, at the Choose Package Options screen, inform the release version of the package or branch where the package it is and click Next. Example: 
    1. For the SSH above the package is located in the `sdk-swift-package-xcframework` branch, so you should select Branch and type its name on the available field.

> It might take a while for Xcode to verify the package, so you will not be able to add these informations immediately. 

1. Then Xcode will open the Add Package to App screen and after a few minutes, OpenRoaming SDK package will be installed in your App.
1. Also, please make sure that OpenRoaming Package is also added on Build Phases > Link Binary with Libraries.

## Test whether the SDK was installed correctly
1. Go to your project
1. Import `OpenRoaming` on your swift file
1. Call the show version method
    1. `let version = OpenRoaming.showVersion()`
1. Check the “version” value. If it is null, redo all the procedures above, otherwise it is working correctly.

## Removing the SDK package from your project
1. If the installation was not successful, to redo the procedures you maybe will have to remove the package from your project.
1. On the File Manager, click on your project `.xcodeproj` file
1. Go to Swift Packages
1. You will see OpenRoaming, such as its Version Rules and Location
1. Select OpenRoaming and click on  — below

## Unable to install "App" error
If you face this error, please check out this link: https://pspdfkit.com/guides/ios/current/knowledge-base/library-not-found-swiftpm/
