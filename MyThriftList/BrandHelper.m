//
//  BrandHelper.m
//  MyThriftList
//
//  Created by Mark Mathis on 7/18/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import "BrandHelper.h"
#import "UIView+Nib.h"
#import "UIImage+Gradient.h"
#import "UIColor+HexString.h"

@implementation BrandHelper

NSDictionary *styleDictionary;

-(NSDictionary *)getStyleDictionary:(NSString *)apiId
{
    NSError *error = nil;
    NSString *fileName = [NSString stringWithFormat:@"%@_style", apiId];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error]; 
    
    if(error)
    {
        NSLog(@"can't get %@.json file",fileName);
    }
    
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if(error)
    {
        NSLog(@"can't parse styles.json file");
    }
    
    return json;
}

- (id)init
{
    self = [super init];
    if (self) {
        //get apiId
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *apiId = [infoDict objectForKey:@"BrandId"];

        styleDictionary = [self getStyleDictionary:apiId];
    }
    return self;
}

+(id)sharedInstance
{
    // structure used to test whether the block has completed or not
    //it seems that it will be set to 0 every time, but a static obj will only be initialized once
    //which is why this works
    static dispatch_once_t p = 0;
    
    //initialize shared object as nil
    //it seems that it will be set to nil every time, but a static obj will only be initialized once
    //which is why this works
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    //this is a grand central dispatch nicety
    //it will increment the counter variable defined before
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (BrandedActionButton *)getBrandedActionButton:(NSString *)label owner:(NSObject *)owner
{
    BrandedActionButton *button = (BrandedActionButton*)[UIView viewWithNibName:@"BrandedActionButton" owner:owner];
    
    button.buttonLabel.text = label;
    
    UIImage *coloredOverlay = [UIImage imageWithGradient:[UIImage imageNamed:@"generic_action_button_color_mask.png"] startColor:[self getDefaultActionButtonColor] endColor:[self getDefaultActionButtonColor]];
    
    button.imageOverlay.image = coloredOverlay;
    
    [button.button setBackgroundImage:[UIImage imageNamed:@"generic_action_button.png"] forState:UIControlStateNormal];
    [button.button setBackgroundImage:[UIImage imageNamed:@"generic_action_button_pressed.png"] forState:UIControlStateHighlighted];
    
    return button;
}

- (UIImage *)getBrandedBGImage:(NSString *)imageName
{
    
    return [UIImage imageWithGradient:[UIImage imageNamed:imageName] startColor:[self getDefaultBGColor] endColor:[UIColor colorWithHexString:@"#FEFDE3"]];;
}


- (UIImage *)getBrandedRowActionImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [self imageFilledWith:[self getDefaultActionButtonColor] using:image];
}


- (UIColor *)getBrandedColorForKey:(NSString *)key
{
    NSString *hexColor = (NSString *)[styleDictionary objectForKey:key];
    
    if(hexColor == nil)
    {
        NSLog(@"Could not find color for key:%@",key);
        return [UIColor whiteColor];
    }
    else
        return [UIColor colorWithHexString:hexColor];
}

- (UIColor *)getDefaultBGColor
{
    return [self getBrandedColorForKey:@"BGColorDefault"];
}

- (UIColor *)getDefaultTextColor
{
    return [self getBrandedColorForKey:@"TextColorDefault"];
}

- (UIColor *)getDefaultActionButtonColor
{
    return [self getBrandedColorForKey:@"ActionButtonColorDefault"];
}

- (UIColor *)getDefaultBarButtonColor
{
    return [self getBrandedColorForKey:@"BarButtonColorDefault"];
}

- (UIColor *)getDefaultTableRowColor
{
    return [self getBrandedColorForKey:@"TableRowColorDefault"];
}

- (UIColor *)getDefaultTableBGColor
{
    return [self getBrandedColorForKey:@"TableBGColorDefault"];
}

- (UIColor *)getDefaultNavBarColor
{
    return [self getBrandedColorForKey:@"NavBarColorDefault"];
}

- (UIColor *)getDefaultTabBarColor
{
    return [self getBrandedColorForKey:@"TabBarColorDefault"];
}

- (UIColor *)getDefaultTabItemSelectedColor
{
    return [self getBrandedColorForKey:@"TabBarItemSelectedColorDefault"];
}

- (UIImage *)getLargeBrandedLogo
{
    //get apiId
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *apiId = [infoDict objectForKey:@"BrandId"];
    NSString *logoName = [NSString stringWithFormat:@"%@_large_logo.png",apiId];
    return [UIImage imageNamed:logoName];
}

#pragma mark Generate images with given fill color
// Convert the image's fill color to the passed in color
-(UIImage*) imageFilledWith:(UIColor*)color using:(UIImage*)startImage
{
    // Create the proper sized rect
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(startImage.CGImage), CGImageGetHeight(startImage.CGImage));
    
    // Create a new bitmap context
    CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(startImage.CGImage), kCGImageAlphaPremultipliedLast);
    
    // Use the passed in image as a clipping mask
    CGContextClipToMask(context, imageRect, startImage.CGImage);
    // Set the fill color
    CGContextSetFillColorWithColor(context, color.CGColor);
    // Fill with color
    CGContextFillRect(context, imageRect);
    
    // Generate a new image
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:startImage.scale orientation:startImage.imageOrientation];
    
    // Cleanup
    CGContextRelease(context);
    CGImageRelease(newCGImage);
    
    return newImage;
}

@end
