##Overview
The Push Notifications framework provides an easy way to add Pearson's Push Notifications service to your iOS application.

##Specifications
* supports iOS 5 +
* supports ARC and non-ARC applications

##Getting Started

The **PushNotifications.framework** has a direct dependency on the **PearsonAppServicesiOSSDK.framework**. You must add both of those to your project (through the "Link Binary With Libraries" section of the "Build Phase.")

Make sure that "Other Linker Flags" in "Build Settings" has the following two settings:

    -ObjC -all_load

**PushNotifications** requires the following additional frameworks:

*	CoreLocation.framework
*	CoreTelephony.framework
*	SystemConfiguration.framework
*	Security.framework

###Building the SDK from the source code

####AppServices dependency
Because of the direct dependency of the **PushNotifications.framework** on the **PearsonAppServicesiOSSDK.framework**, you must have a zipped build of that framework in your local maven repository. The **PearsonAppServicesiOSSDK.framework** includes the Apigee App Services SDK which enables monitoring and device registration for notifications to be delivered. Once the **PearsonAppServicesiOSSDK.framework** has been built, navigate to its `framework/src/xcode/build/framework/zip` folder. There should be two files there. The `appservices-#.#.#.#.xcode-framework-zip` is for use with the Xcode Maven plugin from SAP and the `appservices-#.#.#.#.zip` file is for use with the Maven Dependency plugin (#.#.#.# represents the version of the framework you are building). You should copy both of these files to your local maven repository.

To locate the area in the repository to place these files, you must first make sure you are showing hidden files on your Mac.

With that, navigate to `~/.m2/repository/com/pearson/mobileplatform/ios/appservices/appservices`. If a folder doesn't exist for the current version of the SDK you are building, create one and then drop the zip files in there.

####Maven Build
From a Terminal window, navigate to the **push-notifications-ios-sdk/framework** folder and issue the maven command:

`mvn clean install`

Successful builds can be found in the `/src/xcode/build/framework` folder along with zipped files destined for the Maven repository.

Note: At this time, the xcode-maven-plugin is not compatible with maven 3.1 or higher. Please use 3.0. This effects the building of the sample app.

####The Sample App
The sample app has multiple targets with the default being mobileapp4. To build another target, mobileapp1 for example, you can type the following:

    mvn clean install -P mobileapp1
    
The final ipa build can be found in the following location:

    /push-notifications-ios-sdk/samples/PearsonPush/builds/*name of profile chosen*

###Consuming the SDK framework

The framework is currently stored in the Nexus repository and can be downloaded in zip form from here:
[https://devops-tools.pearson.com/nexus-deps/content/repositories/thirdparty/com/pearson/mobileplatform/ios/appservices/pushnotifications/2.0.0/pushnotifications-2.0.0.xcode-framework-zip](https://devops-tools.pearson.com/nexus-deps/content/repositories/thirdparty/com/pearson/mobileplatform/ios/appservices/pushnotifications/2.0.0/pushnotifications-2.0.0.xcode-framework-zip)

You might have to rename the file from `-zip` to `.zip` to unarchive it.

####Xcode Maven Plugin
For Maven builds of your application, the currently recommended plugin to use is the [Xcode Maven Plugin from SAP](http://sap-production.github.io/xcode-maven-plugin/site/index.html).

You would specify the dependency to the two Pearson frameworks in the `dependencies` section of your pom.xml.

    <dependencies>
    	<dependency>
    		<groupId>com.pearson.mobileplatform.ios.appservices</groupId>
    		<artifactId>appservices</artifactId>
    		<version>2.0.10.1</version>
    		<type>xcode-framework</type>
    	</dependency>
    	<dependency>
    		<groupId>com.pearson.mobileplatform.ios.push</groupId>
    		<artifactId>pushnotifications</artifactId>
    		<version>2.0.0</version>
    		<type>xcode-framework</type>
    	</dependency>
    </dependencies>

After that, from a Terminal window, run `mvn initialize` and the framework should download to a folder in your applications working directory.

Ex.: {your App}/target/xcode-deps/frameworks/com.pearson.mobileplatform.ios.appservices/psuhnotifications/pushnotifications-1.3.0/PushNotifications.framework

## Push Notifications

###Requirements
1. **An iDevice.** You need either an iPhone, iPad, or iPodTouch to develop for Push Notifications. The simulator will not receive any type of Remote Notifications.
2. **AppId and ProvisioningProfile.** Each applications that requires Push Notification services needs a separate AppID, Provisioning Profile and Signing Certificate (with Push Services enabled) issued from the Apple iOS Developer Program. 

#####Please Note: Development vs Distribution Environments
Each iOS app implementing Push Notifications requires 2 Provisioning Profiles issued for each application; one for the development environment and one for the distribution environment. Each provisioning profile is used to generate a separate _notifier_ on the server side. 

These notifiers will be linked to the `application` name so AppServices will be supplying two application names (one for development and one for distribution). It is up to the app developer to Archive their application with the correct application name.

###Usage
Please refer to the **PearsonPush** sample application  (in the repository's samples folder) for an example of using the **PearsonPushNotifications** & **PearsonAppServicesiOSSDK** to add Push Notification to your application.

#####Application Delegate
You'll need to import the following file to get started:

    #import <PushNotifications/PearsonPushNotifications.h>

The PearsonsPushNotifcations instance should be intialized as soon as possible so it is best to do so from within the `application:didFinishLaunchingWithOptions:` method. For more information on different initialization methods, see the Initialization section below.

    // Initialize PushNotifications
        self.pushNotifications = [[PearsonPushNotifications alloc] initWithOrganization: *your organization name (provided by GRID Mobile team)*
                                                                            application: *your app ID (provided by GRID Mobile team)*
                                                                                 apiKey: *your api key (provided by GRID Mobile team)* ];
        [self.pushNotifications showLogging:YES];
        
        [self.pushNotifications registerApplicationWithAPN:[PearsonPushNotificationType getTypeWithBadge:YES Sound:YES Alert:YES Newsstand:NO]];
        
        [self.pushNotifications authenticationProvider:PearsonPIAuthentication];

The first line above initializes the **PearsonPushNotifications** object. The `organization`, `application` and `apiKey` values will be supplied to you by the MobilePlatform team. Register with the team by filling out [this form](https://docs.google.com/a/pearson.com/forms/d/1TahKgy3q2H7TFUVZygZxRTvGCaAztCZjQA6prDs0cPw/viewform). 

Next, you can see debugging logs generated by the **PearsonPushNotifications** toggled on.

The next line makes the call to register the app with Apple Push Notification Services (APN). Note that even though Apple deprecated certain register methods and notification type classes in iOS 8, PushNotification framework seamlessly supports your app registration with APN and accessing your user notification settings on both iOS 7 and iOS 8 and higher.

This is very important step in the launching process. According to Apple, *“Device tokens can change. Your app needs to reregister every time it is launched.”* To learn more about this, see the “Registering for Remote Notifications” section of the Local and Push Notification Programming Guide (https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/IPhoneOSClientImp.html#//apple_ref/doc/uid/TP40008194-CH103-SW1).

The PushNotifications services requires an access (or authentication) token. Currently, the service supports Pi and MI (Rumba, SMS) tokens. **(Please note that Whittaker tokens are no longer supported.)** The type of provider will determine how the request header is constructed. You must specify the token provider you will be using at some point so it's best to do it during the initialization. 

* For Pi tokens, specify `[self.pushNotifications authenticationProvider:PearsonPIAuthentication]`.
* For MI tokens, specify `[self.pushNotifications authenticationProvider:PearsonMIAuthentication]`.

You must make sure that the Application Delegate contains the three protocol methods for handling Remote Notifications.

    	* application:didReceiveRemoteNotification:
    	* application:didRegisterForRemoteNotificationsWithDeviceToken:
    	* application:didFailToRegisterForRemoteNotificationsWithError:

The SDK must be made aware of the success or failure of registering the application for remote notifications with APNs. To do this, the following lines must be added to these two protocol methods accordingly:

    - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
    {
        ...
        [self.pushNotifications application:application didRegisterWithNewDeviceToken:deviceToken];
        ...
    }
    
    - (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
    {
        ...
        [self.pushNotifications application:application didFailToRegisterWithError:error];
        ...
    }

It is beneficial to pass any incoming notifications to the PushNotifications SDK and to register for the `kPN_IncomingNotification` local notification.
In the following example, the application delegate registers as an observer for `kPN_IncomingNotification` and sets a method called `notificationReceived` as the selector.

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:kPN_IncomingNotification object:nil];
 
    - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
    {
        ...
        [self.pushNotifications application:application didReceivePushNotification:userInfo];
        ...
    }

    - (void)notificationReceived:(NSNotification*)nsNotification
    {
        Notification* notification = (Notification*)nsNotification.object;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Incoming Notification"
                                                            message: notification.alert
                                                           delegate: self
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
        [alertView show];
        [self playCustomSound];
    }

#### One More Thing To Do
There's one last piece to the PushNotifications puzzle. Once a valid user id and authorization token are obtained, the app is ready to register with App Services.

    [appDelegate.pushNotifications registerWithAppServicesUsingAuthorizationToken:token
                                                                           userId:appDelegate.userID];

#####Notification Types
With iOS 8 Apple depricated the previous notification type enum `UIRemoteNotificationType` and introduced a new enum `UIUserNotificationType`. Our current PushNotification framework seamlessly supports both types depending on which iOS version is run on the device. The good news is that the NSUInteger values of those enum types are the same for both `UIRemoteNotificationType` and `UIUserNotificationType` with exception of the Newsstand type, which is discontinued in iOS 8 and we are not currently handling NewsstandContentAvailability. To register for the specified types of Push notifications when calling `- (void) registerApplicationWithAPN:(NSUInteger)notificationType`, you must indicate a `NSUInteger` value for the types of notifications the application will accept. There are two ways to generate that value:

**1.** Build the bit mask value using the iOS 8 enum constants (iOS 7 enum has the same int values, with exception of Newsstand type) and pass to `registerApplicationWithAPN:`

    UIUserNotificationType type = (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert);

That would 1 + 2 + 4 or 7;
You can pass `type` to the register method:

    [self.pushNotifications registerApplicationWithAPN:type];

**2.** Use `PearsonPushNotificationType` without worring about version of iOS

`PearsonPushNotificationType` is a simple utility class for generating a value for UIRemoteNotificationType. Use the `getTypeWithBadge:Sound:Alert:Newsstand:` method to return the desired notification type value.

    UIRemoteNotificationType notificationType = [PearsonPushNotificationType getTypeWithBadge:YES Sound:YES Alert:YES Newsstand:NO];

Now you can pass `notificationType` to the register method:

    [self.pushNotifications registerApplicationWithAPN:notificationType];

If you wish to see which notification types have been enabled for the application, you can do the following:

    PushNotificationType* pushType = [PearsonPushNotificationType new];
    
    NSLog(@"BADGE : %@", pushType.badge?@"YES":@"NO");
    NSLog(@"SOUND : %@", pushType.sound?@"YES":@"NO");
    NSLog(@"ALERT : %@", pushType.alert?@"YES":@"NO");

If, for validation purposes, you want to check if notification types have been set you may use `areNotificationTypesSet` method:

    PushNotificationType* pushType = [PearsonPushNotificationType new];
    BOOL areNotificationTypesSet = [pushType areNotificationTypesSet];

`areNotificationTypesSet` returns YES (true) if at least one notification is set and NO (false) if none are set. This method handles both iOS 7 and iOS 8.

#####Initialization of PearsonPushNotifications with App Monitoring
The **PearsonAppServicesiOSSDK.framework** includes an App Monitoring feature that is instantiated when the PearsonAppServicesiOSSDK/PearsonClient is instantiated in the PearsonPushNotifications instance. You, the developer, have to turn the service on to begin monitoring within the PearsonPushNotifications framework; the default is that monitoring is disabled.

######PearsonPushNotification Initialization methods:

**Deprecated Initialization:** The deprecated basic initialization methods will initialize the `PearsonPushNotifications` with all monitoring options turned off. The first method listed uses the default base url and the second allows for specifying a custom base url.
  
        - (id) initWithOrganization:*your organization name (provided by MobilePlatform Services team)*
                        application:*your app ID (provided by MobilePlatform Services team)*
                             apiKey:*your app ID (provided by MobilePlatform Services team)*;
                             
        - (id) initWithOrganization:*your organization name (provided by MobilePlatform Services team)*
                        application:*your app ID (provided by MobilePlatform Services team)*
                             apiKey:*your app ID (provided by MobilePlatform Services team)*
                            baseURL:*a custom base URL (default URL is https://mobileservices.openclasslabs.com/appservices)*;
                     
**Basic Initialization:** The new basic initialization method will initialize the `PearsonPushNotifications` using the default base URL. This method gives you the option of specifically enabling default app monitoring.

        - (id) initWithOrganization:*your organization name (from MobilePlatform Services team)*
                        application:*your app ID (provided by GRID Mobile team)*
                             apiKey:*your app ID (provided by GRID Mobile team)*
                         monitoring:*YES turns on default monitoring, NO turns off all monitoring;

**Custom Initialization:** The custom initialization method allows you to specify custom monitoring options as well as a base URL.

        - (id) initWithOrganization:*your organization name (from MobilePlatform Services team)*
                        application:*your app ID (provided by GRID Mobile team)*
                             apiKey:*your app ID (provided by GRID Mobile team)*
                 monitoringOptions:*your customized PearsonMonitoringOptions object*
                            baseURL:*your specified base URL (enter the kPN_PearsonDefaultNotificationBaseURL constant to use the default)*

Please see the PearsonAppServicesiOSSDK for detailed information about configuring a PearsonMonitoringOptions object. 

Note that entering `nil` for `monitoringOptions:` will enable default monitoring. You can also disable monitoring options by configuring your PearsonMonitoringOptions object the following way:

    PearsonMonitoringOptions* monitoringOptions = [[PearsonMonitoringOptions alloc]init];
    monitoringOptions.monitoringEnabled = NO;

#####Registration Process
For Push Notifications to be enabled, there are 4 requirements going on in the background:

  1. Application/device has registered with Apple Push Notification Service (APNs).
  2. User is registered with MobilePlatform AppServices
  3. Device is registered with MobilePlatform AppServices
  4. User and device are "connected".
  
You can test the status of any of these requirements by using the following methods:

    - (BOOL) applicationIsRegisteredForNotifications
    - (BOOL) deviceIsRegisteredWithAppServices
    - (BOOL) userIsRegisteredWithAppServices
    - (BOOL) userIsConnectedToDevice

The following notifications are dispatched upon completion of the various steps in a registration request (names should be self-explanatory):

    1. kPN_DeviceRegistrationRequest
    2. kPN_UserRegistrationRequest
    3. kPN_UserDeviceConnectionRequest
    
A `PearsonClientResponse` object is attached to the notification and you can use this to determine the success or failure of the request.

#####Unregistering
In the event that you wish to prevent a device from receiving notifications for the current user (ex.: when the user logs out), you will need to call the unregistration method.

    if([appDelegate.pushNotifications userIsConnectedToDevice])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDeviceDisconnectResponse:) name:kPN_UserDeviceDisconnectionRequest     object:nil];
        [appDelegate.pushNotifications unregisterWithAppServicesUsingAuthorizationToken:authorizationToken];
    }

The following notifications are dispatched upon completion of the various steps in an unregistration request (names should be self-explanatory):

    1. kPN_DeviceUnregistrationRequest
    2. kPN_UserDeviceDisconnectionRequest

A `PearsonClientResponse` object is attached to the notification and you can use this to determine the success or failure of the request.

**Note:** The user is not unregistered from App Services during an Unregistration request. This is because the user might be registered with another device. Only the device is unregistered and the connection between the user and the device is broken.

#####Notification Payload
`PushNotifcatons` will insert any incoming notification payloads passed to it into a `notification` object that it returns through the local notification named kPN_IncomingNotificaton.

A basic payload delivered from APNs would be in this format:

    { "aps" : 
        {
            "alert" : "New assignments have been posted to OpenClass",
            "badge" : 5,
            "sound" : "default"
       }
    } 

Values for `badge` and `sound` will be typed as `NSString`. The `alert` type is `id` because it can take the form of a `NSString, NSArray, or NSDictionary` depending on the specific application.

Any "custom" data in a payload such as in the following example will be inserted into the notification object's `customPayload` NSDictionary as key/value pairs.

    {
        "aps" : {
            "alert" : "Reminder: Mid-term papers are due Monday.",
            "badge" : 1,
            "sound" : "bong.aiff"
        },
        "courseName" : "Art History 101",
        "instructor" : "Marilyn Stokstadl"
    }

#####Groups
You can add users that are already registered with App Services to groups very easily.

    [self.pushNotification addUserWithId:*your user Id from your Authorization source*
                            toGroupNamed:*the name of the group you're adding the user to*
                          usingAuthToken:*your current valid auth token*];


The default behavior for the PushNotifications SDKis to first check for the existence of a group with the name specified. If none exists, it creates one before adding the user to it. You can change this default behavior by setting the following during the initialization process:

    [self.pushNotifications onlyAddUserToExistingGroups:YES];
    
In this case, the SDK will check for the existence of the group and if it exists, it will add the user. If not, it will fail with a notification that it could not add the user to the group.

Removing a user from a group is just as easy as adding one.

    [self.pushNotification removeUserWithId:*your user Id from your Authorization source*
                             fromGroupNamed:*the name of the group you're adding the user to*
                             usingAuthToken:*your current valid auth token*];

#####Notification Preferences
If you are intending to set notification preferences from your app so that your users can filter what types of notifications they want to receive, you will have to import an additional header from the SDK:

    #import <PearsonAppServicesiOSSDK/PearsonNotificationsPreferences.h>

For detailed information as to how Push Notification Filtering works, please refer to the [Push Notifications filtering and preferences design pages](http://pdn.pearson.com/grid-mobile/mobile-push-notifications/push-notifications-device-preferences-and-message-filtering). 

The `PearsonNotificationPreferences` class contains two `NSDictionary` properties, `whitelist` and `blacklist`. You would typically create an instance of this class in the following manner:

    PearsonNotificationPreferences* prefs = [PearsonNotificationPreferences new];
    prefs.whitelist = @{@"notificationTypeA": @[],
                        @"notificationTypeB": @[@"notificationException1", @"notificationException2"]
                        };
    prefs.blacklist = @{};
   
   [self.pushNotifications saveNotificationPreferences:prefs
                                          withAuthToken:[self currentAuthToken]];

Another way to add filtering data to the whitelist or blacklist would be to use the helper methods `addToWhitelist:(NSArray*)list` and `addToBlacklist:(NSArray*)list`.

You need to create an array of strings with the filtering key as the first object and any exceptions afterwards.

    PearsonNotificationPreferences* prefs = [PearsonNotificationPreferences new];
    [prefs.addToWhiteList:@[@"filterKey1", @"exceptionKey1", @"exceptionKey2", @"exceptionKey3"]];
    [prefs.addToWhiteList:@[@"filterKey2"];
    [prefs.addToBlackList:@[@"filterKey3", @"exceptionKey4"];

or

    NSArray* filterArray1 = [NSArray arrayWithObjects:@"filterKey2", @"exception1", nil];
    [prefs.addToBlackList:filterArray1];

In the above example, after the `PearsonNotificationPreferences` object has been instantiated, it is passed to the PearsonPushNotifications instance via the `saveNotificationPreferences:withAuthToken:` method. A couple of things then happen. First, the valid preferences object is saved and persistently stored on the device. Then, an attempt is made to post the preferences object to PearsonAppServices to be stored (until the next update). 

Note that each time your app is launched, the locally stored preferences will be retrieved and posted to PearsonAppServices.

A notification is broadcast to report the success or failure of these attempts (`kPN_SaveNotificationPreferences`).

To retrieve the stored preferences object from the PearsonPushNotifications instance, call the getter method:

    PearsonNotificationPreferences* preferences = [self.pushNotification notificationPreferences];

######Saving Notification Preferences and Network Reachability

The case may arise where a user's device is offline and their notification preferences have been updated and saved locally. You can set up your app to report these updates to PearsonAppServices as soon as the device comes online again by registering to receive alerts when network reachability changes. *(Please note that these steps are only required if you don't already have a routine in place to determine reachability.)*

    [self.pushNotifications notifyWhenNetworkChangesOccur:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kPN_NetworkConnectionChange object:nil];

In the above example, `kPN_NetworkConnectionChange` is the string constant representing the network change event and `networkChanged:` is the selector set to handle the event.

    - (void) networkChanged:(NSNotification*)notification
    {
        NSString* reachable = (NSString *)[notification object];
        
        if ([reachable isEqualToString:kPN_NetworkReachable])
        {
            if(! [self.pushNotifications notificationPreferencesHaveBeenUpdated])
           {
                [self.pushNotifications saveNotificationPreferences:nil
                                                      withAuthToken:[self currentAuthToken]];
            }
        } else if ([reachable isEqualToString:kPN_NetworkUnreachable]){
            // Do something when device goes offline.
        }
    }

The object attached to the notification will be a NSString with a value equal to either `kPN_NetworkReachable` (there is a network connection) or `kPN_NetworkUnreachable` (the device is offline).

If the network is reachable, the example first tests to see if the current notification preferences have been updated to PersonAppServices. If not, it calls `saveNotificationPreferences:withAuthToken:` with a `nil` value for `PearsonNotificationPreferences`. The nil value causes the `pushNotifications` instance to send the last locally saved preferences to PearsonAppServices.

The object attached to the notification will be a NSString with a value equal to either `kPN_NetworkReachable` (there is a network connection) or `kPN_NetworkUnreachable` (the device is offline).

If the network is reachable, the example first tests to see if the current notification preferences have been updated to PersonAppServices. If not, it calls `saveNotificationPreferences:withAuthToken:` with a `nil` value for `PearsonNotificationPreferences`. The nil value causes the `pushNotifications` instance to send the last locally saved preferences to PearsonAppServices.

####Launch Options
If your app is launched by a swipe of an alert in the notification center, it will enter your application through the `application:didFinishLaunchingWithOptions:` method of the AppDelegate. If you need to capture that notification content, you would do something like the following:

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        ...
        if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) 
        {
        	[self application:application didReceiveRemoteNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
    	}
    	...
    }


##Get Help
Frequently asked questions and support from the Mobile Platform community can be found on the [**Pearson Developers Network community support pages**](/community). Browse the forums for assistance or submit a new question.
