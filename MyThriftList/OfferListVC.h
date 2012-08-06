//
//  OfferListVC.h
//  MyThriftList
//
//  Created by Dan Xue on 7/19/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "PullToRefreshView.h"
#import "SideSwipeTableViewController.h"

@interface OfferListVC : SideSwipeTableViewController <UITableViewDelegate, UITableViewDataSource, PullToRefreshViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate>

//outlets
@property (nonatomic, strong) IBOutlet UIImageView *brandedLogo;
@property (nonatomic, strong) IBOutlet UISearchBar *offerSearchBar;


//properties
@property (nonatomic, strong) NSMutableArray *offerListData;
@property (nonatomic, strong) NSMutableArray *circularDetailData;
//side swipe stuff
@property (nonatomic, strong) NSArray* buttonData;
@property (nonatomic, strong) NSMutableArray* buttons;



@end
