//
//  BaseBusiness.m
//  MyThriftList
//
//  Created by Mark Mathis on 6/27/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import "BaseBusiness.h"
#import "SettingsHelper.h"


@implementation BaseBusiness

//synthesize so subclasses can access
@synthesize settingsHelper;


- (id)init {
    self = [super init];
    if (self) {
        self.settingsHelper = [SettingsHelper sharedInstance];
    }
    return self;
}

-(NSInteger)getMaxPages:(NSInteger)totalCount pageSize:(NSInteger)pageSize
{
    return totalCount%pageSize==0?totalCount/pageSize:totalCount/pageSize+1;
}

- (void)sendMessage:(NSString *)developerMessage httpErrorMessage:(NSString *)httpErrorMessage url:(NSString *)url
{
    developerMessage = developerMessage==nil?@"":developerMessage;
    httpErrorMessage = httpErrorMessage==nil?@"":httpErrorMessage;
    
    NSArray *keys = [NSArray arrayWithObjects:@"developerMessage", @"httpErrorMessage", @"url", nil];
    NSArray *values = [NSArray arrayWithObjects:developerMessage, httpErrorMessage, url, nil];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SERVER_ERROR_EVENT object:self userInfo:dict];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    
//    NSString *body = response.bodyAsString;
//    
//    //check to see if it was a success
//    if(response.isError || [body isEqualToString:@"null"])
//    {
//        [request cancel];
//    }
//    else
//    {
//        [self request:request didLoadResponse:response];
//    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    
    [NSException raise:NSInvalidArgumentException format:@"You must override the didLoadObjects delegate method in your BaseBusiness subclass"];
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error  
{
    NSLog(@"%@",[error localizedDescription]);
    
//    if (objectLoader.response.isUnauthorized)
//        [authenticationManager handleUnauthorized];
//    else
//    { 
//        NSString *developerMessage =objectLoader.response.bodyAsString;
//        NSString *httpMessage = [error localizedDescription];
//        
//        [self sendMessage:developerMessage httpErrorMessage:httpMessage url:[objectLoader.URL absoluteString]];
//    }
}

@end
