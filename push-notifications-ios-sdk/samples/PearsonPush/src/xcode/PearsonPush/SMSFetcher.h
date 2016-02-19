//
//  SMSFetcher.h
//  PearsonPush
//
//  Created by Richard Rosiak on 3/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SMSFetchAuthTokenKey @"auth_token"
#define SMSFetchUserIDKey @"user_id"

@protocol SMSFetcherDelegate <NSURLConnectionDelegate>

- (void) smsResponseWithReturnData:(NSDictionary*)fetchedData
                             error:(NSError*)error;
@end

@interface SMSFetcher : NSObject

@property (nonatomic, weak) id <SMSFetcherDelegate> delegate;

@property (nonatomic, weak) NSString* authPath;

@property (nonatomic, strong) NSURLConnection* connection;
@property (nonatomic, strong) NSError* error;
@property (nonatomic, strong) NSMutableData* responseData;

- (id) initWithAuthPath:(NSString*)authPath;

- (void) fetchTokenWithUsername:(NSString *)username
                       password:(NSString *)password;

- (void) cancelFetch;

@end
