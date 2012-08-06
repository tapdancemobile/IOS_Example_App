//
//  SettingsHelper.h
//  MyThriftList
//
//  Created by Mark Mathis on 6/25/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsHelper : NSObject

//singleton creator
+(id)sharedInstance;
-(id)init;
-(NSObject *)getSetting:(NSString *)key;
-(BOOL)updateSetting:(NSString *)key value:(NSObject *)value save:(BOOL)save;

@end

