//
//  PGMSmsEnvironment.m
//  sms-collections-client
//
//  Created by Joe Miller on 12/5/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMSmsEnvironment.h"
#import "PGMSmsError.h"

NSString * const PGMSmsBase_Staging     = @"https://login.cert.pearsoncmg.com/";
NSString * const PGMSmsBase_Production  = @"https://login.pearsoncmg.com/";



@implementation PGMSmsEnvironment

- (instancetype)initForType:(PGMSmsEnvironmentType)environmentType
                 withSiteID:(NSString *)siteID
                      error:(NSError**)error
{
    if (self = [super init])
    {
        if (!siteID || [siteID isEqualToString:@""]) {
            if ( error != nil ) {
                *error = [PGMSmsError createErrorForErrorCode:PGMSmsMissingSiteIdError andDescription:@"App must provide site id"];
            }
            return nil;
        }
        
        _environmentType = environmentType;
        _siteID = siteID;
        switch (self.environmentType) {
            case PGMSMSCertStagingEnv:
                _baseUrl = PGMSmsBase_Staging;
                break;
            case PGMSmsProductionEnv:
                _baseUrl = PGMSmsBase_Production;
                break;
            default:
                break;
        }
    }
    return self;
}

@end
