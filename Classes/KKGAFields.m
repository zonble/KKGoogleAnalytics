#import "KKGAFields.h"

NSString *const kKKGAIHitType = @"t";
NSString *const kKKGAITrackingId = @"tid";
NSString *const kKKGAIClientId = @"cid";
NSString *const kKKGAIAnonymizeIp = @"aip";
NSString *const kKKGAISessionControl = @"sc";
NSString *const kKKGAIScreenResolution = @"sr";
NSString *const kKKGAIViewportSize = @"vp";
NSString *const kKKGAIEncoding = @"de";
NSString *const kKKGAIScreenColors = @"sd";
NSString *const kKKGAILanguage = @"ul";
NSString *const kKKGAIJavaEnabled = @"fe";
NSString *const kKKGAIFlashVersion = @"fl";
NSString *const kKKGAINonInteraction = @"ni";
NSString *const kKKGAIReferrer = @"dr";
NSString *const kKKGAILocation = @"dl";
NSString *const kKKGAIHostname = @"dh";
NSString *const kKKGAIPage = @"dp";
NSString *const kKKGAIDescription = @"cd";
NSString *const kKKGAIScreenName = @"cd";
NSString *const kKKGAITitle = @"dt";
NSString *const kKKGAIAppName = @"an";
NSString *const kKKGAIAppVersion = @"av";
NSString *const kKKGAIAppId = @"aid";
NSString *const kKKGAIAppInstallerId = @"aiid";
NSString *const kKKGAIUserId = @"uid";

NSString *const kKKGAIEventCategory = @"ec";
NSString *const kKKGAIEventAction = @"ea";
NSString *const kKKGAIEventLabel = @"el";
NSString *const kKKGAIEventValue = @"ev";

NSString *const kKKGAISocialNetwork = @"sn";
NSString *const kKKGAISocialAction = @"sa";
NSString *const kKKGAISocialTarget = @"st";

NSString *const kKKGAITransactionId = @"ti";
NSString *const kKKGAITransactionAffiliation = @"ta";
NSString *const kKKGAITransactionRevenue = @"tr";
NSString *const kKKGAITransactionShipping = @"ts";
NSString *const kKKGAITransactionTax = @"tt";
NSString *const kKKGAICurrencyCode = @"cu";

NSString *const kKKGAIItemPrice = @"ip";
NSString *const kKKGAIItemQuantity = @"iq";
NSString *const kKKGAIItemSku = @"ic";
NSString *const kKKGAIItemName = @"in";
NSString *const kKKGAIItemCategory = @"iv";

NSString *const kKKGAICampaignSource = @"cs";
NSString *const kKKGAICampaignMedium = @"cm";
NSString *const kKKGAICampaignName = @"cn";
NSString *const kKKGAICampaignKeyword = @"ck";
NSString *const kKKGAICampaignContent = @"cc";
NSString *const kKKGAICampaignId = @"ci";

NSString *const kKKGAITimingCategory = @"utc";
NSString *const kKKGAITimingVar = @"utv";
NSString *const kKKGAITimingValue = @"utt";
NSString *const kKKGAITimingLabel = @"utl";

NSString *const kKKGAIExDescription = @"exd";
NSString *const kKKGAIExFatal = @"exf";

// hit types
NSString *const kKKGAIAppView = @"appview";
NSString *const kKKGAIPageView = @"pageview";
NSString *const kKKGAIEvent = @"event";
NSString *const kKKGAISocial = @"social";
NSString *const kKKGAITransaction = @"transaction";
NSString *const kKKGAIItem = @"item";
NSString *const kKKGAIException = @"exception";
NSString *const kKKGAITiming = @"timing";

NSString *const kKKGAIExperimentID = @"xid";
NSString *const kKKGAIExperimentVariant = @"xvar";

@implementation KKGAFields

+ (NSString *)customDimensionForIndex:(NSUInteger)index
{
	return [NSString stringWithFormat:@"cd%lu", (unsigned long)index];
}
+ (NSString *)customMetricForIndex:(NSUInteger)index
{
	return [NSString stringWithFormat:@"cm%lu", (unsigned long)index];
}

@end
