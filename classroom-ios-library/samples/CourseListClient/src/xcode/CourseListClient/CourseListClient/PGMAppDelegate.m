//
//  PGMAppDelegate.m
//  CourseListClient
//
//  Created by Joe Miller on 8/14/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMAppDelegate.h"
#import <Pi-ios-client/PGMPiClient.h>

@interface PGMAppDelegate ()

@property (nonatomic, strong) PGMPiClient *piClient;

@end

@implementation PGMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initializePiClient];
    return YES;
}

- (void)initializePiClient
{
    NSString *clientId = @"wkLZmUJAsTSMbVEI9Po6hNwgJJBGsgi5";
    NSString *clientSecret = @"SAftAexlgpeSTZ7n";
    NSString *redirectUrl = @"http://int-piapi.stg-openclass.com/pi_group12client";
    
    self.piClient = [[PGMPiClient alloc] initWithClientId:clientId
                                             clientSecret:clientSecret
                                              redirectUrl:redirectUrl];
}

- (void)loginWithUsername:(NSString*)username password:(NSString*)password
{
    [self.piClient loginWithUsername:username
                            password:password
                             options:nil
                          onComplete:^(PGMPiResponse *response) {
             if(response.error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginError" object:response];
                 });
             }
             else
             {
                 NSLog(@"PiClientApp LOGINCOMPLETE: %@ ::: Credentials: %@", [response getObjectForOperationType:PiTokenOp],
                       [response getObjectForOperationType:PiUserIdOp]);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self processSuccessfulPiResponse:response];
                 });
             }
         }
     ];
}

- (void)processSuccessfulPiResponse:(PGMPiResponse *) response
{
    PGMPiToken *piToken = (PGMPiToken *)[response getObjectForOperationType:PiTokenOp];
    PGMPiCredentials *piCredentials = (PGMPiCredentials *)[response getObjectForOperationType:PiUserIdOp];
    
    self.credentials = [[PGMCredentials alloc] initWith:piToken piCredentials:piCredentials];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginComplete" object:nil];
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
