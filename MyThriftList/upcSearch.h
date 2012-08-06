//
//  upcSearch.h
//  MyThriftList
//
//  Created by Dan Xue on 6/21/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <Foundation/Foundation.h>

@interface upcSearch : NSObject <RKObjectLoaderDelegate>

//singleton creator
+(id)sharedInstance;

//utility methods
//-(void)getOffers;
-(void)searchByUPC:(NSString*)upcCode;

@end