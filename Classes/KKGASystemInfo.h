#import <Foundation/Foundation.h>

NSString *KKUserAgentString();

@interface KKGASystemInfo : NSObject
+ (NSString *)appName;
+ (NSString *)appVersion;
+ (NSString *)CPUType;
+ (NSString *)machineModel;
@end
