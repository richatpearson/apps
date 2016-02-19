//
//  SeerByteValidator.m
//  Seer-ios-client
//
//  Created by Tomack, Barry on 3/21/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "SeerByteValidator.h"

@interface SeerByteValidator()

@property (nonatomic, assign) NSInteger bundleSize;

@end

@implementation SeerByteValidator

NSInteger const kSEER_DefaultBundleSize        = 102400;   // 100 KB
NSInteger const kSEER_MaxBundleSize            = 1048576;  // 1 MB
NSInteger const kSEER_MaxBundleSizeLowerBound  = 1024;     // 1 KB

- (id) init
{
    self = [super init];
    
    if(self)
    {
        self.bundleSize = kSEER_DefaultBundleSize;
    }
    
    return self;
}

- (ValidationResult*) limitBundleSize:(NSInteger)bundleSize
{
    ValidationResult* validationResult = [ValidationResult new];
    
    if (bundleSize > kSEER_MaxBundleSize || bundleSize < kSEER_MaxBundleSizeLowerBound)
    {
        validationResult.valid = NO;
        validationResult.title = @"Bundle Size Error";
        validationResult.detail = [NSString stringWithFormat:@"Attempted to set max bundle size greater than maximum value of %ld or less than min value of %ld bytes",
                                   (long)kSEER_MaxBundleSize, (long)kSEER_MaxBundleSizeLowerBound];
    }
    else
    {
        validationResult.valid = YES;
        validationResult.title = @"Bundle Size Set Successfully!";
        validationResult.detail = @"";
        
        self.bundleSize = bundleSize;
    }
    
    return validationResult;
}

- (NSInteger) bundleSizeLimit
{
    return self.bundleSize;
}

- (NSInteger) defaultBundleSize
{
    return kSEER_DefaultBundleSize;
}

- (NSInteger) maxBundleSize
{
    return kSEER_MaxBundleSize;
}

- (NSInteger) maxBundelSizeLowerBound
{
    return kSEER_MaxBundleSizeLowerBound;
}

- (ValidationResult*) validDataSize:(NSDictionary*)dataDict
{
    NSError *err;
    
    NSData * data = [NSPropertyListSerialization dataWithPropertyList:dataDict
                                                               format:NSPropertyListBinaryFormat_v1_0
                                                                options:0
                                                                error:&err];
    return [self validSize:data];
}

- (ValidationResult*) validDataStringSize:(NSString*)dataString
{
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [self validSize:data];
}

- (ValidationResult*) validSize:(NSData*)data
{
    ValidationResult* validationResult = [ValidationResult new];
    
    
    
    NSUInteger bytes = 0;
    if (data) {
        bytes = [data length];
    }
    
    if (!data)
    {
        validationResult.valid = NO;
        validationResult.title = @"Invalid Data Size";
        validationResult.detail = @"No data set for this application.";
    }
    else if (bytes > self.bundleSize)
    {
        validationResult.valid = NO;
        validationResult.title = @"Invalid Data Size";
        validationResult.detail = @"The data exceeds the maximum bundle size limit set for this application.";
    }
    
    return validationResult;
}

@end
