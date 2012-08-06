//
//  AppDelegate.m
//  MyThriftList
//
//  Created by Mark Mathis on 6/18/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import "AppDelegate.h"
#import "OffersBusiness.h"
#import "BrandHelper.h"
#import "AppConstants.h"
#import "SettingsHelper.h"
#import "AFHTTPRequestOperationLogger.h"
#import "watoolkitios-lib/WAToolkit.h"
#import "SettingsHelper.h"
#import "UIDevice+IdentifierAddition.h"
#import "DefaultVC.h"

@implementation AppDelegate

@synthesize window = _window;

UIAlertView *reachabilityAlert;
UIAlertView *serverErrorAlert;
UIAlertView *updateErrorAlert;
WACloudAccessToken *token;
SettingsHelper *settingsHelper;
BrandHelper *brandHelper;


/**
 * Determine if application is running from a test inside an external command-line build by xcodebuild.
 */
- (BOOL) isTest
{
    NSString *wrapper = [[[NSProcessInfo processInfo]environment] valueForKey:@"XCInjectBundle"];
    return wrapper != nil && ([wrapper rangeOfString:@"octest"].location != NSNotFound);
}


- (void)setupRestKitCoreData
{   
    
    // Look for our managed object model in all of the bundles. (From the app
    // it is in the main bundle but not for unit tests.)
    NSString *modelPath = nil;
    for (NSBundle* bundle in [NSBundle allBundles])
    {
        modelPath = [bundle pathForResource:@"MyThriftList" ofType:@"momd"];
        if (modelPath)
            break;
    }
    NSAssert(modelPath != nil, @"Could not find managed object model.");
    NSManagedObjectModel* mom = [[NSManagedObjectModel alloc] 
                                 initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:MTHRIFTLIST_DB_NAME];
    
    bool exists = [fileManager fileExistsAtPath:filePath];
    
    NSError *error;
    
    if (!exists) {
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:MTHRIFTLIST_DB_NAME];
        [fileManager copyItemAtPath:path toPath:filePath error:&error];
    }
    
    if(error != nil)
        NSLog(@"%@",error);
    
    @try {
        // Initialize the object manager.
        [RKObjectManager sharedManager].objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:MTHRIFTLIST_DB_NAME usingSeedDatabaseName:nil managedObjectModel:mom delegate:nil];
    }
    @catch (NSException *exception) {
        NSLog(@" Exception %@", exception.debugDescription);
    }
    
}

-(void)initializeRestKit
{
    
    // Initialize RestKit
    RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:[NSURL URLWithString:(NSString *)[settingsHelper getSetting:SETTINGS_ENDPOINT_KEY]]];

    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:MTHRIFTLIST_DB_NAME];

    //setup input/output mime types
    [RKObjectManager sharedManager].acceptMIMEType = RKMIMETypeJSON; 
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;

    // Enable automatic network activity indicator management
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;

    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelError);
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelError);

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if([self isTest])
    {
        NSLog(@"In Unit Test - No UI needed");
        
        RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
        RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelError);
        RKLogConfigureByName("RestKit/CoreData", RKLogLevelError);
    }
    else
    {
        //initialize TestFlight sdk for feedback
//        [TestFlight takeOff:TESTFLIGHT_TEAM_TOKEN];
//        [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueDeviceIdentifier]];
//        [TestFlight setOptions:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"logToConsole"]];
//        [TestFlight setOptions:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"logToSTDERR"]];
        
        //log AFNetwork requests
        [[AFHTTPRequestOperationLogger sharedLogger] startLogging];
        [[AFHTTPRequestOperationLogger sharedLogger] setLevel:AFLoggerLevelDebug];
        
        //init helpers
        settingsHelper = [SettingsHelper sharedInstance];
        brandHelper = [BrandHelper sharedInstance];
           
        [self initializeRestKit];
        
        //notified of network status changes
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:RKReachabilityDidChangeNotification
                                                   object:nil];
        
        //notified of general server error
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(serverError:)
                                                     name:SERVER_ERROR_EVENT
                                                   object:nil];
        
        
        //register for push
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
        
        
        UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
        tabVC.tabBar.tintColor = [brandHelper getDefaultTabBarColor];
        tabVC.tabBar.selectedImageTintColor = [brandHelper getDefaultTabItemSelectedColor];
    }
        return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark begin push delegate methods
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
    NSString *deviceToken = [[[devToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
   [settingsHelper updateSetting:SETTINGS_PUSH_TOKEN_KEY value:deviceToken save:YES];
}



- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSLog(@"Error in registration. Error: %@", err);
    
}

//reachability delegate method to notify app that we can't hit the network
- (void)reachabilityChanged:(NSNotification*)notification {
    RKReachabilityObserver* observer = (RKReachabilityObserver*)[notification object];
    
    if ([observer isNetworkReachable]) {
        
        //notify all objects that we have a connection
        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_AVAILABLE_NOTIFICATION object:self];
        
    } else {
        
        if(reachabilityAlert == nil)
            reachabilityAlert = [[UIAlertView alloc] initWithTitle:@"Oops.." message:@"Our apologies, we seem to be having network problems. Some portions of the application may be unavailable while we are disconnected." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        if(!reachabilityAlert.isVisible) {
            [reachabilityAlert show];
        }
    
        //notify all objects that we have a connection
        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_DOWN_NOTIFICATION object:self];
    }
    
}


- (void)serverError:(NSNotification*)notification
{
    
    NSString *developerMessage = (NSString *)[notification.userInfo objectForKey:@"developerMessage"];
    
    NSString *httpErrorMessage = (NSString *)[notification.userInfo objectForKey:@"httpErrorMessage"];
    
    NSString *url = (NSString *)[notification.userInfo objectForKey:@"url"];
    
     if(serverErrorAlert == nil)
     {
         serverErrorAlert = [[UIAlertView alloc] initWithTitle:@"Oops.." message: [NSString stringWithFormat:@"Our apologies, but we were unable to complete your last request. Please try it again in a moment. \n\nURL:%@ \n\nError Message: %@\n\nDeveloper Message:%@", url, httpErrorMessage, developerMessage] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     }
    
    if(!serverErrorAlert.isVisible) {
        //only show if not json formatting error
        if(![httpErrorMessage hasPrefix:UNEXPECTED_TOKEN_ERROR_MSG])
            [serverErrorAlert show];
    }
}





@end
