//
//  BrandedActionButton.h
//  MyThriftList
//
//  Created by Mark Mathis on 7/18/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandedActionButton : UIView

@property(nonatomic,retain) IBOutlet UIButton *button;
@property(nonatomic,retain) IBOutlet UIImageView *imageOverlay;
@property(nonatomic,retain) IBOutlet UILabel *buttonLabel;

@end
