//
//  PGMPiClient.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 5/23/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiClient.h"
#import "PGMPiSecureStorage.h"
#import "PGMPiTokenOperation.h"
#import "PGMPiUserIdOperation.h"
#import "PGMPiTokenRefreshOperation.h"
#import "PGMPiConsent.h"
#import "PGMPiConsentPolicy.h"
#import "PGMPiForgotPassword.h"
#import "PGMPiForgotUsername.h"

@interface PGMPiClient()

@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) NSString *redirectUrl;

@property (nonatomic, readwrite) NSString *piUserId;

@property (nonatomic, strong) PGMPiToken *currentToken;
@property (nonatomic, strong) NSString *keychainAccessGroup;
@property (nonatomic, assign) CFTypeRef cfkeychainAccessibility;

@property (nonatomic, readwrite) PGMPiEnvironment *piEnvironment;
@property (nonatomic, strong) PGMPiSecureStorage *piSecureStorage;

@property (nonatomic, strong) NSOperationQueue *piLoginQueue;
@property (nonatomic, strong) NSOperationQueue *piTokenRefreshQueue;

@property (nonatomic, copy) PiRequestComplete loginRequestComplete;
@property (nonatomic, copy) PiRequestComplete tokenRefreshRequestComplete;
@property (nonatomic, copy) PiRequestComplete validTokenRequestComplete;
@property (nonatomic, copy) PiRequestComplete consentFlowRequestComplete;

@property (nonatomic, strong) NSMutableDictionary* responseDict;

// operations
@property (nonatomic, strong) PGMPiTokenOperation *piTokenOp;
@property (nonatomic, strong) PGMPiUserIdOperation *piUserIdOp;
@property (nonatomic, strong) PGMPiTokenRefreshOperation *piTokenRefreshOp;

@property (nonatomic, strong) NSMutableArray *consentPolicyIds;
@property (nonatomic, strong) NSString *escrowTicket;

@property (nonatomic, strong) NSMutableArray *observedOperations;

@end

NSString* const PGMPiLoginRequest           = @"piLoginRequest";
NSString* const PGMPiTokenRefreshRequest    = @"piTokenRefreshRequest";
NSString* const PGMPiValidTokenRequest      = @"piValidTokenRequest";
NSString* const PGMPiForgotPasswordRequest  = @"piForgotPasswordRequest";
NSString* const PGMPiForgotUsernameRequest  = @"piForgotUsernameRequest";
NSString* const PGMPiLoginQueueName         = @"PiLoginQueue";
NSString* const PGMPiTokenRefreshQueueName  = @"PiTokenRefreshQueue";

@implementation PGMPiClient

- (id) initWithClientId:(NSString*)clientId
           clientSecret:(NSString*)clientSecret
            redirectUrl:(NSString*)redirectUrl
{
    // Precondition - Can't continue without the client Id
    NSParameterAssert(clientId);
    
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    self.clientId = clientId;
    self.clientSecret = clientSecret;
    self.redirectUrl = redirectUrl;
    
    self.piEnvironment = [PGMPiEnvironment stagingEnvironment];
    self.responseDict = [NSMutableDictionary new];
    
    self.observedOperations = [NSMutableArray array];
    
    [self createOperationQueues];
    
    self.secureStoreCredentials = YES;
    self.cfkeychainAccessibility = kSecAttrAccessibleWhenUnlocked;
    
    if (!self.clientLoginOptions)
    {
        self.clientLoginOptions = [PGMPiClientLoginOptions new];
    }
    
    self.consentPolicyIds = [NSMutableArray new];
    
#ifdef _SECURITY_SECITEM_H_
    self.piSecureStorage = [PGMPiSecureStorage new];
#endif
    
    return self;
}

- (BOOL) setEnvironment:(PGMPiEnvironment*)environment
{
    if (environment)
    {
        self.piEnvironment = environment;
        return YES;
    }
    else
    {
        assert(0);
    }
    return NO;
}

- (void) setUserId:(NSString*)userId
{
    self.piUserId = userId;
}

- (void) setKeychainAccessGroup:(NSString*)accessGroup
{
    self.keychainAccessGroup = accessGroup;
}

- (void) setKeychainAccessibility:(id)keychainAccessibility
{
    self.cfkeychainAccessibility = (__bridge CFTypeRef)keychainAccessibility;
}

#pragma mark Bookkeeping

- (void)createOperationQueues
{
    self.piLoginQueue = [NSOperationQueue new];
    [self.piLoginQueue addObserver:self forKeyPath:@"operations" options:0 context:NULL];
    [self.piLoginQueue setName:PGMPiLoginQueueName];
    
    self.piTokenRefreshQueue = [NSOperationQueue new];
    [self.piTokenRefreshQueue addObserver:self forKeyPath:@"operations" options:0 context:NULL];
    [self.piTokenRefreshQueue setName:PGMPiTokenRefreshQueueName];
}

- (void)removeOperationQueues
{
    [self.piTokenRefreshQueue removeObserver:self forKeyPath:@"operations"];
    [self.piLoginQueue removeObserver:self forKeyPath:@"operations"];
    self.piTokenRefreshQueue = nil;
    self.piLoginQueue = nil;
}

- (void)stopObservingOperations
{
    [self.observedOperations enumerateObjectsUsingBlock:^(NSObject *operation, NSUInteger idx, BOOL *stop) {
        [operation removeObserver:self forKeyPath:@"isFinished"];
    }];
    self.observedOperations = nil;
}

-(void)dealloc
{
    //we *must* stop listening to the queues when we deallocate.
    // if we don't then the KVO framework will throw an InternalConsistencyException
    // when a KVO event happens after the PiClient is deallocated.
    [self stopObservingOperations];
    [self removeOperationQueues];
    
}

#pragma mark Requests

- (PGMPiResponse*) loginWithUsername:(NSString *)username
                            password:(NSString *)password
                             options:(PGMPiClientLoginOptions *)options

{
    PGMPiResponse *response =  [self loginWithUsername:username
                                              password:password
                                               options:(PGMPiClientLoginOptions *)options
                                            onComplete:nil];
    
    return response;
}

- (PGMPiResponse*) loginWithUsername:(NSString *)username
                            password:(NSString *)password
                             options:(PGMPiClientLoginOptions *)options
                          onComplete:(PiRequestComplete)onComplete
{
    if (options)
    {
        self.clientLoginOptions = options;
    }
    
    self.piCredentials = [PGMPiCredentials credentialsWithUsername:username password:password];
    
    PGMPiResponse* response = [self createNewResponseForRequest:PiLoginRequest];
    
    if (self.piEnvironment.currentEnvironmentType == PGMPiNoEnvironment)
    {
        response.requestStatus = PiRequestFailure;
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:NSLocalizedString(@"No Environment (PGMPiStaging, PGMPiProduction, PGMPiCustom) was set", @"No Envirionment was set.")
                       forKey:NSLocalizedDescriptionKey];
        response.error = [NSError errorWithDomain:PGMPiErrorDomain code:PGMPiConnectionError userInfo:errorDetail];
        NSLog(@"PiClient ERROR: No Environment was set");
        if(onComplete)
        {
            onComplete(response);
        }
    }
    else
    {
        if ([self storeResponse:response])
        {
            if([self performLoginWithUsername:username
                                     password:password
                                  responseObj:response])
            {
                if(onComplete)
                {
                    self.loginRequestComplete = onComplete;
                }
                response.requestStatus = PiRequestPending;
            }
            else
            {
                response.requestStatus = PiRequestFailure;
                NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                [errorDetail setValue:NSLocalizedString(@"Initialization options not available", @"Initialization options not available.")
                               forKey:NSLocalizedDescriptionKey];
                response.error = [NSError errorWithDomain:PGMPiErrorDomain code:PGMPiConnectionError userInfo:errorDetail];
                if(onComplete)
                {
                    onComplete(response);
                }
            }
        }
        else
        {
//            NSLog(@"Can't store response - another request running..?");
            response.requestStatus = PiRequestFailure;
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:NSLocalizedString(@"There is a Login Request currently running.", @"There is a Login Request currently running.")
                           forKey:NSLocalizedDescriptionKey];
            response.error = [NSError errorWithDomain:PGMPiErrorDomain code:PGMPiConnectionError userInfo:errorDetail];
            if(onComplete)
            {
                onComplete(response);
            }
        }
    }
    
    if ( response.requestStatus != PiRequestFailure)
    {
        self.loginRequestComplete = onComplete;
    }
    
    return response;
}

- (PGMPiResponse*) refreshAccessToken
{
    return [self refreshAccessTokenAndOnComplete:nil];
}

- (PGMPiResponse*) refreshAccessTokenAndOnComplete:(PiRequestComplete)onComplete
{
    PGMPiResponse* response = [self createNewResponseForRequest:PiTokenRefreshRequest];
    
    if (onComplete)
    {
        self.tokenRefreshRequestComplete = onComplete;
    }
    
    if (self.piUserId)
    {
        if ([self storeResponse:response])
        {
            if ([self performTokenRefreshWithResponseObj:response])
            {
                response.requestStatus = PiRequestPending;
            }
        }
    }
    else
    {
        response.requestStatus = PiRequestFailure;
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:NSLocalizedString(@"Unable to refresh token due to missing User Id.", @"Unable to refresh token due to missing User Id.")
                       forKey:NSLocalizedDescriptionKey];
        response.error = [NSError errorWithDomain:PGMPiErrorDomain code:PGMPiConnectionError userInfo:errorDetail];
    }
    
    return response;
}

- (PGMPiResponse*) validAccessToken
{
    return [self validAccessTokenAndOnComplete:nil];
}

- (PGMPiResponse*) validAccessTokenAndOnComplete:(PiRequestComplete)onComplete
{
    PGMPiResponse* response = [self createNewResponseForRequest:PiValidTokenRequest];
    
    if( self.currentToken )
    {
        if([self.currentToken isCurrent])
        {
            [response setObject:self.currentToken forOperationType:PiValidToken];
            response.requestStatus = PiRequestSuccess;
        }
        else
        {
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:NSLocalizedString(@"Access Token is not valid", @"Access Token is not valid")
                           forKey:NSLocalizedDescriptionKey];
            response.error = [NSError errorWithDomain:PGMPiErrorDomain code:PGMPiTokenError userInfo:errorDetail];
            response.requestStatus = PiRequestFailure;
        }
    }
    else
    {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:NSLocalizedString(@"There is no current Access Token", @"There is no current Access Token")
                       forKey:NSLocalizedDescriptionKey];
        response.error = [NSError errorWithDomain:PGMPiErrorDomain code:PGMPiTokenError userInfo:errorDetail];
        response.requestStatus = PiRequestFailure;
    }
    if (onComplete)
    {
        onComplete(response);
    }
    return response;
}

- (PGMPiResponse*) validAccessTokenWithUserId:(NSString*)userId
{
    return [self validAccessTokenWithUserId:userId onComplete:nil];
}

- (PGMPiResponse*) validAccessTokenWithUserId:(NSString*)userId onComplete:(PiRequestComplete)onComplete
{
    PGMPiResponse* response = [self createNewResponseForRequest:PiValidTokenRequest];
    
    PGMPiToken * tokenObj = [self retrieveTokenObjWithIdentifier:userId];
    
    self.piUserId = userId;
    
    if(tokenObj)
    {
//        NSLog(@"PiClient validAccessTokenWithUserId HAS TOKEN OBJECT");
        if([tokenObj isCurrent])
        {
//            NSLog(@"PiClient validAccessTokenWithUserId Token Object IS CURRENT");
            [response setObject:tokenObj forOperationType:PiValidToken];
            response.requestStatus = PiRequestSuccess;
            
            self.currentToken = tokenObj;
            
            if (onComplete)
            {
                onComplete(response);
            }
        }
        else
        {
//            NSLog(@"PiClient validAccessTokenWithUserId Token Object IS NOT CURRENT");
            self.tokenRefreshRequestComplete = onComplete;
            response.requestType = PiTokenRefreshRequest;
            if ([self storeResponse:response])
            {
                if ([self performTokenRefreshWithResponseObj:response])
                {
                    response.requestStatus = PiRequestPending;
                }
            }
        }
    }
    
    return response;
}

- (PGMPiResponse*) createNewResponseForRequest:(PGMPiRequestType)requestType
{
    PGMPiResponse* response = [PGMPiResponse new];
    response.requestType = requestType;
    response.requestStatus = PiRequestPending;
    
    if (self.currentToken)
    {
        response.accessToken = self.currentToken.accessToken;
    }
    if (self.piUserId)
    {
        response.userId = self.piUserId;
    }
    
    return response;
}

- (BOOL) storeResponse:(PGMPiResponse*)response
{
    if ([self.responseDict objectForKey:[response piRequestType]])
    {
        return NO;
    }
    [self.responseDict setObject:response forKey:[response piRequestType]];
    return YES;
}

- (BOOL) performLoginWithUsername:(NSString*)username
                         password:(NSString*)password
                      responseObj:(PGMPiResponse*)response
{
    if (!self.clientLoginOptions)
    {
        return NO;
    }
    NSMutableArray *opArray = [NSMutableArray new];
    // Go Through Init Options
    if(self.clientLoginOptions.requestTokens)
    {
        [self tokenOpWithUsername:username
                         password:password
                      responseObj:response];
        [opArray addObject:self.piTokenOp];
    }
    if (self.clientLoginOptions.requestUserId)
    {
        [self userIdOpWithUsername:username
                       responseObj:response];
        [self.piUserIdOp addDependency:self.piTokenOp];
        [opArray addObject:self.piUserIdOp];
    }
    
    [self.piLoginQueue addOperations:opArray waitUntilFinished:NO];
    return YES;
}

- (BOOL) performTokenRefreshWithResponseObj:(PGMPiResponse*)response
{
    [self tokenRefreshOpWithResponseObj:response];
    
    [self.piTokenRefreshQueue addOperation:self.piTokenRefreshOp];
    return YES;
}

#pragma mark Operation setters
- (void) tokenOpWithUsername:(NSString*)username
                    password:(NSString*)password
                 responseObj:(PGMPiResponse*)response
{
    self.piTokenOp = [[PGMPiTokenOperation alloc] initWithClientId:self.clientId
                                                       redirectUrl:self.redirectUrl
                                                          username:username
                                                          password:password
                                                       environment:self.piEnvironment
                                                        responseId:[response piResponseId]
                                                       requestType:[response piRequestType]];
    self.piTokenOp.delegate = self;
    [self.piTokenOp addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
    [self.observedOperations addObject:self.piTokenOp];
}

- (void) userIdOpWithUsername:(NSString*)username
                  responseObj:(PGMPiResponse*)response
{
    self.piUserIdOp = [[PGMPiUserIdOperation alloc] initWithCredentials:self.piCredentials
                                                            environment:self.piEnvironment
                                                             responseId:[response piResponseId]
                                                            requestType:[response piRequestType]];
    self.piUserIdOp.delegate = self;
    [self.piUserIdOp addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
    [self.observedOperations addObject:self.piUserIdOp];
}

- (void) tokenRefreshOpWithResponseObj:(PGMPiResponse*)response
{
    self.currentToken = [self retrieveTokenObjWithIdentifier:self.piUserId];
    
    self.piTokenRefreshOp = [[PGMPiTokenRefreshOperation alloc] initWithClientId:self.clientId
                                                                    clientSecret:self.clientSecret
                                                                        tokenObj:self.currentToken
                                                                     environment:self.piEnvironment
                                                                      responseId:[response piResponseId]
                                                                     requestType:[response piRequestType]];
    self.piTokenRefreshOp.delegate = self;
    [self.piTokenRefreshOp addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
    [self.observedOperations addObject:self.piTokenRefreshOp];
}


#pragma mark Operation REQUEST COMPLETE methods

- (void) requestComplete:(NSNumber*)requestType
{
    PGMPiResponse *response = [self.responseDict objectForKey:requestType];
    
    if (! [self respond:response withCompletionBlockForRequest:requestType])
    {
        if (! [self respondWithDelegate:response] )
        {
            if (! [self respond:response withNotificationForRequestType:requestType] )
            {
                NSLog(@"Error: PGMPiClient has no way to respond to request");
            }
        }
    }
    [self.responseDict removeObjectForKey:requestType];
    if ( requestType == [NSNumber numberWithInteger:PiLoginRequest] )
    {
        if (! response.error)
        {
            [self secureStoreLoginOpResults];
        }
    }
    if ( requestType == [NSNumber numberWithInteger:PiTokenRefreshRequest] )
    {
        if (! response.error)
        {
            [self storeTokenObj:self.currentToken
                 withIdentifier:self.piUserId
          keychainAccessibility:(__bridge id)kSecAttrAccessibleWhenUnlocked
                    accessGroup:nil];
        }
    }
}

- (BOOL) respond:(PGMPiResponse*)response withCompletionBlockForRequest:(NSNumber*)requestType
{
    BOOL responded = NO;
    switch ([requestType intValue])
    {
        case PiLoginRequest:
            if (self.loginRequestComplete)
            {
                self.loginRequestComplete(response);
                responded = YES;
            }
            break;
        case PiTokenRefreshRequest:
            self.tokenRefreshRequestComplete(response);
            responded = YES;
            break;
            //        case PiValidTokenRequest:
            //            self.validTokenRequestComplete(response);
            //            responded = YES;
            //            break;
        default:
            NSLog(@"ERROR: CAN'T FIND REQUEST TYPE");
            break;
    }
    return responded;
}

- (BOOL) respondWithDelegate:(PGMPiResponse*)response
{
    BOOL responded = NO;
    
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(delegateResponse:)])
        {
            [self.delegate delegateResponse:response];
            responded = YES;
        }
    }
    
    return responded;
}

- (BOOL) respond:(PGMPiResponse*)response withNotificationForRequestType:(NSNumber*)requestType
{
    BOOL responded = NO;
    
    NSString *event = @"";
    
    switch ([requestType intValue])
    {
        case PiLoginRequest:
            event = PGMPiLoginRequest;
            break;
        case PiTokenRefreshRequest:
            event = PGMPiTokenRefreshRequest;
            break;
        case PiValidTokenRequest:
            event = PGMPiValidTokenRequest;
            break;
        default:
            break;
    }
    if ( ![event isEqualToString:@""] )
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:event object:response];
        });
        responded = YES;
    }
    return responded;
}

- (void) secureStoreLoginOpResults
{
    [self storeTokenObj:self.currentToken
         withIdentifier:self.piUserId
  keychainAccessibility:(__bridge id)kSecAttrAccessibleWhenUnlocked
            accessGroup:nil];
    
    if (self.secureStoreCredentials)
    {
        [self storeCredentials:self.piCredentials
                withIdentifier:self.piUserId
         keychainAccessibility:(__bridge id)kSecAttrAccessibleWhenUnlocked
                   accessGroup:nil];
    }
    else
    {
        [self deleteCredentialsWithIdentifier:self.piUserId];
    }
}

- (BOOL) logout
{
    if (self.piUserId)
    {
        [self deleteTokenObjWithIdentifier:self.piUserId];
        if(self.secureStoreCredentials)
        {
            [self deleteCredentialsWithIdentifier:self.piUserId];
        }
    }
    self.currentToken = [PGMPiToken new];
    return YES;
}

- (PGMPiResponse*) submitConsentPolicies:(NSArray*)policies
                     withCurrentUsername:(NSString*)username
                             andPassword:(NSString*)password
                              onComplete:(PiRequestComplete)onComplete {
    
    self.consentFlowRequestComplete = onComplete;
    
    PGMPiResponse *response = [self submitConsentPolicies:policies
                                      withCurrentUsername:username
                                              andPassword:password];
    
    return response;
}

- (PGMPiResponse*) submitConsentPolicies:(NSArray*)policies
                     withCurrentUsername:(NSString*)username
                             andPassword:(NSString*)password
{
    PGMPiResponse* response = [self createNewResponseForRequest:PiLoginRequest];
    
    PiRequestComplete consentPostCompletionHandler = ^(PGMPiResponse *response) {
        if (response.error) {
            [self.responseDict removeObjectForKey:[NSNumber numberWithInteger:response.requestType]];
            self.consentFlowRequestComplete(response);
        } else {
            self.consentFlowRequestComplete(response);
            [self performLoginWithUsername:username password:password responseObj:response];
        }
    };
    
    if ([self validateConsentToPolicies:policies]) {
        if ([self storeResponse:response]) {
        
            PGMPiConsent *consent = [PGMPiConsent new];
            [consent postConsentForPolicyIds:self.consentPolicyIds
                             andEscrowTicket:self.escrowTicket
                              forEnvironment:self.piEnvironment
                          withResponseObject:response
                                  onComplete:consentPostCompletionHandler];
        } else {
            NSLog(@"Can't store request for posting consent. Another Pi Login request must be running");
        }
    } else {
//        NSLog(@"Consents are not valid");
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:NSLocalizedString(@"Missing consent", @"User has not consented to all policies.")
                       forKey:NSLocalizedDescriptionKey];
        response.error = [NSError errorWithDomain:PGMPiErrorDomain code:PGMPiMissingConsentError userInfo:errorDetail];
        
        self.consentFlowRequestComplete(response);
    }
    
    return response;
}

- (BOOL) validateConsentToPolicies:(NSArray*)policies {
    if (policies.count != self.consentPolicyIds.count) {
        return NO;
    }
    
    for (PGMPiConsentPolicy *policy in policies) {
        if (!policy.isConsented || ![self.consentPolicyIds containsObject:policy.policyId]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark PI "Forgot" Methods

- (PGMPiResponse*) forgotPasswordForUsername:(NSString *)username
{
    return [self forgotPasswordForUsername:username onComplete:nil];
}

- (PGMPiResponse*) forgotPasswordForUsername:(NSString*)username
                                  onComplete:(PiRequestComplete)onComplete
{
    PGMPiResponse *response = [self createNewResponseForRequest:PiForgotPasswordRequest];
    
    if (! onComplete)
    {
        onComplete = ^(PGMPiResponse *response) {
            if (self.delegate)
            {
                if ([self.delegate respondsToSelector:@selector(delegateResponse:)])
                {
                    [self.delegate delegateResponse:response];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:PGMPiForgotPasswordRequest object:response];
            });
        };
    }
    
    if (username && ![username isEqualToString:@""])
    {
        [PGMPiForgotPassword requestPasswordWithUsername:username
                                                clientId:self.clientId
                                           piEnvironment:self.piEnvironment
                                              piResponse:response
                                              onComplete:onComplete];
    }
    else
    {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:NSLocalizedString(@"Missing username", @"A valid username must be submitted to receive a reset password email.")
                       forKey:NSLocalizedDescriptionKey];
        response.error = [NSError errorWithDomain:PGMPiErrorDomain code:PiForgotPasswordRequest userInfo:errorDetail];
        
        if (onComplete) {
            onComplete(response);
        }
        // Untested Delegate Response - might not be necessary
        if (self.delegate)
        {
            if ([self.delegate respondsToSelector:@selector(delegateResponse:)])
            {
                [self.delegate delegateResponse:response];
            }
        }
    }
    
    return response;
}

- (PGMPiResponse*) forgotUsernameForEmail:(NSString *)email
{
    return [self forgotUsernameForEmail:email
                             onComplete:nil];
}

- (PGMPiResponse*) forgotUsernameForEmail:(NSString *)email
                               onComplete:(PiRequestComplete)onComplete
{
    PGMPiResponse* response = [self createNewResponseForRequest:PiForgotUsernameRequest];
    
    if (! onComplete)
    {
        onComplete = ^(PGMPiResponse *response) {
            if (self.delegate)
            {
                if ([self.delegate respondsToSelector:@selector(delegateResponse:)])
                {
                    [self.delegate delegateResponse:response];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:PGMPiForgotUsernameRequest object:response];
            });
        };
    }
    
    if (email && ![email isEqualToString:@""])
    {
        [PGMPiForgotUsername requestUsernameForEmail:email
                                            clientId:self.clientId
                                       piEnvironment:self.piEnvironment
                                          piResponse:response
                                          onComplete:onComplete];
    }
    else
    {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:NSLocalizedString(@"Missing email", @"A valid email must be submitted to receive a reset username reminder.")
                       forKey:NSLocalizedDescriptionKey];
        response.error = [NSError errorWithDomain:PGMPiErrorDomain code:PiForgotUsernameRequest userInfo:errorDetail];
        
        if (onComplete) {
            onComplete(response);
        }
        // Untested Delegate Response - might not be necessary
        if (self.delegate)
        {
            if ([self.delegate respondsToSelector:@selector(delegateResponse:)])
            {
                [self.delegate delegateResponse:response];
            }
        }
    }
    
    return response;
}

#pragma mark PI API Delegate
- (NSString*) currentAccessToken
{
    NSString* aToken = [NSString stringWithFormat:@"Bearer %@", self.currentToken.accessToken];
    
    return aToken;
}

- (void) tokenOpCompleteWithToken:(PGMPiToken*)token
                            error:(NSError*)error
                       responseId:(NSNumber*)responseId
                      requestType:(NSNumber*)requestType
{
    PGMPiResponse* response = [self.responseDict objectForKey:requestType];
    if (token)
    {
        self.currentToken = token;
        [response setObject:token forOperationType:PiTokenOp];
        //NSLog(@"Setting token Object in Response: %@", [response getObjectForOperationType:PiTokenOp]);
    }
    if (error)
    {
        response.error = error;
    }
}

- (void) tokenOpCompleteWithEscrowTicket:(NSString*)escrowTicket
                                   error:(NSError*)error
                              responseId:(NSNumber*)responseId
                             requestType:(NSNumber*)requestType
{
    PGMPiResponse* response = [self.responseDict objectForKey:requestType];
    response.error = error;
    if (escrowTicket)
    {
        self.escrowTicket = escrowTicket;
        PGMPiConsent *consent = [PGMPiConsent new];
        NSArray *consentPolicies = [consent requestPoliciesWithEscrowTicket:escrowTicket
                                                                environment:self.piEnvironment];
        
        if (consentPolicies && consentPolicies.count > 0)
        {
            [self storeConsentPolicyIdsForConsents:consentPolicies];
            [response setObject:consentPolicies forOperationType:PiTokenOp];
        } else {
            NSString *errorDesc = @"Cannot parse consent policy data.";
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:NSLocalizedString(errorDesc, @"Cannot parse consent policy data.")
                           forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:PGMPiErrorDomain code:PGMPiTokenError userInfo:errorDetail];
        }
    }
    if (error)
    {
        response.error = error;
    }
}

- (void) storeConsentPolicyIdsForConsents:(NSArray*)consentPolicies
{
    if (self.consentPolicyIds.count > 0) {
        [self.consentPolicyIds removeAllObjects];
    }
    
    for (PGMPiConsentPolicy *policy in consentPolicies) {
        [self.consentPolicyIds addObject:policy.policyId];
    }
}

- (void) userIdOpCompleteWithCredentials:(PGMPiCredentials*)credentials
                                   error:(NSError*)error
                              responseId:(NSNumber*)responseId
                             requestType:(NSNumber*)requestType
{
    PGMPiResponse* response = [self.responseDict objectForKey:requestType];
    if (credentials)
    {
        self.piCredentials = credentials;
        self.piUserId = self.piCredentials.userId;
        [response setObject:self.piCredentials forOperationType:PiUserIdOp];
    }
    if (error)
    {
        response.error = error;
    }
}

- (void) tokenRefreshOpCompleteWithToken:(PGMPiToken*)token
                                   error:(NSError*)error
                              responseId:(NSNumber*)responseId
                             requestType:(NSNumber*)requestType
{
    PGMPiResponse* response = [self.responseDict objectForKey:requestType];
    if (token)
    {
        self.currentToken = token;
        [response setObject:token forOperationType:PiTokenRefreshOp];
//        NSLog(@"Setting token Object in  token refresh Response: %@", self.currentToken);
    }
    if (error)
    {
        response.error = error;
    }
}

#pragma mark Secure Storage

- (BOOL) storeCredentials:(PGMPiCredentials*)credentials
           withIdentifier:(NSString *)identifier
{
    return [self storeCredentials:credentials
                   withIdentifier:identifier
            keychainAccessibility:(__bridge id)kSecAttrAccessibleWhenUnlocked
                      accessGroup:nil];
}

- (BOOL) storeCredentials:(PGMPiCredentials*)credentials
           withIdentifier:(NSString *)identifier
    keychainAccessibility:(id)keychainAccessibility
{
    // if keychainAccessibility is nil, set it default value
    if(!keychainAccessibility)
        keychainAccessibility = CFBridgingRelease(kSecAttrAccessibleWhenUnlocked);
    
    return [self storeCredentials:credentials
                   withIdentifier:identifier
            keychainAccessibility:keychainAccessibility
                      accessGroup:nil];
}

- (BOOL) storeCredentials:(PGMPiCredentials*)credentials
           withIdentifier:(NSString *)identifier
              accessGroup:(NSString *)accessGroup
{
    return [self storeCredentials:credentials
                   withIdentifier:identifier
            keychainAccessibility:(__bridge id)kSecAttrAccessibleWhenUnlocked
                      accessGroup:accessGroup];
}

- (BOOL) storeCredentials:(PGMPiCredentials*)credentials
           withIdentifier:(NSString *)identifier
    keychainAccessibility:(id)keychainAccessibility
              accessGroup:(NSString *)accessGroup
{
    // if keychainAccessibility is nil, set it default value
    if(!keychainAccessibility)
        keychainAccessibility = CFBridgingRelease(kSecAttrAccessibleWhenUnlocked);
    
    NSData *credentialsData = [NSKeyedArchiver archivedDataWithRootObject:credentials];
    
    return [self.piSecureStorage storeKeychainData:credentialsData
                                    withIdentifier:identifier
                                           service:PGMPiSecureCredentialsService
                             keychainAccessibility:keychainAccessibility
                                       accessGroup:accessGroup];
}

- (PGMPiCredentials *) retrieveCredentialsWithIdentifier:(NSString *)identifier
{
    NSData *credData = [self.piSecureStorage retrieveDataWithIdentifier:identifier
                                                                service:PGMPiSecureCredentialsService
                                                            accessGroup:self.keychainAccessGroup];
    
    PGMPiCredentials *credential = [NSKeyedUnarchiver unarchiveObjectWithData:credData];
    
    return credential;
}

- (BOOL) deleteCredentialsWithIdentifier:(NSString *)identifier
{
    return [self.piSecureStorage deleteDataWithIdentifer:identifier
                                                 service:PGMPiSecureCredentialsService
                                             accessGroup:self.keychainAccessGroup];
}

- (BOOL) storeTokenObj:(PGMPiToken*)tokenObj
        withIdentifier:(NSString *)identifier
{
    return [self storeTokenObj:tokenObj
                withIdentifier:identifier
         keychainAccessibility:(__bridge id)kSecAttrAccessibleWhenUnlocked
                   accessGroup:nil];
}

- (BOOL) storeTokenObj:(PGMPiToken*)tokenObj
        withIdentifier:(NSString *)identifier
 keychainAccessibility:(id)keychainAccessibility
{
    // if keychainAccessibility is nil, set it default value
    if(!keychainAccessibility)
        keychainAccessibility = CFBridgingRelease(kSecAttrAccessibleWhenUnlocked);
    
    return [self storeTokenObj:(PGMPiToken*)tokenObj
                withIdentifier:identifier
         keychainAccessibility:keychainAccessibility
                   accessGroup:nil];
}

- (BOOL) storeTokenObj:(PGMPiToken*)tokenObj
        withIdentifier:(NSString *)identifier
           accessGroup:(NSString *)accessGroup
{
    return [self storeTokenObj:(PGMPiToken*)tokenObj
                withIdentifier:identifier
         keychainAccessibility:(__bridge id)kSecAttrAccessibleWhenUnlocked
                   accessGroup:accessGroup];
}

- (BOOL) storeTokenObj:(PGMPiToken*)tokenObj
        withIdentifier:(NSString *)identifier
 keychainAccessibility:(id)keychainAccessibility
           accessGroup:(NSString *)accessGroup
{
    // if keychainAccessibility is nil, set it default value
    if(!keychainAccessibility)
        keychainAccessibility = CFBridgingRelease(kSecAttrAccessibleWhenUnlocked);
    
    NSData *tokenData = [NSKeyedArchiver archivedDataWithRootObject:tokenObj];
    
    return [self.piSecureStorage storeKeychainData:tokenData
                                    withIdentifier:identifier
                                           service:PGMPiSecureTokenService
                             keychainAccessibility:keychainAccessibility
                                       accessGroup:accessGroup];
}

- (PGMPiToken *) retrieveTokenObjWithIdentifier:(NSString *)identifier
{
    NSData *tokenData = [self.piSecureStorage retrieveDataWithIdentifier:identifier
                                                                service:PGMPiSecureTokenService
                                                            accessGroup:self.keychainAccessGroup];
    
    PGMPiToken *tokenObj = [NSKeyedUnarchiver unarchiveObjectWithData:tokenData];
    
    return tokenObj;
}

- (BOOL) deleteTokenObjWithIdentifier:(NSString *)identifier
{
    return [self.piSecureStorage deleteDataWithIdentifer:identifier
                                                 service:PGMPiSecureTokenService
                                             accessGroup:self.keychainAccessGroup];
}

#pragma mark KVO Observer to monitor piQueues

// KVO to determine when queue is empty
- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if (object == self.piLoginQueue && [keyPath isEqualToString:@"operations"])
    {
        if (self.piLoginQueue.operationCount == 0)
        {
            [self requestComplete:[NSNumber numberWithInteger:PiLoginRequest]];
        }
    }
    else if (object == self.piTokenRefreshQueue && [keyPath isEqualToString:@"operations"])
    {
//        NSLog(@"PiClient observe piTokenRefreshQueue");
        if (self.piTokenRefreshQueue.operationCount == 0)
        {
//            NSLog(@"PiClient observe piTokenRefreshQueue EMPTY");
            [self requestComplete:[NSNumber numberWithInteger:PiTokenRefreshRequest]];
        }
    }
    else if ([object isEqual:self.piTokenOp] && [keyPath isEqualToString:@"isFinished"])
    {
        [self.piTokenOp removeObserver:self forKeyPath:@"isFinished"];
        [self.observedOperations removeObject:self.piTokenOp];
//        NSLog(@"piTokenOp isFinished");
        if (! self.piTokenOp.success)
        {
            [self cancelQueue:[self.piTokenOp.requestType integerValue]];
        }
    }
    else if ([object isEqual:self.piUserIdOp] && [keyPath isEqualToString:@"isFinished"])
    {
        [self.piUserIdOp removeObserver:self forKeyPath:@"isFinished"];
        [self.observedOperations removeObject:self.piUserIdOp];
//        NSLog(@"piUserIdOp isFinished");
        if (! self.piUserIdOp.success)
        {
            [self cancelQueue:[self.piUserIdOp.requestType integerValue]];
        }
    }
    else if ([object isEqual:self.piTokenRefreshOp] && [keyPath isEqualToString:@"isFinished"])
    {
        [self.piTokenRefreshOp removeObserver:self forKeyPath:@"isFinished"];
        [self.observedOperations removeObject:self.piTokenRefreshOp];
//        NSLog(@"piTokenRefreshOp isFinished");
        if (! self.piTokenRefreshOp.success)
        {
            [self cancelQueue:[self.piTokenRefreshOp.requestType integerValue]];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void) cancelQueue:(PGMPiRequestType)requestType
{
    if (requestType == PiLoginRequest)
    {
        [self.piLoginQueue cancelAllOperations];
    }
    if (requestType == PiTokenRefreshRequest)
    {
        [self.piTokenRefreshQueue cancelAllOperations];
    }
}


@end
