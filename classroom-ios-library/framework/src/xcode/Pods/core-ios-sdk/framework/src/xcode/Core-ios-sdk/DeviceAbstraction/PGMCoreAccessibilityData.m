//
//  PGMCoreAccessibilityData.m
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 12/9/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>
#import <UIKit/UIKit.h>

#import "PGMCoreAccessibilityData.h"
#import "PGMCoreDeviceAbstraction.h"

@interface PGMCoreAccessibilityData()

@property (strong, nonatomic, readwrite)   NSArray   *   enabledAccessibilityServices;

@property (weak, nonatomic) PGMCoreDeviceData *deviceData;

@end

@implementation PGMCoreAccessibilityData

NSString* const PGMCoreEnabledAccessibilityServices = @"enabledAccessibilityServices";

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
        if (deviceData)
        {
            self.deviceData = deviceData;
        }
        
        [self gatherData];
    }
    return self;
}

- (void) gatherData
{
    self.enabledAccessibilityServices = [self gatherAccessibilityServices];
}

- (NSDictionary*) dataAsDictionary
{
    NSDictionary* dataDict = @{PGMCoreEnabledAccessibilityServices : self.enabledAccessibilityServices};
    return dataDict;
}

- (NSArray*)gatherAccessibilityServices
{
    NSMutableArray* accessibilityAR = [NSMutableArray array];
    
    if(UIAccessibilityIsVoiceOverRunning()) [accessibilityAR addObject:PGMCoreVoiceOverRunning];
    if(UIAccessibilityIsMonoAudioEnabled()) [accessibilityAR addObject:PGMCoreMonoAudioEnabled];
    if(UIAccessibilityIsClosedCaptioningEnabled()) [accessibilityAR addObject:PGMCoreClosedCaptioningEnabled];
    
    if (self.deviceData)
    {
        float sysVer = [[self.deviceData deviceOSVersion] floatValue];
        
        if (sysVer >= 6.0)
        {
            if(UIAccessibilityIsVoiceOverRunning()) [accessibilityAR addObject:PGMCoreGuidedAccessEnabled];
            if(UIAccessibilityIsInvertColorsEnabled()) [accessibilityAR addObject:PGMCoreInvertColorsEnabled];
        }
    }
    
    return accessibilityAR;
}

@end
