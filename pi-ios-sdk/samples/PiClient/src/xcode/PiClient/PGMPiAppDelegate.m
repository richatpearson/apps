//
//  PGMAppDelegate.m
//  PiClient
//
//  Created by Richard Rosiak on 5/29/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiAppDelegate.h"
#import <Pi-ios-client/PGMPiConsentPolicy.h>

@interface PGMPiAppDelegate ()

@property (nonatomic, strong) PGMPiClient *piClient;
@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) NSString *redirectUrl;
@property (nonatomic, strong) PGMPiEnvironment *environment;

@end

@implementation PGMPiAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString* bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    [self setPiAppProperties:bundleName];
    
    self.piClient = [[PGMPiClient alloc] initWithClientId:self.clientId
                                             clientSecret:self.clientSecret
                                              redirectUrl:self.redirectUrl];
    
    [self.piClient setEnvironment:self.environment];
    
    return YES;
}

- (void) setPiAppProperties:(NSString*)bundleName
{
    // We found that SQE is creating new targets for automated testing, and the new targets failed because they weren't
    // named according to what we expect here. This is the reason for choosing hasPrefix then agreeing on a naming
    // convention.
    if([bundleName hasPrefix:@"PiClientStaging"])
    {
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>PiClientStaging");
        self.clientId = @"wkLZmUJAsTSMbVEI9Po6hNwgJJBGsgi5";
        self.clientSecret = @"SAftAexlgpeSTZ7n";
        self.redirectUrl = @"http://int-piapi.stg-openclass.com/pi_group12client";
        self.environment = [PGMPiEnvironment stagingEnvironment];
    }
    else if ([bundleName hasPrefix:@"PiClientProduction"])
    {
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>PiClientProduction");
        self.clientId = @"GgXYn6HjbT2CzKXm5jh9aIGC7htBNWk1";
        self.clientSecret = @"pKAsAPi4DAEPesbw";
        self.redirectUrl = @"http://piapi.openclass.com/pi_group12client";
        self.environment = [PGMPiEnvironment productionEnvironment];
    }
    else
    {
        [NSException raise:@"Invalid bundle name"
                    format:@"The bundleName provided (%@) is not valid. It's possible a scheme was created that's not accounted for here.",
         bundleName];
    }
}

- (void) delegateResponse:(PGMPiResponse *)pgmPiRepsonse
{
    //TODO: provide implementation
}

- (BOOL) storeUsername:(NSString*)username andPassword:(NSString*)password
{
    if (username && password)
    {
        self.piCredentials = [PGMPiCredentials credentialsWithUsername:username password:password];
        
        return [self.piClient storeCredentials:self.piCredentials withIdentifier:self.piCredentials.userId];
    }
    return NO;
}

- (PGMPiCredentials*) retrieveCredentials
{
    if (self.piCredentials.userId)
    {
         return [self.piClient retrieveCredentialsWithIdentifier:self.piCredentials.userId];
    }
    return nil;
}

-(BOOL) deleteCredentials
{
    return [self.piClient deleteCredentialsWithIdentifier:self.piCredentials.userId];
}

-(void) loginWithUsername:(NSString*)username
                 password:(NSString*)password
                  options:(PGMPiClientLoginOptions*)options
         storeCredentials:(BOOL)storeCreds
{
    PiRequestComplete loginCompletionHandler = ^(PGMPiResponse *response)
    {
        if(response.error)
        {
            NSLog(@"The error desc from login is %@ with code of %lu", response.error.description, (long)response.error.code);
            if (response.error.code == 3840) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginErrorBadCredentials" object:response];
                });
            }
            else if (response.error.code == 7) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginErrorNoConsent" object:response];
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginError" object:response];
                });
            }
        }
        else
        {
            NSLog(@"PiClientApp LOGINCOMPLETE: %@ ::: Credentials: %@", [response getObjectForOperationType:PiTokenOp],
                  [response getObjectForOperationType:PiUserIdOp]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginComplete" object:response];
            });
        }
    };
    
    self.piClient.secureStoreCredentials = storeCreds;
    self.currentUsername = username;
    self.currentPassword = password;
    
    [self.piClient loginWithUsername:username
                            password:password
                             options:nil
                          onComplete:loginCompletionHandler];
}

-(void) submitConsentPolicies:(NSArray*)policies {
    
    PiRequestComplete consentFlowCompletionHandler = ^(PGMPiResponse *response)
    {
        if (response.error) {
            if (response.error.code == 9) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnconsentedPolicyError" object:response];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConsentFlowError" object:response];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ConsentFlowCompleted" object:response];
            });
        }
    };
    
    [self.piClient submitConsentPolicies:policies
                     withCurrentUsername:self.currentUsername
                             andPassword:self.currentPassword
                              onComplete:consentFlowCompletionHandler];
}

- (PGMPiResponse *) checkToken
{
    NSLog(@"AppDelegate checkToken");
    PiRequestComplete validTokenCompletionHandler = ^(PGMPiResponse *response)
    {
        if(response.error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"InvalidPiToken" object:response];
            });
        }
        else
        {
            NSLog(@"PiClientApp ValidToken onComplete: %@ ::: UserID: %@", [response getObjectForOperationType:PiTokenOp],
                  [response getObjectForOperationType:PiUserIdOp]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ValidPiToken" object:response];
            });
        }
    };
    PGMPiResponse *response;
    if ( self.piCredentials.userId )
    {
        NSLog(@"AppDelegate checkToken Credentials: %@", self.piCredentials.userId);
        response = [self.piClient validAccessTokenWithUserId:self.piCredentials.userId onComplete:validTokenCompletionHandler];
    }
    else
    {
        NSLog(@"AppDelegate calling validAccessTokenAndOnComplete");
        response = [self.piClient validAccessTokenAndOnComplete:validTokenCompletionHandler];
    }
    NSLog(@"AppDelegate: accessToken: %@, %d", response.accessToken, (int)response.requestStatus);
    if (response.requestStatus == PiRequestSuccess)
    {
        NSLog(@"PiClientApp ValidToken: %@ ::: UserID: %@", [response getObjectForOperationType:PiValidToken], response.userId);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ValidPiToken" object:response];
        });
    }
    else
    {
        if( self.piCredentials.userId )
        {
            if (response.requestStatus == PiRequestFailure)
            {
                NSLog(@"PiClientApp InvalidToken onComplete: %@ ::: Credentials: %@", [response getObjectForOperationType:PiTokenOp],
                      [response getObjectForOperationType:PiUserIdOp]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"InvalidPiToken" object:response];
                });
            }
        }
        else
        {
            NSLog(@"PiClientApp InvalidToken onComplete: %@ ::: Credentials: %@", [response getObjectForOperationType:PiTokenOp],
                  [response getObjectForOperationType:PiUserIdOp]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"InvalidPiToken" object:response];
            });
        }
    }
    
    return response;
}

- (void) tokenRefresh
{
    PiRequestComplete tokenRefreshCompletionHandler = ^(PGMPiResponse *response)
    {
        NSLog(@"tokenRefreshCompletionHandler");
        if(response.error)
        {
             NSLog(@"PiClientApp TokenRefresh onComplete ERROR");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TokenRefreshError" object:response];
            });
        }
        else
        {
            NSLog(@"PiClientApp TokenRefresh onComplete SUCCESS");
            NSLog(@"PiClientApp TokenRefresh onComplete ResponseToken: %@", [response getObjectForOperationType:PiTokenRefreshOp]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TokenRefreshed" object:response];
            });
        }
    };
    [self.piClient refreshAccessTokenAndOnComplete:tokenRefreshCompletionHandler];
}

- (void) logout
{
    [self.piClient logout];
    self.piToken = nil;
    self.piCredentials = nil;
}

- (PGMPiClientLoginOptions*)getLoginOptions
{
    return self.piClient.clientLoginOptions;
}

- (void) forgotPasswordForUsername:(NSString*)userName
{
    PiRequestComplete forgotPasswordCompletionHandler = ^(PGMPiResponse *response)
    {
        if (response.error)
        {
            NSLog(@"PiClientApp Forgot Password ERROR");
        }
        else
        {
            NSLog(@"PiClientApp Forgot Password SUCCESS");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ForgotPasswordComplete" object:response];
        });
    };
    
    [self.piClient forgotPasswordForUsername:userName
                                  onComplete:forgotPasswordCompletionHandler];
    
}

- (void) forgotUsernameForEmail:(NSString*)email
{
    PiRequestComplete forgotUsernameCompletionHandler = ^(PGMPiResponse *response)
    {
        if (response.error)
        {
            NSLog(@"PiClientApp Forgot Username ERROR");
        }
        else
        {
            NSLog(@"PiClientApp Forgot Username SUCCESS");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ForgotUsernameComplete" object:response];
        });
    };
    
    [self.piClient forgotUsernameForEmail:email
                               onComplete:forgotUsernameCompletionHandler];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
