//
//  OffersBusiness.m
//  MyThriftList
//
//  Created by Mark Mathis on 6/19/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import "OffersBusiness.h"
#import "Offer.h"
#import "SettingsHelper.h"
#import "NSDate-Misc.h"



@implementation OffersBusiness

@synthesize isRefreshing;
BOOL connected;
int totalItemCount;

-(BOOL)shouldExecuteRefreshisForced:(BOOL)isForced
{
    //don't allow another refresh if one is already in progress
    if(isRefreshing==YES)
        return NO;
    
    //always allow refresh for forced assuming shopping list is not null
    if (isForced) 
        return YES;
    
    //logic for dependent refresh
    NSNumber *refreshInterval = (NSNumber *)[super.settingsHelper getSetting:SETTINGS_MINIMUM_REFRESH_INTERVAL_KEY];
    NSDate *date = (NSDate *)[super.settingsHelper getSetting:SETTINGS_OFFERS_LIST_LAST_REFRESH_KEY];
    
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    NSInteger elapsedTime = (NSInteger)timeInterval;
    int elapsedTimeInMinutes = abs((elapsedTime/60)%60);
    
   // NSString *accessToken = (NSString *)[super.settingsHelper getSetting:SETTINGS_AUTHENTICATION_TOKEN_KEY];
    
    //not authenticated yet
    //if([@"none" isEqualToString:accessToken])
      //  return NO;
    
    //check interval
    if(elapsedTimeInMinutes > [refreshInterval intValue] || [[self getCachedItems] count] == 0)
    {
        NSLog(@"Should refresh data interval time has been met");
        return YES;
    } else
    {
        NSLog(@"Not refreshing need to wait until refresh interval has been met");
        return NO;
    }
}


-(void)setupMapping 
{
    // Setup our offer mappings
    RKManagedObjectMapping *offerMapping = [RKManagedObjectMapping mappingForClass:[Offer class] inManagedObjectStore:[RKObjectManager sharedManager].objectStore];
    offerMapping.primaryKeyAttribute = @"itemId";
    offerMapping.rootKeyPath = @"Items";
    [offerMapping mapKeyPath:@"ItemId" toAttribute:@"itemId"];
    [offerMapping mapKeyPath:@"OfferType" toAttribute:@"offerType"];
    [offerMapping mapKeyPath:@"Title" toAttribute:@"title"];
    [offerMapping mapKeyPath:@"Description" toAttribute:@"offerDescription"];
    [offerMapping mapKeyPath:@"ValidFrom" toAttribute:@"validFrom"];
    [offerMapping mapKeyPath:@"ValidTo" toAttribute:@"validTo"];
    [offerMapping mapKeyPath:@"UnitType" toAttribute:@"unitType"];
    [offerMapping mapKeyPath:@"DiscountType" toAttribute:@"discountType"];
    [offerMapping mapKeyPath:@"BuyCountDiscountType" toAttribute:@"buyCountDiscountType"];
    [offerMapping mapKeyPath:@"DiscountValue" toAttribute:@"discountValue"];
    [offerMapping mapKeyPath:@"ImageUri" toAttribute:@"imageUri"];
    [offerMapping mapKeyPath:@"OfferTypeName" toAttribute:@"offerTypeName"];
    [offerMapping mapKeyPath:@"DiscountTypeName" toAttribute:@"discountTypeName"];
    [offerMapping mapKeyPath:@"BuyDiscountTypeName" toAttribute:@"buyDiscountTypeName"];
    [offerMapping mapKeyPath:@"UnitTypeName" toAttribute:@"unitTypeName"];
    
    
    
    // Register our mappings with the provider using a key path pattern
    [RKObjectManager.sharedManager.mappingProvider setObjectMapping:offerMapping forResourcePathPattern:SERVICE_OFFERS_URL];
    
    [RKObjectManager.sharedManager.mappingProvider setObjectMapping:offerMapping forKeyPath:@"Items"];
    
    
    
}

- (id)init {
    self = [super init];
    if (self) {
        
        [self setupMapping];
        
        //refresh list when network becomes available
        [[NSNotificationCenter defaultCenter] addObserverForName:NETWORK_AVAILABLE_NOTIFICATION object:nil queue:nil usingBlock:^(NSNotification *note) {
            
            connected = YES;
            
        }];
        
        //disable refresh and paging
        [[NSNotificationCenter defaultCenter] addObserverForName:NETWORK_DOWN_NOTIFICATION object:nil queue:nil usingBlock:^(NSNotification *note) {
            
            connected = NO;
            
        }];
        
    }
    return self;
}

//This is a singleton method that is type agnostic and makes for cleaner code as we do not need to 
//create a class variable of type OffersBusiness. This is a newer implementation for iOS utilizing the 
//Grand Central Dispatch framework provided by Apple
+(id)sharedInstance
{
    // structure used to test whether the block has completed or not
    //it seems that it will be set to 0 every time, but a static obj will only be initialized once
    //which is why this works
    static dispatch_once_t p = 0;
    
    //initialize shared object as nil
    //it seems that it will be set to nil every time, but a static obj will only be initialized once
    //which is why this works
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    //this is a grand central dispatch nicety
    //it will increment the counter variable defined before
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

//remove all offers cache
-(BOOL)clearCache
{
    NSManagedObjectContext *context = [RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread;
    
    for (Offer *offer in [Offer allObjects]) {
        [context deleteObject:offer];
    }
    
    NSError *error;
    [context save:&error];
    
    if(error)
    {
        NSLog(@"Error Clearing the cache:%@",[error localizedDescription]);
        return NO;
    } else
    {
        NSLog(@"Clearing the Offers cache");
        return YES;
    }
}

- (void)getAllOffers
{
    /*https://testapi.mythriftlist.com/v1/Offers?date=2012-06-19&limit=200&offset=0&apiKey=5489A281-6939-4C0E-80C3-32DDCA653790*/
    isRefreshing = YES;
    NSArray *keys = [NSArray arrayWithObjects:@"date",@"limit", @"offset", @"apiKey", nil];
    
    NSString *maxOfferDate = @"2012-07-26";
    //[[NSDate date] formattedStringUsingFormat:@"yyyy-MM-dd"];
    NSNumber *limit = [NSNumber numberWithInt:200];
    NSNumber *offset = [NSNumber numberWithInt:0];
    NSString *apiKey = (NSString *)[super.settingsHelper getSetting:SETTINGS_API_KEY];
    
    NSArray *values = [NSArray arrayWithObjects:maxOfferDate,limit,offset,apiKey,nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[SERVICE_OFFERS_URL stringByAppendingQueryParameters:params] delegate:self];
}

//here we request a refresh and only execute if the specified interval has elapsed
//from the current time and the last refresh
//we also refresh if there is nothing in cache at all - first time only probably
-(void)requestRefresh
{
    if([self shouldExecuteRefreshisForced:YES])
        [self getAllOffers];
}

//here we force a refresh regardless of time interval
-(void)forceRefresh
{
    [self getAllOffers];
}

- (NSArray *)retrieveCachedSortedOffers {
    //show all items - sorted
    NSArray *cachedOffers = [[NSArray alloc] init];
    NSFetchRequest *fetchRequest = [Offer fetchRequest];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    cachedOffers = [Offer objectsWithFetchRequest:fetchRequest];
    
    return cachedOffers;
}

- (NSMutableArray *)getCachedItems {
    //retrieve all items sorted by title
    return [NSMutableArray arrayWithArray:[self retrieveCachedSortedOffers]];
}


#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    
    //cancel request if error
    [super request:request didLoadResponse:response];
    isRefreshing = NO;
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LIST_OFFER_CHANGE_EVENT object:nil];
    //save the last refresh date
    [super.settingsHelper updateSetting:SETTINGS_OFFERS_LIST_LAST_REFRESH_KEY value:[NSDate date] save:YES];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    [super objectLoader:objectLoader didFailWithError:error];
}


- (void) searchOffers:(NSString *) keyword completionBlock:(void (^)(NSArray *data, NSError *error)) block {
    
    //ask gcd to run this for us
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        
        NSArray *returnArray;
        
        if (keyword == nil || [keyword isEqualToString:@""]) {
            returnArray = [self retrieveCachedSortedOffers];
        } else {
            //search core data for key
            returnArray = [Offer objectsWithPredicate:[NSPredicate predicateWithFormat:@"title CONTAINS[c] %@", keyword]];
        }
        
        if(returnArray) {
            block(returnArray, nil);
        } else {
            NSError *error = [NSError errorWithDomain:@"offers_search" code:1 
                                             userInfo:[NSDictionary dictionaryWithObject:@"Can't fetch data" forKey:NSLocalizedDescriptionKey]];
            block(nil, error);
        }
        
    });
}

@end
