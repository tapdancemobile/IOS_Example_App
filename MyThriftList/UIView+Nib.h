//
//  UIView+Nib.h
//  MyThriftList
//
//  Created by Mark Mathis on 7/18/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Nib)
+(UIView *) viewWithNibName:(NSString *)nibName owner:(NSObject *)owner;
@end
