//
//  PGMPiEnvironment.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 5/27/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiEnvironment.h"

NSString* const PGMPiDefaultBase_Staging            = @"https://int-piapi.stg-openclass.com/";
NSString* const PGMPiDefaultBase_Prod               = @"https://piapi.openclass.com/";

NSString *const PGMPiEscrowDefaultBase_Staging      = @"https://escrow.stg-openclass.com/";
NSString *const PGMPiEscrowDefaultBase_Prod         = @"https://escrow.prd-prsn.com/";

NSString* const PGMPiLoginPath                      = @"v1/piapi-int/login/credentials";
NSString* const PGMPiLoginPathProd                  = @"v1/piapi/login/credentials";

NSString* const PGMPiUserIdPath_Staging             = @"v1/piapi-int/credentials/?username=%@";
NSString* const PGMPiUserIdPath_Prod                = @"v1/piapi/credentials/?username=%@";
NSString* const PGMPiRefreshPath_Staging            = @"pioauth-int/refresh";
NSString* const PGMPiRefreshPath_Prod               = @"pioauth/refresh";
NSString* const PGMPiUserCompositePath              = @"piapi-int/usercomposite/%@";
NSString* const PGMPiIdentityProfilePath            = @"v1/piapi-int/identityprofiles/@";

NSString* const PGMPiEscrowEndpoint                 = @"escrow/%@";
NSString* const PGMPiPostConsentEndpoint_Staging    = @"v1/piapi-int/login/redeemEscrow/";
NSString* const PGMPiPostConsentEndpoint_Prod       = @"v1/piapi/login/redeemEscrow/";

NSString const *PGMPiLoginSuccessUrlKey             = @"login_success_url";
NSString const *PGMPiResponseTypeKey                = @"response_type";
NSString const *PGMPiScopeKey                       = @"scope";
NSString const *PGMPiClientIdKey                    = @"client_id";
NSString const *PGMPiClientSecretKey                = @"client_secret";
NSString const *PGMPiRedirectUrlKey                 = @"redirect_url";

NSString* const PGMPiForgotPasswordPath_Staging     = @"v1/piapi-int/login/forgotpassword";
NSString* const PGMPiForgotPasswordPath_Prod        = @"v1/piapi/login/forgotpassword";
NSString* const PGMPiForgotUsernamePath_Staging     = @"v1/piapi-int/login/forgotusername";
NSString* const PGMPiForgotUsernamePath_Prod        = @"v1/piapi/login/forgotusername";

@interface PGMPiEnvironment()

@property (nonatomic, readwrite) NSString *_basePiURL;
@property (nonatomic, readwrite) NSString *_baseEscrowURL;
@property (nonatomic, readwrite) NSString *_state;
@property (nonatomic, readwrite) NSString *_scope;
@property (nonatomic, readwrite) NSString *_loginSuccessUrl;
@property (nonatomic, readwrite) NSString *_responseType;
@property (nonatomic, readwrite) NSString *_postConsentEndpoint;
@property (nonatomic, readwrite) NSString *_userIdEndpoint;
@property (nonatomic, readwrite) NSString *_refreshEndpoint;

@property (nonatomic, readwrite) NSString *_loginLocalPath;
@property (nonatomic, assign) BOOL _isEnvStaging;

@property (nonatomic, readwrite) NSString *_forgotPasswordPath;
@property (nonatomic, readwrite) NSString *_forgotUsernamePath;
@end

@implementation PGMPiEnvironment

+ (instancetype) stagingEnvironment
{
    return [[self alloc] initWithStagingPaths];
}

+ (instancetype) productionEnvironment
{
    return [[self alloc] initWithProductionPaths];
}

- (id) initWithStagingPaths
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self._basePiURL = PGMPiDefaultBase_Staging;
    self._baseEscrowURL = PGMPiEscrowDefaultBase_Staging;
    self._state = @"state";
    self._scope = @"s2";
    self._postConsentEndpoint = PGMPiPostConsentEndpoint_Staging;
    self._userIdEndpoint = PGMPiUserIdPath_Staging;
    self._refreshEndpoint = PGMPiRefreshPath_Staging;
    
    self._loginSuccessUrl = @"http://int-piapi.stg-openclass.com/pioauth-int/authCode";
    self._responseType = @"code";
    
    self._loginLocalPath = PGMPiLoginPath;
    
    self.currentEnvironmentType = PGMPiStaging;
    
    self._isEnvStaging = YES;
    
    self._baseEscrowURL = PGMPiEscrowDefaultBase_Staging;
    
    self._forgotPasswordPath = PGMPiForgotPasswordPath_Staging;
    self._forgotUsernamePath = PGMPiForgotUsernamePath_Staging;
    
    return self;
}

- (id) initWithProductionPaths
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self._basePiURL = PGMPiDefaultBase_Prod;
    self._baseEscrowURL = PGMPiEscrowDefaultBase_Prod;
    self._state = @"state";
    self._scope = @"s2";
    self._postConsentEndpoint = PGMPiPostConsentEndpoint_Prod;
    self._userIdEndpoint = PGMPiUserIdPath_Prod;
    self._refreshEndpoint = PGMPiRefreshPath_Prod;
    
    self._loginSuccessUrl = @"http://piapi.openclass.com/pioauth/authCode";
    self._responseType = @"code";
    
    self._loginLocalPath = PGMPiLoginPathProd;
    
    self.currentEnvironmentType = PGMPiProduction;
    
    self._isEnvStaging = NO;
    
    self._forgotPasswordPath = PGMPiForgotPasswordPath_Prod;
    self._forgotUsernamePath = PGMPiForgotUsernamePath_Prod;
    
    return self;
}

- (id) init
{
    // You are not allowed to intialize with [PGMPiEnvironment new] or [[PGMPiEnvironment alloc] init]
    assert(0);
    return nil;
}

#pragma mark GETTERS

- (NSString*) basePiURL
{
    return self._basePiURL;
}
- (NSString*) baseEscrowURL
{
    return self._baseEscrowURL;
}
- (NSString*) state
{
    return self._state;
}
- (NSString*) scope
{
    return self._scope;
}
- (NSString*) loginSuccessUrl
{
    return self._loginSuccessUrl;
}
- (NSString*) responseType
{
    return self._responseType;
}
-(NSString*) postConsentEndpoint
{
    return self._postConsentEndpoint;
}
-(NSString*) userIdEndpoint
{
    return self._userIdEndpoint;
}
-(NSString*) refreshEndpoint
{
    return self._refreshEndpoint;
}

- (NSString*) loginLocalPath
{
    return self._loginLocalPath;
}
-(BOOL) isEnvStaging
{
    return self._isEnvStaging;
}
-(NSString*) forgotPasswordPath
{
    return self._forgotPasswordPath;
}
-(NSString*) forgotUsernamePath
{
    return self._forgotUsernamePath;
}

- (NSString*) piLoginPath
{
    return [NSString stringWithFormat:@"%@%@", self.basePiURL, self.loginLocalPath];
}

- (NSString*) piUserIdPathWithUsername:(NSString*)username
{
    NSString* userIdPath = [NSString stringWithFormat: self.userIdEndpoint, username];
    return [NSString stringWithFormat:@"%@%@", self.basePiURL, userIdPath];
}

- (NSString*) piRefreshPath
{
    // TODO: Remove when https is implemented in refresh endpoint - regarding Staging only!
    // Make sure that url scheme is http in Staging
    NSString *httpURL = self.basePiURL;
    if (self.isEnvStaging)
    {
        httpURL = [self.basePiURL stringByReplacingOccurrencesOfString:@"https://" withString:@"http://"];
    }
    return [NSString stringWithFormat:@"%@%@", httpURL, self.refreshEndpoint];
}

- (NSString*) escrowPathFormat
{
    return [NSString stringWithFormat:@"%@%@",self.baseEscrowURL, PGMPiEscrowEndpoint];
}

- (NSString*) escrowPathWithTicket:(NSString*)ticket
{
    NSString *fullPath = [NSString stringWithFormat:[self escrowPathFormat], ticket];
    
    return fullPath;
}

- (NSString*) consentPostPathFormat
{
    return [NSString stringWithFormat:@"%@%@", self.basePiURL, self.postConsentEndpoint];
}

- (NSString*) postConsentPathWithTicket:(NSString*)ticket
{
    return [NSString stringWithFormat:@"%@%@",[self consentPostPathFormat], ticket];
}

- (NSString*) piForgotPasswordUrl
{
    return [NSString stringWithFormat:@"%@%@", self.basePiURL, self.forgotPasswordPath];
}

- (NSString*) piForgotUsernameUrl
{
    return [NSString stringWithFormat:@"%@%@", self.basePiURL, self.forgotUsernamePath];
}

#pragma mark SETTERS
- (BOOL) setBasePiURL:(NSString*)basePiURL
{
    NSURL *bURL = [NSURL URLWithString:basePiURL];
    if( [bURL.scheme isEqualToString:@"https"] )
    {
        self._basePiURL = basePiURL;
        
        self.currentEnvironmentType = PGMPiCustom;
        
        return YES;
    }
    return NO;
}
- (BOOL) setBaseEscrowURL:(NSString*)baseEscrowURL
{
    NSURL *bURL = [NSURL URLWithString:baseEscrowURL];
    if( [bURL.scheme isEqualToString:@"https"] )
    {
        self._baseEscrowURL = baseEscrowURL;
        
        self.currentEnvironmentType = PGMPiCustom;
        
        return YES;
    }
    return NO;
}
- (BOOL) setState:(NSString*)state
{
    if (state)
    {
        self._state = state;
        self.currentEnvironmentType = PGMPiCustom;
        return YES;
    }
    return NO;
}
- (BOOL) setScope:(NSString*)scope
{
    if (scope)
    {
        self._scope = scope;
        self.currentEnvironmentType = PGMPiCustom;
        return YES;
    }
    return NO;
}
- (BOOL) setLoginSuccessUrl:(NSString*)loginSuccessUrl
{
    if (loginSuccessUrl)
    {
        self._loginSuccessUrl = loginSuccessUrl;
        self.currentEnvironmentType = PGMPiCustom;
        return YES;
    }
    return NO;
}
- (BOOL) setResponseType:(NSString*)responseType
{
    if (responseType)
    {
        self._responseType = responseType;
        self.currentEnvironmentType = PGMPiCustom;
        return YES;
    }
    return NO;
}

@end
