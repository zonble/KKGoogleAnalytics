#import "KKGASystemInfo.h"
#import <CoreServices/CoreServices.h>
#include <sys/types.h>
#include <sys/sysctl.h>

NSString *KKUserAgentString(void) {
	static NSString *userAgent;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSString *OSVersion = @"";
		if ([[NSProcessInfo processInfo] respondsToSelector:@selector(operatingSystemVersion)]) {
			NSOperatingSystemVersion versionInfo = [NSProcessInfo processInfo].operatingSystemVersion;
			OSVersion = [NSString stringWithFormat:@"%ld_%ld_%ld", (long)versionInfo.majorVersion, versionInfo.minorVersion, (long)versionInfo.patchVersion];
		}
		else {
			SInt32 major, minor, bugfix;
#if !TARGET_OS_IPHONE
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
			Gestalt(gestaltSystemVersionMajor, &major);
			Gestalt(gestaltSystemVersionMinor, &minor);
			Gestalt(gestaltSystemVersionBugFix, &bugfix);
			OSVersion = [NSString stringWithFormat:@"%d_%d_%d", major, minor, bugfix];
#pragma clang diagnostic pop
#endif
		}

		userAgent = [NSString stringWithFormat:@"%@/%@ (Macintosh; %@ Mac OS X %@; %@)",
					 [KKGASystemInfo appName],
					 [KKGASystemInfo appVersion],
					 [KKGASystemInfo CPUType],
					 OSVersion,
					 [KKGASystemInfo machineModel]] ;
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

+ (NSString *)CPUType
{
	int error = 0;
	int value = 0;
	unsigned long length = sizeof(value) ;

	NSString *visibleCPUType = @"an Unknown Processor";

	error = sysctlbyname("hw.cputype", &value, &length, NULL, 0);
	int cpuType = -1;
	if (error == 0) {
		cpuType = value;
		switch(cpuType) {
			case 7:
				visibleCPUType = @"Intel";
				break;
			case 18:
				visibleCPUType = @"PowerPC";
				break;
			default:
				visibleCPUType = @"Unknown";
				break;
		}
	}

	return visibleCPUType;
}

+ (NSString *)machineModel
{
	size_t len = 0;
	sysctlbyname("hw.model", NULL, &len, NULL, 0);

	if (len) {
		char *model = malloc(len*sizeof(char));
		sysctlbyname("hw.model", model, &len, NULL, 0);
		NSString *model_ns = [NSString stringWithUTF8String:model];
		free(model);
		return model_ns;
	}

	return @"Just an Apple Computer"; //incase model name can't be read
}

+ (NSString *)primaryLanguage
{
	NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
	return languages[0];
}

+ (NSString *)screenResolutionString
{
#if !TARGET_OS_IPHONE
	NSScreen *screen = [NSScreen mainScreen];
	return [NSString stringWithFormat:@"%ldx%ld", (long)screen.frame.size.width, (long)screen.frame.size.height];
#else
	UIScreen *screen = [UIScreen mainScreen];
	return [NSString stringWithFormat:@"%ldx%ld", (long)screen.bounds.size.width, (long)screen.bounds.size.height];
#endif
}

+ (NSString *)screenDepthString
{
#if !TARGET_OS_IPHONE
	NSScreen *screen = [NSScreen mainScreen];
	switch (screen.depth) {
		case NSWindowDepthTwentyfourBitRGB:
			return @"24-bits";
		case NSWindowDepthSixtyfourBitRGB:
			return @"64-bits";
		case NSWindowDepthOnehundredtwentyeightBitRGB:
			return @"128-bits";
		default:
			break;
	}
	return nil;
#else
	return @"24-bits";
#endif
}

@end
