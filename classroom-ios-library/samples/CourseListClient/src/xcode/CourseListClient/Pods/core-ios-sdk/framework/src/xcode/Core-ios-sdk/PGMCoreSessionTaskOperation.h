//
//  PGMCoreSessionTaskOperation.h
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 8/5/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PGMCoreSessionTaskOperation;

typedef void(^DidCompleteWithErrorHandler)(PGMCoreSessionTaskOperation *operation,
                                           NSData *data,
                                           NSError *error);

typedef void(^DidReceiveChallengeHandler)(PGMCoreSessionTaskOperation *operation,
                                          NSURLAuthenticationChallenge *challenge,
                                          void(^completionHandler)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential)
                                          );

typedef void(^DidSendBodyDataHandler)(PGMCoreSessionTaskOperation *operation,
                                      int64_t bytesSent,
                                      int64_t totalBytesSent,
                                      int64_t totalBytesExpectedToSend);

typedef void(^NeedNewBodyStreamHandler)(PGMCoreSessionTaskOperation *operation,
                                        void(^completionHandler)(NSInputStream *bodyStream));

typedef void(^WillPerformHTTPRedirectionHandler)(PGMCoreSessionTaskOperation *operation,
                                                 NSHTTPURLResponse *response,
                                                 NSURLRequest *request,
                                                 void(^completionHandler)(NSURLRequest *));

/*!
 This is an abstract class is not intended to be used by itself. 
 Instead, use one of its subclasses, `<PGMCoreSessionDataTaskOperation>`, 
 `<PGMCoreSessionDownloadTaskOperation>`, or `<PGMCoreSessionUploadTaskOperation>`.
 */
@interface PGMCoreSessionTaskOperation : NSOperation <NSURLSessionTaskDelegate>

/// ----------------
/// @name Properties
/// ----------------

/*!
 The `NSURLSessionTask` associated with this operation
 */

@property (nonatomic, weak)   NSURLSessionTask *task;

/*!
 The `NSURLCredential` to be used if authentication challenge received.
 */

@property (nonatomic, strong) NSURLCredential *credential;

/*! 
 Did complete with error handler block
 
 Uses the following typdef:
 
 typedef void(^DidCompleteWithErrorHandler)(NetworkTaskOperation *operation,
 NSData *data,
 NSError *error);
 */

@property (nonatomic, copy)   DidCompleteWithErrorHandler       didCompleteWithErrorHandler;

/*! 
 Did receive challenge handler block
 
 Uses the following typdef:
 
 typedef void(^DidReceiveChallengeHandler)(NetworkTaskOperation *operation,
 NSURLAuthenticationChallenge *challenge,
 void(^completionHandler)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential)
 );
 */

@property (nonatomic, copy)   DidReceiveChallengeHandler        didReceiveChallengeHandler;

/*! 
 Did send body data handler block
 
 Uses the following typdef:
 
 typedef void(^DidSendBodyDataHandler)(NetworkTaskOperation *operation,
 int64_t bytesSent,
 int64_t totalBytesSent,
 int64_t totalBytesExpectedToSend);
 */
@property (nonatomic, copy)   DidSendBodyDataHandler            didSendBodyDataHandler;

/*! 
 Need new body stream handler block
 
 Uses the following typdef:
 
 typedef void(^NeedNewBodyStreamHandler)(NetworkTaskOperation *operation,
 void(^completionHandler)(NSInputStream *bodyStream));
 */
@property (nonatomic, copy)   NeedNewBodyStreamHandler          needNewBodyStreamHandler;

/*! 
 Will perform HTTP redirection handler block
 
 Uses the following typdef:
 
 typedef void(^WillPerformHTTPRedirectionHandler)(NetworkTaskOperation *operation,
 NSHTTPURLResponse *response,
 NSURLRequest *request,
 void(^completionHandler)(NSURLRequest *));
 */
@property (nonatomic, copy)   WillPerformHTTPRedirectionHandler willPerformHTTPRedirectionHandler;

/*! 
 The GCD queue to which completion/progress blocks will be dispatched. If `nil`, it will use `dispatch_get_main_queue()`.
 
  Often, its useful to have the completion blocks run on the main queue (as you're generally updating the UI).
  But if you're doing something on a background thread that doesn't rely on UI updates (or if performing tests
  in the absence of a UI), you might want to use a background queue.
 */

@property (nonatomic, strong) dispatch_queue_t completionQueue;


/// --------------------
/// @name Initialization
/// --------------------

/*! 
 Create PGMCoreSessionTaskOperation
 
  @param session The `NSURLSession` for which the task operation should be created.
  @param request The `NSURLRequest` for the task operation.
 
  @return        Returns PGMCoreSessionTaskOperation.
 */

- (instancetype)initWithSession:(NSURLSession *)session
                        request:(NSURLRequest *)request;

/// ----------------------
/// @name Regarding status
/// ----------------------

/*!
 Return whether this operation respond to an authentication challenge.
 
 @return `YES` if it can respond to challenge. `NO` if the session manager will try.
 */
- (BOOL)canRespondToChallenge;


/// ----------------------
/// @name Manage operation
/// ----------------------

/*!
 Called when operation is done for setting the executing and finshed booleans
 */
- (void)completeOperation;


@end
