//
//  PGMCoreDeviceAbstraction.h
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 7/10/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMCoreDeviceData.h"
#import "PGMCoreServiceProviderData.h"
#import "PGMCoreApplicationData.h"
#import "PGMCoreNetworkData.h"
#import "PGMCoreLocalizationData.h"
#import "PGMCoreAccessibilityData.h"
#import "PGMCoreReachability.h"

/*!
 Device Absraction is a utility for gathering basic data about the iOS device
 that the Pearson App is running on as well as some genral user preference data.<br><br>
 **Device Data**<br>
 NSString   `deviceVendor` - the manufacturer of the device (currently will always be "Apple")<br>
 NSString   `deviceModel` - the model of the device (iPhone, iPad, etc.)<br>
 NSString   `deviceOSName` - the name of the operating system running on the device (ex.: iPhone OS)<br>
 NSString   `deviceOSVersion` - the current version of the operating system<br>
 NSString   `deviceResolution` - the "width x height" pixel resolution of the current device (ex.: 640x960)<br>
 **Service Provider**<br>
 NSString   `serviceProvider` - the name of the carrier (Verizon, ATT, etc.)<br>
 NSString   `serviceProviderCountry` - the country that the Carrier is based out of<br>
 **Application Data**<br>
 NSString   `appVendorID` - the alphanumeric string that uniquely identifies a device to the app's vendor<br>
 NSString   `appName` - the application's bundle's display name<br>
 NSString   `appVersion` - the application's version number<br>
 NSString   `appBuild` - the application's build number<br>
 **Network**<br>
 NSString   `networkType` - the current network connection type (WifI, WWAN, none)<br>
 **Localization**<br>
 NSString   `languagePreference` - the user's preferred language setting<br>
 NSString   `localeSetting` - the user's country code determined by the setting for Language and Region Format<br>
 **Accessibility**<br>
 NSArray   `enabledAccessibilityServices` - an array of those accessibility settings that are turned on by the user<br>
 */

@interface PGMCoreDeviceAbstraction : NSObject

extern NSString* const PGMCoreNetworkTypeWifi;
extern NSString* const PGMCoreNetworkTypeWWAN;
extern NSString* const PGMCoreNetworkStatusChange;
extern NSString* const PGMCoreNetworkReachable;
extern NSString* const PGMCoreNetworkUnreachable;

extern NSString* const PGMCoreVoiceOverRunning;
extern NSString* const PGMCoreMonoAudioEnabled;
extern NSString* const PGMCoreClosedCaptioningEnabled;
extern NSString* const PGMCoreGuidedAccessEnabled;
extern NSString* const PGMCoreInvertColorsEnabled;

/*!
 Device Data object containing read-only properties.
 
 @see DeviceData.h
 */
@property (strong, nonatomic) PGMCoreDeviceData            *   deviceData;

/*!
 Service Provider Data containing read-only properties
 
 @see ServiceProviderData.h
 */
@property (strong, nonatomic) PGMCoreServiceProviderData   *   serviceProviderData;

/*!
 Application Data containing read-only properties
 
 @see ApplicationData.h
 */
@property (strong, nonatomic) PGMCoreApplicationData       *   applicationData;

/*!
 Network Data containing read-only properties
 
 @see NetworkData.h
 */
@property (strong, nonatomic) PGMCoreNetworkData           *   networkData;

/*!
 Localization Data containing read-only properties
 
 @see LocalizationData.h
 */
@property (strong, nonatomic) PGMCoreLocalizationData      *   localizationData;
/*!
 Accessibility Data containing read-only properties
 
 @see AccessibilityData.h
 */
@property (strong, nonatomic) PGMCoreAccessibilityData     *   accessibilityData;

/*!
 A string containing the Universally unique identifier generated for the specific
 app running on the specific device. The standard format for UUIDs represented in
 ASCII is a string punctuated by hyphens, for example 68753A44-4D6F-1226-9C60-0050E4C00067.
 */
@property (strong, nonatomic, readonly)   NSString  *   uuid;

/*!
 Initializing an instance of DeviceAbstraction begins the process of
 gathering data about the device, service provider, type of network, localization,
 application, and accessibility.<br>
 
 @return an instance of the DeviceAbstraction class
 */
- (id) init;

/*!
 Refresh the data objects
 */
- (void) refresh;

//- (void) gatherData;

/*!
 Retrieve the gathered data as an NSDictionary
 
 @return A NSDictionary with all of the key-value object pairs.
 */
- (NSDictionary*) dataAsDictionary;

/*!
 Retrieve the gathered data as a NSData obejct
 
 @return All of the DeviceAbstraction gathered data in a NSData format.
 */
- (NSData*) jsonDataObject;

/*!
 Retrieve the gathered data as a JSON string
 
 @return All of the DeviceAbstraction gathered data as JSON in a NSString format.
 */
- (NSString*) jsonDataString;

/*!
 Retrieve the device data
 
 @return The device data properties stored in an NSDictionary
 */
- (NSDictionary*) deviceDataAsDictionary;

/*!
 Retrieve the service provider  data
 
 @return The service provider properties stored in an NSDictionary
 */
- (NSDictionary*) serviceProviderDataAsDictionary;

/*!
 Retrieve the application data
 
 @return The application data properties stored in an NSDictionary
 */
- (NSDictionary*) applicationDataAsDictionary;

/*!
 Retrieve the network data
 
 @return The network data properties stored in an NSDictionary
 */
- (NSDictionary*) networkDataAsDictionary;

/*!
 Retrieve the localization data
 
 @return The localization data properties stored in an NSDictionary
 */
- (NSDictionary*) localizationDataAsDictionary;

/*!
 Retrieve the accessibility data
 
 @return The accessibility data properties stored in an NSDictionary
 */
- (NSDictionary*) accessibilityDataAsDictionary;

/*!
 Simple method for to enable getting notified when network connection statuses
 change from online to offline and back again. All that is necessary is to register
 as an obeserver for `Pearson_NetworkStatusChange` notifications and to set the
 `DeviceAbstraction` object to notify you when the network chnages occur. When they
 do, the object attached with the notification will be a NSString with the value of
 `Pearson_NetworkReachable` or `Pearson_NetworkUnreachable` to accordingly indicate
 whether the device is on or offline.
 
 @param alertMe Indicates if the DeviceAbstraction dispatch notifications when
 network status changes.
 */
//- (void) notifyWhenNetworkChangesOccur:(BOOL)alertMe;

@end
