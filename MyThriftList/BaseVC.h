//
//  BaseVC.h
//  MyThriftList
//
//  Created by Mark Mathis on 6/18/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginOverlayVC.h"
#import "BrandHelper.h"

//temp start
#define SHOPPING_ITEM_MODE 0
#define PRODUCT_MODE 1
#define OFFER_MODE 2
// temp end

#define CIRCULAR_MODE @"circular"
#define COUPON_MODE @"coupon"

@interface BaseVC : UIViewController

@property(nonatomic, strong) LoginOverlayVC *loginOverlay;
@property(nonatomic, weak) BrandHelper *brandHelper;

-(BOOL)authenticated;

@end
