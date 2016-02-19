//
//  SeerClient.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/16/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeerClientDelegate.h"
#import "SeerQueueDelegate.h"
#import "ActivityStreamValidator.h"
#import "TincanValidator.h"
#import "Tincan.h"
#import "ActivityStream.h"
#import "SeerUtility.h"
#import "ValidationResult.h"

/*!
 Units specified for setting byte limitations
 */
enum {
    kSEER_bytes = 0,
    kSEER_KB    = 1,
    kSEER_MB    = 2,
    kSEER_GB    = 3
};

typedef NSUInteger SeerByteUnits;

typedef void (^SeerRequestComplete)(SeerClientResponse*);

/*!
 SeerClient is the top-level class in the Seer-ios-client framework used to
 interface with the Seer systems. The following are request types (events) 
 that can be made through the SeerClient:<br>
 `kSEER_TokenFetch`<br>
 `kSEER_TincanReport`<br>
 `kSEER_ActivityStreamReport`<br>
 `kSEER_InstrumentationReport`<br>
 `kSEER_RequestStartSession`<br>
 `kSEER_RequestReportQueue`<br>
 `kSEER_RequestResultForQueuedBatch`<br>
 `kSEER_BundleSizeLimit`<br>
 */
@interface SeerClient : NSObject <SeerQueueDelegate>

extern NSString* const kSEER_TokenFetch;
extern NSString* const kSEER_TincanReport;
extern NSString* const kSEER_ActivityStreamReport;
extern NSString* const kSEER_InstrumentationReport;

extern NSString* const kSEER_RequestStartSession;
extern NSString* const kSEER_RequestReportQueue;
extern NSString* const kSEER_RequestResultForQueuedBatch;
extern NSString* const kSEER_BundleSizeLimit;

/*!
 Set a <SeerClientDelegate> object to receive call backs on delegate methods when
 requests are made.
 */
@property (nonatomic, strong) id <SeerClientDelegate> delegate;

/*!
 Set the number of days to retain items in the queue before they are purged.
 Not yet implemeted in current release.
 */
@property (nonatomic, strong) NSNumber* daysToRetainItemsInQueue;

/*!
 Set to YES if you want to automatically upload queued data when the app first 
 starts and at anytime that the app goes to the background.
 */
@property (nonatomic, assign) BOOL autoReportQueue;

/*!
 Set to YES when you require a response for each request you make to send a 
 queued item to the Seer server.
 */
@property (nonatomic, assign) BOOL receiveQueuedItemResponses;

/*!
 Set to YES when you want to remove oldest items from queue to make room for the item you 
 want to insert if DB/disk is full. When set to NO the framework will return and error if
 DB/disk is full.
 Default value = YES; set when SeerClient is initialized
 */
@property (nonatomic, assign) BOOL removeOldItemsWhenFullDB;

/*!
 Initializes an instance of the SeerClient class.
 
 @param clientId     supplied by the Seer team after the application is registered
 @param clientSecret supplied by the Seer team after the application is registered
 @param apiKey       supplied by the Seer team after the application is registered
 
 @return intialized instance of the SeerClient
 */
- (id) initWithClientId:(NSString*) clientId
           clientSecret:(NSString*) clientSecret
                 apiKey:(NSString*) apiKey;

/*!
 Allows you to enter custom endpoints to reach the Seer server
 
 @param endpoint specified path within the base url (e.g., "/sactivity", "/tincan")
 @param name     A key value for the path )e.g., "kSEER_ActivityStreamReport")
 */
- (void) addEndpoint:(NSString*)endpoint forName:(NSString*)name;

/*!
 Get a NSDictionary containing all of the endpoints currently stored in the 
 Seer-ios-client framework.
 
 @return Stored endpoints in a key-value format
 */
- (NSDictionary*) getEndpoints;

/*!
 Change the base URL from the default setting.
 
 @param newBaseURL The new url to point to the Seer Server
 */
- (void) changeSeerBaseURL:(NSString*)newBaseURL;

/*!
 Retrievce the base URL that being used for the Seer Server connection
 
 @return The base URL as a string.
 */
- (NSString*) getSeerBaseURL;

/*!
 Begin the Seer Session after all intialization is complete
 */
- (void) startSeerSession;

/*!
 Begin the Seer Seesion after all intialization is complete and then call the 
 onComplete block
 
 @param onComplete <#onComplete description#>
 */
- (void) startSeerSessionAndOnComplete:(SeerRequestComplete)onComplete;

/*!
 Validate that an Activity Stream object conforms to Seer requirements.
 
 @param activityStream The ActivityStream object to validate
 
 @return The success or failure of the validation test.
 */
- (ValidationResult*) validActivityStream:(ActivityStream*)activityStream;

/*!
 Validate that a NSDictionary containing the Activity Stream data to be reported 
 conforms to Seer requirements.
 
 @param activityStreamPayload The Activity Stream data stored in an NSDicitonary
 object.
 
 @return The success or failure of the validation test.
 */
- (ValidationResult*) validActivityStreamPayload:(NSDictionary*)activityStreamPayload;

/*!
 Validate that an Activity Stream Instrumantation object conforms to Seer 
 requirements.
 
 @param instrumentation The Activity Stream Instrumentation object to validate.
 
 @return The success or failure of the validation test.
 */
- (ValidationResult*) validInstrumentation:(ActivityStream*)instrumentation;

/*!
 Validate that a NSDictionary containing the Activity Stream Instrumentation data
 to be reported conforms to Seer requirements.
 
 @param instrumentationPayload The Activity Stream Instrumentation data stored 
 in an NSDicitonary
 object.

 @return The success or failure of the validation test.
 */
- (ValidationResult*) validInstrumentationPayload:(NSDictionary*)instrumentationPayload;

/*!
 Validate that a Tin Can object conforms to Seer requirements.
 
 @param tincan The Tin Can object to be validated.
 
 @return The success or failure of the validation test.
 */
- (ValidationResult*) validTincan:(Tincan*)tincan;

/*!
 Validate that a NSDictionary containing the Tin Can data to be reported conforms 
 to Seer requirements.
 
 @param tincanStatement The Tin Can data stored in an NSDicitonary.
 
 @return The success or failure of the validation test.
 */
- (ValidationResult*) validTincanStatement:(NSDictionary*)tincanStatement;

#pragma mark Methods when using delegate
/*!
 Directly report an Activity Stream object to Seer. Use this method when using 
 the delegate method to get your responses.
 
 @param activityStream The Activity Stream object to report
 
 @return The success or failure of the data upload.
 */
- (SeerClientResponse*) reportActivityStream:(ActivityStream*)activityStream;

/*!
 Directly report an Activity Stream payload (NSDictionary) to Seer. Use this method when using
 the delegate method to get your responses.
 
 @param activityStreamPayload The Activity Stream data dictionary to report
 
 @return The success or failure of the data upload.
 */
- (SeerClientResponse*) reportActivityStreamPayload:(NSDictionary*)activityStreamPayload;

/*!
 Directly report an Activity Stream Instrumentation object to Seer. Use this method when using
 the delegate method to get your responses.
 
 @param instrumentation The Activity Stream Instrumentation object to report
 
 @return The success or failure of the data upload.
 */
- (SeerClientResponse*) reportInstrumentation:(ActivityStream*)instrumentation;

/*!
 Directly report an Activity Stream Instrumentation payload (NSDictionary) to Seer.
 Use this method when using the delegate method to get your responses.
 
 @param instrumentationPayload The Activity Stream Instrumentation data dictionary to report
 
 @return The success or failure of the data upload.
 */
- (SeerClientResponse*) reportInstrumentationPayload:(NSDictionary*)instrumentationPayload;

/*!
 Directly report a Tin Can object to Seer. Use this method when using the delegate 
 method to get your responses.
 
 @param tincan The Tin Can object to report
 
 @return The success or failure of the data upload.
 */
- (SeerClientResponse*) reportTincan:(Tincan*)tincan;

/*!
 Directly report a Tin Can Statement (NSDictionary) to Seer. Use this method when using
 the delegate method to get your responses.
 
 @param tincanStatement The Tin Can data dictionary to report
 
 @return The success or failure of the queuing.
 */
- (SeerClientResponse*) reportTincanStatement:(NSDictionary*)tincanStatement;

/*!
 Queue an Activity Stream object to be reported to Seer at a latter time. Use this method when using
 the delegate method to get your responses.
 
 @param activityStream The Activity Stream object to queue
 
 @return The success or failure of the queuing.
 */
- (SeerClientResponse*) queueActivityStream:(ActivityStream*)activityStream;

/*!
 Queue an Activity Stream payload (NSDictionary) to be reported to Seer at a later time. 
 Use this method when using the delegate method to get your responses.
 
 @param activityStreamPayload The Activity Stream data dictionary to queue
 
 @return The success or failure of the queuing.
 */
- (SeerClientResponse*) queueActivityStreamPayload:(NSDictionary*)activityStreamPayload;

/*!
 Queue an Activity Stream Instrumentation object to be reported to Seer at a later time. 
 Use this method when using the delegate method to get your responses.
 
 @param instrumentation The Activity Stream Instrumentation object to queue
 
 @return The success or failure of the queuing.
 */
- (SeerClientResponse*) queueInstrumentation:(ActivityStream*)instrumentation;

/*!
 Queue an Activity Stream Instrumentation payload (NSDictionary) to be reported 
 to Seer at a later time. Use this method when using the delegate method to get 
 your responses.
 
 @param instrumentationPayload The Activity Stream Instrumentation data dictionary to queue
 
 @return The success or failure of the queuing.
 */
- (SeerClientResponse*) queueInstrumentationPayload:(NSDictionary*)instrumentationPayload;

/*!
 Queue a Tin Can object to Seer. Use this method when using the delegate method to get your responses.
 
 @param tincan The Tin Can object to queue
 
 @return The success or failure of the queuing.
 */
- (SeerClientResponse*) queueTincan:(Tincan*)tincan;

/*!
 Queue a Tin Can Statement (NSDictionary) to be reported to Seer at a later time. 
 Use this method when using the delegate method to get your responses.
 
 @param tincanStatement The Tin Can data dictionary to queue
 
 @return The success or failure of the queuing.
 */
- (SeerClientResponse*) queueTincanStatement:(NSDictionary*)tincanStatement;

#pragma mark Methods when using blocks
/*!
 Directly report an Activity Stream object to Seer. Use this method when using
 an onComplete block to handle the response.
 
 @param activityStream The Activity Stream object to report
 @param onComplete     The onComplete method called after the upload is attempted.
 
 @return The success or failure of the data upload attempt.
 */
- (SeerClientResponse*) reportActivityStream:(ActivityStream*)activityStream
                                  onComplete:(SeerRequestComplete)onComplete;
/*!
 Directly report an Activity Stream payload (NSDictionary) to Seer. Use this method when using
 an onComplete block to handle the response.
 
 @param activityStreamPayload The Activity Stream data dictionary to report
 @param onComplete     The onComplete method called after the upload is attempted.
 
 @return The success or failure of the data upload attempt.
 */
- (SeerClientResponse*) reportActivityStreamPayload:(NSDictionary*)activityStreamPayload
                                         onComplete:(SeerRequestComplete)onComplete;

/*!
 Directly report an Activity Stream Instrumentation object to Seer. Use this method when using
 an onComplete block to handle the response.
 
 @param instrumentation The Activity Stream Instrumentation object to report
 @param onComplete     The onComplete method called after the upload is attempted.

 @return The success or failure of the data upload.
 */
- (SeerClientResponse*) reportInstrumentation:(ActivityStream*)instrumentation
                                   onComplete:(SeerRequestComplete)onComplete;

/*!
 Directly report an Activity Stream Instrumentation payload (NSDictionary) to Seer.
 Use this method when using an onComplete block to handle the response.
 
 @param instrumentationPayload The Activity Stream Instrumentation data dictionary to report
 @param onComplete     The onComplete method called after the upload is attempted.
 
 @return The success or failure of the data upload.
 */
- (SeerClientResponse*) reportInstrumentationPayload:(NSDictionary*)instrumentationPayload
                                          onComplete:(SeerRequestComplete)onComplete;

/*!
 Directly report a Tin Can object to Seer. Use this method when using
 an onComplete block to handle the response.
 
 @param tincan The Tin Can object to report
 @param onComplete     The onComplete method called after the upload is attempted.
 
 @return The success or failure of the data upload.
 */
- (SeerClientResponse*) reportTincan:(Tincan*)tincan
                          onComplete:(SeerRequestComplete)onComplete;

/*!
 Directly report a Tin Can Statement (NSDictionary) to Seer. Use this method when using
 an onComplete block to handle the response.
 
 @param tincanStatement The Tin Can data dictionary to report
 @param onComplete     The onComplete method called after the upload is attempted.
 
 @return The success or failure of the queuing.
 */
- (SeerClientResponse*) reportTincanStatement:(NSDictionary*)tincanStatement
                                   onComplete:(SeerRequestComplete)onComplete;

/*!
 Queue an Activity Stream object to be reported to Seer at a latter time. Use this method when using
 an onComplete block to handle the response.
 
 @param activityStream The Activity Stream object to queue
 @param onComplete     The onComplete method called after the upload is attempted.
 
 @return The success or failure of the queuing.
 */
- (SeerClientResponse*) queueActivityStream:(ActivityStream*)activityStream
                                 onComplete:(SeerRequestComplete)onComplete;

/*!
 Queue an Activity Stream payload (NSDictionary) to be reported to Seer at a later time.
 Use this method when using an onComplete block to handle the response.
 
 @param activityStreamPayload The Activity Stream data dictionary to queue
 @param onComplete     The onComplete method called after the upload is attempted.
 
 @return The success or failure of the queuing.
 */
- (SeerClientResponse*) queueActivityStreamPayload:(NSDictionary*)activityStreamPayload
                                        onComplete:(SeerRequestComplete)onComplete;

/*!
 Queue an Activity Stream Instrumentation object to be reported to Seer at a later time.
 Use this method when using an onComplete block to handle the response.
 
 @param instrumentation The Activity Stream Instrumentation object to queue
 @param onComplete     The onComplete method called after the upload is attempted.
 
 @return The success or failure of the queuing.
 */
- (SeerClientResponse*) queueInstrumentation:(ActivityStream*)instrumentation
                                  onComplete:(SeerRequestComplete)onComplete;

/*!
 Queue an Activity Stream Instrumentation payload (NSDictionary) to be reported
 to Seer at a later time. Use this method when using an onComplete block to handle 
 the response.
 
 @param instrumentationPayload The Activity Stream Instrumentation data dictionary to queue
 @param onComplete     The onComplete method called after the upload is attempted.
 
 @return The success or failure of the queuing.
 */
- (SeerClientResponse*) queueInstrumentationPayload:(NSDictionary*)instrumentationPayload
                                         onComplete:(SeerRequestComplete)onComplete;

/*!
 Queue a Tin Can object to Seer. Use this method when using an onComplete block to handle
 the response.
 
 @param tincan The Tin Can object to queue
 @param onComplete     The onComplete method called after the upload is attempted.
 
 @return The success or failure of the queuing.
 */
- (SeerClientResponse*) queueTincan:(Tincan*)tincan
                         onComplete:(SeerRequestComplete)onComplete;

/*!
 Queue a Tin Can Statement (NSDictionary) to be reported to Seer at a later time.
 Use this method when using an onComplete block to handle the response.
 
 @param tincanStatement The Tin Can data dictionary to queue
 @param onComplete     The onComplete method called after the upload is attempted.
 
 @return The success or failure of the queuing.
 */
- (SeerClientResponse*) queueTincanStatement:(NSDictionary*)tincanStatement
                                  onComplete:(SeerRequestComplete)onComplete;

/*!
 Call to directly report items in the Queue to Seer
 */
- (void)reportQueue;

/*!
 Get the current space that the Seer Queue is taking up on disc.
 
 @return Size in bytes
 */
- (NSNumber*)getQueueSize;

/*!
 Get the number of items currently queued up
 
 @return The number of rows in the Queue table
 */
- (NSNumber*)getQueueItemCount;

/*!
 Get the max size of the batched bundles of data to be sent to the Seer Server.
 
 @return The current max bundle size in bytes
 */
- (NSInteger) bundleSizeLimit;

/*!
 The upper limit of the max size that you can set for the batched bundles.
 
 @return The current max bundle size that can be set in bytes
 */
- (NSInteger) maxBundleSizeLimit;

/*!
 Get the default size of the batched bundles of data sent to the Seer server.
 
 @return The default bundle size in bytes
 */
- (NSInteger) defaultBundleSizeLimit;

/*!
 The minimum value that can be set for a max bundle size
 
 @return The value in bytes
 */
- (NSInteger) maxBundleSizeLowerBoundLimit;

/*!
 Change the default batched bundle size. This method is temporary.
 
 @param bundleSize <#bundleSize description#>
 
 @return <#return value description#>
 */
- (ValidationResult*) validateAndSetBundleSize:(NSInteger)bundleSize __attribute__ ((deprecated));

@end
