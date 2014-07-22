#import "AppDelegate.h"
#import "KKGAI.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate
            
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[KKGoogleAnalytics sharedInstance].trackingID = @"UA-144934-12";
	[[KKGoogleAnalytics sharedInstance] send:[[KKGADictionaryBuilder createScreenView:@"Hi"] build]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

@end
