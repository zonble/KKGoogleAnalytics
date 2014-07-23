#import "AppDelegate.h"
#import "KKGAISystemInfo.h"
#import "KKGAI.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	KKGAI().trackingID = @"UA-144934-12";
	[KKGAI() send:[[KKGADictionaryBuilder createScreenView:@"KKBOX"] build]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

@end
