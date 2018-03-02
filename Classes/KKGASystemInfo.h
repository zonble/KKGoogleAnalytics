@import Foundation;

NSString * _Nonnull KKUserAgentString();

/** KKGASystemInfo helps to obtain required system information. */
@interface KKGASystemInfo : NSObject
/** Get the name of current application. */
+ (nullable NSString *)appName;
/** Get the version of current application. */
+ (nullable NSString *)appVersion;
/** Get CPU type. It could be "Intel", "PowerPC" or "Unknown". */
+ (nonnull NSString *)CPUType;
/** Get the model of current device. */
+ (nonnull NSString *)machineModel;
/** Get the language code of current user's primary language. */
+ (nullable NSString *)primaryLanguage;
/** Get screen resolution, such as "1024x768". */
+ (nonnull NSString *)screenResolutionString;
/** Get screen depth, such as "24-bits", "64-bits" or "128-bits". */
+ (nullable NSString *)screenDepthString;
@end
