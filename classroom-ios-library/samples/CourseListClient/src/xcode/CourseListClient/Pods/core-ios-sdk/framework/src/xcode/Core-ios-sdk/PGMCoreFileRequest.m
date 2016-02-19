//
//  PGMFileRequest.m
//  PGMCoreNetworking
//
//  Created by Tomack, Barry on 8/11/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMCoreFileRequest.h"

@implementation PGMCoreFileRequest

- (instancetype)initWithDictionary:(NSDictionary *)fileDict
{
    self = [super init];
    if (self) {
        _fileType = [fileDict objectForKey:@"fileType"];
        _fileName = [fileDict objectForKey:@"fileName"];
        _fileURL = [NSURL URLWithString:[fileDict objectForKey:@"fileURL"]];
        _progress = -1;
    }
    return self;
}

- (NSString *) description
{
    NSMutableString* desc = [NSMutableString string];
    
    [desc appendFormat:@"   \nPGMFileRequest:\n"];
    [desc appendFormat:@"   fileType: %@\n", self.fileType];
    [desc appendFormat:@"   fileName: %@\n", self.fileName];
    [desc appendFormat:@"   fileURL: %@\n", self.fileURL];
    
    return desc;
}

@end
