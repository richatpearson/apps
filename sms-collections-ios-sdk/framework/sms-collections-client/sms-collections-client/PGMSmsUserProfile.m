//
//  PGMSmsUserProfile.m
//  sms-collections-client
//
//  Created by Richard Rosiak on 12/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMSmsUserProfile.h"
#import "PGMSmsUserModule.h"

@implementation PGMSmsUserProfile

- (PGMSmsUserModule*) moduleById:(NSString*)moduleId {
    if (!self.userModules || [self.userModules count] == 0) {
        return nil;
    }
    
    NSArray *queryResult = [self.userModules
                            filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"moduleId = %@", moduleId]];
    
    
    return (queryResult && [queryResult count] > 0) ? queryResult[0] : nil;
}

- (NSArray*) allModules {
    if (!self.userModules) {
        return [NSArray new];
    }
    
    return self.userModules;
}

- (NSArray*) expiredModules {
    if (!self.userModules) {
        return [NSArray new];
    }
    
    return [self.userModules filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isExpired = YES"]];
}

- (NSArray*) activeModules {
    if (!self.userModules) {
        return [NSArray new];
    }
    
    return [self.userModules filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isExpired = NO"]];
}

- (NSArray*) trialModules {
    if (!self.userModules) {
        return [NSArray new];
    }
    
    return [self.userModules filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isTrial = YES"]];
}

- (NSArray*) modulesExpiringWithinWarningPeriod {
    if (!self.userModules) {
        return [NSArray new];
    }
    
    return [self.userModules filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isExpiringWithinWarningPeriod = YES"]];
}

-(NSString*) profileDescription {
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"user id: %@,\nfirst name: %@,\nlast name: %@,\nlogin name: %@,\nemail address: %@,\ninstitution name: %@\n",
          self.userId,
          self.firstName,
          self.lastName,
          self.loginName,
          self.emailAddress,
          self.institutionName];
    [description appendString:@"\nModules:\n"];
    for (PGMSmsUserModule *userModule in self.userModules) {
        [description appendString:[userModule moduleDescription]];
    }
    
    return description;
}

@end
