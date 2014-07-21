#import <Cocoa/Cocoa.h>

@interface KKGoogleAnalytics : NSObject

+ (instancetype)sharedInstance;
- (void)startDispatching;
- (void)pauseDispatching;

@property (retain, nonatomic) NSString *trackingID;
@property (retain, nonatomic) NSString *userID;
@end

@interface KKGoogleAnalytics (Tracking)
- (void)trackScreenView:(NSString *)tag;
- (void)trackPageViewWithName:(NSString *)name hostname:(NSString *)hostname page:(NSString *)page;
- (void)trackEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value;
- (void)trackTransaction:(NSString *)transactionID affliation:(NSString *)affliation revenue:(NSNumber *)revenue shipping:(NSNumber *)shipping tax:(NSNumber *)tax currencyCode:(NSString *)currencyCode;
- (void)trackItem:(NSString *)transactionID name:(NSString *)name SKU:(NSString *)SKU cateogory:(NSString *)category price:(NSNumber *)price quantity:(NSNumber *)quantity currencyCode:(NSString *)currencyCode;
@end
