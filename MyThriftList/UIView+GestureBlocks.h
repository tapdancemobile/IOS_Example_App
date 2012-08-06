//
//  UIView+GestureBlocks.h
//  MyThriftList
//
//  Created by Mark Mathis on 7/18/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIView (GestureBlocks)

@property (readwrite, nonatomic, copy) void (^tapHandler)(UIGestureRecognizer *sender);

- (void)initialiseTapHandler:(void (^) (UIGestureRecognizer *sender))block forTaps:(int)numberOfTaps;
- (IBAction)handleTap:(UIGestureRecognizer *)sender;

@end
