#import "KKGoogleAnalytics.h"

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


static NSString *const KKGoogleAnalyticsErrorDomain = @"KKGoogleAnalyticsErrorDomain";

@interface KKGoogleAnalytics()
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation KKGoogleAnalytics

- (void)dealloc
{
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
	}
	return self;
}

- (void)_sendPayloads
{
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	NSError *error;
	NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
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

	[NSURLConnection sendAsynchronousRequest:HTTPRequest queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

	}];

//	NSLog(@"%@", s);
}

- (void)_doAssertion
{
	NSAssert(self.trackingID != nil, @"Must have self.trackingID");
	NSAssert([self.trackingID length] > 0, @"Must have self.trackingID");
	NSAssert(self.clientID != nil, @"Must have self.clientID");
	NSAssert([self.clientID length] > 0, @"Must have self.clientID");
}

- (void)_addRecord:(NSString *)record
{
	NSParameterAssert(record);
	NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
	[object setValue:record forKey:@"text"];
	[self.managedObjectContext insertObject:object];
	[self.managedObjectContext save:nil];
}

- (NSString *)appName
{
	NSString *name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
	if (!name) {
		name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
	}
	return name;
}

- (NSString *)appVersion
{
	return  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (void)trackScreenView:(NSString *)tag
{
	[self _doAssertion];
	NSParameterAssert(tag);

	NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
	payload[@"v"] = @1;
	payload[@"tid"] = self.trackingID;
	payload[@"cid"] = self.clientID;
	payload[@"t"] = @"appview";
	payload[@"an"] = self.appName;
	payload[@"av"] = self.appVersion;
	payload[@"cd"] = tag;
	[self _addRecord:[NSString stringAsWWWURLEncodedFormFromDictionary:payload]];
}

- (void)trackTransaction:(NSString *)transactionID affliation:(NSString *)affliation revenue:(NSNumber *)revenue shipping:(NSNumber *)shipping tax:(NSNumber *)tax currencyCode:(NSString *)currencyCode
{
	[self _doAssertion];
	NSParameterAssert(transactionID);
	NSParameterAssert(affliation);
	NSParameterAssert(revenue);
	NSParameterAssert(shipping);
	NSParameterAssert(tax);

	NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
	payload[@"v"] = @1;
	payload[@"tid"] = self.trackingID;
	payload[@"cid"] = self.clientID;
	payload[@"t"] = @"transaction";
	payload[@"an"] = self.appName;
	payload[@"av"] = self.appVersion;
	payload[@"ti"] = transactionID;
	payload[@"ta"] = affliation;
	payload[@"tr"] = revenue;
	payload[@"ts"] = shipping;
	payload[@"tt"] = tax;
	if (currencyCode) {
		payload[@"cu"] = currencyCode;
	}
	[self _addRecord:[NSString stringAsWWWURLEncodedFormFromDictionary:payload]];
}

- (void)trackItem:(NSString *)transactionID name:(NSString *)name SKU:(NSString *)SKU cateogory:(NSString *)category price:(NSNumber *)price quantity:(NSNumber *)quantity currencyCode:(NSString *)currencyCode
{
	[self _doAssertion];
	NSParameterAssert(transactionID);
	NSParameterAssert(name);
	NSParameterAssert(SKU);
	NSParameterAssert(category);
	NSParameterAssert(price);
	NSParameterAssert(quantity);

	NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
	payload[@"v"] = @1;
	payload[@"tid"] = self.trackingID;
	payload[@"cid"] = self.clientID;
	payload[@"t"] = @"item";
	payload[@"an"] = self.appName;
	payload[@"av"] = self.appVersion;
	payload[@"ti"] = transactionID;
	payload[@"in"] = name;
	payload[@"ip"] = price;
	payload[@"iq"] = quantity;
	payload[@"ic"] = SKU;
	payload[@"iv"] = category;
	if (currencyCode) {
		payload[@"cu"] = currencyCode;
	}
	[self _addRecord:[NSString stringAsWWWURLEncodedFormFromDictionary:payload]];
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