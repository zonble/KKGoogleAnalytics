#import "KKGASystemInfo.h"
#import <CoreServices/CoreServices.h>

NSString *KKUserAgentString() {
	static NSString *userAgent;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		SInt32 major, minor, bugfix;
		Gestalt(gestaltSystemVersionMajor, &major);
		Gestalt(gestaltSystemVersionMinor, &minor);
		Gestalt(gestaltSystemVersionBugFix, &bugfix);
		NSString *OSVersion = [NSString stringWithFormat:@"%d_%d_%d", major, minor, bugfix];

		userAgent = [NSString stringWithFormat:@"%@/%@ (Macintosh; N; Mac OS X %@) ",
					 [KKGASystemInfo appName],
					 [KKGASystemInfo appVersion],
					 OSVersion] ;
	});
	return userAgent;
}

@implementation KKGASystemInfo

+ (NSString *)appName
{
	NSString *name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
	if (!name) {
		name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
	}
	return name;
}

+ (NSString *)appVersion
{
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

@end
