#import "KKGAISystemInfo.h"
#import <CoreServices/CoreServices.h>

NSString *KKUserAgentString() {
	static NSString *userAgent;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSProcessInfo *info = [NSProcessInfo processInfo];
		SInt32 major, minor, bugfix;
		Gestalt(gestaltSystemVersionMajor, &major);
		Gestalt(gestaltSystemVersionMinor, &minor);
		Gestalt(gestaltSystemVersionBugFix, &bugfix);
		NSString *OSVersion = [NSString stringWithFormat:@"%d_%d_%d", major, minor, bugfix];

		userAgent = [NSString stringWithFormat:@"%@/%@ (Macintosh; N; Mac OS X %@) ",
					 [KKGAISystemInfo appName],
					 [KKGAISystemInfo appVersion],
					 OSVersion] ;
	});
	return userAgent;
}

@implementation KKGAISystemInfo

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
