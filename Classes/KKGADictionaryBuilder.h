#import <Foundation/Foundation.h>

@interface KKGADictionaryBuilder : NSObject
- (void)set:(NSString *)value forKey:(NSString *)key;
- (void)setAll:(NSDictionary *)params;
- (NSString *)get:(NSString *)paramName;
- (NSMutableDictionary *)build;
@end

@interface KKGADictionaryBuilder (ClassMethods)
+ (KKGADictionaryBuilder *)createScreenView:(NSString *)tag;
+ (KKGADictionaryBuilder *)createPageViewWithName:(NSString *)name hostname:(NSString *)hostname page:(NSString *)page;
+ (KKGADictionaryBuilder *)createEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value;
+ (KKGADictionaryBuilder *)createTransaction:(NSString *)transactionID affliation:(NSString *)affliation revenue:(NSNumber *)revenue shipping:(NSNumber *)shipping tax:(NSNumber *)tax currencyCode:(NSString *)currencyCode;
+ (KKGADictionaryBuilder *)createItem:(NSString *)transactionID name:(NSString *)name SKU:(NSString *)SKU cateogory:(NSString *)category price:(NSNumber *)price quantity:(NSNumber *)quantity currencyCode:(NSString *)currencyCode;

+ (KKGADictionaryBuilder *)createSocialWithNetwork:(NSString *)network action:(NSString *)action target:(NSString *)target;
+ (KKGADictionaryBuilder *)createTimingWithCategory:(NSString *)category interval:(NSNumber *)intervalMillis name:(NSString *)name label:(NSString *)label;
+ (KKGADictionaryBuilder *)createExceptionWithDescription:(NSString *)description withFatal:(NSNumber *)fatal;
@end
