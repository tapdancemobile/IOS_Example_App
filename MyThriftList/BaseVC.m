//
//  BaseVC.m
//  MyThriftList
//
//  Created by Mark Mathis on 6/18/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import "BaseVC.h"
#import "UIColor+HexString.h"
#import <Foundation/NSJSONSerialization.h>
#import "watoolkitios-lib/WAToolkit.h"
#import "SettingsHelper.h"
#import "AppConstants.h"




@implementation BaseVC

@synthesize loginOverlay, brandHelper;

NSDictionary *appStyles;
WACloudAccessToken *token;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        
        brandHelper = [BrandHelper sharedInstance];
        
        //initialize the overlay
        self.loginOverlay = [[LoginOverlayVC alloc] initWithNibName:@"LoginOverlayVC" bundle:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
   /* UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Profile" 
                                                                     style:UIBarButtonItemStyleBordered  
                                                                    target:self 
                                                                    action:@selector(displayProfile)];
    self.navigationItem.rightBarButtonItem = barButtonItem;*/
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self testACSLogin];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
