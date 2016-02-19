//
//  RumbaFetcher.h
//  PearsonPush
//
//  Created by Tomack, Barry on 3/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

typedef enum
{
    Rumba_Token_Fetch=0,
    Rumba_UserId_Fetch
} RumbaFetchType;

#import <Foundation/Foundation.h>

#define RumbaFetchTokenKey @"auth_token"
#define RumbaFetchUserIDKey @"user_id"

@protocol RumbaFetcherDelegate <NSObject>

- (void) rumbaResponseForFetchType:(NSInteger) type
                        returnData:(NSDictionary*)fetchedData
                             error:(NSError*)error;
@end

@interface RumbaFetcher : NSObject

@property (nonatomic, weak) id <RumbaFetcherDelegate> delegate;

@property (nonatomic, strong) NSMutableData* responseData;
@property (nonatomic, strong) NSURLConnection* connection;

@property (nonatomic, strong) NSError* error;

@property RumbaFetchType fetchType;

- (void) cancelFetch;

- (void) rumbaFetchErrorMessage:(NSString*)errorStr
                      errorCode:(NSUInteger)code;
@end
