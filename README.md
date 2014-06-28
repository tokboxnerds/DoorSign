DoorSign
========

DoorSign is an iPad (iOS7.1+) application designed to show the status of meeting rooms using calendars available on the local device.

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
