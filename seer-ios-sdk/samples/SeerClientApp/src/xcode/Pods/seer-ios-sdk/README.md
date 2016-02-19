#Pearson Seer iOS Client

##Overview

The Seer iOS SDK ( **Seer-ios-sdk** ) provides an easy way to connect to Seer and upload Activity Stream payloads and Tin Can statements. The sdk features a queue for persistently storing recorded Activity Stream and Tin Can data for batch upload when the device your application is running on is online.

##System Requirements

* supports iOS 5 +
* supports ARC and non-ARC applications

##Getting Started

**Register your application with the Seer team.**

The Seer team will need the following information, which you can send to seerteam@pearson.com

*    Application name
     *    Short Application Description (one sentence or so).
     *    List of contacts for the application. For each contact, please provide the following:
          *    Name
          *    Phone number
          *    Email address
          
You will receive a unique client id, client secret, and api key to use for communicating with Seer.

##Installation

Installation is as simple as including the framework in the Xcode project.

###Download
<<<<<<< HEAD
The Seer iOS SDK can be downloaded directly from the Nexus repository here:  (https://devops-tools.pearson.com/nexus-deps/content/groups/all-deps/com/pearson/mobileplatform/ios/seerclient/Seer-ios-client/1.1.0/Seer-ios-client-1.1.0.xcode-framework-zip). You'll be prompted for your Nexus credentials.
=======
The Seer iOS SDK can be downloaded directly from the Nexus repository here:  (https://devops-tools.pearson.com/nexus-deps/content/groups/all-deps/com/pearson/mobileplatform/ios/seerclient/Seer-ios-client/1.0.0/Seer-ios-client-1.0.0.xcode-framework-zip). You'll be prompted for your Nexus credentials.
>>>>>>> FETCH_HEAD

It might be necessary to rename the file from `-zip` to `.zip` to extract the files.

After that, place the `Seer-ios-client.framework` package anywhere that it can be easily found (ex.: within the project folder structure).

###Using CocoaPods
If you have never used CocoaPods - please refer to the following [http://guides.cocoapods.org/ guild] to install it on your computer.
You will also need access to our git repo: gridmobile-cocoapods. Run the following command in your terminal:

```
pod repo add gridmobile-cocoapods ssh://git@devops-tools.pearson.com/mp/gridmobile-cocoapods.git
```
Which will install our podspecs in your ~/.cocoapods/repos

Lastly, in the directory where your .xcodeproj is located create a Podfile with the following entry:

```
pod 'legacy-authentication-ios-sdk', '<version>'
```
Example

```
pod 'legacy-authentication-ios-sdk', '1.0.0'
```
Then run the following pod command in the directory where your .xcodeproj file is:

```
pod install
```
In Xcode open <your_project>.xcworkspace and build.


###Building the SDK framework from source code

There are two options available to build the framework directly from the source code downloaded from the GitHub repository: Xcode project or Maven. Choose the option that best fits your project setup and follow the directions below:

####The Xcode Project

Navigate to the **seer-ios-sdk/framework/src/xcode/** folder and launch the Xcode project (`SeeriOSSDK.xcodeproj`). Select **Archive** from the **Project** menu. After the build is complete, Xcode should open a new window to display the framework package. If not, the framework package can be found by right clicking on **SeeriOSSDK.framework** in the **Products** group of the **Project Navigator.**

####Maven
Note: At this time, the xcode-maven-plugin is not compatible with maven 3.1 or higher. Please use 3.0.

From a Terminal window, navigate to **seer-ios-sdk/framework/** and type `mvn clean install` to let Maven do the build. When the Maven run is complete, the **SeeriOSSDK.framework**  bundle can be found in the **seer-ios-sdk/framework/target/checkout/src/xcode/build.** For most cases, the framework found in the *Release-iphoneos* folder can be used.

##Usage

### Implementation

The **Seer-ios-client** framework is dependent upon the SQLite library so you must add both the `Seer-ios-client` framework and `libsqlite3.dylib` to your project.

To implement the **Seer-ios-client** framework in your app, you'll first need to import the `SeerClient` header.

```
#import <Seer-ios-client/SeerClient.h>
```
    
Once that is done, you can create a property for it and a new instance.

```
@property (nonatomic, strong) SeerClient* seerClient;
...
self.seerClient = [SeerClient alloc] initWithClientId: *client ID supplied by Seer team*
                                         clientSecret: *client secret supplied by Seer team*
                                               apiKey: *api key supplied by Seer team (could be nil)*
```
                                               
#### The Queue
The **Seer-ios-client** includes a SQLite queue for persistently storing data to be uploaded to Seer. As the app developer, you have the choice of either reporting your Activity Stream and Tin Can data directly or queuing it for upload at a later time when the application isn't busy with user interactions. The Queue also comes in handy for recording interactions while the user is offline. Any interactions that can not be sent directly to Seer are stored automatically to be sent when the device is online again.

The easiest way to set the **Seer-ios-client Queue** to upload data to Seer automatically is to set the `autoReportQueue` flag in the SeerClient to `YES` (default setting). This tells the SeerClient that you want to upload queued data when the app first starts and at anytime that the app goes to the background.

```
self.seerClient.autoReportQueue = YES;
```

For greater control over when the SeerClient uploads queued data, you can set the `autoReportQueue` flag to `NO` and add calls to the SeerClient's `reportQueue` method

```
[self.seerClient reportQueue];
```

at various transitions of the applications state.

```
    1. applicationDidBecomeActive:
    2. applicationDidEnterBackground:
    3. applicationWillEnterForeground:
    4. applicationWillTerminate:
    5. applicationWillResignActive:
```

On the rare occasion when you require a response for each request you make to send a queued item to the Seer server, you can set the `receiveQueuedItemResponses` flag to `YES` (default setting is `NO`).

```
self.receiveQueuedItemResponses = YES;
```

#### Seer Client Events
The following constants represent seven SeerClient events.

```
kSEER_TokenFetch                     - Event generated when SeerClient is fetching an authorization token.
kSEER_TincanReport                   - Event generated when Tin Can data is reported to Seer.
kSEER_ActivityStreamReport           - Event generated when Activity Stream data is reported to Seer.
kSEER_InstrumentationReport          - Event generated when Instrumentation data is reported to Seer.

kSEER_RequestStartSession            - Event generated when a Seer Client session has started
kSEER_RequestReportQueue             - Event generated for the process of reporting the entire queue with all the batches in it
kSEER_RequestResultForQueuedBatch    - Event generated when an individual batch of items in the queue is reported to Seer
```

#### SeerClientResponse

Every request made to the Seer Client generates a `SeerClientResponse` object or, for batch-related requests `SeerClientBatchResponse` object. The `SeerClientResponse` contains the following properties: 

```
BOOL success;            // indicates if the request was a success or failure. 
NSInteger requestId;     // unique number identifying this request
NSError* error;          // any error generated by the request would stored here
NSString* requestType;   // the type of request made (kSEER_RequestStartSession, kSEER_ActivityStreamReport, etc.)
BOOL queued;             // indicates if the report request was queued
```
The `SeerClientBatchResponse` contains these properties:

```
BOOL success;            // indicates if the request was a success or failure.
NSArray* requestIds;     // collection of ids uniquely identifying the requests (queue items) in the batch 
NSError* error;          // any error generated by the request would stored here
NSString* requestType;   // the type of request made (kSEER_RequestStartSession, kSEER_ActivityStreamReport, etc.)
BOOL queued;
```

#### Seer Client Responses to Seer Client Requests

The **Seer-ios-client** offers 3 ways to receive responses from your requests. You can choose to either set a delegate, "listen" for Notifications, or set `onComplete` blocks. You can also mix and match.

##### Register as a Delegate

Register an object ( *i.e.: AppDelegate* ) that implements the `<SeerClientDelegate>` protocols as a delegate of `SeerClient` and before starting a Seer session.

    self.seerClient.delegate = self;                                              
    
After a request is complete, the Seer Client will call the delegate method with a generated response.

```
- (void) seerClientDelegateResponse:(SeerClientResponse*)seerClientRepsonse; 
```

or, for reporting a batch upload:

```
- (void) seerClientDelegateBatchResponse:(SeerClientBatchResponse*)seerClientBatchResponse;
```

##### Notification

You can add an observer for any of the 7 Seer Client events listed above.

```
[[NSNotificationCenter defaultCenter] addObserver: self
                                         selector: @selector(startSessionComplete:)
                                             name: kSEER_RequestStartSession
                                           object: nil];
```

In the above example, an observer is added for the `kSEER_RequestStartSession` event. In this case, a method `startSessionComplete` is named as the selector.

##### onComplete Blocks

All *onComplete* blocks must conforms to the type definition for `SeerRequestComplete`.

```
typedef void (^SeerRequestComplete)(SeerClientResponse*);
```

The following is an example of this kind of approach.

```
SeerRequestComplete seerStartSessionComplete = ^(SeerClientResponse seerClientResponse) 
{
	if(seerClientResponse.error)
	{
		 [self showError:seerClientResponse.error];
	} else {
		[self.spinner stopAnimating];
		[self enableUIElements];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:kSEER_RequestStartSession object:nil];
	}
};

[self.seerClient startSeerSessionAndOnComplete:seerStartSessionComplete];
```

#### Start a Session
After the initialization and desired property settings are complete, it is recommended that you call one of Seer Client's startSession methods.

```
[self.seerClient startSeerSession];

or

[self.seerClient startSeerSessionAndOnComplete:seerStartSessionComplete];
```

#### An Example
In this example taken from the Application Delegate of the SeerClientApp sample application, you can see both the delegate method and the notification method employed at the initialization of the Seer Client. The delegate method in the sample app is used solely to process responses from direct reporting of Activity Streams and Tin Can data while responses to the start of the session and the reporting of the queue are handled through notifications. 

```
- (void) initSeerClient
{
    self.seerClient = [[SeerClient alloc] initWithClientId: @"!@#$%^&&*"
                                              clientSecret: @"*&^%$#@@!"
                                                    apiKey: nil];
    
    self.seerClient.autoReportQueue = YES;
    self.seerClient.receiveQueuedItemResponses = YES;
    
    self.seerClient.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(startSessionComplete:)
                                                 name: kSEER_RequestStartSession
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(sessionUpdated)
                                                 name: kSEER_RequestReportQueue
                                               object: nil];
    
    [self.seerClient startSeerSession];
}
``` 

### Endpoints

Endpoints refer to the types of reported data to be uploaded to Seer and are represented by the paths appended to the base Seer url.

    https://seer-beacon.qaprod.ecollege.com

There are preset endpoints in the **Seer-ios-sdk** for reporting Activity Streams, Instrumentations (a specific form of an Activity Stream), and Tin Can statements. These endpoints are referenced by the following constants:

<table width="300">
<tr>
<td> <b>Constant</b> </td>
<td> <b>Path</b></td>
</tr>
<tr>
<td>1. kSEER_ActivityStreamReport</td>
<td>/sactivity</td>
</tr>
<tr>
<td>2. kSEER_InstrumentationReport</td>
<td>/sinstrumentation</td>
</tr>
<tr>
<td>3. kSEER_TincanReport</td>
<td>/tincan</td>
</tr>
<tr>
<td>4. kSEER_ActivityStreamBatch</td>
<td>/sactivity/batch</td>
</tr>
<tr>
<td>5. kSEER_TincanBatch</td>
<td>/tincan/batch</td>
</tr>
</table>

Use these constants when referring to these specific endpoints. 

The **Seer-ios-sdk** also allows you to add new or customized endpoints if needed.

```
[self.seerClient addEndpoint:@"/customendpoint" forName:@"myApplicationsCustomPath"];
```

The `getEndpoints` method will return a dictionary of all the endpoints stored in the Seer Client with the key being the name and the value being the path.

```
NSDictionary* endpointDictionary = [self.seerClient getEndpoints];
```

### ActivityStream/Instrumentation Reporting

The **Seer-ios-sdk** provides two ways of reporting an ActivityStream/Instrumentation to Seer.

#### 1. Data Dictionary

This is an example of constructing the ActivityStream/Instrumentation data directly as a `NSDictionary` before validating it & reporting it via the `SeerClient`.

```
NSDictionary *payload = @{
                             @"actor" : @{
                                            @"id" : @"pearsonappuser@gmail.com"
                                        },
                             @"verb": @"action",
                             @"object": @{
                                            @"id" : @"objectId",
                                            @"objectType" : @"objectType",
                                        },
                             @"generator" : @{
                                            @"appId" : @"Seer-ios-sample-app",
                                            @"deviceAbstraction" : [self.deviceAbstraction getJSONString],
                                            },
                             @"published" : [SeerUtility iso8601StringFromDate:[NSDate date]],
                         };

 [self.seerClient reportActivityStreamPayload:payload];
 
```

#### 2. Construct ActivityStream Object

The following is an example of constructing the same activity stream by using the **Seer-ios-sdk** `ActivitySteam` objects.

```
ActivityStream* activityStream = [ActivityStream new];

[activityStream setActorWithId:@"pearsonappuser@gmail.com"];
[activityStream setVerb:@"action"];
[activityStream setObjectWithId:@"objectId" objectType:@"objectType"];

ActivityStreamGenerator* generator = [ActivityStreamGenerator new];
[generator setAppId:@"Seer-ios-sample-app"];
[generator setStringValue:[self.deviceAbstraction getJSONString] forProperty:@"deviceAbstraction"];

[activityStream setGenerator:generator];

[activityStream setPublished:[SeerUtility iso8601StringFromDate:[NSDate date]]];

[self.seerClient reportActivityStream:activityStream];

```

The first method for constructing the data dictionary and reporting it is fairly straightforward but somewhat vulnerable to errors due to typos. The second method is a little more formalized and does not have the typo vulnerabilities of the first.

Please note that Seer requires the following values in an ActivityStream payload:

```
{
     actor: {
          id: String // required
     },
     verb: String, //required
     generator: {
          appId: String //required
     }
     object: {
          id: String, //required
          objectType: String //required
     }
     context:{      // optional, Seer specific
          String: String,
          String: String
  }
}
```

Also note that the above examples rely on the SeerClientDelegate callback. Each call can be substituted with a `SeerRequestComplete` block alternative method available in the `SeerClient`.

### Tincan Reporting

Just as with ActivitytStream/Instrumentation, `SeerClient` provides two methods for Tincan reporting.

#### 1. Data Dictionary

The following is an example of constructing the Tincan data directly as a `NSDictionary` before validating it & reporting it via the `SeerClient`.

```
NSDictionary *statement = @{
                                @"id" :[SeerUtility uniqueId],
                                @"actor": @{
                                     @"name": @"Sigmund Freud",
                                     @"mbox": @"sigmund.freud@pearson.com",
                                	 @"objectType" : @"Agent",
                                	 @"account": @{
                                		  @"homePage": @"https://sms.pearsoncmg.com",
                                		  @"name": @"9e805697-d4b3-4e32-8024-4774bd4e5bcb"
                                	  },
                                },
                                @"verb": @{
                                	 @"id": @"http://adlnet.gov/expapi/verbs/completed",
                                	 @"display": @{@"en-US": @"completed"}
								},
                                @"object": @{
                                	 @"objectType" : @"Activity",
                                	 @"id": @"http://example.com/tests/123456788",
                                	 @"definition": @{
                                	      @"type": @"http://adlnet.gov/expapi/activities/assessment",
                                	      @"name": @{ @"en-US": @"Psychology 101 - Dream Analysis" },
                                	      @"description": @{ @"en-US": @"Just a cigar" },
                                	 },
                                },
                                @"result": @{
                                     @"completion": YES,
                                     @"success": YES,
                                     @"score": @{
                                          @"scaled": @0.95
                                     }
                                },
                                @"context": @{
                                     @"instructor": @{
                                          @"objectType" : @"Agent",
                                          @"account": @{
                                               @"homePage": @"https://sms.pearsoncmg.com",
                                               @"name": @"2cf40031-84a4-4034-a858-82ece0aef315"
                                          }
                                     },
                                     @"extensions" : @{
                                          @"appId" : @"123456789"
                                     },
                                     @"contextActivities":@{
                                          @"parent": @[@{ "@id": "@http://example.com/courses#12345" }],
                                          @"category": @[@{ @"id": @"http://example.com/institutions#12345" }]
                                     }
                                },
                                @"timestamp": [SeerUtility iso8601StringFromDate:[NSDate date]],
                                @"authority": @{
                                     @"objectType" : @"Agent",
                                     @"account": @{
                                          @"homePage": @"https://sms.pearsoncmg.com",
                                          @"name": @"9e805697-d4b3-4e32-8024-4774bd4e5bcb"
                                     }
                                }
								
[self.seerClient reportTincanStatement:statement];

```

#### 2. Construct using Tincan Objects

The following is one example of constructing and reporting the same Tin Can statement by using the **Seer-ios-sdk** `Tincan` objects.

```
Tincan* tincan = [Tincan new];

TincanActor* actor = [TincanActor new];
TincanActorAccount* actorAcct = [TincanActorAccount new];
[actorAccount setHomepage: @"https://sms.pearsoncmg.com"];
[actorAccount setName: @"9e805697-d4b3-4e32-8024-4774bd4e5bcb"];
[actor setAccount:acctorAcct];
[actor setObjectType: @"Agent"];

TincanVerb* verb = [TincanVerb new];
[verb setId:@"http://adlnet.gov/expapi/verbs/completed"];
[verb setDisplay:@{@"en-US": @"completed"}];

TincanObject* object = [TincanObject new];
[object setId:  @"http://example.com/tests/123456788"];
[object setObjectType: @"http://example.com/tests/123456788"];
TincanObjectDefinition* objDef = [TincanObjectDefinition new];
[objDef setType:  @"http://adlnet.gov/expapi/activities/assessment"];
[objDef setNameWithDictionary: @{ @"en-US": @"Calculus 101 Test" }];
[objDef setDescriptionWithDicitonary: @{ @"en-US": @"Calculus 101" }];
[object setObjectDefinition: objDef];

TincanResult* result = [TincanResult new];
[result setCompletion: YES];
[result setSuccess: YES];
TincanResultScore* score = [TincanResultScore new];
[score setScaled: @0.95];
[result setScore:score];

TincanContext* context = [TincanContext new];
TincanActor* instructor = [TincanActor new];
TincanActorAccount* instrAcct = [TincanActorAccount new];
[instrAcct setHomepage: @"https://sms.pearsoncmg.com"];
[instrAcct setName: @"2cf40031-84a4-4034-a858-82ece0aef315"];
[instructor setAccount: instrAcct];
[instructor setObjectType: @"Agent"];
TincanCanContextActivities* activities = [TincanContextActivities new];
[activities setParentWithId: "@http://example.com/courses#12345"];
[activities setCategoryWithId: @"http://example.com/institutions#12345"];
[context setExtensionsWithAppId: @"123456789"];
[context setInstructor: instructor];
[context setContextActivities: activities];

TincanActor* authority = [TincanActor new];
TincanActorAccount* authAcct = [TincanActorAccount new];
[authAccount setHomepage: @"https://sms.pearsoncmg.com"];
[authAccount setName: @"9e805697-d4b3-4e32-8024-4774bd4e5bcb"];
[authority setAccount:authAcct];
[authority setObjectType: @"Agent"];

[tincan setId: [SeerUtility uniqueId]];
[tincan setActor: actor];
[tincan setVerb: verb];
[tincan setObejct: object];
[tincan setResult: result];
[tincan setContext: context];
[tincan setAuthority: authority];
[tincan setTimestamp: [SeerUtility iso8601StringFromDate:[NSDate date]]];

SeerReportComplete seerReportComplete = ^(SeerClientResponse seerClientResponse) 
{
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate updateRequestStatus:status
                    forRequestWithId:@(seerClientResponse.requestId)
                         requestType:seerClientResponse.requestType
                               queue:seerClientResponse.queued];
} 

[self.seerClient reportTincan:tincan
                   onComplete:seerReportComplete];

```

Please note that Seer requires the following values in a Tincan statement:

```
{
     actor:{
          mbox : String **
     },
     verb:{
          id : String
     },
     object:{
          id : String,
          definition:{
               type : String
          }
     },
     context : {
          extensions : {
               appId : String
          }
     }
}
```

**As per Tincan specifications (https://github.com/adlnet/xAPI-Spec/blob/master/xAPI.md), Actor requires an inverse functional identifier. This could be either one of the following:

*    mbox (NSString)
*    mbox_sha1sum (NSString)
*    openid (NSString)
*    account (TincanActorAccount)

Also note that the above examples employs a `SeerRequestComplete` block rather than relying on a delegate callback as in the Activity Stream example.

### Validating Data

The `ActivityStreamValidator` and `TincanValidator` included with the **Seer-ios-sdk** only validate the data for the Seer required fields. Formal validation of the data in regard to current specifications is not required for Seer but is suggested. For Tincan validation, try the xAPI Validator (http://zackpierce.github.io/xAPI-Validator-JS/).

##Queuing
The **Seer-ios-client** provides methods to call in the event you would prefer to queue data and report it at a later time rather than send it directly as it is gathered (Queuing non-essential data for upload at a later time is a very good practice to follow). 

The rules and methods previously outlined for reporting data directly to Seer also apply to queuing data. The method names are nearly identical. For example, you've previously seen this reporting method used:

```
[self.seerClient reportActivityStream:activityStreamObject];
```

The queuing method equivalent would be:

```
[self.seerClient queueActivityStream:activityStreamObject];
```

The default size of the queued payloads sent to Seer is 102400 bytes (100KB). You have the option to change that but you cannot go above the maximum size set by the Seer server of 1048576 bytes (1 MB) and it has to be at least 1024 bytes (1 KB). 

The following example would set the bundle size limit sent to Seer at 1024 bytes. The bundle size limit is given in bytes and the call will check if it is within 1048576 bytes and 1024 bytes. 

```
[self.seerClient validateAndSetBundleSize:1024];

```
NOTE: Currently the seer library doesn't support changing the batch (bundle) size. The `validateAndSetBundleSize` method is annotated as depricated.  

####Unable to Insert an Item into Queue
The seer SDK also enforces maximum size of database where the queued items are stored. Currently that max size is 10 Mb. In the event that the insertion of a new item into the queue would cause the database to go over its maximum limit the seer SDK may delete the oldest item(s) from the queue - just enough to make sufficient room for the new item to be stored. This decision to delete oldest item(s) is dtermined by a public BOOL property in SeerClient class - `removeOldItemsWhenFullDB`. The default value is YES, but the client app can change it. If set to YES the seer SDK removes oldest queued item(s) if database is full (or disk is full). Otherwise (if `removeOldItemsWhenFullDB` is set to NO) the seer SDK reports and error - `SeerQueueFullDBError` (int value of 9) - if queue database is full or `SeerQueueFullDiskError` (int value of 10) - if the disk on the device is full. In the case of full db/disk and `removeOldItemsWhenFullDB` set to NO, the only way to enable insertion of the new item into the queue is to either report the queue to Seer, set `removeOldItemsWhenFullDB` to YES or remove un-needed items from the disk.

###Batching
When **seer-ios-client** starts seding queued items to Seer it will do it in batches. The size of each batch is determined by aforementioned default size of queued paylaod (100KB) which can be changed. The **seer-ios-client** will try to send enough batches so that all items from queue will be send to Seer.

####Max queue size
In the rare event when the queue keeps growing and the device is continually off-line we don't want it to grow without bounds. To this end **seer-ios-client** enforces queue max size which is 10MB. If this max were to ever be reached the sdk will remove the oldest item(s) in the queue to make room for any incoming item.

##Getting Help
Frequently asked questions and support from the Mobile Platform community can be found on the [Pearson Developers Network community support pages] (http://pdn.pearson.com/community). Browse the forums for assistance or submit a new question.
