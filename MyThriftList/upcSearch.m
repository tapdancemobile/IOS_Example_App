//
//  upcSearch.m
//  MyThriftList
//
//  Created by Dan Xue on 6/21/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import "upcSearch.h"
#import "InmarConstants.h"
#import "UPC.h"

@implementation upcSearch 


-(void)setupMapping 
{
   //set up for upc search 
   RKObjectMapping *upcMapping = [RKObjectMapping mappingForClass:[UPC class]];
   upcMapping.rootKeyPath = @"0";
   [upcMapping mapKeyPath:@"productname" toAttribute:@"productName"];
   [upcMapping mapKeyPath:@"producturl" toAttribute:@"productUrl"];
   
   // Register our mappings with the provider using a key path pattern
   [RKObjectManager.sharedManager.mappingProvider setObjectMapping:upcMapping forKeyPath:@"0"];
}

- (id)init {
   self = [super init];
   if (self) {
      
      [self setupMapping];
      
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



#pragma mark business methods

-(void)searchByUPC:(NSString*) upcCode
{
   /*[[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@%@",UPC_SEARCH_URL,upcCode] usingBlock:^(RKObjectLoader* loader) {
      loader.delegate = self;
      loader.objectMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[UPC class]];
     // NSLog(@"%@%@",UPC_SEARCH_URL,upcCode);
   }];*/
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@",UPC_SEARCH_URL] usingBlock:^(RKObjectLoader* loader) {
    loader.delegate = self;
    loader.objectMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[UPC class]];
    // NSLog(@"%@%@",UPC_SEARCH_URL,upcCode);
    }];
   
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
   
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
   
   // Send a notification - set the list objects
   NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObject:objects forKey:LIST_PAYLOAD_KEY];
   
   [[NSNotificationCenter defaultCenter] postNotificationName:LIST_REFRESH_EVENT_STOP object:self userInfo:dict];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
   UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
   [alert show];
   NSLog(@"Hit error: %@", error);
}

@end
