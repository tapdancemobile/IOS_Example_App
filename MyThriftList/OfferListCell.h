//
//  OfferListCell.h
//  MyThriftList
//
//  Created by Dan Xue on 7/25/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferListCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel * retailerLabel;
@property(nonatomic, strong) IBOutlet UILabel * offerTitleLabel;
@property(nonatomic, strong) IBOutlet UILabel * offerDescriptionLabel;
@property(nonatomic, strong) IBOutlet UILabel * expiredDateLabel;
//@property(nonatomic, strong) IBOutlet UILabel *productQtyLabel;
@property(nonatomic, strong) IBOutlet UIImageView *productImageView;
@property(nonatomic, strong) IBOutlet UIView *bgView;
@property(nonatomic, strong) IBOutlet UILabel * valueLabel;
@property BOOL clipped;

@end