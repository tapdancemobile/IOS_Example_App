//
//  NSDate-Misc.h
//  VelsolBase
//
//  Created by  on 3/2/12.
//  Copyright (c) 2012 Velocitor Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSDate(Misc)
+ (NSDate *)dateWithoutTime;
- (NSDate *)dateByAddingDays:(NSInteger)numDays;
- (NSDate *)dateAsDateWithoutTime;
- (int)differenceInDaysTo:(NSDate *)toDate;
- (NSString *)formattedDateString;
- (NSString *)formattedStringUsingFormat:(NSString *)dateFormat;
@end
