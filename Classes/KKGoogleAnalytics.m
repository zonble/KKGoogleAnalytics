#import "KKGoogleAnalytics.h"
#import "KKGAFields.h"
#import "KKGASystemInfo.h"

KKGoogleAnalytics *KKGAI() {
	return [KKGoogleAnalytics sharedInstance];
}

@interface NSString (HTTPFormExtensions)
+ (instancetype)stringAsWWWURLEncodedFormFromDictionary:(NSDictionary *)formDictionary;
@end

NS_INLINE NSString *KKEscape(NSString *inValue) {
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

static NSString *GenerateUUIDString() {
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
	CFRelease(uuid);
	return CFBridgingRelease(uuidStr);
}

static NSString *const KKGoogleAnalyticsErrorDomain = @"KKGoogleAnalyticsErrorDomain";

@interface KKGoogleAnalytics ()
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
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
		self.language = languages[0];
		self.clientID = existingClientID;
		self.screenResolution = [KKGASystemInfo screenResolutionString];
		self.screenDepth = [KKGASystemInfo screenDepthString];
		[self dispatch];
		[self _scheduleTimer];
	}
	return self;
}

- (void)timer:(NSTimer *)timer
{
	[self dispatch];
}

- (void)_scheduleTimer
{
	if (self.timer) {
		[self.timer invalidate];
		self.timer = nil;
	}
	self.timer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
}

- (BOOL)dispatch
{
	if ([self.operationQueue operationCount]) {
		return NO;
	}

	__block NSError *error = nil;
	__block NSArray *array = nil;
	void (^getArrayBlock)(void) = ^{
		NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		[request setEntity:entityDescription];
		array = [self.managedObjectContext executeFetchRequest:request error:&error];
	};
	if (![NSThread isMainThread]) {
		dispatch_sync(dispatch_get_main_queue(), getArrayBlock);
	}
	else {
		getArrayBlock();
	}
	if (!array || ![array count]) {
		return NO;
	}
	NSMutableString *payload = [NSMutableString string];
	[array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[payload appendFormat:@"%@\n", [obj valueForKey:@"text"]];
	}];

	NSURL *URL = [NSURL URLWithString:@"https://ssl.google-analytics.com/batch"];
	NSMutableURLRequest *HTTPRequest = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	[HTTPRequest setHTTPMethod:@"POST"];
	[HTTPRequest setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
	[HTTPRequest addValue:KKUserAgentString() forHTTPHeaderField:@"User-Agent"];

	[NSURLConnection sendAsynchronousRequest:HTTPRequest queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		if (!connectionError) {
			dispatch_async(dispatch_get_main_queue(), ^{
				for (id object in array) {
					[self.managedObjectContext deleteObject:object];
				}
				[self.managedObjectContext save:nil];
			});
		}
	}];
	return YES;
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

#define SET(k, v) if(v) { payload[k] = v; }
	SET(kKKGAIUserId, self.userID);
	SET(kKKGAIScreenResolution, self.screenResolution);
	SET(kKKGAIScreenColors, self.screenDepth);
	SET(kKKGAILanguage, self.language);
#undef SET

	NSString *text = [NSString stringAsWWWURLEncodedFormFromDictionary:payload];
	void (^insertAndSaveBlock)(void) = ^{
		NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
		[object setValue:text forKey:@"text"];
		[self.managedObjectContext insertObject:object];
		[self.managedObjectContext save:nil];
	};
	if (![NSThread isMainThread]) {
		dispatch_async(dispatch_get_main_queue(), insertAndSaveBlock);
	}
	else {
		insertAndSaveBlock();
	}
}

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

	NSBundle *frameworkBundle = ([NSBundle bundleForClass:[KKGoogleAnalytics class]]) ?: [NSBundle mainBundle];
	NSURL *modelURL = [frameworkBundle URLForResource:@"GoogleAnalytics" withExtension:@"momd"];
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
		if (error.code == NSFileReadNoSuchFileError) {
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

	NSURL *storedDataURL = [applicationFilesDirectory URLByAppendingPathComponent:@"GoogleAnalytics.storedata"];
	NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
	NSString *type = NSSQLiteStoreType; // NSXMLStoreType
	if (![coordinator addPersistentStoreWithType:type configuration:nil URL:storedDataURL options:nil error:&error]) {
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

