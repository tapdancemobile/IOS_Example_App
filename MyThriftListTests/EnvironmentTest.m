//
//  EnvironmentTest.m
//  MyThriftList
//
//  Created by Mark Mathis on 8/1/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import "EnvironmentTest.h"
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>

@implementation EnvironmentTest

- (void)setUp
{
	[RKTestFactory setUp];
}

- (void)tearDown
{
	[RKTestFactory tearDown];
}

- (void)testSharedSingleton
{
	RKClient *client = [RKTestFactory client];
	STAssertEquals(client, [RKClient sharedClient], nil);
}

- (void)testTearDownOfSharedClient
{
	STAssertNil([RKClient sharedClient], nil);
}



@end
