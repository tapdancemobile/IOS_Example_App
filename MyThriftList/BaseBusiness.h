//
//  BaseBusiness.h
//  MyThriftList
//
//  Created by Mark Mathis on 6/27/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsHelper.h"
#import "AppConstants.h"


#define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

enum DATA_REQUEST_TYPES{
    OFFERS = 1
};

@interface BaseBusiness : NSObject <RKObjectLoaderDelegate>

@property (nonatomic, strong) SettingsHelper *settingsHelper;


@end
