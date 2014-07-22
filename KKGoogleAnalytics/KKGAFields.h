#import <Foundation/Foundation.h>

extern NSString *const kKKGAIHitType;
extern NSString *const kKKGAITrackingId;
extern NSString *const kKKGAIClientId;
extern NSString *const kKKGAIAnonymizeIp;
extern NSString *const kKKGAISessionControl;
extern NSString *const kKKGAIScreenResolution;
extern NSString *const kKKGAIViewportSize;
extern NSString *const kKKGAIEncoding;
extern NSString *const kKKGAIScreenColors;
extern NSString *const kKKGAILanguage;
extern NSString *const kKKGAIJavaEnabled;
extern NSString *const kKKGAIFlashVersion;
extern NSString *const kKKGAINonInteraction;
extern NSString *const kKKGAIReferrer;
extern NSString *const kKKGAILocation;
extern NSString *const kKKGAIHostname;
extern NSString *const kKKGAIPage;
extern NSString *const kKKGAIDescription;  // synonym for kKKGAIScreenName
extern NSString *const kKKGAIScreenName;   // synonym for kKKGAIDescription
extern NSString *const kKKGAITitle;
extern NSString *const kKKGAIAppName;
extern NSString *const kKKGAIAppVersion;
extern NSString *const kKKGAIAppId;
extern NSString *const kKKGAIAppInstallerId;
extern NSString *const kKKGAIUserId;

extern NSString *const kKKGAIEventCategory;
extern NSString *const kKKGAIEventAction;
extern NSString *const kKKGAIEventLabel;
extern NSString *const kKKGAIEventValue;

extern NSString *const kKKGAISocialNetwork;
extern NSString *const kKKGAISocialAction;
extern NSString *const kKKGAISocialTarget;

extern NSString *const kKKGAITransactionId;
extern NSString *const kKKGAITransactionAffiliation;
extern NSString *const kKKGAITransactionRevenue;
extern NSString *const kKKGAITransactionShipping;
extern NSString *const kKKGAITransactionTax;
extern NSString *const kKKGAICurrencyCode;

extern NSString *const kKKGAIItemPrice;
extern NSString *const kKKGAIItemQuantity;
extern NSString *const kKKGAIItemSku;
extern NSString *const kKKGAIItemName;
extern NSString *const kKKGAIItemCategory;

extern NSString *const kKKGAICampaignSource;
extern NSString *const kKKGAICampaignMedium;
extern NSString *const kKKGAICampaignName;
extern NSString *const kKKGAICampaignKeyword;
extern NSString *const kKKGAICampaignContent;
extern NSString *const kKKGAICampaignId;

extern NSString *const kKKGAITimingCategory;
extern NSString *const kKKGAITimingVar;
extern NSString *const kKKGAITimingValue;
extern NSString *const kKKGAITimingLabel;

extern NSString *const kKKGAIExDescription;
extern NSString *const kKKGAIExFatal;

//extern NSString *const kKKGAISampleRate;

//extern NSString *const kKKGAIIdfa;
//extern NSString *const kKKGAIAdTargetingEnabled;

// hit types
extern NSString *const kKKGAIAppView;
extern NSString *const kKKGAIPageView;
extern NSString *const kKKGAIEvent;
extern NSString *const kKKGAISocial;
extern NSString *const kKKGAITransaction;
extern NSString *const kKKGAIItem;
extern NSString *const kKKGAIException;
extern NSString *const kKKGAITiming;

@interface KKGAFields : NSObject
+ (NSString *)customDimensionForIndex:(NSUInteger)index;
+ (NSString *)customMetricForIndex:(NSUInteger)index;
@end
