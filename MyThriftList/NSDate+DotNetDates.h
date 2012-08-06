//
//  NSDate+DotNetDates.h
//  VelsolBase
//
//  Created by Mac User on 1/4/12.
//  Copyright (c) 2012 Velocitor Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DotNetDates)
+(NSDate*) dateFromDotNet:(NSString*)stringDate;
-(NSString*) dateToDotNet;
@end
