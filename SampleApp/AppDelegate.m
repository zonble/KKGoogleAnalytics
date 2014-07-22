#import "AppDelegate.h"
#import "KKGASystemInfo.h"
#import "KKGAI.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate
            
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//	NSLog(@"KKUserAgentString():%@", KKUserAgentString());
	[KKGoogleAnalytics sharedInstance].trackingID = @"UA-144934-12";
	[[KKGoogleAnalytics sharedInstance] send:[[KKGADictionaryBuilder createScreenView:@"Hi"] build]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

@end
