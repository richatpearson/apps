//
//  PGMPiUserOperation.m
//  Pi-ios-client
//

//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiUserIdOperation.h"
#import "PGMPiError.h"
#import "PGMPiToken.h"
#import "PGMPiEnvironment.h"

@interface PGMPiUserIdOperation ()

@property (nonatomic, strong) PGMPiCredentials *credentials;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) PGMPiEnvironment *environment;

@property (nonatomic, strong) NSMutableData* responseData;

@end

@implementation PGMPiUserIdOperation

NSString* const PGMPiUserIdKey = @"id";
NSString* const PGMPiDataKey = @"data";

- (id) initWithCredentials:(PGMPiCredentials*)credentials
               environment:(PGMPiEnvironment*)environment
                responseId:(NSNumber*)responseId
               requestType:(NSNumber*)requestType
{
    self = [super init];
    if (self)
    {
        _executing_ = NO;
        _finished_ = NO;
        
        self.credentials = credentials;
        self.environment = environment;
        self.responseId = responseId;
        self.requestType = requestType;
        
        self.success = NO;
    }
    return self;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return _executing_;
}

- (BOOL)isFinished
{
    return _finished_;
}

- (void)start
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if ([self isCancelled] || _finished_)
    {
        [self willChangeValueForKey:@"isFinished"];
        _finished_ = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }

    NSString* accessToken = [self.delegate currentAccessToken];
    if (!accessToken)
    {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:NSLocalizedString(@"No Current Access Token", @"No Current Access Token")
                       forKey:NSLocalizedDescriptionKey];
        
        [self.delegate userIdOpCompleteWithCredentials:nil
                                                 error:[NSError errorWithDomain:PGMPiErrorDomain code:PGMPiTokenError userInfo:errorDetail]
                                            responseId:self.responseId
                                           requestType:self.requestType];
        [self markAsComplete];
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    _executing_ = YES;
    [self didChangeValueForKey:@"isExecuting"];

    NSURL* url = [NSURL URLWithString:[self.environment piUserIdPathWithUsername:self.credentials.username]];
    NSLog(@"Url for user id is %@", [self.environment piUserIdPathWithUsername:self.credentials.username]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:accessToken forHTTPHeaderField:@"Authorization"];
    
    [request setTimeoutInterval:15.0];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection == nil)
    {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:NSLocalizedString(@"Cannot establish a network connection", @"Cannot establish a network connection")
                       forKey:NSLocalizedDescriptionKey];
        
        [self.delegate userIdOpCompleteWithCredentials:nil
                                                 error:[NSError errorWithDomain:PGMPiErrorDomain code:PGMPiUserIdError userInfo:errorDetail]
                                            responseId:self.responseId
                                           requestType:self.requestType];
        [self markAsComplete];
    }
}

- (void) markAsComplete
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    _executing_ = NO;
    _finished_ = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if([self isCancelled])
    {
        [self markAsComplete];
		return;
    }
    
    self.responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate userIdOpCompleteWithCredentials:nil
                                             error:error
                                        responseId:self.responseId
                                       requestType:self.requestType];
    [self markAsComplete];
}

/**
 Example User Data
 {
    status: "success"
    data: {
        id: "536409e6e4b085221e58ac31"
        userName: "group12user"
        resetPassword: false
        identity: {
            uri: http://int-piapi.stg-openclass.com/v1/piapi-int/identities/ffffffff5364096be4b06dc3168baa33
            id: "ffffffff5364096be4b06dc3168baa33"
        }
        createdAt: "2014-05-02T21:11:02+0000"
        updatedAt: "2014-05-02T21:11:02+0000"
    }
 }
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError* jsonError = nil;
    NSDictionary* jsonDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&jsonError];
//    NSLog(@"PiUserIDOp: %@", jsonDict);
    if( jsonError )
    {
        [self.delegate userIdOpCompleteWithCredentials:nil
                                                 error:jsonError
                                            responseId:self.responseId
                                           requestType:self.requestType];
    }
    else
    {
        NSDictionary* dataDict = [jsonDict objectForKey:PGMPiDataKey];
            
        if([dataDict isKindOfClass:[NSDictionary class]])
        {
            for (NSString *key in dataDict)
            {
                if ([key isEqualToString:@"id"])
                    self.credentials.userId = [dataDict objectForKey:key];
                if ([key isEqualToString:@"username"])
                    self.credentials.username = [dataDict objectForKey:key];
                if ([key isEqualToString:@"resetPassword"])
                    self.credentials.resetPassword = [[dataDict objectForKey:key] boolValue];
                if ([key isEqualToString:@"identity"])
                {
                    NSDictionary *idDict = (NSDictionary*)[dataDict objectForKey:key];
                    self.credentials.identity = [[PGMPiIdentity alloc] initWithDictionary: idDict];
                }
                
            }
            
            
            [self.delegate userIdOpCompleteWithCredentials:self.credentials
                                                     error:nil
                                                responseId:self.responseId
                                               requestType:self.requestType];
            self.success = YES;
        }
        else
        {
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:NSLocalizedString(@"Unable to obtain userId.", @"Unable to obtain userId.")
                           forKey:NSLocalizedDescriptionKey];
            
            [self.delegate userIdOpCompleteWithCredentials:nil
                                                     error:[NSError errorWithDomain:PGMPiErrorDomain code:PGMPiUserIdError userInfo:errorDetail]
                                                responseId:self.responseId
                                               requestType:self.requestType];
        }
        
    }
    [self markAsComplete];
}

@end
