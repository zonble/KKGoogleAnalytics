#import <Cocoa/Cocoa.h>

@class KKGoogleAnalytics;

KKGoogleAnalytics *KKGAI();

/*! The top-level class. */
@interface KKGoogleAnalytics : NSObject

/*!
 Get the shared instrance.
*/
+ (instancetype)sharedInstance;
/*!
 Start the timer to do dispatching.
*/
- (void)startDispatching;
/*!
 Pause the timer to do dispatching.
*/
- (void)pauseDispatching;

/*!
 Queue tracking information with the given parameter values.
 @param params A map from parameter names to parameter values which
        will be set just for this piece of tracking information, or
        nil for none.
*/
- (void)send:(NSDictionary *)params;
/*!
  Dispatches any pending tracking information.
*/
- (BOOL)dispatch;

/*!
  The tracking ID to use for this tracker.  It should be of the form
 `UA-xxxxx-y`.
*/
@property (strong, nonatomic) NSString *trackingID;
@property (strong, nonatomic) NSString *userID;
@end
