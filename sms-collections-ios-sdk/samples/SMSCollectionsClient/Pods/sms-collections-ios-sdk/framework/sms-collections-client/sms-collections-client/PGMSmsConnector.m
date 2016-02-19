//
//  PGMSmsConnector.m
//  sms-collections-client
//
//  Created by Joe Miller on 12/5/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMSmsConnector.h"
#import "NSString+MD5.h"
#import "NSString+Numeric.h"
//#import "PGMSmsTokenParser.h"
#import "PGMSmsError.h"

NSString *const PGMSmsSalt = @"PE";

@interface PGMSmsConnector()

@property (nonatomic, strong) PGMSmsEnvironment *environment;
@property (nonatomic, strong) PGMSmsResponse *response;

@end

@implementation PGMSmsConnector

- (instancetype)initWithEnvironment:(PGMSmsEnvironment *)environment
{
    if (self = [super init])
    {
        self.environment = environment;
    }
    return self;
}

- (PGMSmsAuthenticationResponseHandler *)networkResponseHandler
{
    if (!_networkResponseHandler)
    {
        _networkResponseHandler = [PGMSmsAuthenticationResponseHandler new];
    }
    return _networkResponseHandler;
}

- (PGMCoreNetworkRequester*)networkRequester {
    
    if (!_networkRequester) {
        _networkRequester = [PGMCoreNetworkRequester new];
    }
    return _networkRequester;
}

- (PGMSmsUserProfileParser*) userProfileParser {
    if (!_userProfileParser) {
        _userProfileParser = [PGMSmsUserProfileParser new];
    }
    return _userProfileParser;
}

- (void)runAuthenticationRequestWithUsername:(NSString *)username
                                 andPassword:(NSString *)password
                                  onComplete:(SmsRequestComplete)requestComplete
{
    NSURLRequest *request = [self buildNetworkRequestForLoginWithUsername:username andPassword:password];
    
    NetworkRequestComplete loginCompletionHandler = ^(NSData *data, NSURLResponse *response, NSError *error) {
        PGMSmsResponse *smsResponse = [self.networkResponseHandler handleAuthenticationResponse:response withError:error];
        requestComplete(smsResponse);
    };
    
    [self.networkRequester performNetworkCallWithRequest:request
                                    andCompletionHandler:loginCompletionHandler];
}

- (NSURLRequest *)buildNetworkRequestForLoginWithUsername:(NSString*)username
                                              andPassword:(NSString*)password
{
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@sso/SSOServlet2?cmd=login", self.environment.baseUrl];
    [urlStr appendFormat:@"&siteid=%@", self.environment.siteID];
    [urlStr appendFormat:@"&okurl=/&errurl=/&ssoEstablished=true&encPassword=Y"];
    [urlStr appendFormat:@"&loginname=%@", username];
    [urlStr appendFormat:@"&password=%@", [password MD5]];
    
    NSLog(@"Request login url is %@", urlStr);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    
    return request;
}

- (void)runObtainModuleIDsRequestWithToken:(NSString *)token
                                   andSalt:(NSString *)salt
                                onComplete:(SmsRequestComplete)requestComplete {

    self.response = [PGMSmsResponse new];
    
    NSURLRequest *request = [self buildNetworkRequestForModuleIDsWithToken:token andSalt:salt];
    
    NetworkRequestComplete networkingCompletionHandler = ^(NSData* data, NSURLResponse *response, NSError *error) {
        
        if (error && !data) {
            self.response.error = error;
            NSLog(@"PGMSmsConnector runObtainModuleIDsRequestWithToken received error");
            requestComplete(self.response);
        } else {
            NSString *diagnosticsResponseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@" ");
            NSLog(@"PGMSmsConnector runObtainModuleIDsRequestWithToken diagnosticsResponseString showing XML response from call after login.");
            NSLog(@"---------------------------------------------------------------------------------");
            NSLog(@"%@", diagnosticsResponseString);
            NSLog(@"---------------------------------------------------------------------------------");
            NSLog(@" ");

            [self parseUserProfileForData:data];
            requestComplete(self.response);
        }
    };
    
    [self.networkRequester performNetworkCallWithRequest:request
                                    andCompletionHandler:networkingCompletionHandler];
    
}

- (NSURLRequest *)buildNetworkRequestForModuleIDsWithToken:(NSString *)token
                                                   andSalt:(NSString *)salt {

    //
    // This is the Confluence documentation.
    // https://confluence.pearson.com/confluence/display/eText/eText+SMS+and+RUMBA+Authentication+and+Authorization+Services
    //
    // Where key is the token.
    // Following are more details on parameters.
    // key = SSO Session key which identifies the current user and session.
    // This parameter is established when an SSO session is activated. It can be obtained by calling SSOServlet2’s chk_login or login command.
    // sec = An encrypted version of the last 8 characters of the session key. The encryption is calculated as follows -
    // String secretKey = UnixCrypt.crypt(salt, ssoSessionKey.substring(0, 8));
    // siteid = ID of the site the user is attempting to access.
    // SMSMD5Hash.java
    // Additional documentation on how we are creating this call.
    // https://docs.google.com/a/pearson.com/document/d/1T8nnobeSeIFEAUbglEGEfBeIYUxontT341jRnK75i4A/edit#heading=h.hmitncqtptqe
    //
    // Example from confluence documentation.
    // http://login.cert.pearsoncmg.com/sso/SSOProfileServlet?key=787328107103105287282013&sec=PEcJnanabeO4c&siteid=7169
    //
    // where key is the token we got back from login.  sec is UnixCrypt.crypt(salt, ssoSessionKey.substring(0, 8));
    
    NSString *smsSalt = (salt) ? salt : PGMSmsSalt;
    NSString *secret = [PGMSmsSecret getSecretParameterWithLoginToken:token  andSalt:smsSalt];

    // Example of what this GET request should look like.
    // https://login.cert.pearsoncmg.com/sso/SSOProfileServlet2?key=120772913211561698711182014&sec=PEDWXYbHGiBBw&siteid=87227
    
    NSMutableString *urlStr = [ NSMutableString stringWithFormat:@"%@sso/SSOProfileServlet2?", self.environment.baseUrl];
    [urlStr appendFormat:@"key=%@",         token];
    [urlStr appendFormat:@"&sec=%@",        secret];
    [urlStr appendFormat:@"&siteid=%@",     self.environment.siteID];
    
    NSLog(@"PGMSmsConnector  buildNetworkRequestForModuleIDsWithToken urlStr: ");
    NSLog(@"---------------------------------------------------------------------------------");
    NSLog(@"%@", urlStr);
    NSLog(@"---------------------------------------------------------------------------------");

    // Create request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];

    return request;
}

-(void) parseUserProfileForData:(NSData*)data {
    //NSLog(@"Initializing user profile parser - will parse data.");
    [self.userProfileParser parseWithData:data];
    
    [self checkForErrorFromParser:self.userProfileParser];
    self.response.userProfile = self.userProfileParser.userProfile;
}

-(void) checkForErrorFromParser:(PGMSmsUserProfileParser*)userProfileParser {
    if (userProfileParser.smsErrorMessage && ![userProfileParser.smsErrorMessage isEqualToString:@""]) {
        self.response.error = [PGMSmsError createErrorForErrorCode:PGMSmsDenySubscriptionError
                                                    andDescription:userProfileParser.smsErrorMessage];
    }
}

@end




