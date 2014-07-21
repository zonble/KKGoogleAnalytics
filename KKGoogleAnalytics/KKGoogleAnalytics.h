#import <Cocoa/Cocoa.h>

@interface KKGoogleAnalytics : NSObject
+ (instancetype)sharedInstance;
- (void)_sendPayloads;

- (void)trackScreenView:(NSString *)tag;
- (void)trackTransaction:(NSString *)transactionID affliation:(NSString *)affliation revenue:(NSNumber *)revenue shipping:(NSNumber *)shipping tax:(NSNumber *)tax currencyCode:(NSString *)currencyCode;


@property (retain, nonatomic) NSString *trackingID;
@property (retain, nonatomic) NSString *clientID;
@end
