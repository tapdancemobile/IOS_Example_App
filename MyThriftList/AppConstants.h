//
//  AppConstants.h
//  MyThriftList
//
//  Created by Mark Mathis on 6/19/12.
//  Copyright (c) 2012 Inmar. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MTHRIFTLIST_DB_NAME @"MyThriftList.sqlite"

//settings plists
#define SETTINGS_PLIST_FILENAME @"settings"
#define SETTINGS_OVERRIDE_PLIST_FILENAME @"settingsoverride"

//settings keys
//secured
#define SETTINGS_ENDPOINT_KEY @"secretEndpoint"
#define SETTINGS_API_KEY @"secretAPIKey"
#define SETTINGS_REALM_KEY @"secretRealm"
#define SETTINGS_AUTHENTICATION_TOKEN_KEY @"secretAuthenticationToken"
#define SETTINGS_REFRESH_TOKEN_KEY @"secretRefreshToken"
#define SETTINGS_DEVICE_ID_KEY @"secretDeviceID"
#define SETTINGS_PUSH_TOKEN_KEY @"secretPushToken"
#define SETTINGS_NAMESPACE_KEY @"secretNamespace"
#define SETTINGS_CLIENT_SECRET_KEY @"secretClientSecret"
#define SETTINGS_CLIENT_REDIRECT_KEY @"secretClientRedirect"
#define SETTINGS_ENCRYPTED_KEY @"encrypted"
#define SETTINGS_LAST_INSTALL_OR_IGNORE_VERSION_KEY @"lastInstallOrIgnoreVersion"

//unsecured
#define SETTINGS_OFFERS_LIST_LAST_REFRESH_KEY @"offersListLastRefresh"
#define SETTINGS_MINIMUM_REFRESH_INTERVAL_KEY @"minimumRefreshIntervalInMinutes"

//Services
#define SERVICE_OFFERS_URL @"/Offers"

//Notifications
#define LOGIN_EVENT @"LoginEvent"
#define MODULE_EVENT @"ModuleEvent"
#define SERVER_ERROR_EVENT @"ServerErrorEvent"
#define UPDATE_AVAILABLE_EVENT @"UpdateAvailable"
#define LIST_REFRESH_EVENT @"ListRefreshEvent"
#define LIST_CHANGE_EVENT @"ListChangeEvent"
#define LIST_PAYLOAD_KEY @"ListPayloadKey"
#define LIST_TOTAL_ITEM_COUNT_KEY @"totalItemCount"
#define LIST_CURRENT_PAGE_KEY @"currentPageKey"
#define NETWORK_AVAILABLE_NOTIFICATION @"networkAvailable"
#define NETWORK_DOWN_NOTIFICATION @"networkDown"
#define AUTHENTICATED_NOTIFICATION @"authenticated"
#define UNAUTHENTICATED_NOTIFICATION @"unAuthenticated"
#define UPC_SEARCH_EVENT @"UpcSearchEvent"
#define CHECK_CARD_EVENT @"CheckCardInvalidation"
#define ADD_CARD_EVENT @"AddNewCard"
#define LIST_OFFER_CHANGE_EVENT @"ListOfferChangeEvent"
#define CIRCULAR_CHANGE_EVENT @"CircularChangeEvent"

//Error Message
//Sean is returning a null for empty lists - which is not json compliant
//I have to hardcode to workaround
#define UNEXPECTED_TOKEN_ERROR_MSG @"Unexpected token"

@interface AppConstants : NSObject

@end
