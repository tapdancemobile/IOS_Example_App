//
//  NSDate+DotNetDates.m
//  VelsolBase
//
//  Created by Mac User on 1/4/12.
//  Copyright (c) 2012 Velocitor Solutions. All rights reserved.
//

#import "NSDate+DotNetDates.h"

@implementation NSDate (DotNetDates)

+(NSDate*) dateFromDotNet:(NSString*)stringDate{
    
    NSDate *returnValue;
    
    if ([stringDate isMemberOfClass:[NSNull class]]) {
        returnValue=nil;
    }
    else {
        NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
        
        returnValue= [[NSDate dateWithTimeIntervalSince1970:
                       [[stringDate substringWithRange:NSMakeRange(6, 10)] intValue]]
                      dateByAddingTimeInterval:offset];
    }
    
    return returnValue;
    
}
-(NSString*) dateToDotNet{
    double timeSince1970=[self timeIntervalSince1970];
    NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    offset=offset/3600;
    double nowMillis = 1000.0 * (timeSince1970);
    NSString *dotNetDate=[NSString stringWithFormat:@"/Date(%.0f%+03d00)/",nowMillis,offset] ;
    return dotNetDate;
}


@end
