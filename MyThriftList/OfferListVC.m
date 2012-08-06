//
//  OfferListVC.m
//  MyThriftList
//
//  Created by Dan Xue on 7/19/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//
#import "Offer.h"
#import "OfferListVC.h"
#import "OfferListCell.h"
#import "NoResultsCell.h"
#import "AppConstants.h"
#import "OffersBusiness.h"
#import "UIImageView+AFNetworking.h"
#import "SettingsHelper.h"
#import "SideSwipeTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define BUTTON_LEFT_MARGIN 10.0
#define BUTTON_SPACING 54.0

@interface OfferListVC (PrivateStuff)
-(void) setupSideSwipeView;
@end


@implementation OfferListVC

//@synthesize shoppingListTable;
@synthesize offerListData, brandedLogo;
@synthesize circularDetailData;
@synthesize buttonData, buttons, offerSearchBar;
Offer *offer;
OffersBusiness *offerBusiness;
id observer;
PullToRefreshView *pull;

#pragma mark network and utility methods

-(void)update
{
    //get shopping list - should only be one
    //offerList = [[Offer allObjects] lastObject];
    
    self.offerListData = [offerBusiness getCachedItems];
    
    [tableView reloadData];
    [pull finishedLoading];
}

-(void)requestRefresh:(BOOL)isForced
{
    
    if([offerBusiness shouldExecuteRefreshisForced:isForced])
    {
        //set pull indicator
        self.tableView.contentOffset = CGPointMake(0, -65);
        [pull setState:PullToRefreshViewStateLoading];
        
        if(isForced)
            [offerBusiness forceRefresh];
        else
            [offerBusiness requestRefresh];
    }
}

-(void)initSideSwipe
{
    // Setup the title and image for each button within the side swipe view
    self.buttonData = [NSArray arrayWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Removed", @"title", @"shoppinglist_delete.png", @"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Favorite", @"title", @"shoppinglist_favorite.png", @"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"clipped", @"title", @"shoppinglist_check.png", @"image", nil],
                       nil];
    self.buttons = [[NSMutableArray alloc] initWithCapacity:buttonData.count];
    
    self.sideSwipeView = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.rowHeight)];
    [self setupSideSwipeView];
}

- (void) setupSideSwipeView
{
    // Add the background pattern
    self.sideSwipeView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"dotted-pattern.png"]];
    
    self.sideSwipeView.backgroundColor = [super.brandHelper getDefaultBGColor];
    
    // Overlay a shadow image that adds a subtle darker drop shadow around the edges
    UIImage* shadow = [[UIImage imageNamed:@"inner-shadow.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImageView* shadowImageView = [[UIImageView alloc] initWithFrame:sideSwipeView.frame];
    shadowImageView.alpha = 0.3;
    shadowImageView.image = shadow;
    shadowImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.sideSwipeView addSubview:shadowImageView];
    
    // Iterate through the button data and create a button for each entry
    CGFloat leftEdge = BUTTON_LEFT_MARGIN;
    for (NSDictionary* buttonInfo in buttonData)
    {
        // Create the button
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // Make sure the button ends up in the right place when the cell is resized
        button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        
        // Get the button image
        UIImage* buttonImage = [UIImage imageNamed:[buttonInfo objectForKey:@"image"]];
        
        // Set the button's frame
        button.frame = CGRectMake(leftEdge, sideSwipeView.center.y - buttonImage.size.height/2.0, buttonImage.size.width, buttonImage.size.height);
        
        // Add the image as the button's background image
        // [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        UIImage* grayImage = [super.brandHelper getBrandedRowActionImage:[buttonInfo objectForKey:@"image"]];
        [button setImage:grayImage forState:UIControlStateNormal];
        
        // Add a touch up inside action
        [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // Keep track of the buttons so we know the proper text to display in the touch up inside action
        [buttons addObject:button];
        
        // Add the button to the side swipe view
        [self.sideSwipeView addSubview:button];
        
        // Move the left edge in prepartion for the next button
        leftEdge = leftEdge + buttonImage.size.width + BUTTON_SPACING;
    }
}

#pragma mark Button touch up inside action
- (IBAction) touchUpInsideAction:(UIButton*)button
{
    /*
     {"OfferType":0,"OfferId":0,"Name":"milk","Quantity":1}
     */
    NSIndexPath* indexPath = [tableView indexPathForCell:sideSwipeCell];
    
    NSUInteger index = [buttons indexOfObject:button];
    NSDictionary* buttonInfo = [buttonData objectAtIndex:index];
    
    Offer *item = [offerListData objectAtIndex:indexPath.row];
    OfferListCell *cell = (OfferListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if([(NSString *)[buttonInfo objectForKey:@"title"] isEqualToString:@"Removed"]) {
        cell.clipped = NO;
        item.isClipped = [NSNumber numberWithBool:NO];
    } 
    else if([(NSString *)[buttonInfo objectForKey:@"title"] isEqualToString:@"clipped"]){
        cell.clipped = YES;
        item.isClipped = [NSNumber numberWithBool:YES];
    }
       
    [self removeSideSwipeView:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{ 
    [super viewDidLoad];
    
    //setup sideswipe 
    [self initSideSwipe];
    
    //make tableviw bg clear
    tableView.backgroundView = nil;
    
    //initialize business objects
    offerBusiness = [OffersBusiness sharedInstance];
    
    
    //initialize items
    [self update];
    //setup pull to refresh code
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [pull setDelegate:self];
    [self.tableView addSubview:pull];
    
}


-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    //update view when new list is returned
    [[NSNotificationCenter defaultCenter] addObserverForName:LIST_OFFER_CHANGE_EVENT object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self update];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:CIRCULAR_CHANGE_EVENT object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self update];
    }];
    
    //request a refresh - only executes if time interval has been met
    [[NSNotificationCenter defaultCenter] addObserverForName:NETWORK_AVAILABLE_NOTIFICATION object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        [self requestRefresh:NO];
        
    }];
    
    //force a refresh after system check
    [[NSNotificationCenter defaultCenter] addObserverForName:LIST_REFRESH_EVENT object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        [self requestRefresh:YES];
        
    }];
    
    //server error event
    [[NSNotificationCenter defaultCenter] addObserverForName:SERVER_ERROR_EVENT object:nil queue:nil usingBlock:^(NSNotification *note) {
        [pull finishedLoading];
    }];
    
    
    //set localized title
    self.title = NSLocalizedString(@"OFFER_LIST_VC_TITLE", nil);
    self.navigationController.navigationBar.tintColor = [super.brandHelper getDefaultNavBarColor];
    
    //set bg color
    self.view.backgroundColor = [super.brandHelper getDefaultBGColor];
    self.brandedLogo.image = [super.brandHelper getLargeBrandedLogo];
    self.offerSearchBar.tintColor = [super.brandHelper getDefaultNavBarColor];
    
    //dismiss keyboard if user taps off it's screen area
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]; 
    tap.delegate = self;
    [self.tableView addGestureRecognizer:tap];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([offerSearchBar isFirstResponder]){
        return YES;
    }
    return NO;
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //remove observer from all notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
}

-(void)viewDidAppear:(BOOL)animated
{
    //request refresh - based on interval
    [self requestRefresh:NO];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.offerListData.count > 0)
        return self.offerListData.count;
    else
        return 1;
    
}

- (UITableViewCell *)getItemCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OfferListCell";
    OfferListCell *itemCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (itemCell == nil){
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[OfferListCell class]])
            {
                itemCell = (OfferListCell *)currentObject;
                break;
            }
        }
    }
    Offer *item = [offerListData objectAtIndex:indexPath.row];
    itemCell.offerTitleLabel.text = item.title;
    itemCell.valueLabel.text = [NSString stringWithFormat:@"$%@",[item.discountValue stringValue]] ;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    itemCell.expiredDateLabel.text =[NSString stringWithFormat:@"Expired on %@ ", [dateFormatter stringFromDate:item.validTo]];
    
    if(item.imageUri)
        // Here we use the new provided setImageWithURL: method to load the web image
        [itemCell.productImageView setImageWithURL:[NSURL URLWithString:item.imageUri]
                                  placeholderImage:[UIImage imageNamed:@"image_not_available.png"]];
    
    return itemCell;
}

- (UITableViewCell *)getNoResultsCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NoResultsCell";
    NoResultsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[NoResultsCell class]])
            {
                cell = (NoResultsCell *)currentObject;
                break;
            }
        }
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.offerListData.count > 0)
        return [self getItemCell:self.tableView indexPath:indexPath];   
    else
        return [self getNoResultsCell:self.tableView indexPath:indexPath];
}

//have to do this to change bg color of cell on draw
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    //We need to make sure that the empty results cell isn't used
    if(offerListData.count > 0)
    {
        Offer *item = [offerListData objectAtIndex:indexPath.row];
        OfferListCell *offerListCell = (OfferListCell*)cell;
        
        //here we rely on the KVO we setup in the cell to change the bg color
        offerListCell.clipped = [item.isClipped boolValue];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([offerSearchBar isFirstResponder]){
        [offerSearchBar resignFirstResponder];
        return;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark Pull to refresh delegate methods
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    [self requestRefresh:YES];
}

//search the name and description fields and return core data entries
-(void) searchOffers:(NSString *)keyword 
{
    
    [offerBusiness searchOffers:keyword completionBlock:^(NSArray *data, NSError *error) {
        self.offerListData = [NSMutableArray arrayWithArray:data];
        if(!error)
        {
            dispatch_sync(dispatch_get_main_queue(), ^(void) {
                [self.tableView reloadData];
            });    
        }
        else {
            NSLog(@"error %@", error);
        }
    }];
    
}

-(void)dismissKeyboard {
    [offerSearchBar resignFirstResponder];
}


#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar

{
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;  
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar

{
    searchBar.showsCancelButton = NO;
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchOffers:searchBar.text];
}

@end

