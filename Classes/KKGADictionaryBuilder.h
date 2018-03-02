@import Foundation;

@interface KKGADictionaryBuilder : NSObject
- (void)set:(nonnull NSString *)value forKey:(nonnull NSString *)key;
- (void)setAll:(nonnull NSDictionary *)params;
- (NSString * _Nonnull)get:(nonnull NSString *)paramName;
- (nonnull NSMutableDictionary *)build;
@end

@interface KKGADictionaryBuilder (ClassMethods)
+ (nonnull instancetype)createScreenView:(nonnull NSString *)tag;
+ (nonnull instancetype)createPageViewWithName:(nonnull NSString *)name hostname:(nonnull NSString *)hostname page:(nonnull NSString *)page;
+ (nonnull instancetype)createEventWithCategory:(nonnull NSString *)category action:(nonnull NSString *)action label:(nullable NSString *)label value:(nullable NSNumber *)value;
+ (nonnull instancetype)createTransaction:(nonnull NSString *)transactionID affliation:(nonnull NSString *)affliation revenue:(nonnull NSNumber *)revenue shipping:(nonnull NSNumber *)shipping tax:(nonnull NSNumber *)tax currencyCode:(nullable NSString *)currencyCode;
+ (nonnull instancetype)createItem:(nonnull NSString *)transactionID name:(nonnull NSString *)name SKU:(nonnull NSString *)SKU cateogory:(nonnull NSString *)category price:(nonnull NSNumber *)price quantity:(nonnull NSNumber *)quantity currencyCode:(nullable NSString *)currencyCode;

+ (nonnull instancetype)createSocialWithNetwork:(nonnull NSString *)network action:(nonnull NSString *)action target:(nonnull NSString *)target;
+ (nonnull instancetype)createTimingWithCategory:(nonnull NSString *)category interval:(nonnull NSNumber *)intervalMillis name:(nonnull NSString *)name label:(nonnull NSString *)label;
+ (nonnull instancetype)createExceptionWithDescription:(nonnull NSString *)description withFatal:(nonnull NSNumber *)fatal;
@end
