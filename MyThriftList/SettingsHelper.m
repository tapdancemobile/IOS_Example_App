//
//  SettingsHelper.m
//  MyThriftList
//
//  Created by Mark Mathis on 6/25/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//


#import "SettingsHelper.h"
#import "NSData+AESCrypt.h"
#import "NSString+AESCrypt.h"
#import "AppConstants.h"

#define AES_ENCRYPTION_KEY @"1nm@r43v3r"

@implementation SettingsHelper

//private settings
NSMutableDictionary *settings;

//just to help with debugging
BOOL shouldEncrypt = YES;
BOOL encrypted;

//This is a singleton method that is type agnostic and makes for cleaner code as we do not need to 
//create a class variable. This is a newer implementation for iOS utilizing the 
//Grand Central Dispatch framework provided by Apple
+(id)sharedInstance;
{
    // structure used to test whether the block has completed or not
    //it seems that it will be set to 0 every time, but a static obj will only be initialized once
    //which is why this works
    static dispatch_once_t p = 0;
    
    //initialize shared object as nil
    //it seems that it will be set to nil every time, but a static obj will only be initialized once
    //which is why this works
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    //this is a grand central dispatch nicety
    //it will increment the counter variable defined before
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (void)overrideSettings:(NSString *)apiId {
    
    // Get Paths
    NSString *defaultSettingsPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_settings", apiId] ofType:@"plist"];
    
    // Read in override settings
    NSMutableDictionary *overrideDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:defaultSettingsPath];

    
    NSNumber *overrideVersion = (NSNumber *)[overrideDictionary objectForKey:@"version"];
    NSNumber *lastOverrideVersion = (NSNumber *)[settings objectForKey:@"lastOverrideVersion"];
    
    //don't reprocess the override file if it has been processed
    if([lastOverrideVersion intValue] == [overrideVersion intValue])
        return;
    
    for (NSString *key in [overrideDictionary allKeys]) {
        //If key exists in dictionary then update existing setting value
        if ([[settings allKeys] indexOfObject:key] != NSNotFound) {
            if (![[overrideDictionary objectForKey:key] isEqual:[settings objectForKey:key]]) {
                
                // Different so merge
                NSLog(@"updating key %@", key);
                [settings setObject:[overrideDictionary objectForKey:key] forKey:key];
            }
        }
        //if key does not exist, add it
        else
        {
            NSLog(@"adding key %@", key);
            [settings setObject:[overrideDictionary objectForKey:key] forKey:key];
        }
    }
    
    //set processed
    [settings setObject:overrideVersion forKey:@"lastOverrideVersion"];
    
}



- (BOOL) updateSettings{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"settings.plist"];
    return [settings writeToFile:filePath atomically:YES];
}

//get setting from plist by key
-(NSObject *)getSetting:(NSString *)key
{
    
    NSObject *setting = [settings objectForKey:key];
    
    //check if the plist is encrypted
    encrypted = [(NSNumber *)[settings objectForKey:SETTINGS_ENCRYPTED_KEY] boolValue];
    
    //check if this is encrypted
    if(encrypted)
    {
        NSLog(@"retrieving key:%@",key);
        NSString *keySubstring = [key substringWithRange:NSMakeRange(0, 6)];
        if ([@"secret" isEqualToString:keySubstring]) {
            setting = [(NSString *)setting AES256DecryptWithKey:AES_ENCRYPTION_KEY];    
        }
    }
    
    return setting;
}

//save setting by key
-(BOOL)updateSetting:(NSString *)key value:(NSObject *)value save:(BOOL)save
{
    //set default value
    [settings setObject:value forKey:key];
    
    //check if the plist is encrypted
    encrypted = [(NSNumber *)[self getSetting:SETTINGS_ENCRYPTED_KEY] boolValue];
    
    //encrypt if we are using encryption
    if(encrypted)
    {
            NSLog(@"updating key:%@",key);
            NSString *keySubstring = [key substringWithRange:NSMakeRange(0, 6)];
            if ([@"secret" isEqualToString:keySubstring]) {
                [settings setObject:[(NSString *)value AES256EncryptWithKey:AES_ENCRYPTION_KEY] forKey:key];
            }
    }
    
    
    BOOL success = YES;
    
    if(save)
        success = [self updateSettings];
    
    return success;
}

- (void)encryptValueForKey:(NSString *)key
{
    NSString *encryptedClientRedirect;
    encryptedClientRedirect = [(NSString *)[self getSetting:key] AES256EncryptWithKey:AES_ENCRYPTION_KEY];
    [self updateSetting:key value:encryptedClientRedirect save:NO];
}

//encrypt sensitive fields
-(void)encryptSensitiveFields 
{
    NSLog(@"********* Encrypting settings *************");
    
    [self encryptValueForKey:SETTINGS_CLIENT_REDIRECT_KEY];
    [self encryptValueForKey:SETTINGS_CLIENT_SECRET_KEY];
    [self encryptValueForKey:SETTINGS_ENDPOINT_KEY];
    [self encryptValueForKey:SETTINGS_NAMESPACE_KEY];
    [self encryptValueForKey:SETTINGS_REALM_KEY];
    [self encryptValueForKey:SETTINGS_REFRESH_TOKEN_KEY];
    [self encryptValueForKey:SETTINGS_AUTHENTICATION_TOKEN_KEY];
    [self encryptValueForKey:SETTINGS_API_KEY];
    [self encryptValueForKey:SETTINGS_DEVICE_ID_KEY];
    [self encryptValueForKey:SETTINGS_PUSH_TOKEN_KEY];
    [self updateSetting:SETTINGS_ENCRYPTED_KEY value:[NSNumber numberWithBool:YES] save:NO];
    
    //write to settings file
    [self updateSettings];
}

- (void)getSettingsFromFileName:(NSString *)mFileName {
    BOOL success;
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:mFileName];
    
    NSString *settingsBundleFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:mFileName];
    
    //check to see if the file is even present in the bundle
    if(![fileManager fileExistsAtPath:settingsBundleFile])
    {
        NSLog(@"%@ file is not present in Resources Directory",mFileName);
    }
        
    
    success = [fileManager fileExistsAtPath:filePath];
    
    //always copy to docs dir
    //this is how we know if plists have been merged
    if(!success){
        [fileManager copyItemAtPath:settingsBundleFile toPath:filePath error:&error];
    } 
    
    //set dictionary
    settings = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    
    //get apiId
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *apiId = [infoDict objectForKey:@"BrandId"];
    
    //override settings based on appId passed in
    [self overrideSettings:apiId];
    
    //save settings to disk incase something changed
    [self updateSettings];
}


- (void)initializeSettings {
    
     [self getSettingsFromFileName:@"settings.plist"];
    
    //check if the plist is encrypted
    encrypted = [(NSNumber *)[self getSetting:SETTINGS_ENCRYPTED_KEY] boolValue];
    
    //The plist should already be encrypted in the bundle, but here we encrypt it just in case.
    if(shouldEncrypt)
    {
        if(!encrypted)
            [self encryptSensitiveFields];
        else
            NSLog(@"********* settings already encrypted *************");
    }
}


- (id)init {
    self = [super init];
    if (self) {
        [self initializeSettings];
    }
    return self;
}

@end

