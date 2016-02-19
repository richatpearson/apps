#Pearson Core iOS SDK

##Overview
The Core iOS SDK provides development teams with common mobile application functionality. The Core iOS SDK contains the following:

1. **Device Abstraction**, a utility that was created as a central point to gather data about the iOS device it is running on.
2. **Session Management**, networking code based on NSURLSession that wraps the NSURLSessionTasks in NSOperations so that they can be queued and dependencies added.
3. **Reachability**, a handy utility for testing network reachability

##System Requirements

* iOS 7 or newer
* ARC Compliant.

##Getting Started
The following frameworks are required:

* CoreTelephony
* SystemConfiguration
* Core Graphics

##Install the Core iOS SDK
There are two ways to acquire the Core iOS SDK: downloading a .zip of the framework from Nexus or setting a dependency in your Maven .pom file. 

###Download from Nexus
The **Core iOS SDK** can be downloaded directly from the Nexus repository here: [https://devops-tools.pearson.com/nexus-master/content/repositories/releases/com/pearson/mobileplatform/ios/core/CoreiOSSDK/2.0.0/CoreiOSSDK-2.0.0.xcode-framework-zip](https://devops-tools.pearson.com/nexus-master/content/repositories/releases/com/pearson/mobileplatform/ios/core/CoreiOSSDK/2.0.0/CoreiOSSDK-2.0.0.xcode-framework-zip)

It might be necessary to rename the file from `-zip` to `.zip` to extract the files.

After that, place the `CoreiOSSDK.framework` package anywhere it can be easily found (ex.: within the project folder structure).

###Xcode Maven Plugin
For Maven builds of an application, the currently recommended plugin to use is the Xcode Maven Plugin from SAP, documented here: [http://sap-production.github.io/xcode-maven-plugin/site/index.html](http://sap-production.github.io/xcode-maven-plugin/site/index.html).

In the pom.xml file, specify the dependency to the framework in the dependencies section.


    <dependencies>
    	<dependency>
    		<groupId>com.pearson.mobileplatform.ios.core</groupId>
    		<artifactId>CoreiOSSDK</artifactId>
    		<version>2.0.0</version>
    		<type>xcode-framework</type>
    	</dependency>
    </dependencies>


After that, from a Terminal window, run `mvn initialize` and the framework should download to a folder in the application's working directory.

`
Ex.: {YourApp}/target/xcode-deps/frameworks/Release/com.pearson.mobileplatform.ios.core/CoreiOSSDK/CoreiOSSDK.framework
`

###Building the SDK framework from the source code

There are two options available to build the framework directly from the source code downloaded from the Nexus repository: Xcode project or Maven. Choose the option that best fits your project setup and follow the directions below:

####The Xcode Project
Navigate to the **core-library-ios-sdk/framework/src/xcode/** folder and launch the Xcode project (`CoreiOSSDK.xcodeproj`). Select **Archive** from the **Project** menu. After the build is complete, Xcode should open a new window to display the framework package. If not, the framework package can be found by right clicking on **CoreiOSSDK.framework** in the **Products** group of the **Project Navigator.**

####Maven
Note: At this time, the xcode-maven-plugin is not compatible with maven 3.1 or higher. Please use 3.0.

From a Terminal window, navigate to **core-library-ios-sdk/framework/** and type `mvn clean install` to let Maven do the build. When the Maven run is complete, the **CoreiOSSDK.framework**  bundle can be found in the **core-library-ios-sdk/framework/target/checkout/src/xcode/build.** For most cases, the framework found in the *Release-iphoneos* folder can be used.

###Implementing the CoreiOSSDK framework
Once the **CoreiOSSDK framework** is obtained, add it to the Xcode project through the **Link Binary With Libraries** section of **Build Phases** of the project's target(s). 

##Supported Features

###DeviceAbstraction

The Device Abstraction instance captures basic information about the device an application is running on. The following is a list of the properties collected by the **DeviceAbstraction** instance with a brief description:

**Device Data**

NSString*   `deviceVendor` - the manufacturer of the device (currently will always be "Apple")

NSString*   `deviceModel` - the model of the device (iPhone, iPad, etc.)

NSString*   `deviceOSName` - the name of the operating system running on the device (ex.: iPhone OS)

NSString*   `deviceOSVersion` - the current version of the operating system;

NSString*   `deviceResolution` - the "width x height" pixel resolution of the current device (ex.: 640x960);

**Service Provider**

NSString*   `serviceProvider` - the name of the carrier (Verizon, ATT, etc.);

NSString*   `serviceProviderCountry` - the country that the Carrier is based out of;

**Application Data**

NSString*   `appVendorID` - the alphanumeric string that uniquely identifies a device to the app's vendor;

NSString*   `appName` - the application's bundle's display name;

NSString*   `appVersion` - the application's version number;

NSString*   `appBuild` - the application's build number;

**Network**

NSString*   `networkType` - the current network connection type (WifI, WWAN, none);

**Localization**

NSString*   `languagePreference` - the user's preferred language setting;

NSString*   `localeSetting` - the user's country code determined by the setting for Language and Region Format;

**Accessibility**

NSArray*   `enabledAccessibilityServices` - an array of those accessibility settings that are turned on by the user;

####Usage

To use **DeviceAbstraction,** import the `DeviceAbstraction.h` header.

    #import <CoreiOSSDK/PGMCoreDeviceAbstraction.h>

Create a **Device Abstraction** property and add a new instance.

    @property (strong, nonatomic) PGMCoreDeviceAbstraction* deviceAbstraction;
    ...
    self.deviceAbstraction = [PGMCoreDeviceAbstraction new];

To retrieve any particular property value, use simple dot notation... 

    NSString *networkType = self.deviceAbstraction.networkData.networkType;

To retrieve the data as a NSData object, use the public method...

    NSData *jsonDataObject = [self.deviceAbstraction getJSONDataObject];

There is also a helper method if the JSON is required as a string:

    NSString *jsonString = [self.deviceAbstraction getJSONDataString];

To refresh the device abstraction data at any time, either create a new instance of **DeviceAbstraction** or call `refresh` on an existing instance.

    [self.deviceAbsraction refresh];

####Samples

To view an example that illustrates the use of the **DeviceAbstraction** class in the **CoreiOSSDK,** please refer to the **PearsonCore** sample application found within the repository at *core-library-ios-sdk/samples/PearsonCore/src/xcode/.* 

The instance of the **DeviceAbstraction** can be found as a property of the **DeviceAbstractionViewController.**

####Accessibility

In order to match functionality with the Android class of the same name, expect the `enabledAccessibiltyServices` array to contain a list of only those accessibility services that are turned on. If none are turned on, the array will be empty (`[enabledAccessibilityServices count] == 0`).

####Example JSON string returned

	{
	   uuid: A52A3D18-486F-4F00-9E8A-277121760F6E
	   deviceVendor: Apple
	   deviceModel: iPhone
	   deviceOSName: iPhone OS
	   deviceOSVersion: 7.0
	   serviceProvider: Verizon
	   spCountry: US
	   appVendorID: 4E0CC137-7597-4ECF-80BA-8B26713969F7
	   appName: DeviceAbstraction
	   appVersion: 1.0
	   appBuild: 1.0
	   networkType: Wifi
	   languagePreference: English
	   localeSetting: US
	   enabledAccessibilityServices: [
		   VoiceOverRunning
		   GuidedAccessEnabled
		   InvertColorsEnabled
	   ]
	}

### Networking and Session Management
The PGMCore Library provides a unique networking management library based on NSURLSessions wrapped within NSOperations. This allows you to create multiple request tasks, create dependencies between task operations and enqueue them fairly easily.

To begin, you create an instance of the `PGMCoreSessionManger`by initializing with a default session configuration.

    self.sessionManager = [[PGMCoreSessionManager alloc] init];
    
You can add a custom configuration in the initialization by calling that method instead.

    NSURLSessionConfiguration *customSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // Configure Session Configuration
    [customSessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    
    self.sessionManager = [[PGMCoreSessionManager alloc] initWithSessionConfiguration: customSessionConfiguration];
    
Since the session manager contains a reference to the shared reachability instance, you can set that to start listening for changes in the reachability state. See the Network Reachability section for more information about this feature.

    [self.sessionManager.reachability startListening];
    
Completion blocks, by default, will be called on the main queue. You can change this by setting the session manager's completionQueue property.

    self.sessionManager.completionQueue = dispatch_queue_create("com.pearson.MyQueue", NULL);

Except for background sessions, the default setting for the maximum concurrent operations allowed is 3. You can change this setting as well.

    self.sessionManager.maxConcurrentOperationCount = 1;
    
After you have the session manager configured, you can start using it to generate operations for your different kinds of session task needs. Note that the different 
`NSURLSessionTask` types have a corresponding `PGMCoreSessionTaskOperation`.

    NSURLSessionDataTask -> PGMCoreSessionDataTaskOperation
    NSURLSessionDownloadTask -> PGMCoreSessionDownloadTaskOperation
    NSURLSessionUploadTask -> PGMCoreSessionUploadTaskOperation

####PGMCoreSessionDataTaskOperation operation example:

    NSOperation *operation = [self.sessionManager dataOperationWithRequest:request
                                                           progressHandler:nil
                                                         completionHandler:^(PGMCoreSessionTaskOperation *operation, NSData *data, NSError *error) {
                                                             if (error)
                                                             {
                                                                 [self dataFetchFailed];
                                                             }
                                                             else
                                                             {
                                                                 NSError *error = nil;
                                                                 NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                          options:0
                                                                                                                            error:&error];
                                                                 
                                                                 self.myDataDict = [dataDict objectForKey:@"data"];
                                                                 [self myDataFetchSuccess];
                                                             }
                                                         }];
    [self.sessionManager addOperationToQueue:userIdOperation];
    
####PGMCoreSessionDownloadTaskOperation operation example (uses a PGMCoreFileRequest data object):

    PGMCoreFileRequest *fileRequest = [[PGMCoreFileRequest alloc] initWithDictionary:fileDict];
    NSOperation *operation = [self.sessionManager downloadOperationWithURL:fileRequest.fileURL
                                                           didWriteDataHandler:^(PGMCoreSessionDownloadTaskOperation *operation, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
                                                               float progress;
                                                               if (totalBytesExpectedToWrite > 0)
                                                               {
                                                                   progress = fmodf((float) totalBytesWritten / totalBytesExpectedToWrite, 1.0);
                                                               } else {
                                                                   progress = fmodf((float) totalBytesWritten / 1e6, 1.0);
                                                               }
                                                               fileRequest.progress = progress;
                                                               
                                                               PGMFileListTableCell *cell = (id)[self.fileListTableView cellForRowAtIndexPath:indexPath];
                                                               [cell.progressView setProgress:progress];
                                                           }
                                                   didFinishDownloadingHandler:^(PGMCoreSessionDownloadTaskOperation *operation, NSURL *location, NSError *error) {
                                                               NSString *filename = [operation.task.originalRequest.URL lastPathComponent];
                                                               PGMFileListTableCell *cell = (id)[self.fileListTableView cellForRowAtIndexPath:indexPath];
                                                       
                                                               if (error)
                                                               {
                                                                   [cell.progressView setTintColor: [UIColor redColor]];
                                                               }
                                                               else
                                                               {
                                                                   NSString *path = [self.sessionManager.documentsPath stringByAppendingPathComponent:filename];
                                                                   
                                                                   [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:path] error:nil];
                                                               }
                                                               
                                                               fileRequest.progress = 1.0;
                                                       
                                                               [cell.progressView setProgress:fileRequest.progress];
                                                               
                                                               self.fileCompleteCount++;
                                                               [self checkFilesComplete];
                                                           }];
        [self.sessionManager addOperationToQueue:operation];

### Network Reachability
It is often necessary to know the status of a device's connection to the network (Wifi or WWAN) and be notified when that status changes. The PGMCore library offers an easy way to do this through `PGMCoreReachability`.

You can create a shared instance of the class (it's a Singleton) and instruct it to start listening to the networking:

    PGMCoreReachability *reachability = [PGMCoreReachability sharedReachability];
    [reachability startListening];
    
**Note:** The PGMCoreSessionManager has a shared instance of PGMCoreReachability so it can be used if the session manager has been implemented. 

    [self.sessionManager.reachability startListening];
    
You can easily test if a network is reachable or reachable specifically by WWAN or WiFi:

    BOOL networkIsReachable = reachability.reachable;
	BOOL networkIsReachableViaWWAN = reachability.reachableViaWWAN;
	BOOL networkIsReachableViaWiFi = reachability.reachableViaWiFi;

`PGMCoreReachability` is a simple networking management utility based on Apple's Reachability helper class and AFNetworking's Reachability Manager. It allows you to query network status and register observers for when network connectivity changes.

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:PGMCoreReachabilityChanged object:nil];
     
Here is a simple example of a selector method for this notification that refreshes a UITableView and shows an alert displaying the status text of the notification:

    - (void) networkChanged:(NSNotification*)notification
	{
		NSString* reachable = [[notification userInfo] objectForKey:PGMCoreReachabilityNotificationStatusText];
		[self refreshTableView];
		[self showAlertMessageWithTitle:@"Network Change" message:reachable];
	}

It's a very handy utility if you need to determine the reachability with a particular host or IP address.

    + (instancetype) reachabilityWithHostName:(NSString *)hostName;
    + (instancetype) reachabilityWithIPAddress:(const struct sockaddr_in *)ipAddress;   

You can query the current reachability status (unknown, no connection, connected via WiFI, connected via WWAN), 

    - (PGMCoreReachabilityStatus) currentReachabilityStatus;

This `PGMCoreReachabilityStatus` is enumerated as follows:

    PGMCoreNetworkReachabilityUnknown = -1
    PGMCoreNetworkNotReachable        =  0
    PGMCoreNetworkReachableViaWiFi    =  1
    PGMCoreNetworkReachableViaWWAN    =  2

##Getting Help
Frequently asked questions and support from the GRID Mobile community can be found on the [Pearson Developers Network community support pages](http://pdn.pearson.com/community). Browse the forums for assistance or submit a new question.