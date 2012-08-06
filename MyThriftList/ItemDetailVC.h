//
//  ItemDetailVC.h
//  MyThriftList
//
//  Created by Dan Xue on 6/22/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "Offer.h"

@interface ItemDetailVC : BaseVC <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> 

// Session 0 Item info cell
@property (nonatomic, strong) IBOutlet UITableViewCell *itemCell;
@property (nonatomic, strong) IBOutlet UIImageView *itemImageView;
@property (nonatomic, strong) IBOutlet UILabel *itemNameLabel; 
@property (nonatomic, strong) IBOutlet UILabel *itemDescriptionLabel;

// Sesssion 1 Edit detail info
@property (nonatomic, strong) IBOutlet UITableViewCell *quantityCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *categoryCell;

// Scroll View (e.g. popular coupons)
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
// delete bn
@property (nonatomic, strong) IBOutlet UIButton * deleteBn;
// data
@property (nonatomic, strong) Offer *offer;



@end
