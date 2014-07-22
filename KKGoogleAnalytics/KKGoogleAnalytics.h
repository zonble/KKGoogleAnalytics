#import <Cocoa/Cocoa.h>

@interface KKGoogleAnalytics : NSObject

+ (instancetype)sharedInstance;
- (void)startDispatching;
- (void)pauseDispatching;
- (void)send:(NSDictionary *)params;

@property (strong, nonatomic) NSString *trackingID;
@property (strong, nonatomic) NSString *userID;
@end

