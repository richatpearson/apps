//
//  PGMSmsUserModule.h
//  sms-collections-client
//
//  Created by Richard Rosiak on 12/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGMSmsUserModule : NSObject

@property (nonatomic, strong) NSString *moduleId;
@property (nonatomic, assign) BOOL isTrial;
@property (nonatomic, assign) BOOL isExpiringWithinWarningPeriod;
@property (nonatomic, assign) BOOL isExpired;
@property (nonatomic, strong) NSString *lastSignOnDate;
@property (nonatomic, strong) NSString *expirationDate;
@property (nonatomic, strong) NSString *productTypeId;
@property (nonatomic, strong) NSString *marketName;
@property (nonatomic, strong) NSString *licenseType;
@property (nonatomic, strong) NSString *productRoleName;

-(instancetype) initWithIsTrial:(BOOL)isTrial
  isExpiringWithinWarningPeriod:(BOOL)isExpiringWithinWarningPeriod
                      isExpired:(BOOL)isExpired;

-(NSString*) moduleDescription;

@end
