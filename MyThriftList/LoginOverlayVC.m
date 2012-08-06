//
//  LoginOverlayVC.m
//  MyThriftList
//
//  Created by Mark Mathis on 7/18/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import "LoginOverlayVC.h"
#import "AppConstants.h"
#import "BrandHelper.h"
#import "UIView+GestureBlocks.h"

@interface LoginOverlayVC ()

@end

@implementation LoginOverlayVC

@synthesize bgView,loginButtonPlaceholder,registerButtonPlaceholder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BrandHelper *helper = [BrandHelper sharedInstance];
    
    bgView.image = [helper getBrandedBGImage:@"rounded_bg.png"];
    
    BrandedActionButton *brandedLoginBtn = [helper getBrandedActionButton:@"Login" owner:self];
    brandedLoginBtn.center = loginButtonPlaceholder.center;
    [brandedLoginBtn initialiseTapHandler:^(UIGestureRecognizer *sender) {
        [self login:0];
    } forTaps:1];
    
    BrandedActionButton *brandedNewUserBtn = [helper getBrandedActionButton:@"New User" owner:self];
    brandedNewUserBtn.center = registerButtonPlaceholder.center;
    [brandedNewUserBtn initialiseTapHandler:^(UIGestureRecognizer *sender) {
        [self login:0];
    } forTaps:1];
    
    [self.view addSubview:brandedLoginBtn];
    [self.view addSubview:brandedNewUserBtn];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)login:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_EVENT object:nil];
}

@end
