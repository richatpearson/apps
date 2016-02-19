//
//  PGMCoreSessionUploadTaskOperation.h
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 8/5/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PGMCoreSessionDataTaskOperation.h"

@interface PGMCoreSessionUploadTaskOperation : PGMCoreSessionDataTaskOperation

/// --------------------
/// @name Initialization
/// --------------------

/*! 
 Initialize upload operation
 
  @param session The `NSURLSession` used for the upload task.
  @param request The `NSURLRequest`.
  @param data    The `NSData` for the body of the request.
 
  @note Do not set the body of the request in the `NSMutableURLRequest` object via `setHTTPBody`,
        but rather use the `data` parameter of this method.
 */
- (instancetype) initWithSession:(NSURLSession *)session
                         request:(NSURLRequest *)request
                            data:(NSData *)data;

/*! 
 Initialize upload operation
 
  @param session  The `NSURLSession` used for the upload task.
  @param request  The `NSURLRequest`.
  @param fromFile The file `NSURL` for the file containing the body of the request. This must be
                  fully qualified URL, not a relative URL.
 
  @note Do not set the body of the request in the `NSMutableURLRequest` object via `setHTTPBody`,
        but rather use the `data` parameter of this method.
 */
- (instancetype) initWithSession:(NSURLSession *)session
                         request:(NSURLRequest *)request
                        fromFile:(NSURL *)fromFile;


@end
