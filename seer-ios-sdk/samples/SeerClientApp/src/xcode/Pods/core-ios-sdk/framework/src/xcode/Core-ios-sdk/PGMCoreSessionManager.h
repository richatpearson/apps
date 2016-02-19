//
//  PGMCoreSessionManager.h
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 8/1/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//
//  The Networking code in the GRID Mobile Core is based upon the defacto public
//  networking library AFNetworking 2.0 https://github.com/AFNetworking/AFNetworking.
//  combined with the work of Robert Ryan and his NetworkManager

#import <Foundation/Foundation.h>

#import "PGMCoreSessionAuthorizationDelegate.h"
#import "PGMCoreReachability.h"

#import "PGMCoreSessionDataTaskOperation.h"
#import "PGMCoreSessionDownloadTaskOperation.h"
#import "PGMCoreSessionUploadTaskOperation.h"

@class PGMCoreSessionManager;

typedef BOOL(^URLSessionDidFinishEventsHandler)(PGMCoreSessionManager *manager);

typedef void(^DidReceiveChallenge)(PGMCoreSessionManager *manager,
                                   NSURLAuthenticationChallenge *challenge,
                                   void (^completionHandler)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential));

typedef void(^DidBecomeInvalidWithError)(PGMCoreSessionManager *manager,
                                         NSError *error);

typedef void(^DidFinishDownloadingToURL)(PGMCoreSessionManager *manager,
                                         NSURLSessionDownloadTask *downloadTask,
                                         NSURL *location);

typedef void(^DidCompleteWithError)(PGMCoreSessionManager *manager,
                                    NSURLSessionTask *task,
                                    NSError *error);

/*!
 The PGMCoreSessionManager creates NSURLSessions objects based on
 specified NSURKSessionConfiguration objects. It manages task operations based on
 `<NSURLSessionTaskDelegate>`, `<NSURLSessionDataDelegate>`, 
 `<NSURLSessionDownloadDelegate>`, and `<NSURLSessionDelegate>`.
 
 ##Usage
 
 1. Create property to hold `sessionManager`:
 
 @property (nonatomic, strong) PGMCoreSessionManager *sessionManager;
 
 2. Instantiate `sessionManager`:
 
 self.sessionManager = [[PGMCoreSessionManager alloc] init];
 
 3. Create task and add it to the manager's queue:
 
 NSOperation *operation = [self.sessionManager dataOperationWithRequest:request
                                                        progressHandler:nil
                                                      completionHandler:^(PGMCoreSessionTaskOperation *operation, NSData *data, NSError *error) {
                                                         if (error)
                                                         {
                                                              NSLog(@"Error,%@", [error localizedDescription]);
                                                         }
                                                         else
                                                         {
                                                              NSLog(@"RESPONSE: %@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
                                                         
                                                              NSError *error = nil;
                                                         self.dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:0
                                                                                                       error:&error];
                                                         }
                                                    }];
 [self.sessionManager addOperationToQueue:operation];
 */

@interface PGMCoreSessionManager : NSObject <NSSecureCoding, NSCopying>

/*!
 The managed session object.
 */
@property (nonatomic, readonly, strong) NSURLSession *session;

/*!
 The operation queue on which delegate callbacks are run.
 */
@property (readonly, nonatomic, strong) NSOperationQueue *operationQueue;

/*!
 The generated operations are stored here for reference and keyed on the task identifier.
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *operations;

/*!
 Set a value for the maxConcurrentOperationCount for the operationQueue.
 */
@property (nonatomic, assign) NSInteger maxConcurrentOperationCount;

/*!
 The authorization delegate.
 */
@property (nonatomic, readonly, strong) id <PGMCoreSessionAuthorizationDelegate> authorizationDelegate;

///---------------------------
/// @name Network Reachability
///---------------------------

/*!
 The used to monitor network reachability. `PGMCoreSessionManager` uses the `sharedManager` by default.
 */
@property (readwrite, nonatomic, strong) PGMCoreReachability *reachability;

///--------------------------
/// @name Completion Handlers
///--------------------------

/*! 
 The completion handler to be set an app delegate's `handleEventsForBackgroundURLSession`
 and to be called by `URLSessionDidFinishEventsHandler`.
 */
@property (nonatomic, copy) void (^completionHandler)(void);

/*!
 The block that will be called by `URLSessionDidFinishEventsForBackgroundURLSession:`.
 
 This uses the following typedef:
 
 typedef BOOL(^URLSessionDidFinishEventsHandler)(PGMCoreSessionManager *manager);
 
 @note If this block calls the completion handler, it should return `NO`, to inform the default `URLSessionDidFinishEvents` method
 that it does not need to call the `completionHandler`. It should also make sure to `nil` the `completionHandler` after it calls it.
 
 If this block does not call the completion handler itself, it should return `YES` to inform
 the default routine that it should call the `completionHandler` and perform the necessary clean-up.
 */
@property (nonatomic, copy) URLSessionDidFinishEventsHandler urlSessionDidFinishEventsHandler;

/*! 
 The block that will be called by `URLSession:didReceiveChallenge:completionHandler:`.
 
 This uses the following typedef:
 
 typedef void(^DidReceiveChallenge)(PGMCoreSessionManager *manager,
 NSURLAuthenticationChallenge *challenge,
 
 */
@property (nonatomic, copy) DidReceiveChallenge didReceiveChallenge;

/*! 
 The block that will be called by `URLSession:didBecomeInvalidWithError:`.
 
 This uses the following typedef:
 
 typedef void(^DidBecomeInvalidWithError)(PGMCoreSessionManager *manager,
 NSError *error);
 
 */
@property (nonatomic, copy) DidBecomeInvalidWithError didBecomeInvalidWithError;

/*! 
 The block that will be called by `URLSession:downloadTask:didFinishDownloadingToURL:`.
 Generally we keep the task methods at the task operation class level, but for background
 downloads, we may lose the operations when the app is killed.
 
 This uses the following typedef:
 
 typedef void(^DidFinishDownloadingToURL)(PGMCoreSessionManager *manager,
 NSURLSessionDownloadTask *downloadTask,
 NSURL *location);
 
 */
@property (nonatomic, copy) DidFinishDownloadingToURL didFinishDownloadingToURL;

/*!
 The block that will be called by `URLSession:task:didCompleteWithError:`.
 Generally we keep the task methods at the task operation class level, but for background
 downloads, we may lose the operations when the app is killed.
 
 This uses the following typedef:
 
 typedef void(^DidCompleteWithError)(PGMCoreSessionManager *manager,
 NSURLSessionTask *task,
 NSError *error);
 
 */
@property (nonatomic, copy) DidCompleteWithError didCompleteWithError;

///-------------------------------
/// @name Managing URL Credentials
///-------------------------------

/*!
 Whether request operations should consult the credential storage for authenticating the connection. `YES` by default.
 
 @see AFURLConnectionOperation -shouldUseCredentialStorage
 */
@property (nonatomic, assign) BOOL shouldUseCredentialStorage;

/*!
 The credential used by request operations for authentication challenges.
 */
@property (nonatomic, strong) NSURLCredential *credential;


///-------------------
/// @name Miscelaneous
///-------------------
/*!
 A handy property for getting the path for downloaded documents
 */
@property (nonatomic, strong) NSString *documentsPath;

///-------------------------------
/// @name Managing Callback Queues
///-------------------------------

/*!
 The dispatch queue to use for completion blocks. The default is the main queue.
 */
@property (nonatomic, strong) dispatch_queue_t completionQueue;

///---------------------
/// @name Initialization
///---------------------

/*!
 Creates and returns a manager for a session created with the default NSURLSessionConfiguration.
 
 @return A manager for the newly created session.
 */
- (instancetype)init;

/*!
 Creates and returns a manager for a session created with the provided NSURLSessionConfiguration.
 
 @param configuration The configuration used to create the managed session.
 
 @return A manager for the newly created session.
 */
- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration*)configuration;

/*!
 <#Description#>
 
 @param configuration <#configuration description#>
 @param authDelegate  <#authDelegate description#>
 
 @return <#return value description#>
 */
- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration*)configuration
                  usingAuthorizationDelegate:(id<PGMCoreSessionAuthorizationDelegate>)authDelegate;

/*!
 **Not unit testable**
 
 @param identifier Bundle identifier
 
 @return a PGMCoreSessionManger instance with a background session configured
 */
+ (instancetype) backgroundSessionManagerWithIdentifier:(NSString *)identifier;

/// ------------------------------------------
/// @name SessionTaskOperation factory methods
/// ------------------------------------------

/*! 
 Create data task operation.
 
  @param request The `NSURLRequest`.
  @param progressHandler The method that will be called with as the data is being downloaded.
  @param didCompleteWithErrorHandler The block that will be called when the upload is done.
 
  @return Returns `NetworkDataTaskOperation`.
 
  @note If you supply `progressHandler`, it is assumed that you will take responsibility for
        handling the individual data chunks as they come in. If you don't provide this block, this
        class will aggregate all of the individual `NSData` objects into one final one for you.
 
  @note The progress/completion blocks will, by default, be called on the main queue. If you want
        to use a different GCD queue, specify a non-nil `<completionQueue>` value.
 */
- (PGMCoreSessionDataTaskOperation *) dataOperationWithRequest:(NSURLRequest *)request
                                               progressHandler:(ProgressHandler)progressHandler
                                             completionHandler:(DidCompleteWithErrorHandler)didCompleteWithErrorHandler;

/*!
 Create data task operation.
 
  @param url The NSURL.
  @param progressHandler The method that will be called with as the data is being downloaded.
  @param didCompleteWithErrorHandler The block that will be called when the upload is done.
 
  @return Returns `NetworkDataTaskOperation`.
 
  @note If you supply `progressHandler`, it is assumed that you will take responsibility for
        handling the individual data chunks as they come in. If you don't provide this block, this
        class will aggregate all of the individual `NSData` objects into one final one for you.
 
  @note The progress/completion blocks will, by default, be called on the main queue. If you want
        to use a different GCD queue, specify a non-nil `<completionQueue>` value.
 */
- (PGMCoreSessionDataTaskOperation *)dataOperationWithURL:(NSURL *)url
                                          progressHandler:(ProgressHandler)progressHandler
                                        completionHandler:(DidCompleteWithErrorHandler)didCompleteWithErrorHandler;

/*! 
 Create download task operation.
 
  @param request The `NSURLRequest`.
  @param didWriteDataHandler The method that will be called with as the data is being downloaded.
  @param didFinishDownloadingHandler The block that will be called when the upload is done.
 
  @return Returns `NetworkDownloadTaskOperation`.
 
  @note The progress/completion blocks will, by default, be called on the main queue. If you want
        to use a different GCD queue, specify a non-nil `<completionQueue>` value.
 */

- (PGMCoreSessionDownloadTaskOperation *)downloadOperationWithRequest:(NSURLRequest *)request
                                                  didWriteDataHandler:(DidWriteDataHandler)didWriteDataHandler
                                          didFinishDownloadingHandler:(DidFinishDownloadingHandler)didFinishDownloadingHandler;

/*! 
 Create download task operation.
 
  @param url The NSURL.
  @param didWriteDataHandler The method that will be called with as the data is being downloaded.
  @param didFinishDownloadingHandler The block that will be called when the upload is done.
 
  @return Returns `NetworkDownloadTaskOperation`.
 
  @note The progress/completion blocks will, by default, be called on the main queue. If you want
        to use a different GCD queue, specify a non-nil `<completionQueue>` value.
 */

- (PGMCoreSessionDownloadTaskOperation *)downloadOperationWithURL:(NSURL *)url
                                              didWriteDataHandler:(DidWriteDataHandler)didWriteDataHandler
                                      didFinishDownloadingHandler:(DidFinishDownloadingHandler)didFinishDownloadingHandler;

/*! 
 Create download task operation.
 
  @param resumeData The `NSData` from `<NetworkDownloadTaskOperation>` method `cancelByProducingResumeData:`.
  @param didWriteDataHandler The method that will be called with as the data is being downloaded.
  @param didFinishDownloadingHandler The block that will be called when the upload is done.
 
  @return Returns `NetworkDownloadTaskOperation`.
 
  @note The progress/completion blocks will, by default, be called on the main queue. If you want
        to use a different GCD queue, specify a non-nil `<completionQueue>` value.
 */

- (PGMCoreSessionDownloadTaskOperation *)downloadOperationWithResumeData:(NSData *)resumeData
                                                     didWriteDataHandler:(DidWriteDataHandler)didWriteDataHandler
                                             didFinishDownloadingHandler:(DidFinishDownloadingHandler)didFinishDownloadingHandler;

/*! 
 Create upload task operation.
 
  @param request The `NSURLRequest`.
  @param data    The body of the request
  @param didSendBodyDataHandler The method that will be called with periodic updates while data is being uploaded
  @param didCompleteWithErrorHandler The block that will be called when the upload is done.
 
  @return Returns `NetworkUploadTaskOperation`.
 
  @note The progress/completion blocks will, by default, be called on the main queue. If you want
        to use a different GCD queue, specify a non-nil `<completionQueue>` value.
 */

- (PGMCoreSessionUploadTaskOperation *)uploadOperationWithRequest:(NSURLRequest *)request
                                                             data:(NSData *)data
                                           didSendBodyDataHandler:(DidSendBodyDataHandler)didSendBodyDataHandler
                                      didCompleteWithErrorHandler:(DidCompleteWithErrorHandler)didCompleteWithErrorHandler;

/*! 
 Create upload task operation.
 
  @param url  The NSURL.
  @param data The body of the request
  @param didSendBodyDataHandler The method that will be called with periodic updates while data is being uploaded
  @param didCompleteWithErrorHandler The block that will be called when the upload is done.
 
  @return Returns `NetworkUploadTaskOperation`.
 
  @note The progress/completion blocks will, by default, be called on the main queue. If you want
        to use a different GCD queue, specify a non-nil `<completionQueue>` value.
 */

- (PGMCoreSessionUploadTaskOperation *)uploadOperationWithURL:(NSURL *)url
                                                         data:(NSData *)data
                                       didSendBodyDataHandler:(DidSendBodyDataHandler)didSendBodyDataHandler
                                  didCompleteWithErrorHandler:(DidCompleteWithErrorHandler)didCompleteWithErrorHandler;

/*! 
 Create upload task operation.
 
  @param request The `NSURLRequest`.
  @param fileURL    The URL of the file to be uploaded
  @param didSendBodyDataHandler The method that will be called with periodic updates while data is being uploaded
  @param didCompleteWithErrorHandler The block that will be called when the upload is done.
 
  @return Returns `NetworkUploadTaskOperation`.
 
  @note The progress/completion blocks will, by default, be called on the main queue. If you want
        to use a different GCD queue, specify a non-nil `<completionQueue>` value.
 */

- (PGMCoreSessionUploadTaskOperation *)uploadOperationWithRequest:(NSURLRequest *)request
                                                          fileURL:(NSURL *)fileURL
                                           didSendBodyDataHandler:(DidSendBodyDataHandler)didSendBodyDataHandler
                                      didCompleteWithErrorHandler:(DidCompleteWithErrorHandler)didCompleteWithErrorHandler;

/*! 
 Create upload task operation.
 
  @param url   The NSURL.
  @param fileURL  The URL of the file to be uploaded
  @param didSendBodyDataHandler The method that will be called with periodic updates while data is being uploaded
  @param didCompleteWithErrorHandler The block that will be called when the upload is done.
 
  @return Returns `NetworkUploadTaskOperation`.
 
  @note The progress/completion blocks will, by default, be called on the main queue. If you want
        to use a different GCD queue, specify a non-nil `<completionQueue>` value.
 */

- (PGMCoreSessionUploadTaskOperation *)uploadOperationWithURL:(NSURL *)url
                                                      fileURL:(NSURL *)fileURL
                                       didSendBodyDataHandler:(DidSendBodyDataHandler)didSendBodyDataHandler
                                  didCompleteWithErrorHandler:(DidCompleteWithErrorHandler)didCompleteWithErrorHandler;

/// -----------------------------------------------
/// @name NSOperationQueue utility methods
/// -----------------------------------------------

/*! 
 Add operation.
 
  A convenience method to add operation to the session manager's `operationQueue` operation queue.
 
  @param operation The operation to be added to the queue.
 */

- (void) addOperationToQueue:(NSOperation *)operation;

@end
