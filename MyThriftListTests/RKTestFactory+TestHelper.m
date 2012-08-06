//
//  RKTestFactory+TestHelper.m
//  MyThriftList
//
//  Created by Mark Mathis on 8/1/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import "RKTestFactory+TestHelper.h"

@implementation RKTestFactory (TestHelper)

// Perform any global initialization of your testing environment
+ (void)didInitialize
{
	// This is a great place to configure your test bundle
	NSBundle *testTargetBundle = [NSBundle bundleWithIdentifier:@"com.inmar.MyThriftListTests"];
	[RKTestFixture setFixtureBundle:testTargetBundle];
	
	// Or set logging levels for your tests
	RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
}

// Perform any actions you'd like to occur when [RKTestFactory setUp] is invoked
+ (void)didSetUp
{
	// Maybe clear the cache between tests?
	[RKTestFactory clearCacheDirectory];
}

// Perform any actions you'd like to occur when [RKTestFactory tearDown] is invoked
+ (void)didTearDown
{
	
}

@end
