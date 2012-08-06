//
//  BrandHelper.h
//  MyThriftList
//
//  Created by Mark Mathis on 7/18/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BrandedActionButton.h"

@interface BrandHelper : NSObject

//singleton creator
+(id)sharedInstance;

- (BrandedActionButton *)getBrandedActionButton:(NSString *)label owner:(NSObject *)owner;
- (UIImage *)getBrandedBGImage:(NSString *)imageName;
- (UIImage *)getBrandedRowActionImage:(NSString *)imageName;
- (UIColor *)getDefaultBGColor;
- (UIColor *)getDefaultTextColor;
- (UIColor *)getDefaultActionButtonColor;
- (UIColor *)getDefaultBarButtonColor;
- (UIColor *)getDefaultTableRowColor;
- (UIColor *)getDefaultTableBGColor;
- (UIColor *)getDefaultNavBarColor;
- (UIColor *)getDefaultTabBarColor;
- (UIColor *)getDefaultTabItemSelectedColor;
- (UIImage *)getLargeBrandedLogo;
-(UIImage*) imageFilledWith:(UIColor*)color using:(UIImage*)startImage;
@end
