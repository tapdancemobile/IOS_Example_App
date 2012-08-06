//
//  UIView+GestureBlocks.m
//  MyThriftList
//
//  Created by Mark Mathis on 7/18/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import "UIView+GestureBlocks.h"

@implementation UIView (GestureBlocks)

@dynamic tapHandler;

- (void (^) (UIGestureRecognizer *sender))tapHandler {
	return (void (^) (UIGestureRecognizer *sender))objc_getAssociatedObject(self, @"tapHandler");
}

- (void)setTapHandler:(void (^) (UIGestureRecognizer *sender))block {
	objc_setAssociatedObject(self,@"tapHandler",block,OBJC_ASSOCIATION_RETAIN);
}

- (void)initialiseTapHandler:(void (^) (UIGestureRecognizer *sender))block forTaps:(int)numberOfTaps
{
    [self setTapHandler:block];
    UITapGestureRecognizer *singleFingerDTap = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(handleTap:)];
    
    singleFingerDTap.numberOfTapsRequired = numberOfTaps;
    singleFingerDTap.numberOfTouchesRequired = 1;
    
    self.userInteractionEnabled = YES;
    self.superview.userInteractionEnabled = YES;
    
    [self addGestureRecognizer:singleFingerDTap];
}

- (IBAction)handleTap:(UIGestureRecognizer *)sender {
    NSLog(@"Called handletap");
    if (self.tapHandler != nil)
        self.tapHandler(sender);
}

@end
