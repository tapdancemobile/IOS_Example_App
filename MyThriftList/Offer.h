//
//  Offer.h
//  MyThriftList
//
//  Created by Dan Xue on 7/27/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Offer : NSManagedObject

@property (nonatomic, retain) NSNumber * buyCountDiscountType;
@property (nonatomic, retain) NSNumber * buyDiscountTypeName;
@property (nonatomic, retain) NSNumber * discountType;
@property (nonatomic, retain) NSNumber * discountTypeName;
@property (nonatomic, retain) NSNumber * discountValue;
@property (nonatomic, retain) NSString * imageUri;
@property (nonatomic, retain) NSNumber * itemId;
@property (nonatomic, retain) NSString * offerDescription;
@property (nonatomic, retain) NSNumber * offerType;
@property (nonatomic, retain) NSNumber * offerTypeName;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * unitType;
@property (nonatomic, retain) NSNumber * unitTypeName;
@property (nonatomic, retain) NSDate * validFrom;
@property (nonatomic, retain) NSDate * validTo;
@property (nonatomic, retain) NSNumber * isClipped;

@end
