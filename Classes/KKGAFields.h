@import Foundation;

/*!
 These fields can be used for the wire format parameter names required by
 the |GAITracker| get, set and send methods as well as the set methods in the
 |GAIDictionaryBuilder| class.
 */
extern NSString * _Nonnull const kKKGAIHitType;
extern NSString * _Nonnull const kKKGAITrackingId;
extern NSString * _Nonnull const kKKGAIClientId;
extern NSString * _Nonnull const kKKGAIAnonymizeIp;
extern NSString * _Nonnull const kKKGAISessionControl;
extern NSString * _Nonnull const kKKGAIScreenResolution;
extern NSString * _Nonnull const kKKGAIViewportSize;
extern NSString * _Nonnull const kKKGAIEncoding;
extern NSString * _Nonnull const kKKGAIScreenColors;
extern NSString * _Nonnull const kKKGAILanguage;
extern NSString * _Nonnull const kKKGAIJavaEnabled;
extern NSString * _Nonnull const kKKGAIFlashVersion;
extern NSString * _Nonnull const kKKGAINonInteraction;
extern NSString * _Nonnull const kKKGAIReferrer;
extern NSString * _Nonnull const kKKGAILocation;
extern NSString * _Nonnull const kKKGAIHostname;
extern NSString * _Nonnull const kKKGAIPage;
extern NSString * _Nonnull const kKKGAIDescription;  // synonym for kKKGAIScreenName
extern NSString * _Nonnull const kKKGAIScreenName;   // synonym for kKKGAIDescription
extern NSString * _Nonnull const kKKGAITitle;
extern NSString * _Nonnull const kKKGAIAppName;
extern NSString * _Nonnull const kKKGAIAppVersion;
extern NSString * _Nonnull const kKKGAIAppId;
extern NSString * _Nonnull const kKKGAIAppInstallerId;
extern NSString * _Nonnull const kKKGAIUserId;

extern NSString * _Nonnull const kKKGAIEventCategory;
extern NSString * _Nonnull const kKKGAIEventAction;
extern NSString * _Nonnull const kKKGAIEventLabel;
extern NSString * _Nonnull const kKKGAIEventValue;

extern NSString * _Nonnull const kKKGAISocialNetwork;
extern NSString * _Nonnull const kKKGAISocialAction;
extern NSString * _Nonnull const kKKGAISocialTarget;

extern NSString * _Nonnull const kKKGAITransactionId;
extern NSString * _Nonnull const kKKGAITransactionAffiliation;
extern NSString * _Nonnull const kKKGAITransactionRevenue;
extern NSString * _Nonnull const kKKGAITransactionShipping;
extern NSString * _Nonnull const kKKGAITransactionTax;
extern NSString * _Nonnull const kKKGAICurrencyCode;

extern NSString * _Nonnull const kKKGAIItemPrice;
extern NSString * _Nonnull const kKKGAIItemQuantity;
extern NSString * _Nonnull const kKKGAIItemSku;
extern NSString * _Nonnull const kKKGAIItemName;
extern NSString * _Nonnull const kKKGAIItemCategory;

extern NSString * _Nonnull const kKKGAICampaignSource;
extern NSString * _Nonnull const kKKGAICampaignMedium;
extern NSString * _Nonnull const kKKGAICampaignName;
extern NSString * _Nonnull const kKKGAICampaignKeyword;
extern NSString * _Nonnull const kKKGAICampaignContent;
extern NSString * _Nonnull const kKKGAICampaignId;

extern NSString * _Nonnull const kKKGAITimingCategory;
extern NSString * _Nonnull const kKKGAITimingVar;
extern NSString * _Nonnull const kKKGAITimingValue;
extern NSString * _Nonnull const kKKGAITimingLabel;

extern NSString * _Nonnull const kKKGAIExDescription;
extern NSString * _Nonnull const kKKGAIExFatal;

// hit types
extern NSString * _Nonnull const kKKGAIAppView;
extern NSString * _Nonnull const kKKGAIPageView;
extern NSString * _Nonnull const kKKGAIEvent;
extern NSString * _Nonnull const kKKGAISocial;
extern NSString * _Nonnull const kKKGAITransaction;
extern NSString * _Nonnull const kKKGAIItem;
extern NSString * _Nonnull const kKKGAIException;
extern NSString * _Nonnull const kKKGAITiming;

extern NSString * _Nonnull const kKKGAIExperimentID;
extern NSString * _Nonnull const kKKGAIExperimentVariant;

/**
 This class provides several fields and methods useful as wire format parameter
 names.  The methods are used for wire format parameter names that are indexed.
 */
@interface KKGAFields : NSObject

/**
 Generates the correct parameter name for a custon dimension with an index.
 @param index the index of the custom dimension.
 @return an NSString representing the custom dimension parameter for the index.
 */
+ (nonnull NSString *)customDimensionForIndex:(NSUInteger)index;

/**
 Generates the correct parameter name for a custom metric with an index.
 @param index the index of the custom metric.
 @return an NSString representing the custom metric parameter for the index.
 */
+ (nonnull NSString *)customMetricForIndex:(NSUInteger)index;
@end
