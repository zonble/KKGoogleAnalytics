@import Foundation;

@class KKGoogleAnalytics;

KKGoogleAnalytics *_Nonnull KKGAI(void);

/**
 The top-level class.
*/
@interface KKGoogleAnalytics : NSObject

/**
 Get the shared instance.
*/
+ (nonnull instancetype)sharedInstance;

/**
 Start the timer to do dispatching.
*/
- (void)startDispatching;

/**
 Pause the timer to do dispatching.
*/
- (void)pauseDispatching;

/**
 Queue tracking information with the given parameter values.
 @param params A map from parameter names to parameter values which
        will be set just for this piece of tracking information, or
        nil for none.
*/
- (void)send:(nonnull NSDictionary *)params;

/**
  Dispatches any pending tracking information.
*/
- (BOOL)dispatch;

/**
 The tracking ID to use for this tracker.  It should be of the form
 `UA-xxxxx-y`.
*/
@property (strong, nonatomic, nullable) NSString *trackingID;

/**
 The user ID for the tracker.
*/
@property (strong, nonatomic, nullable) NSString *userID;
@end
