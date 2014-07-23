#import "KKGADictionaryBuilder.h"
#import "KKGAFields.h"
#import "KKGAISystemInfo.h"

@interface KKGADictionaryBuilder()
@property (strong, nonatomic) NSMutableDictionary *dictionary;
@end

@implementation KKGADictionaryBuilder

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.dictionary = [NSMutableDictionary dictionary];
	}
	return self;
}

- (void)set:(NSString *)value forKey:(NSString *)key
{
	self.dictionary[key] = value;
}

- (void)setAll:(NSDictionary *)params
{
	[self.dictionary setDictionary:params];
}

- (NSString *)get:(NSString *)paramName
{
	return self.dictionary[paramName];
}

- (id)objectForKeyedSubscript:(id <NSCopying>)key
{
	return self.dictionary[key];
}
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
	self.dictionary[key] = obj;
}

- (NSMutableDictionary *)build
{
	return [NSMutableDictionary dictionaryWithDictionary:self.dictionary];
}

@end


@implementation KKGADictionaryBuilder (ClassMethods)

+ (KKGADictionaryBuilder *)createScreenView:(NSString *)tag
{
	NSParameterAssert(tag);

	KKGADictionaryBuilder *builder = [[KKGADictionaryBuilder alloc] init];
	NSMutableDictionary *payload = [NSMutableDictionary dictionary];
	payload[kKKGAIHitType] = kKKGAIAppView;
	payload[kKKGAIAppName] = [KKGAISystemInfo appName];
	payload[kKKGAIAppVersion] = [KKGAISystemInfo appVersion];
	payload[kKKGAIScreenName] = tag;
	[builder.dictionary setDictionary:payload];
	return builder;
}
+ (KKGADictionaryBuilder *)createPageViewWithName:(NSString *)name hostname:(NSString *)hostname page:(NSString *)page
{
	NSParameterAssert(name);
	NSParameterAssert(hostname);
	NSParameterAssert(page);

	KKGADictionaryBuilder *builder = [[KKGADictionaryBuilder alloc] init];
	NSMutableDictionary *payload = [NSMutableDictionary dictionary];
	payload[kKKGAIHitType] = kKKGAIPageView;
	payload[kKKGAIHostname] = name;
	payload[kKKGAIPage] = page;
	payload[kKKGAITitle] = name;
	[builder.dictionary setDictionary:payload];
	return builder;
}
+ (KKGADictionaryBuilder *)createEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value
{
	NSParameterAssert(category);
	NSParameterAssert(action);

	KKGADictionaryBuilder *builder = [[KKGADictionaryBuilder alloc] init];
	NSMutableDictionary *payload = [NSMutableDictionary dictionary];
	payload[kKKGAIHitType] = kKKGAIEvent;
	payload[kKKGAIEventCategory] = category;
	payload[kKKGAIEventAction] = action;
	if (label) {
		payload[kKKGAIEventLabel] = label;
	}
	if (value) {
		payload[kKKGAIEventValue] = value;
	}
	[builder.dictionary setDictionary:payload];
	return builder;
}
+ (KKGADictionaryBuilder *)createTransaction:(NSString *)transactionID affliation:(NSString *)affliation revenue:(NSNumber *)revenue shipping:(NSNumber *)shipping tax:(NSNumber *)tax currencyCode:(NSString *)currencyCode
{
	NSParameterAssert(transactionID);
	NSParameterAssert(affliation);
	NSParameterAssert(revenue);
	NSParameterAssert(shipping);
	NSParameterAssert(tax);

	KKGADictionaryBuilder *builder = [[KKGADictionaryBuilder alloc] init];
	NSMutableDictionary *payload = [NSMutableDictionary dictionary];
	payload[kKKGAIHitType] = kKKGAITransaction;
	payload[kKKGAITransactionId] = transactionID;
	payload[kKKGAITransactionAffiliation] = affliation;
	payload[kKKGAITransactionRevenue] = revenue;
	payload[kKKGAITransactionShipping] = shipping;
	payload[kKKGAITransactionTax] = tax;
	if (currencyCode) {
		payload[kKKGAICurrencyCode] = currencyCode;
	}
	[builder.dictionary setDictionary:payload];
	return builder;
}
+ (KKGADictionaryBuilder *)createItem:(NSString *)transactionID name:(NSString *)name SKU:(NSString *)SKU cateogory:(NSString *)category price:(NSNumber *)price quantity:(NSNumber *)quantity currencyCode:(NSString *)currencyCode
{
	NSParameterAssert(transactionID);
	NSParameterAssert(name);
	NSParameterAssert(SKU);
	NSParameterAssert(category);
	NSParameterAssert(price);
	NSParameterAssert(quantity);

	KKGADictionaryBuilder *builder = [[KKGADictionaryBuilder alloc] init];
	NSMutableDictionary *payload = [NSMutableDictionary dictionary];
	payload[kKKGAIHitType] = kKKGAIItem;
	payload[kKKGAITransactionId] = transactionID;
	payload[kKKGAIItemName] = name;
	payload[kKKGAIItemPrice] = price;
	payload[kKKGAIItemQuantity] = quantity;
	payload[kKKGAIItemSku] = SKU;
	payload[kKKGAIItemCategory] = category;
	if (currencyCode) {
		payload[kKKGAICurrencyCode] = currencyCode;
	}
	[builder.dictionary setDictionary:payload];
	return builder;
}
+ (KKGADictionaryBuilder *)createSocialWithNetwork:(NSString *)network action:(NSString *)action target:(NSString *)target
{
	NSParameterAssert(network);
	NSParameterAssert(action);
	NSParameterAssert(target);

	KKGADictionaryBuilder *builder = [[KKGADictionaryBuilder alloc] init];
	NSMutableDictionary *payload = [NSMutableDictionary dictionary];
	payload[kKKGAIHitType] = kKKGAISocial;
	payload[kKKGAISocialNetwork] = network;
	payload[kKKGAISocialAction] = action;
	payload[kKKGAISocialTarget] = target;
	[builder.dictionary setDictionary:payload];
	return builder;
}
+ (KKGADictionaryBuilder *)createTimingWithCategory:(NSString *)category interval:(NSNumber *)intervalMillis name:(NSString *)name label:(NSString *)label
{
	NSParameterAssert(category);
	NSParameterAssert(intervalMillis);
	NSParameterAssert(name);
	NSParameterAssert(label);

	KKGADictionaryBuilder *builder = [[KKGADictionaryBuilder alloc] init];
	NSMutableDictionary *payload = [NSMutableDictionary dictionary];
	payload[kKKGAIHitType] = kKKGAITiming;
	payload[kKKGAITimingCategory] = category;
	payload[kKKGAITimingVar] = name;
	payload[kKKGAITimingValue] = intervalMillis;
	payload[kKKGAITimingLabel] = label;
	[builder.dictionary setDictionary:payload];
	return builder;
}
+ (KKGADictionaryBuilder *)createExceptionWithDescription:(NSString *)description withFatal:(NSNumber *)fatal
{
	NSParameterAssert(description);
	NSParameterAssert(fatal);

	KKGADictionaryBuilder *builder = [[KKGADictionaryBuilder alloc] init];
	NSMutableDictionary *payload = [NSMutableDictionary dictionary];
	payload[kKKGAIHitType] = kKKGAIException;
	payload[kKKGAIExDescription] = description;
	payload[kKKGAIExFatal] = fatal;
	[builder.dictionary setDictionary:payload];
	return builder;
}


@end
