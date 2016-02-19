/*
 File: PGMCoreReachability.m
 
 Copyright (C) 2013 Pearson Inc. All Rights Reserved.
 
 */

#import <sys/socket.h>

#import <CoreFoundation/CoreFoundation.h>

#import "PGMCoreReachability.h"

NSString* const PGMCoreReachabilityChanged = @"ReachabilityChanged";
NSString* const PGMCoreReachabilityNotificationStatus = @"PGMCoreReachabilityNotificationStatus";
NSString* const PGMCoreReachabilityNotificationStatusText = @"PGMCoreReachabilityNotificationStatusText";

typedef void (^PGMCoreReachabilityStatusBlock)(PGMCoreReachabilityStatus status);

#pragma mark - Supporting functions

#define kShouldPrintReachabilityFlags 0

// Flags coming from System Configuration framework
static void PrintReachabilityFlags(SCNetworkReachabilityFlags flags, const char* comment)
{
#if kShouldPrintReachabilityFlags
    
    NSLog(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c %s\n",
          (flags & kSCNetworkReachabilityFlagsIsWWAN)               ? 'W' : '-',
          (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
          
          (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
          (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
          (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
          (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-',
          comment
          );
#endif
}

typedef void (^PGMCoreReachabilityStatusBlock)(PGMCoreReachabilityStatus status);

NSString * PGMCoreNetworkReachabilityStatusAsString(PGMCoreReachabilityStatus status)
{
    switch (status)
    {
        case PGMCoreNetworkNotReachable:
            return NSLocalizedStringFromTable(@"Network not Reachable", @"PGMCoreReachabilityStatus", nil);
            break;
        case PGMCoreNetworkReachableViaWiFi:
            return NSLocalizedStringFromTable(@"Network reachable via WiFi", @"PGMCoreReachabilityStatus", nil);
            break;
        case PGMCoreNetworkReachableViaWWAN:
            return NSLocalizedStringFromTable(@"Network reachable via WWAN", @"PGMCoreReachabilityStatus", nil);
            break;
        case PGMCoreNetworkReachabilityUnknown:
        default:
            return NSLocalizedStringFromTable(@"Network reachability unknown", @"PGMCoreReachabilityStatus", nil);
    }
}

static PGMCoreReachabilityStatus networkStatusForFlags(SCNetworkReachabilityFlags flags)
{
    PrintReachabilityFlags(flags, "networkStatusForFlags");
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        // The target host is not reachable.
        return PGMCoreNetworkNotReachable;
    }
    
    BOOL returnValue = PGMCoreNetworkNotReachable;
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        /*
         If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
         */
        returnValue = PGMCoreNetworkReachableViaWiFi;
    }
    
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        /*
         ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
         */
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            /*
             ... and no [user] intervention is needed...
             */
            returnValue = PGMCoreNetworkReachableViaWiFi;
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        /*
         ... but WWAN connections are OK if the calling application is using the CFNetwork APIs.
         */
        returnValue = PGMCoreNetworkReachableViaWWAN;
    }
    
    return returnValue;
}

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
    PGMCoreReachabilityStatus status = networkStatusForFlags(flags);
    PGMCoreReachabilityStatusBlock block = (__bridge PGMCoreReachabilityStatusBlock)info;
    if (block)
    {
        block(status);
    }
    
    // Post a notification to notify the client that the network reachability changed.
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:PGMCoreReachabilityChanged
                                          object:nil
                                        userInfo:@{ PGMCoreReachabilityNotificationStatus: @(status),
                                                    PGMCoreReachabilityNotificationStatusText:PGMCoreNetworkReachabilityStatusAsString(status)}];
    });
}

static const void * ReachabilityRetainCallback(const void *info) {
    return Block_copy(info);
}

static void ReachabilityReleaseCallback(const void *info) {
    if (info) {
        Block_release(info);
    }
}

#pragma mark - PGMCoreReachability private interface

@interface PGMCoreReachability ()

@property (readwrite, nonatomic, assign) SCNetworkReachabilityRef networkReachability;
@property (readwrite, nonatomic, assign) PGMCoreReachabilityStatus networkReachabilityStatus;
@property (readwrite, nonatomic, copy) PGMCoreReachabilityStatusBlock networkReachabilityStatusBlock;

@end

#pragma mark - PGMCoreReachability implementation

@implementation PGMCoreReachability
{
    BOOL localWiFiRef;
    SCNetworkReachabilityRef reachabilityRef;
}

+ (instancetype)sharedReachability
{
    static PGMCoreReachability *_sharedReachability = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct sockaddr_in zeroAddress;
        bzero(&zeroAddress, sizeof(zeroAddress));
        zeroAddress.sin_len = sizeof(zeroAddress);
        zeroAddress.sin_family = AF_INET;
        
        _sharedReachability = [self reachabilityWithIPAddress:&zeroAddress];
    });
    
    return _sharedReachability;
}

+ (instancetype)reachabilityWithHost:(NSString *)host;
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [host UTF8String]);
    
    return [[self alloc] initWithReachability:reachability];
}


+ (instancetype)reachabilityWithIPAddress:(const struct sockaddr_in *)ipAddress;
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)ipAddress);
    
    return [[self alloc] initWithReachability:reachability];
}

- (instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability
{
    self = [super init];
    
    if (!self)
    {
        return nil;
    }
    
    self.networkReachability = reachability;
    self.networkReachabilityStatus = PGMCoreNetworkReachabilityUnknown;
    
    return self;
}

+ (instancetype)reachabilityForInternetConnection;
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    return [self reachabilityWithIPAddress:&zeroAddress];
}


+ (instancetype)reachabilityForLocalWiFi;
{
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;
    
    // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0.
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    
    PGMCoreReachability* returnValue = [self reachabilityWithIPAddress: &localWifiAddress];
    if (returnValue != NULL)
    {
        returnValue->localWiFiRef = YES;
    }
    
    return returnValue;
}

#pragma mark - Boolean Tests

- (BOOL)isReachable
{
    return [self isReachableViaWWAN] || [self isReachableViaWiFi];
}

- (BOOL)isReachableViaWWAN
{
    return self.networkReachabilityStatus == PGMCoreNetworkReachableViaWWAN;
}

- (BOOL)isReachableViaWiFi
{
    return self.networkReachabilityStatus == PGMCoreNetworkReachableViaWiFi;
}

#pragma mark - Start and stop notifier

- (void)startListening
{
    [self stopListening];
    
    if (!self.networkReachability)
    {
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    PGMCoreReachabilityStatusBlock callback = ^(PGMCoreReachabilityStatus status) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.networkReachabilityStatus = status;
        if (strongSelf.networkReachabilityStatusBlock)
        {
            strongSelf.networkReachabilityStatusBlock(status);
        }
    };
    
    SCNetworkReachabilityContext context = {0, (__bridge void *)callback, ReachabilityRetainCallback, ReachabilityReleaseCallback, NULL};
    SCNetworkReachabilitySetCallback(self.networkReachability, ReachabilityCallback, &context);
    SCNetworkReachabilityScheduleWithRunLoop(self.networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityGetFlags(self.networkReachability, &flags);
    dispatch_async(dispatch_get_main_queue(), ^{
        PGMCoreReachabilityStatus status = networkStatusForFlags(flags);
        callback(status);
    });
}


- (void)stopListening
{
    if (!self.networkReachability)
    {
        return;
    }
    if (reachabilityRef != NULL)
    {
        SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}


- (void)dealloc
{
    [self stopListening];
    if (reachabilityRef != NULL)
    {
        CFRelease(reachabilityRef);
        reachabilityRef = NULL;
    }
}


#pragma mark - Get Network Reachability Status

- (PGMCoreReachabilityStatus)currentNetworkReachabilityStatus
{
    return self.networkReachabilityStatus;
}

- (NSString*) currentNetworkReachabilityStatusAsString
{
    return PGMCoreNetworkReachabilityStatusAsString([self currentNetworkReachabilityStatus]);
}

- (void)setReachabilityStatusChangeBlock:(void (^)(PGMCoreReachabilityStatus status))block
{
    self.networkReachabilityStatusBlock = block;
}

#pragma mark - NSKeyValueObserving

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key isEqualToString:@"reachable"] || [key isEqualToString:@"reachableViaWWAN"] || [key isEqualToString:@"reachableViaWiFi"])
    {
        return [NSSet setWithObject:@"networkReachabilityStatus"];
    }
    
    return [super keyPathsForValuesAffectingValueForKey:key];
}

@end