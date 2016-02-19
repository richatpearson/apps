//
//  PGMSmsEnvironment.h
//  sms-collections-client
//
//  Created by Joe Miller on 12/5/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PGMSmsEnvironmentType) {
    PGMSMSCertStagingEnv = 0,
    PGMSmsProductionEnv  = 1
};

@interface PGMSmsEnvironment : NSObject

@property (readonly, nonatomic, assign) PGMSmsEnvironmentType environmentType;
@property (readonly, nonatomic, strong) NSString *siteID;
@property (readonly, nonatomic, strong) NSString *baseUrl;


- (instancetype)initForType:(PGMSmsEnvironmentType)environmentType
                 withSiteID:(NSString *)siteID
                      error:(NSError**)error;

@end
