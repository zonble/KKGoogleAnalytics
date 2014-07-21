#import "AppDelegate.h"
#import "KKGoogleAnalytics.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate
            
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[KKGoogleAnalytics sharedInstance].trackingID = @"UA-144934-12";
//	[[KKGoogleAnalytics sharedInstance] trackScreenView:@"Hi"];
//	[[KKGoogleAnalytics sharedInstance] trackScreenView:@"Test"];
	[[KKGoogleAnalytics sharedInstance] trackScreenView:@"Test 2"];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

@end
