//
//  NSString+Util.m
//  VelsolBase
//
//  Created by Mac User on 12/22/11.
//  Copyright (c) 2011 Velocitor Solutions. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString(Util)

+ (NSString *)getEmptyStringForNil:(NSString *)input
{
    if (input == nil) {
        return @"";
    } else {
        return input;
    }
}

@end
