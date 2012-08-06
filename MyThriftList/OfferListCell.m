//
//  OfferListCell.m
//  MyThriftList
//
//  Created by Dan Xue on 7/25/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import "OfferListCell.h"
#import <QuartzCore/QuartzCore.h>
#import "BrandHelper.h"

@implementation OfferListCell

@synthesize retailerLabel;
@synthesize offerTitleLabel;
@synthesize offerDescriptionLabel;
@synthesize expiredDateLabel;
@synthesize productImageView;
@synthesize bgView;
@synthesize valueLabel;
@synthesize clipped;

- (void)awakeFromNib
{
    //setup KVO to change bg based on status
    [self addObserver:self forKeyPath:@"clipped" options:0 context:nil];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


//KVO observer method
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    BrandHelper *brandHelper = [BrandHelper sharedInstance];
    
    if ([@"clipped" isEqualToString:keyPath]) {
        if (clipped) {
            self.bgView.backgroundColor = [UIColor greenColor];
        } else {
            self.bgView.backgroundColor = [brandHelper getDefaultTableRowColor];
        }
    } 
}


- (void)dealloc {
    [self removeObserver:self forKeyPath:@"clipped"];
}

@end