//
//  OffersBusiness.h
//  MyThriftList
//
//  Created by Mark Mathis on 6/19/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <Foundation/Foundation.h>
#import "BaseBusiness.h"



@interface OffersBusiness : BaseBusiness
@property BOOL isRefreshing;
//singleton creator
+(id)sharedInstance;

//utility methods
- (BOOL)shouldExecuteRefreshisForced:(BOOL)isForced;
- (void)requestRefresh;
- (void)forceRefresh;

- (NSMutableArray *)getCachedItems;

- (void) searchOffers:(NSString *) keyword completionBlock:(void (^)(NSArray *data, NSError *error)) block;


@end
