//
//  PGMCoreSessionDownloadTaskOperation.h
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 8/5/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PGMCoreSessionTaskOperation.h"

@class PGMCoreSessionDownloadTaskOperation;

typedef void(^DidFinishDownloadingHandler)(PGMCoreSessionDownloadTaskOperation *operation,
                                           NSURL *location,
                                           NSError *error);

typedef void(^DidWriteDataHandler)(PGMCoreSessionDownloadTaskOperation *operation,
                                   int64_t bytesWritten,
                                   int64_t totalBytesWritten,
                                   int64_t totalBytesExpectedToWrite);

typedef void(^DidResumeHandler)(PGMCoreSessionDownloadTaskOperation *operation,
                                int64_t offset,
                                int64_t expectedTotalBytes);

@interface PGMCoreSessionDownloadTaskOperation : PGMCoreSessionTaskOperation <NSURLSessionDownloadDelegate>

/// ----------------
/// @name Properties
/// ----------------

/*! 
 Block called when the download finishes.
 
 Uses the following typedef:
 
 typedef void(^DidFinishDownloadingHandler)(NetworkDownloadTaskOperation *operation,
 NSURL *location,
 NSError *error);
 */
@property (nonatomic, copy) DidFinishDownloadingHandler didFinishDownloadingHandler;

/*! 
 Block called when download is resumed.
 
 Uses the following typedef:
 
 typedef void(^DidResumeHandler)(NetworkDownloadTaskOperation *operation,
 int64_t offset,
 int64_t expectedTotalBytes);
 */
@property (nonatomic, copy) DidResumeHandler            didResumeHandler;

/*! 
 Block called as data is downloaded and written to the file.
 
 Uses the following typedef:
 
 typedef void(^DidWriteDataHandler)(NetworkDownloadTaskOperation *operation,
 int64_t bytesWritten,
 int64_t totalBytesWritten,
 int64_t totalBytesExpectedToWrite);
 */
@property (nonatomic, copy) DidWriteDataHandler         didWriteDataHandler;


/// -----------------------
/// @name Cancel and resume
/// -----------------------

/*! 
 Cancel operation, producing `resumeData` if we can.
 
  @param completionHandler The block that is called, providing any `NSData` object with the resume data.
 */
- (void)cancelByProducingResumeData:(void (^)(NSData *resumeData))completionHandler;

/*! 
 Create NetworkdDownloadTaskOperation from resume data.
 
  @param session    The `NSURLSession` for which the download task operation should be crewated.
  @param resumeData The `resumeData` provided by `<cancelByProducingResumeData:>`.
 
  @return           Returns `NetworkDownloadTaskOperation` object.
 */
- (instancetype)initWithSession:(NSURLSession *)session
                     resumeData:(NSData *)resumeData;

@end
