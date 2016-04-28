# React Native GCM for IOS [![npm version](https://badge.fury.io/js/react-native-gcm-ios.svg)](http://badge.fury.io/js/react-native-gcm-ios)

This provides a RN wrapper for using Google Cloud Messenger for iOS. Since Android uses GCM, this allows your backend to send cross platform push notifications easily by hitting the same endpoint.

This does not handle actually displaying or handing notifications - it only gets GCM tokens. You should use [react-native-push-notification](https://github.com/zo0r/react-native-push-notification) for that part.

## Installation

This module requires using [CocoaPods](https://cocoapods.org/) in order to install

`npm install --save react-native-gcm-ios`

Add this pod to your podfile

`pod 'react-native-gcm-ios', :path => '../node_modules/react-native-gcm-ios'`

Follow the directions in the [GCM docs](https://developers.google.com/cloud-messaging/ios/client) to get an APNS certificate, upload it, and get a `GoogleService-Info.plist` to add to your project.

## Usage
```javascript
var GcmIOS = require('react-native-gcm-ios');

GcmIOS.addListener('register', (gcmToken) => {
  //send the token to your backend here
})

GcmIOS.addListener('error', (error) => {
  console.log(error);
})
```
