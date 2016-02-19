//
//  PGMAppDelegate.h
//  CourseListClient
//
//  Created by Joe Miller on 8/14/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Pi-ios-client/PGMPiToken.h>
#import "PGMCredentials.h"
#import <classroom-ios/PGMClssRequestManager.h>

@interface PGMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) PGMCredentials *credentials;

- (void)loginWithUsername:(NSString*)username password:(NSString*)password;

@end
