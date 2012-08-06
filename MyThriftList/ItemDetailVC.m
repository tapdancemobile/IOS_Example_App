//
//  ItemDetailVC.m
//  MyThriftList
//
//  Created by Dan Xue on 6/22/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import "ItemDetailVC.h"
#import "UIImageView+AFNetworking.h"

// Product Session
#define ITEM_ROW_HEIGHT 90.0f
// PriceHistory Session
#define EDIT_ROW_HEIGHT 30.0f

@implementation ItemDetailVC

// Session 0 Item info cell
@synthesize itemCell;
@synthesize itemImageView;
@synthesize itemNameLabel; 
@synthesize itemDescriptionLabel;

// Sesssion 1 Edit detail info
@synthesize quantityCell;
@synthesize categoryCell;

// Scroll View (e.g. popular coupons)
@synthesize scrollView;
// delete bn
@synthesize deleteBn;
// data
@synthesize offer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
     //  self.navigationController.navigationBar.tintColor = [super getTintColor];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.itemNameLabel.text = offer.title;
    self.itemDescriptionLabel.text = offer.description;
    [self.itemImageView setImageWithURL:[NSURL URLWithString:offer.imageUri]
                        placeholderImage:[UIImage imageNamed:@"image_not_available.png"]];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   // Return the number of sections.
   return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // Return the number of rows in the section.
   switch (section) {
      case 0: // Product Cell
         return 1;
      case 1: // Coupon/Circular/Price Histroy Cell
         return 2;
      default:
         return 0;
   }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell;
   switch (indexPath.section) {
      case 0:
         return itemCell;
      case 1:
         switch (indexPath.row) {
            case 0:
               return quantityCell;
            case 1:
               return categoryCell;
            default:
               return cell;
         }         
      default:
         return cell;
   }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   switch (indexPath.section) {
      case 0:
         return ITEM_ROW_HEIGHT;
      case 1:
         return EDIT_ROW_HEIGHT;      
      default:
         return 0;
   }
}

@end
