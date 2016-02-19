//
//  PGMCoreDeviceData.m
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 12/9/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGMCoreDeviceData.h"

NSString* const PGMCoreDeviceVendor                = @"deviceVendor";
NSString* const PGMCoreDeviceModel                 = @"deviceModel";
NSString* const PGMCoreDeviceOSName                = @"deviceOSName";
NSString* const PGMCoreDeviceOSVersion             = @"deviceOSVersion";
NSString* const PGMCoreDeviceResolution            = @"deviceResolution";
NSString* const PGMCoreDeviceTotalDiskSpace        = @"deviceTotalDiskSpace";
NSString* const PGMCoreDeviceAvailableDiskSpace    = @"deviceAvailableDiskSpace";

@interface PGMCoreDeviceData()

@property (strong, nonatomic, readwrite)   NSString *   deviceVendor;
@property (strong, nonatomic, readwrite)   NSString *   deviceModel;
@property (strong, nonatomic, readwrite)   NSString *   deviceOSName;
@property (strong, nonatomic, readwrite)   NSString *   deviceOSVersion;
@property (strong, nonatomic, readwrite)   NSString *   deviceResolution;

@property (strong, nonatomic, readwrite)   NSNumber *   deviceTotalDiskSpace;
@property (strong, nonatomic, readwrite)   NSNumber *   deviceAvailableDiskSpace;

@end

@implementation PGMCoreDeviceData

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
    self.deviceVendor = @"Apple";
    self.deviceModel = [[UIDevice currentDevice] model];
    self.deviceOSName = [[UIDevice currentDevice] systemName];
    self.deviceOSVersion = [[UIDevice currentDevice] systemVersion];
    self.deviceResolution = [self calculateDeviceResolution];
    [self availableDiskSpace];
}

- (NSDictionary*) dataAsDictionary
{
    NSDictionary* dataDict = @{PGMCoreDeviceVendor: self.deviceVendor,
                               PGMCoreDeviceModel : self.deviceModel,
                               PGMCoreDeviceOSName : self.deviceOSName,
                               PGMCoreDeviceOSVersion : self.deviceOSVersion,
                               PGMCoreDeviceResolution : self.deviceResolution,
                               PGMCoreDeviceTotalDiskSpace : self.deviceTotalDiskSpace,
                               PGMCoreDeviceAvailableDiskSpace : self.deviceAvailableDiskSpace
                               };
    return dataDict;
}

- (NSString*) calculateDeviceResolution
{
    NSString* resolution = @"";
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    
    resolution = [NSString stringWithFormat:@"%0.0fx%0.0f", screenSize.width, screenSize.height];
    
    return resolution;
}


- (void) availableDiskSpace
{
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary)
    {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    self.deviceTotalDiskSpace = @(totalSpace);
    self.deviceAvailableDiskSpace = @(totalFreeSpace);
}

@end
