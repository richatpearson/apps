//
//  NetworkData.m
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 12/9/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "PGMCoreNetworkData.h"
#import "PGMCoreReachability.h"

NSString* const PGMCoreNetworkType = @"NetworkType";

@interface PGMCoreNetworkData()

@property (strong, nonatomic, readwrite)   NSString  *   networkType;

@end


@implementation PGMCoreNetworkData

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
    self.networkType = [self determineNetWorkType];
}

- (NSDictionary*) dataAsDictionary
{
    NSDictionary* dataDict = @{PGMCoreNetworkType : self.networkType};
    return dataDict;
}

- (NSString*)determineNetWorkType
{
    PGMCoreReachability *reachability = [PGMCoreReachability sharedReachability];
    [reachability startListening];
    
    NSString* networkType = [reachability currentNetworkReachabilityStatusAsString];
    return networkType;
}

//
// This is only for applications not using ARC
//
#if !__has_feature(objc_arc)
- (void) dealloc
{
    [super dealloc];
    
    self.networkType = nil;
}
#endif
@end
