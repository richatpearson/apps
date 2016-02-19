//
//  PGMSmsUserModule.m
//  sms-collections-client
//
//  Created by Richard Rosiak on 12/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMSmsUserModule.h"

@implementation PGMSmsUserModule

-(instancetype) initWithIsTrial:(BOOL)isTrial
  isExpiringWithinWarningPeriod:(BOOL)isExpiringWithinWarningPeriod
                      isExpired:(BOOL)isExpired {
    self = [super init];
    if (self) {
        self.isTrial = isTrial;
        self.isExpiringWithinWarningPeriod = isExpiringWithinWarningPeriod;
        self.isExpired = isExpired;
    }
    
    return self;
}

-(NSString*) moduleDescription {
    return [NSString stringWithFormat:@"module id: %@,\n isTrial: %d,\n isExp w/warning: %d,\n isExpired: %d,\n lastSignOnDate: %@,\n expirationDate: %@,\n prod type id: %@,\n marketName: %@,\n licenseType: %@,\n productRoleName: %@\n",
          self.moduleId,
          self.isTrial,
          self.isExpiringWithinWarningPeriod,
          self.isExpired,
          self.lastSignOnDate,
          self.expirationDate,
          self.productTypeId,
          self.marketName,
          self.licenseType,
          self.productRoleName];
}

@end
