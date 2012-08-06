//
//  UIColor+HexString.h
//  MyThriftList
//
//  Created by Mark Mathis on 6/21/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor()

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;

+ (UIColor *) colorWithHexString: (NSString *) hexString;

@end
