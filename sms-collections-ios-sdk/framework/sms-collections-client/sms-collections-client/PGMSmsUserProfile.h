//
//  PGMSmsUserProfile.h
//  sms-collections-client
//
//  Created by Richard Rosiak on 12/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMSmsUserModule.h"

@interface PGMSmsUserProfile : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *loginName;
@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic, strong) NSString *institutionName;
@property (nonatomic, strong) NSArray *userModules;

- (PGMSmsUserModule*) moduleById:(NSString*)moduleId;
- (NSArray*) allModules;
- (NSArray*) expiredModules;
- (NSArray*) activeModules;
- (NSArray*) trialModules;
- (NSArray*) modulesExpiringWithinWarningPeriod;

- (NSString*) profileDescription;

@end
