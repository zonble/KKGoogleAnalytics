KKGoogleAnalytics
=================

Yet another Google Analytics library for Mac and iOS (includes Mac Catalyst).

Google has official Google Analytics SDKs for mobile platforms such as
iOS and Adnroid, but Google does not provide such a SDK for Mac OS X,
thus, many developers create their own Google Analytics
library. However, existing open-source library does not meet our need.

Some of them send payloads to Google's measuring API point directly
but not to put them in an upload queue. It may cause creating too many
connections, and it does not sound good for users. It may also fail to
upload payloads if there is no Internet connection, and then we lose
these payloads.

Some of them does not care about the user-agent string contained in
the HTTP connection to send payloads. Google extracts operating system
version and other useful information from user-agent. If we do not
care about it, we lose the information about what the operating
systems and hardware models that our users are using.

That's why we create another Google Analytics library for
Mac. **KKGoogleAnalytics** stores payloads in a Core Data database first
and then schedules timers to upload stored payloads, like Google's own
iOS SDK. It also let the user-agent string carry OS version and
hardware model information.

## Requirements

KKGoogleAnalytics supports Mac OS X 10.7 and above / iOS 3.0 and above / Mac Catalyst 13.0 and above.

## Installation

You can install KKGoogleAnalytics via CocoaPods.

## License

KKGoogleAnalytics is available under the MIT license.
