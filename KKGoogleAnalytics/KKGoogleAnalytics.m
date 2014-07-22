#import "KKGoogleAnalytics.h"
#import "KKGAFields.h"
#import "KKGASystemInfo.h"

@interface NSString (HTTPFormExtensions)
+ (instancetype)stringAsWWWURLEncodedFormFromDictionary:(NSDictionary *)formDictionary;
@end

NS_INLINE NSString *KKEscape(NSString *inValue)
{
	CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)inValue, NULL, CFSTR("&+"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
	return CFBridgingRelease(escaped);
}

@implementation NSString (HTTPFormExtensions)
+ (instancetype)stringAsWWWURLEncodedFormFromDictionary:(NSDictionary *)formDictionary
{
	NSMutableString *combinedDataString = [NSMutableString string];
	NSArray *allKeys = [formDictionary allKeys];
	for (id key in allKeys) {
		id value = formDictionary[key];
		if ([value respondsToSelector:@selector(stringValue)]) {
			value = [value stringValue];
		}
		[combinedDataString appendFormat:@"%@=%@", KKEscape(key), KKEscape(value)];
		if (key != [allKeys lastObject]) {
			[combinedDataString appendString:@"&"];
		}
	}
	return combinedDataString;
}
@end

static NSString *GenerateUUIDString()
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return CFBridgingRelease(uuidStr);
}

static NSString *const KKGoogleAnalyticsErrorDomain = @"KKGoogleAnalyticsErrorDomain";

@interface KKGoogleAnalytics()
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSString *clientID;
@property (strong, nonatomic) NSString *screenResolution;
@property (strong, nonatomic) NSString *screenDepth;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation KKGoogleAnalytics

- (void)dealloc
{
	[self.timer invalidate];
	self.timer = nil;
	[self.operationQueue cancelAllOperations];
}

+ (instancetype)sharedInstance
{
	static dispatch_once_t onceToken;
	static KKGoogleAnalytics *sharedInstance;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[KKGoogleAnalytics alloc] init];
	});
	return sharedInstance;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.operationQueue = [[NSOperationQueue alloc] init];
		self.operationQueue.maxConcurrentOperationCount = 1;
		NSString *existingClientID = [[NSUserDefaults standardUserDefaults] stringForKey:@"GoogleAnalyticsClientID"];
		if (!existingClientID) {
			existingClientID = GenerateUUIDString();
			[[NSUserDefaults standardUserDefaults] setObject:existingClientID forKey:@"GoogleAnalyticsClientID"];
		}
		NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
		self.language = languages[0];
		self.clientID = existingClientID;
		NSScreen *screen = [NSScreen mainScreen];
		self.screenResolution = [NSString stringWithFormat:@"%ldx%ld", (long)screen.frame.size.width, (long)screen.frame.size.height];

		switch (screen.depth) {
			case NSWindowDepthTwentyfourBitRGB:
				self.screenDepth = @"24-bits";
				break;
			case NSWindowDepthSixtyfourBitRGB:
				self.screenDepth = @"64-bits";
				break;
			case NSWindowDepthOnehundredtwentyeightBitRGB:
				self.screenDepth = @"128-bits";
				break;
			default:
				self.screenDepth = nil;
				break;
		}
		[self _sendPayloads];
		[self _scheduleTimer];
	}
	return self;
}

- (void)timer:(NSTimer *)timer
{
	[self _sendPayloads];
}

- (void)_scheduleTimer
{
	if (self.timer) {
		[self.timer invalidate];
		self.timer = nil;
	}
	self.timer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
}

- (void)_sendPayloads
{
	if ([self.operationQueue operationCount]) {
		return;
	}

	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	NSError *error;
	__block NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
	if (![array count]) {
		return;
	}
	NSMutableString *s = [NSMutableString string];
	[array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[s appendFormat:@"%@\n", [obj valueForKey:@"text"]];
	}];

	NSURL *URL = [NSURL URLWithString:@"http://www.google-analytics.com/collect"];
	NSMutableURLRequest *HTTPRequest = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	[HTTPRequest setHTTPMethod:@"POST"];
	[HTTPRequest setHTTPBody:[s dataUsingEncoding:NSUTF8StringEncoding]];
	[HTTPRequest addValue:KKUserAgentString() forHTTPHeaderField:@"User-Agent"];

	[NSURLConnection sendAsynchronousRequest:HTTPRequest queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		if (!connectionError) {
			for (id object in array) {
				[self.managedObjectContext deleteObject:object];
			}
			[self.managedObjectContext save:nil];
		}
	}];
}

- (void)startDispatching
{
	[self _scheduleTimer];
}

- (void)pauseDispatching
{
	if (self.timer) {
		[self.timer invalidate];
		self.timer = nil;
	}
}

- (void)send:(NSDictionary *)params
{
	NSAssert(self.trackingID != nil, @"Must have self.trackingID");
	NSAssert([self.trackingID length] > 0, @"Must have self.trackingID");
	NSAssert(self.clientID != nil, @"Must have self.clientID");
	NSAssert([self.clientID length] > 0, @"Must have self.clientID");

	NSMutableDictionary *payload = [NSMutableDictionary dictionaryWithDictionary:params];
	NSParameterAssert(payload);
	payload[@"v"] = @1;
	payload[kKKGAITrackingId] = self.trackingID;
	payload[kKKGAIClientId] = self.clientID;

	if (self.userID) {
		payload[kKKGAIUserId] = self.userID;
	}
	if (self.screenResolution) {
		payload[kKKGAIScreenResolution] = self.screenResolution;
	}
	if (self.screenDepth) {
		payload[kKKGAIScreenColors] = self.screenDepth;
	}
	if (self.language) {
		payload[kKKGAILanguage] = self.language;
	}

	NSString *text = [NSString stringAsWWWURLEncodedFormFromDictionary:payload];
	NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
	[object setValue:text forKey:@"text"];
	[self.managedObjectContext insertObject:object];
	[self.managedObjectContext save:nil];
}

@end


@implementation KKGoogleAnalytics (CoreData)

- (NSURL *)applicationFilesDirectory
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
	NSString *bundleID = [NSBundle mainBundle].bundleIdentifier;
	return [appSupportURL URLByAppendingPathComponent:bundleID];
}

- (NSManagedObjectModel *)managedObjectModel
{
	if (_managedObjectModel) {
		return _managedObjectModel;
	}

	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GoogleAnalytics" withExtension:@"momd"];
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
	if (_persistentStoreCoordinator) {
		return _persistentStoreCoordinator;
	}

	NSManagedObjectModel *mom = [self managedObjectModel];
	if (!mom) {
		NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
		return nil;
	}

	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
	NSError *error = nil;

	NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];

	if (!properties) {
		BOOL ok = NO;
		if ([error code] == NSFileReadNoSuchFileError) {
			ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
		}
		if (!ok) {
			[[NSApplication sharedApplication] presentError:error];
			return nil;
		}
	}
	else {
		if (![properties[NSURLIsDirectoryKey] boolValue]) {
			// Customize and localize this error.
			NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];

			NSMutableDictionary *dict = [NSMutableDictionary dictionary];
			[dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
			error = [NSError errorWithDomain:KKGoogleAnalyticsErrorDomain code:101 userInfo:dict];

			[[NSApplication sharedApplication] presentError:error];
			return nil;
		}
	}

	NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"GoogleAnalytics.storedata"];
	NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
	NSString *type = NSSQLiteStoreType; // NSXMLStoreType
	if (![coordinator addPersistentStoreWithType:type configuration:nil URL:url options:nil error:&error]) {
		[[NSApplication sharedApplication] presentError:error];
		return nil;
	}
	_persistentStoreCoordinator = coordinator;

	return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
	if (_managedObjectContext) {
		return _managedObjectContext;
	}

	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (!coordinator) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		[dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
		[dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
		NSError *error = [NSError errorWithDomain:KKGoogleAnalyticsErrorDomain code:9999 userInfo:dict];
		[[NSApplication sharedApplication] presentError:error];
		return nil;
	}
	_managedObjectContext = [[NSManagedObjectContext alloc] init];
	[_managedObjectContext setPersistentStoreCoordinator:coordinator];

	return _managedObjectContext;
}

@end

