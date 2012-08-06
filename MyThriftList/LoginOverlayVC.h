//
//  LoginOverlayVC.h
//  MyThriftList
//
//  Created by Mark Mathis on 7/18/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandedActionButton.h"

@interface LoginOverlayVC : UIViewController

@property(nonatomic,retain) IBOutlet UIImageView *bgView;
@property(nonatomic,retain) IBOutlet UIView *loginButtonPlaceholder;
@property(nonatomic,retain) IBOutlet UIView *registerButtonPlaceholder;

-(IBAction)login:(id)sender;

@end
