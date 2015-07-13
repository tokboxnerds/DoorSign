DoorSign
========

DoorSign is an iPad (iOS8.2+) application designed to show the status of meeting rooms using calendars available on the local device.

For a one off room you can use any calendar available on a device. If you want to show the availability of a resource (e.g. a meeting room), the calendar for that resource must be synced to the device. For the best experience use activesync ("Microsoft Exchange" account type) and make sure "Push" is not disabled.

Google Apps
-----------

* Create a dedicated Google account for the iPads (many iPads can share one account)
* Login to that account on a computer, and under Other Calendars > Browse Interesting Calendars > More > Resources for {your domain}, click Subscribe next to each calendar you wish to be available.
* Add the Google account on the device, syncing only Calendars.
* In Safari on the iPad visit [m.google.com/sync/settings](http://m.google.com/sync/settings) and tick each calendar you want to be available.
* Restart the device. (This is not strictly necessary, but is the fastest way to see the additional calendars.)

For bonus points:

* If adding the Google account does not force you to, setup a PIN on the device. (DoorSign will prevent the device sleeping, but this will prevent inquisitive users upgrading the OS).
* Enable Guided Access mode (Settings > General > Accessibility > Guided Access "On", and Passcode Settings > Set Guided Access Passowrd), then after starting the app triple tap the home button to enable Guided Access.
* Alternatively use the Configurator to put the device in single app mode.

Building & Running
------------------

DoorSign uses webpack & react-native, so you'll need to do a couple of extra steps before you can start hacking away and
getting a copy running on your device.

1. Run `npm install` in the same directory as this readme.
2. Run `npm start` in the same directory.
3. open `DoorSigns2.xcodeproj` in Xcode.
4. Find a line like ```//  jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle"];``` and
   uncomment it. Also look for ```jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];```
   and comment it out.
5. You can now Build and Run the app in a Simulator.
6. To run it on a device, change "localhost" to your own IP address (your device will need to be able to reach this).

To build a new copy for distribution:

1. Run `npm run build` in the same directory as this readme.
2. If you've commented out the line ```jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];```
   now is the time to uncomment it.
3. Build & Run on a device to make DoorSign launches correctly in this build mode.
