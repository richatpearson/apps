//
//  PGMPiResponse.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 5/23/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiResponse.h"

static NSInteger nextResponseID = 1;
NSRecursiveLock *responseIDLock = nil;

@interface PGMPiResponse()

@property (nonatomic, assign) NSUInteger responseId;
@property (nonatomic, strong) NSMutableDictionary *responseDict;

@end

@implementation PGMPiResponse

- (id) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if ( !responseIDLock )
    {
        responseIDLock = [NSRecursiveLock new];
    }
    self.responseDict = [NSMutableDictionary new];
    self.responseId = [self getNextResponseId];
    
    return self;
}

- (NSNumber*) piRequestType
{
    return [NSNumber numberWithInteger: self.requestType];
}

- (NSNumber*) piResponseId
{
    return [NSNumber numberWithInteger: self.responseId];
}

-(NSInteger) getNextResponseId
{
    // make sure we can use this lock
    assert(responseIDLock);
    
    [responseIDLock lock];
    NSInteger ret = nextResponseID++;
    [responseIDLock unlock];
    
    return ret;
}

- (id) getObjectForOperationType:(PGMPiOperationType)opType
{
    return [self.responseDict objectForKey:[NSNumber numberWithInteger:opType]];
}

- (void) setObject:(id)response forOperationType:(PGMPiOperationType)opType
{
    [self.responseDict setObject:response forKey:[NSNumber numberWithInteger:opType]];
}

- (NSUInteger)count
{
    return [self.responseDict count];
}

- (NSString*) description
{
    NSMutableString *desc = [NSMutableString new];
    
    [desc appendFormat:@"Pi Response"];
    [desc appendFormat:@": requestType: %ld", self.requestType];
    [desc appendFormat:@": requestStatus: %ld", self.requestStatus];
    [desc appendFormat:@": userId: %@", self.userId];
    [desc appendFormat:@": accessToken: %@", self.accessToken];
    [desc appendFormat:@": error: %@", self.error];
    [desc appendFormat:@": timestamp: %@", self.timestamp];
    [desc appendFormat:@": responses: %@", self.responseDict];
    
    return desc;
}

@end
