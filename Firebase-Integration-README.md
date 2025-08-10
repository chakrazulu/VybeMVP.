# Firebase Cloud Messaging Integration Guide

This guide provides step-by-step instructions for setting up Firebase Cloud Messaging (FCM) in the VybeMVP iOS app to enable push notifications for number match events.

## Prerequisites

1. An Apple Developer account with access to certificates and provisioning profiles
2. A Firebase account (you can create one at [firebase.google.com](https://firebase.google.com))
3. Xcode 14.0 or later

## Step 1: Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter "VybeMVP" as the project name and follow the setup wizard
4. Accept the Firebase terms and click "Create project"

## Step 2: Register Your iOS App with Firebase

1. In the Firebase console, click the iOS icon to add an iOS app
2. Enter your app's bundle ID (e.g., `com.infinitiesinn.vybe`)
3. Enter the app nickname: "VybeMVP"
4. (Optional) Enter the App Store ID if available
5. Click "Register app"
6. Download the `GoogleService-Info.plist` file
7. Add the `GoogleService-Info.plist` file to your Xcode project (drag and drop it into the root of your project and ensure "Copy items if needed" is checked)

## Step 3: Add Firebase SDK to Your Project

### Option A: Using Swift Package Manager (Recommended)

1. In Xcode, select File > Add Packages
2. Enter the Firebase iOS SDK repository URL: `https://github.com/firebase/firebase-ios-sdk.git`
3. Click "Next"
4. Select the following Firebase products:
   - Firebase Core
   - Firebase Messaging
5. Click "Add Package"

### Option B: Using CocoaPods

1. If you don't have CocoaPods installed, run: `sudo gem install cocoapods`
2. Create a `Podfile` in your project root with the following content:

```ruby
platform :ios, '15.0'

target 'VybeMVP' do
  use_frameworks!

  pod 'FirebaseCore'
  pod 'FirebaseMessaging'
end
```

3. Run `pod install` in the terminal
4. Open the newly created `.xcworkspace` file instead of your `.xcodeproj` file

## Step 4: Configure Push Notification Capability

1. In Xcode, select your project in the Project Navigator
2. Select your app target under "Targets"
3. Go to the "Signing & Capabilities" tab
4. Click "+ Capability" and add "Push Notifications"
5. Add "Background Modes" capability and check "Remote notifications"

## Step 5: Configure Apple Push Notification service (APNs)

1. Go to the [Apple Developer Portal](https://developer.apple.com/account/)
2. Navigate to "Certificates, IDs & Profiles"
3. Under "Keys", click the "+" button to add a new key
4. Name it "VybeMVP APNs Key"
5. Check "Apple Push Notifications service (APNs)"
6. Click "Continue" and then "Register"
7. Download the key file (`.p8`) - **IMPORTANT: This can only be downloaded once**
8. Note the Key ID displayed on the page

## Step 6: Add APNs Key to Firebase

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Select your "VybeMVP" project
3. Navigate to Project Settings > Cloud Messaging
4. Scroll to the "Apple app configuration" section
5. Click "Upload" under APNs Authentication Key
6. Upload the `.p8` key file you downloaded earlier
7. Enter the Key ID and your Apple Team ID
8. Click "Upload"

## Step 7: Update the AppDelegate and NotificationManager

The code for these files has already been added to the project. You need to:

1. Uncomment the Firebase-related code in `AppDelegate.swift`
2. Uncomment the MessagingDelegate extension in `NotificationManager.swift`
3. Add the necessary imports in both files:
   - `import FirebaseCore`
   - `import FirebaseMessaging`

## Step 8: Initialize Firebase in Your App

In `AppDelegate.swift`, uncomment the `FirebaseApp.configure()` line in the `application(_:didFinishLaunchingWithOptions:)` method.

## Step 9: Testing Push Notifications

1. Build and run the app on a physical device (simulators cannot receive push notifications)
2. Accept the notification permission prompt
3. Check the console logs to verify that the FCM token is generated and printed
4. In the Firebase Console, go to Cloud Messaging > Send your first message
5. Enter a notification title and text
6. Under "Target", select "Single device" and paste the FCM token from your console logs
7. Click "Send message"

## Troubleshooting

### Push Notifications Not Received

1. Verify that the app has notification permissions (check Settings > YourApp > Notifications)
2. Confirm the APNs key is correctly uploaded to Firebase
3. Ensure the physical device has an internet connection
4. Check the FCM token is being correctly generated and printed to console
5. Verify the bundle ID matches between Xcode and Firebase registration

### FCM Token Not Generated

1. Ensure Firebase is correctly initialized with `FirebaseApp.configure()`
2. Check that the `GoogleService-Info.plist` is added to the project and contains the correct bundle ID
3. Verify the MessagingDelegate is set up properly

## Next Steps

- Implement server-side notification sending for number match events
- Create a backend service to store FCM tokens for users
- Develop a notification inbox UI in the app

## References

- [Firebase Cloud Messaging Documentation](https://firebase.google.com/docs/cloud-messaging)
- [Setting Up APNs with FCM](https://firebase.google.com/docs/cloud-messaging/ios/certs)
- [Sending Test FCM Messages](https://firebase.google.com/docs/cloud-messaging/ios/first-message)
