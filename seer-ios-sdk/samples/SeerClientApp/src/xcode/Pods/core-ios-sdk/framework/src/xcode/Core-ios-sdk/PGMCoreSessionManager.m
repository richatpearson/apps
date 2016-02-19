//
//  PGMCoreSessionManager
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 8/1/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMCoreSessionManager.h"

static NSMutableDictionary *backgroundSessionsDict;

@interface PGMCoreSessionManager () <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;

@property (nonatomic, readwrite, strong) NSMutableDictionary *operations;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, assign) NSInteger defaultConcurrentOperations;

@property (nonatomic, getter = isBackgroundSession) BOOL backgroundSession;

@property (nonatomic, readwrite, strong) id <PGMCoreSessionAuthorizationDelegate> authorizationDelegate;

@end

@implementation PGMCoreSessionManager : NSObject

- (instancetype) init
{
    return [self initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] usingAuthorizationDelegate:nil];
}

- (instancetype) initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    return [self initWithSessionConfiguration:configuration usingAuthorizationDelegate:nil];
}

- (instancetype) initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration
                   usingAuthorizationDelegate:(id<PGMCoreSessionAuthorizationDelegate>)authDelegate
{    
    self = [super init];
    if (!self)
    {
        return self;
    }
    
    // Someone may try to abuse the library.
    if (!configuration)
    {
        configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    
    self.sessionConfiguration = configuration;
    self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:nil];

    self.operations = [NSMutableDictionary new];
    self.defaultConcurrentOperations = 3;
    
    self.authorizationDelegate = authDelegate;
    
    self.reachability = [PGMCoreReachability sharedReachability];
    
    self.documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    return self;
}

+ (instancetype) backgroundSessionManagerWithIdentifier:(NSString *)identifier
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        backgroundSessionsDict = [[NSMutableDictionary alloc] init];
    });
    
    PGMCoreSessionManager *manager = backgroundSessionsDict[identifier];
    if (!manager) {
        NSURLSessionConfiguration *sessionConfiguration;

        sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfiguration:identifier];
        
        manager = [[self alloc] initWithSessionConfiguration:sessionConfiguration];
        manager.backgroundSession = YES;
        
        backgroundSessionsDict[identifier] = manager;
    }
    
    return manager;
}

//+ (NSURLSession *)backgroundSession {
//    static NSURLSession *session = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        // Session Configuration
//        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.pearson.gridmobile.ios.core.BackgroundSession"];
//        
//        // Initialize Session
//        session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
//    });
//    
//    return session;
//}

#pragma mark - Static methods;

//+ (dispatch_group_t) defaultCompletionGroup
//{
//    static dispatch_group_t group;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        group = dispatch_group_create();
//    });
//    return group;
//}
//
//+ (dispatch_queue_t) defaultCompletionQueue
//{
//    return dispatch_get_main_queue();
//}

#pragma mark - Custom getters

//- (dispatch_queue_t) completionQueue
//{
//    if (!_completionQueue)
//    {
//        _completionQueue = [PGMCoreSessionManager defaultCompletionQueue];
//    }
//    return _completionQueue;
//}

# pragma mark Operation Wrappers

- (PGMCoreSessionDataTaskOperation *) dataOperationWithURL:(NSURL *)url
                                           progressHandler:(ProgressHandler)progressHandler
                                         completionHandler:(DidCompleteWithErrorHandler)didCompleteWithErrorHandler;
{
    NSParameterAssert(url);
    
    return [self dataOperationWithRequest:[NSURLRequest requestWithURL:url]
                          progressHandler:progressHandler
                        completionHandler:didCompleteWithErrorHandler];
}

- (PGMCoreSessionDataTaskOperation *) dataOperationWithRequest:(NSURLRequest *)request
                                               progressHandler:(ProgressHandler)progressHandler
                                             completionHandler:(DidCompleteWithErrorHandler)didCompleteWithErrorHandler;
{
    NSParameterAssert(request);
    
    PGMCoreSessionDataTaskOperation *operation;
    
    operation = [[PGMCoreSessionDataTaskOperation alloc] initWithSession:self.session request:request];
    NSAssert(operation, @"%s: instantiation of PGMCoreSessionDataTaskOperation failed", __FUNCTION__);
    operation.progressHandler = progressHandler;
    operation.didCompleteWithErrorHandler = didCompleteWithErrorHandler;
    operation.completionQueue = self.completionQueue;
    
    [self.operations setObject:operation forKey:@(operation.task.taskIdentifier)];
    
    return operation;
}

- (PGMCoreSessionDownloadTaskOperation *) downloadOperationWithURL:(NSURL *)url
                                               didWriteDataHandler:(DidWriteDataHandler)didWriteDataHandler
                                       didFinishDownloadingHandler:(DidFinishDownloadingHandler)didFinishDownloadingHandler
{
    NSParameterAssert(url);
    
    PGMCoreSessionDownloadTaskOperation *operation;
    
    operation = [self downloadOperationWithRequest:[NSURLRequest requestWithURL:url]
                               didWriteDataHandler:didWriteDataHandler
                       didFinishDownloadingHandler:didFinishDownloadingHandler];
    
    operation.completionQueue = self.completionQueue;
    
    return operation;
}

- (PGMCoreSessionDownloadTaskOperation *) downloadOperationWithRequest:(NSURLRequest *)request
                                                   didWriteDataHandler:(DidWriteDataHandler)didWriteDataHandler
                                           didFinishDownloadingHandler:(DidFinishDownloadingHandler)didFinishDownloadingHandler
{
    NSParameterAssert(request);
    
    PGMCoreSessionDownloadTaskOperation *operation;
    
    operation = [[PGMCoreSessionDownloadTaskOperation alloc] initWithSession:self.session request:request];
    NSAssert(operation, @"%s: instantiation of PGMCoreDownloadTaskOperation failed", __FUNCTION__);
    operation.didFinishDownloadingHandler = didFinishDownloadingHandler;
    operation.didWriteDataHandler = didWriteDataHandler;
    operation.completionQueue = self.completionQueue;
    
    [self.operations setObject:operation forKey:@(operation.task.taskIdentifier)];
    
    return operation;
}

- (PGMCoreSessionDownloadTaskOperation *) downloadOperationWithResumeData:(NSData *)resumeData
                                                      didWriteDataHandler:(DidWriteDataHandler)didWriteDataHandler
                                              didFinishDownloadingHandler:(DidFinishDownloadingHandler)didFinishDownloadingHandler
{
    NSParameterAssert(resumeData);
    
    PGMCoreSessionDownloadTaskOperation *operation;
    
    operation = [[PGMCoreSessionDownloadTaskOperation alloc] initWithSession:self.session resumeData:resumeData];
    NSAssert(operation, @"%s: instantiation of PGMCoreDownloadTaskOperation failed", __FUNCTION__);
    operation.didFinishDownloadingHandler = didFinishDownloadingHandler;
    operation.didWriteDataHandler = didWriteDataHandler;
    operation.completionQueue = self.completionQueue;
    
    [self.operations setObject:operation forKey:@(operation.task.taskIdentifier)];
    
    return operation;
}

- (PGMCoreSessionUploadTaskOperation *)uploadOperationWithURL:(NSURL *)url
                                                         data:(NSData *)data
                                       didSendBodyDataHandler:(DidSendBodyDataHandler)didSendBodyDataHandler
                                  didCompleteWithErrorHandler:(DidCompleteWithErrorHandler)didCompleteWithErrorHandler
{
    NSParameterAssert(url);
    
    PGMCoreSessionUploadTaskOperation *operation;
    
    operation = [self uploadOperationWithRequest:[NSURLRequest requestWithURL:url]
                                            data:data
                          didSendBodyDataHandler:didSendBodyDataHandler
                     didCompleteWithErrorHandler:didCompleteWithErrorHandler];
    operation.completionQueue = self.completionQueue;
    
    return operation;
}

- (PGMCoreSessionUploadTaskOperation *)uploadOperationWithRequest:(NSURLRequest *)request
                                                             data:(NSData *)data
                                           didSendBodyDataHandler:(DidSendBodyDataHandler)didSendBodyDataHandler
                                      didCompleteWithErrorHandler:(DidCompleteWithErrorHandler)didCompleteWithErrorHandler
{
    NSParameterAssert(request);
    
    PGMCoreSessionUploadTaskOperation *operation;
    
    operation = [[PGMCoreSessionUploadTaskOperation alloc] initWithSession:self.session request:request data:data];
    NSAssert(operation, @"%s: instantiation of PGMCoreUploadTaskOperation failed", __FUNCTION__);
    operation.didCompleteWithErrorHandler = didCompleteWithErrorHandler;
    operation.didSendBodyDataHandler = didSendBodyDataHandler;
    operation.completionQueue = self.completionQueue;
    
    [self.operations setObject:operation forKey:@(operation.task.taskIdentifier)];
    
    return operation;
}

- (PGMCoreSessionUploadTaskOperation *)uploadOperationWithURL:(NSURL *)url
                                                      fileURL:(NSURL *)fileURL
                                       didSendBodyDataHandler:(DidSendBodyDataHandler)didSendBodyDataHandler
                                  didCompleteWithErrorHandler:(DidCompleteWithErrorHandler)didCompleteWithErrorHandler
{
    NSParameterAssert(url);
    
    return [self uploadOperationWithRequest:[NSURLRequest requestWithURL:url]
                                    fileURL:fileURL
                     didSendBodyDataHandler:didSendBodyDataHandler
                didCompleteWithErrorHandler:didCompleteWithErrorHandler];
}

- (PGMCoreSessionUploadTaskOperation *)uploadOperationWithRequest:(NSURLRequest *)request
                                                          fileURL:(NSURL *)url
                                           didSendBodyDataHandler:(DidSendBodyDataHandler)didSendBodyDataHandler
                                      didCompleteWithErrorHandler:(DidCompleteWithErrorHandler)didCompleteWithErrorHandler
{
    NSParameterAssert(request);
    
    PGMCoreSessionUploadTaskOperation *operation;
    
    operation = [[PGMCoreSessionUploadTaskOperation alloc] initWithSession:self.session request:request fromFile:url];
    NSAssert(operation, @"%s: instantiation of PGMCoreUploadTaskOperation failed", __FUNCTION__);
    operation.didCompleteWithErrorHandler = didCompleteWithErrorHandler;
    operation.didSendBodyDataHandler = didSendBodyDataHandler;
    operation.completionQueue = self.completionQueue;
    
    [self.operations setObject:operation forKey:@(operation.task.taskIdentifier)];
    
    return operation;
}

#pragma mark - NSOperationQueue

- (NSOperationQueue *)operationQueue
{
    @synchronized(self)
    {
        if (!_operationQueue)
        {
            _operationQueue = [[NSOperationQueue alloc] init];
            _operationQueue.name = [NSString stringWithFormat:@"%@.PGMCoreSessionManager.%p", [[NSBundle mainBundle] bundleIdentifier], self];
            if (![self isBackgroundSession])
            {
                _operationQueue.maxConcurrentOperationCount = self.maxConcurrentOperationCount;
            }
        }
        
        return _operationQueue;
    }
}

- (NSInteger) maxConcurrentOperationCount
{
    if (!_maxConcurrentOperationCount)
    {
        _maxConcurrentOperationCount = self.defaultConcurrentOperations;
    }
    return _maxConcurrentOperationCount;
}

- (void)addOperationToQueue:(NSOperation *)operation
{
    [self.operationQueue addOperation:operation];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    if (self.didBecomeInvalidWithError)
    {
        dispatch_sync(self.completionQueue ?: dispatch_get_main_queue(), ^{
            self.didBecomeInvalidWithError(self, error);
        });
    }
}

- (void) URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
  completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    if (self.didReceiveChallenge) {
        self.didReceiveChallenge(self, challenge, completionHandler);
    } else {
        if (self.credential && challenge.previousFailureCount == 0) {
            completionHandler(NSURLSessionAuthChallengeUseCredential, self.credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session;
{
    BOOL __block shouldCallCompletionHandler;
    
    // If urlSessionDidFinishEventsHandler available, call it to determine whether
    // the completionHandler should be called.
    //
    // If urlSessionDidFinishEventsHandler not supplied, we'll just assume that
    // the completionHandler should be called.
    
    if (self.urlSessionDidFinishEventsHandler)
    {
        dispatch_sync(self.completionQueue ?: dispatch_get_main_queue(), ^{
            shouldCallCompletionHandler = self.urlSessionDidFinishEventsHandler(self);
        });
    } else {
        shouldCallCompletionHandler = YES;
    }
    
    // Call the completion handler (if available)
    
    if (shouldCallCompletionHandler)
    {
        if (self.completionHandler)
        {
            self.completionHandler();
            self.completionHandler = nil;
        }
    }
}

#pragma mark - NSURLSessionTaskDelegate

- (void)removeTaskOperationForTask:(NSURLSessionTask *)task
{
    PGMCoreSessionTaskOperation *taskOperation = self.operations[@(task.taskIdentifier)];
    
    if (!taskOperation)
        return;
    
    [self.operations enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        if (obj == taskOperation)
        {
            [self.operations removeObjectForKey:key];
            *stop = YES;
        }
    }];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    PGMCoreSessionTaskOperation *operation = self.operations[@(task.taskIdentifier)];
    
    if ([operation respondsToSelector:@selector(URLSession:task:didCompleteWithError:)])
    {
        [operation URLSession:session task:task didCompleteWithError:error];
    }
    else
    {
        if (self.didCompleteWithError)
        {
            dispatch_sync(self.completionQueue ?: dispatch_get_main_queue(), ^{
                self.didCompleteWithError(self, task, error);
                self.didCompleteWithError = nil;
            });
        }
        
        [operation completeOperation];
    }
    
    [self removeTaskOperationForTask:task];
}

- (void) URLSession:(NSURLSession *)session
               task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
  completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    PGMCoreSessionTaskOperation *operation = self.operations[@(task.taskIdentifier)];
    
    // if the operation can handle challenge, then give it one shot, otherwise, we'll take over here
    
    if ([operation respondsToSelector:@selector(URLSession:task:didReceiveChallenge:completionHandler:)] && challenge.previousFailureCount == 0 && [operation canRespondToChallenge])
    {
        [operation URLSession:session task:task didReceiveChallenge:challenge completionHandler:completionHandler];
    }
    else
    {
        if (self.didReceiveChallenge)
        {
            dispatch_sync(self.completionQueue ?: dispatch_get_main_queue(), ^{
                self.didReceiveChallenge(self, challenge, completionHandler);
            });
        } else {
            if (self.credential && challenge.previousFailureCount == 0) {
                completionHandler(NSURLSessionAuthChallengeUseCredential, self.credential);
            } else {
                completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
            }
        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    PGMCoreSessionTaskOperation *operation = self.operations[@(task.taskIdentifier)];
    
    if ([operation respondsToSelector:@selector(URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)])
        [operation URLSession:session task:task didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler
{
    PGMCoreSessionTaskOperation *operation = self.operations[@(task.taskIdentifier)];
    
    if ([operation respondsToSelector:@selector(URLSession:task:needNewBodyStream:)])
        [operation URLSession:session task:task needNewBodyStream:completionHandler];
    else
        completionHandler(nil);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    PGMCoreSessionTaskOperation *operation = self.operations[@(task.taskIdentifier)];
    
    if ([operation respondsToSelector:@selector(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:)])
        [operation URLSession:session task:task willPerformHTTPRedirection:response newRequest:request completionHandler:completionHandler];
    else
        completionHandler(request);
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    PGMCoreSessionDataTaskOperation *operation = self.operations[@(dataTask.taskIdentifier)];
    
    if ([operation respondsToSelector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:)])
        [operation URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
    else
        completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    PGMCoreSessionDataTaskOperation *operation = self.operations[@(dataTask.taskIdentifier)];
    
    if ([operation respondsToSelector:@selector(URLSession:dataTask:didReceiveData:)])
        [operation URLSession:session dataTask:dataTask didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
    PGMCoreSessionDataTaskOperation *operation = self.operations[@(dataTask.taskIdentifier)];
    
    if ([operation respondsToSelector:@selector(URLSession:dataTask:willCacheResponse:completionHandler:)])
        [operation URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
    else
        completionHandler(proposedResponse);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    PGMCoreSessionDataTaskOperation *operation = self.operations[@(dataTask.taskIdentifier)];
    
    if ([operation respondsToSelector:@selector(URLSession:dataTask:didBecomeDownloadTask:)])
        [operation URLSession:session dataTask:dataTask didBecomeDownloadTask:downloadTask];
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    PGMCoreSessionDownloadTaskOperation *operation = self.operations[@(downloadTask.taskIdentifier)];
    
    if ([operation respondsToSelector:@selector(URLSession:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)])
        [operation URLSession:session downloadTask:downloadTask didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    PGMCoreSessionDownloadTaskOperation *operation = self.operations[@(downloadTask.taskIdentifier)];
    
    if ([operation respondsToSelector:@selector(URLSession:downloadTask:didResumeAtOffset:expectedTotalBytes:)])
        [operation URLSession:session downloadTask:downloadTask didResumeAtOffset:fileOffset expectedTotalBytes:expectedTotalBytes];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    PGMCoreSessionDownloadTaskOperation *operation = self.operations[@(downloadTask.taskIdentifier)];
    
    if ([operation respondsToSelector:@selector(URLSession:downloadTask:didFinishDownloadingToURL:)] && operation.didFinishDownloadingHandler)
    {
        [operation URLSession:session downloadTask:downloadTask didFinishDownloadingToURL:location];
    }
    else if (self.didFinishDownloadingToURL)
    {
        dispatch_sync(self.completionQueue ?: dispatch_get_main_queue(), ^{
            self.didFinishDownloadingToURL(self, downloadTask, location);
            self.didFinishDownloadingToURL = nil;
        });
    }
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    NSURLSessionConfiguration *configuration = [decoder decodeObjectOfClass:[NSURLSessionConfiguration class] forKey:@"sessionConfiguration"];
    
    id<PGMCoreSessionAuthorizationDelegate> delegate = [decoder decodeObjectForKey:@"authorizationDelegate"];
    
    self = [self initWithSessionConfiguration:configuration usingAuthorizationDelegate:delegate];
    
    if (!self)
    {
        return nil;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.session.configuration forKey:@"sessionConfiguration"];
    [coder encodeObject:self.authorizationDelegate forKey:@"authorizationDelegate"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithSessionConfiguration:self.session.configuration];
}

@end
