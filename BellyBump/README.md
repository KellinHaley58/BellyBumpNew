This is the repo for BellyBump's iOS App.
This README would normally document whatever steps are necessary to get the
application up and running.

Supported OS & SDK Versions
-----------------------------

* Supported build target - iOS 7.0 / Mac OS 10.8 (Xcode 6.3, Apple LLVM compiler 6.1)


Build & Run Project
-----------------------------


Step 1: Before Setup CocoaPods, make sure Command Line Tools are installed on Xcode. If not, Open Xcode and go to Preferences, then select the Downloads tab. Install the Command Line Tools by clicking on the Install button next to that item in the Components list.


Step 2: Setup CocoaPods (CocoaPods manages library dependencies for your Xcode projects)

Update Ruby gem. Open Terminal and type the following command:

	sudo gem update --system

Install CocoaPods. Type this command:

	sudo gem install cocoapods

Setup CocoaPods. Type this command:

	pod setup


Step 3: Install library dependencies for Xcode project

Change directory to BellyBump XCode project root directory (where BellyBump.xcodeproj file is placed). Type this command:

	pod install


Step 4: Open the new workspace created by CocoaPods. From now on, you will need to open the workspace instead of the project. Just double click the .xcworkspace file, or type:

	open BellyBump.xcworkspace


Step 5: Build and run app.

