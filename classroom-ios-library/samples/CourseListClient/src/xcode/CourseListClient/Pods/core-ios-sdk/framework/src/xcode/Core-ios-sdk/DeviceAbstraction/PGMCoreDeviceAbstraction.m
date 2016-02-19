//
//  PGMCoreDeviceAbstraction.m
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 7/10/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMCoreDeviceAbstraction.h"

@interface PGMCoreDeviceAbstraction()

// User
@property (strong, nonatomic, readwrite) NSString*   uuid;

// Reachability
@property (nonatomic, strong, readwrite) PGMCoreReachability* reachability;

@end

@implementation PGMCoreDeviceAbstraction

NSString* const PGMCoreNetworkTypeWifi         = @"Wifi";
NSString* const PGMCoreNetworkTypeWWAN         = @"WWAN";
NSString* const PGMCoreNetworkStatusChange     = @"NetworkStatusChange";
NSString* const PGMCoreNetworkReachable        = @"NetworkReachable";
NSString* const PGMCoreNetworkUnreachable      = @"NetworkUnreachable";
NSString* const PGMCoreVoiceOverRunning        = @"VoiceOverRunning";
NSString* const PGMCoreMonoAudioEnabled        = @"MonoAudioEnabled";
NSString* const PGMCoreClosedCaptioningEnabled = @"ClosedCaptioningEnabled";
NSString* const PGMCoreGuidedAccessEnabled     = @"GuidedAccessEnabled";
NSString* const PGMCoreInvertColorsEnabled     = @"InvertColorsEnabled";

-(id)init
{
    self = [super init];
    if ( self )
    {
        [self gatherData];
    }
    return self;
}

- (void) refresh
{
    [self gatherData];
}

- (void) gatherData
{
    self.uuid = [self getUUID];
    
    self.deviceData = [PGMCoreDeviceData new];
    self.serviceProviderData = [PGMCoreServiceProviderData new];
    self.networkData = [PGMCoreNetworkData new];
    self.localizationData = [PGMCoreLocalizationData new];
    
    if (self.deviceData)
    {
        self.applicationData = [[PGMCoreApplicationData alloc] initWithDeviceData:self.deviceData];
        self.accessibilityData = [[PGMCoreAccessibilityData alloc] initWithDeviceData:self.deviceData];
    }
    else
    {
        self.applicationData = [PGMCoreApplicationData new];
        self.accessibilityData = [PGMCoreAccessibilityData new];
    }
}

- (NSDictionary*) dataAsDictionary
{
    NSMutableDictionary* dataDict = [NSMutableDictionary new];
    
    [dataDict setObject:self.uuid forKey:@"uuid"];
    
    [dataDict addEntriesFromDictionary:[self.deviceData dataAsDictionary]];
    [dataDict addEntriesFromDictionary:[self.serviceProviderData dataAsDictionary]];
    [dataDict addEntriesFromDictionary:[self.applicationData dataAsDictionary]];
    [dataDict addEntriesFromDictionary:[self.networkData dataAsDictionary]];
    [dataDict addEntriesFromDictionary:[self.localizationData dataAsDictionary]];
    [dataDict addEntriesFromDictionary:[self.accessibilityData dataAsDictionary]];
    
    return dataDict;
}

- (NSData*) jsonDataObject
{
    NSDictionary* jsonDict = [self dataAsDictionary];
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
    return jsonData;
}

- (NSString*) jsonDataString
{
    return [[NSString alloc] initWithData:[self jsonDataObject] encoding:NSUTF8StringEncoding];
}

/********************************** UUID **************************************/

- (NSString*)getUUID
{
    // In iOS 6, you can use [[NSUUID UUID] UUIDString];
    CFUUIDRef uuidObject = CFUUIDCreate(NULL);
    
    // Get the string representation of CFUUID object.
    // Need to use __bridge_transfer for apps using ARC
#if __has_feature(objc_arc)
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuidObject);
#else
    NSString *uuidStr = (NSString *)CFUUIDCreateString(NULL, uuidObject);
#endif
    CFRelease(uuidObject);
    
    return uuidStr;
}


- (NSString *) description
{
    NSMutableString* desc = [NSMutableString string];
    [desc appendFormat:@"   \nDevice Abstract:\n"];
    [desc appendFormat:@"   uuid: %@\n", self.uuid];
    [desc appendFormat:@"   deviceVendor: %@\n", self.deviceData.deviceVendor];
    [desc appendFormat:@"   deviceModel: %@\n", self.deviceData.deviceModel];
    [desc appendFormat:@"   deviceOSName: %@\n", self.deviceData.deviceOSName];
    [desc appendFormat:@"   deviceOSVersion: %@\n", self.deviceData.deviceOSVersion];
    [desc appendFormat:@"   deviceResolution: %@\n", self.deviceData.deviceResolution];
    [desc appendFormat:@"   serviceProvider: %@\n", self.serviceProviderData.serviceProvider];
    [desc appendFormat:@"   spCountry: %@\n", self.serviceProviderData.serviceProviderCountry];
    [desc appendFormat:@"   appVendorID: %@\n", self.applicationData.appVendorID];
    [desc appendFormat:@"   appName: %@\n", self.applicationData.appName];
    [desc appendFormat:@"   appVersion: %@\n", self.applicationData.appVersion];
    [desc appendFormat:@"   appBuild: %@\n", self.applicationData.appBuild];
    [desc appendFormat:@"   networkType: %@\n", self.networkData.networkType];
    [desc appendFormat:@"   languagePreference: %@\n", self.localizationData.languagePreference];
    [desc appendFormat:@"   localeSetting: %@\n", self.localizationData.localeSetting];
    [desc appendFormat:@"   enabledAccessibilityServices: {\n"];
    for(NSString* service in self.accessibilityData.enabledAccessibilityServices)
    {
        [desc appendFormat:@"       %@\n", service];
    }
    [desc appendFormat:@"   }"];
    return desc;
}

- (NSDictionary*)deviceDataAsDictionary
{
    return [self.deviceData dataAsDictionary];
}

- (NSDictionary*)serviceProviderDataAsDictionary
{
    return [self.serviceProviderData dataAsDictionary];
}

- (NSDictionary*)applicationDataAsDictionary
{
    return [self.applicationData dataAsDictionary];
}

- (NSDictionary*)networkDataAsDictionary
{
    return [self.networkData dataAsDictionary];
}

- (NSDictionary*)localizationDataAsDictionary
{
    return [self.localizationData dataAsDictionary];
}

- (NSDictionary*)accessibilityDataAsDictionary
{
    return [self.accessibilityData dataAsDictionary];
}

@end

