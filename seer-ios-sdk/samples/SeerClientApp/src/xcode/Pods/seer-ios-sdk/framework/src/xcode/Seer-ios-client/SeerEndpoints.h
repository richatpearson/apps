//
//  SeerEndpoints.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/17/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 Manages the base url and endpoint paths for sending data to the Seer Server.<br>
 Current default base path: kSEER_BaseURL = "https://seer-beacon.qaprod.ecollege.com"
 */
@interface SeerEndpoints : NSObject

/*!
 Default base url: "https://seer-beacon.qaprod.ecollege.com"
 */
extern NSString* const kSEER_BaseURL;

/*!
 Initialize instance of SeerEndpoints
 
 @param apiKey API Key supplied by the Seer team when your app was registered.
 
 @return An instance of the SeerEnpoints object,
 */
- (id) initWithApiKey:(NSString*)apiKey;

- (void) addEndpoint:(NSString*)endpoint forName:(NSString*)name;

- (void) changeSeerBaseURL:(NSString*)newBaseURL;

- (NSString*) getSeerBaseURL;

- (NSString*) urlStringForEndpoint:(NSString*)name;

- (NSDictionary*) seerEndpoints;

@end
