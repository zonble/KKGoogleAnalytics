#import "AppDelegate.h"
#import "KKGoogleAnalytics.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate
            
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[KKGoogleAnalytics sharedInstance].trackingID = @"UA-144934-12";
	[KKGoogleAnalytics sharedInstance].clientID = @"1234";
	[[KKGoogleAnalytics sharedInstance] trackScreenView:@"Hi"];
	[[KKGoogleAnalytics sharedInstance] _sendPayloads];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

@end
