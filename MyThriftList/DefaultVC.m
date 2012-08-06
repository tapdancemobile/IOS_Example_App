//
//  OopsVCViewController.m
//  MyThriftList
//
//  Created by Mark Mathis on 7/25/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import "DefaultVC.h"

@interface DefaultVC ()

@end

@implementation DefaultVC

@synthesize logoImageView, messageLabel, activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //set bg color
    self.view.backgroundColor = [super.brandHelper getDefaultBGColor];
    self.logoImageView.image = [super.brandHelper getLargeBrandedLogo];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
