//
//  PGMFileRequest.h
//  PGMCoreNetworking
//
//  Created by Tomack, Barry on 8/11/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>

@interface PGMCoreFileRequest : NSObject

@property (nonatomic, strong) NSString * fileType;
@property (nonatomic, strong) NSString * fileName;
@property (nonatomic, strong) NSURL *fileURL;

/*!
 Using CGFloat to get 32 and 64 bit compatibility.
 */
@property (nonatomic, assign) CGFloat progress;

- (instancetype)initWithDictionary:(NSDictionary *)fileDict;

@end
