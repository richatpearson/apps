//
//  ApplicationData.m
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 12/9/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PGMCoreApplicationData.h"

NSString* const PGMCoreAppVendorServices = @"appVendorID";
NSString* const PGMCoreAppName = @"appName";
NSString* const PGMCoreAppVersion = @"appVersion";
NSString* const PGMCoreAppBuild = @"appBuild";
NSString* const PGMCoreAppBundleId = @"appBundleId";

@interface PGMCoreApplicationData()

@property (strong, nonatomic, readwrite)   NSString  *   appVendorID;
@property (strong, nonatomic, readwrite)   NSString  *   appName;
@property (strong, nonatomic, readwrite)   NSString  *   appVersion;
@property (strong, nonatomic, readwrite)   NSString  *   appBuild;
@property (strong, nonatomic, readwrite)   NSString  *   appBundleId;

@property (weak, nonatomic) PGMCoreDeviceData *deviceData;

@end

@implementation PGMCoreApplicationData

//-(id)init
//{
//    self = [super init];
//    if ( self )
//    {
//        [self gatherData];
//    }
//    return self;
//}

-(id)init
{
    return [self initWithDeviceData:nil];
}

- (id) initWithDeviceData:(PGMCoreDeviceData*)deviceData
{
    self = [super init];
    if ( self )
    {
        self.deviceData = deviceData;
        [self gatherData];
    }
    return self;
}

- (void) gatherData
{
    self.appVendorID = [self getVendorID];
    self.appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if( (!self.appName) || [self.appName isKindOfClass:[NSNull class]] )
    {
        self.appName = @"App Name is NULL in Unit Tests because there is no NSBundle";
    }
    
    self.appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if( (!self.appVersion) || [self.appVersion isKindOfClass:[NSNull class]] )
    {
        self.appVersion = @"App Version is NULL in Unit Tests because there is no NSBundle";
    }
    
    self.appBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if( (!self.appBuild) || [self.appBuild isKindOfClass:[NSNull class]] )
    {
        self.appBuild = @"App Build is NULL in Unit Tests because there is no NSBundle";
    }
    self.appBundleId = [[NSBundle mainBundle] bundleIdentifier];
    if( (!self.appBundleId) || [self.appBuild isKindOfClass:[NSNull class]] )
    {
        self.appBundleId = @"App BundleId is NULL in Unit Tests because there is no NSBundle";
    }
}

- (NSDictionary*) dataAsDictionary
{
    NSDictionary* dataDict = @{PGMCoreAppVendorServices: self.appVendorID,
                               PGMCoreAppName : self.appName,
                               PGMCoreAppVersion : self.appVersion,
                               PGMCoreAppBuild : self.appBuild,
                               PGMCoreAppBundleId : self.appBundleId
                               };
    return dataDict;
}

- (NSString*)getVendorID
{
    NSString* vendorID = @"unavailable";
    
    if (self.deviceData)
    {
        float sysVer = [[self.deviceData deviceOSVersion] floatValue];
        
        if (sysVer >= 6.0)
        {
            vendorID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        }
    }
    
    return vendorID;
}

@end
