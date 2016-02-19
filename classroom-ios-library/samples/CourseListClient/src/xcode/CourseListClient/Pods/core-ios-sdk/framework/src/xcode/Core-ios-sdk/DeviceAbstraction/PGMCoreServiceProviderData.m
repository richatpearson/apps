//
//  PGMCoreServiceProviderData.m
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 12/9/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "PGMCoreServiceProviderData.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

NSString* const PGMCoreServiceProvider = @"serviceProvider";
NSString* const PGMCoreServiceProviderCountry = @"serviceProviderCountry";

@interface PGMCoreServiceProviderData()

@property (strong, nonatomic, readwrite)   NSString *   serviceProvider;
@property (strong, nonatomic, readwrite)   NSString *   serviceProviderCountry;

@end

@implementation PGMCoreServiceProviderData

-(id)init
{
    self = [super init];
    if ( self )
    {
        [self gatherData];
    }
    return self;
}

- (void) gatherData
{
    self.serviceProvider = [self getCarrierName];
    self.serviceProviderCountry = [self getCarrierISOCountryCode];
}

- (NSDictionary*) dataAsDictionary
{
    NSDictionary* dataDict = @{PGMCoreServiceProvider : self.serviceProvider,
                               PGMCoreServiceProviderCountry : self.serviceProviderCountry
                               };
    return dataDict;
}

-(NSString*)getCarrierName
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    NSString* carrierName;
    if (carrier)
    {
        carrierName = [carrier carrierName];
    }
    else
    {
        carrierName = @"none";
    }
    
    return carrierName;
}

-(NSString*)getCarrierISOCountryCode
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    NSString* spCountryCode = @"";
    
    if(!carrier)
    {
        spCountryCode = @"unavailable";
    }
    else
    {
        spCountryCode = [carrier isoCountryCode];
    }
    
    return spCountryCode;
}

//
// This is only for applications not using ARC
//
#if !__has_feature(objc_arc)
- (void) dealloc
{
    [super dealloc];
    
    self.serviceProvider = nil;
    self.serviceProviderCountry = nil;
}
#endif

@end
