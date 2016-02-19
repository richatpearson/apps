/*
 File: PGMCoreReachability.h
 
 Copyright (C) 2013 Pearson Inc. All Rights Reserved.
 
 */

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>


typedef NS_ENUM(NSInteger, PGMCoreReachabilityStatus) {
    PGMCoreNetworkReachabilityUnknown = -1,
    PGMCoreNetworkNotReachable        = 0,
    PGMCoreNetworkReachableViaWiFi    = 1,
    PGMCoreNetworkReachableViaWWAN    = 2
};

extern NSString* const PGMCoreReachabilityChanged;
extern NSString* const PGMCoreReachabilityNotificationStatus;
extern NSString* const PGMCoreReachabilityNotificationStatusText;

/*!
 Contains some simple methods to test network reachability and to get 
 notifications when reachability changes.
 
 See Apple's Reachability Sample Code (https://developer.apple.com/library/ios/samplecode/reachability/)
 */
@interface PGMCoreReachability : NSObject

/*!
 The current network reachability status.
 */
@property (readonly, nonatomic, assign) PGMCoreReachabilityStatus networkReachabilityStatus;

/*!
 Whether or not the network is reachable.
 */
@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;

/*!
 Whether or not the network is reachable via WWAN.
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWWAN) BOOL reachableViaWWAN;

/*!
 Whether or not the network is reachable via WiFi.
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

/*!
 Singleton type instance
 
 @return The shared PGMCoreReachabiltiy instance
 */
+ (instancetype) sharedReachability;

/*!
 Initializes a shared instance of PearsonReachability with a specific host.<br>
 `PGMCoreReachability *reachability = [PGMCoreReachability reachabilityWithHostName:@"www.pearson.com"];`<br>
 <i>"A remote host is considered reachable when a data packet, sent by an application
 into the network stack, can leave the local device. Reachability does not guarantee 
 that the data packet will actually be received by the host."</i>
 
 @param hostName The string for the url of the host you wish to reach.
 
 */
+ (instancetype)reachabilityWithHost:(NSString *)host;

/*!
 Use to check the reachability of a given IP address.<br>
 <i>"A remote host is considered reachable when a data packet, sent by an application
 into the network stack, can leave the local device. Reachability does not guarantee
 that the data packet will actually be received by the host."</i>
 
 @param hostAddress the IP address of the host you wish to reach
 */
+ (instancetype)reachabilityWithIPAddress:(const struct sockaddr_in *)ipAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)reachabilityForInternetConnection;

/*!
 * Checks whether a local WiFi connection is available.
 */
+ (instancetype)reachabilityForLocalWiFi;

/*!
 Initialize an instance of PGMCoreReachability
 
 @param reachability The reachability object
 
 @return the initialized instance of PGMCoreReachability
 */
- (instancetype) initWithReachability:(SCNetworkReachabilityRef)reachability;

/*!
 * Start listening for reachability notifications.
 */
- (void)startListening;

/*!
 Stop listening for reachability notifications
 */
- (void)stopListening;

/*!
 Determine the current network reachability status.
 
 @return The defined PGMCoreReachabilityStatus type:<br>
 `PGMCoreNetworkReachabilityUnknown = -1`,<br>
 `PGMCoreNetworkNotReachable        = 0`,<br>
 `PGMCoreNetworkReachableViaWiFi    = 1`,<br>
 `PGMCoreNetworkReachableViaWWAN    = 2`
 */
- (PGMCoreReachabilityStatus)currentNetworkReachabilityStatus;

/*!
 Determines the current network reachability status and returns as a string
 
 @return Network reachability unknown, Network not reachable, Network reachable via WiFi, Network reachable via WWAN
 */
- (NSString*) currentNetworkReachabilityStatusAsString;

/**
 Sets a callback to be executed when the network availability of the `baseURL` host changes.
 
 @param block A block object to be executed when the network availability of the `baseURL` host changes.
 This block has no return value and takes a single argument which represents the various reachability states from the device to the `baseURL`.
 <br>
 **Currently under development...not tested**
 */
- (void)setReachabilityStatusChangeBlock:(void (^)(PGMCoreReachabilityStatus status))block;

@end