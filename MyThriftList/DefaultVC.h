//
//  OopsVCViewController.h
//  MyThriftList
//
//  Created by Mark Mathis on 7/25/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import "BaseVC.h"

@interface DefaultVC : BaseVC

@property(nonatomic,strong) IBOutlet UIImageView *logoImageView;
@property(nonatomic,strong) IBOutlet UILabel *messageLabel;
@property(nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
