//
//  ActivityStreamValidator.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/16/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "ActivityStreamValidator.h"

@implementation ActivityStreamValidator

- (id) init
{
    self = [super init];
    
    if(self)
    {
        self.validActor     = [ValidationResult new];
        self.validVerb      = [ValidationResult new];
        self.validGenerator = [ValidationResult new];
        self.validObject    = [ValidationResult new];
        self.validContext   = [ValidationResult new];
        
        self.validActor.valid       = NO;
        self.validVerb.valid        = NO;
        self.validGenerator.valid   = NO;
        self.validObject.valid      = NO;
        self.validContext.valid     = YES;
    }
    
    return self;
}

- (ValidationResult*) validActivityStream:(NSDictionary*) asDict
{
    ValidationResult* validationResult = [ValidationResult new];
    
    if(asDict)
    {
        for (NSString* key in asDict)
        {
            if ([key isEqualToString:@"actor"])
            {
                self.validActor = [self validateProperty:@"id"
                                                inObject:[asDict objectForKey:key]
                                                 fromKey:key];
            }
            if ([key isEqualToString:@"verb"])
            {
                self.validVerb.valid = [[asDict objectForKey:key] isKindOfClass:[NSString class]];
                
                if(!self.validVerb.valid)
                {
                    self.validVerb.detail = @"Verb property is required and must be a string.";
                }
                else
                {
                    if( [[asDict objectForKey:key] isEqualToString:@""])
                    {
                        self.validVerb.valid = NO;
                        self.validVerb.detail = @"Verb property is required and must be a string that is not empty.";
                    }
                }
            }
            if ([key isEqualToString:@"generator"])
            {
                self.validGenerator = [self validateProperty:@"appId"
                                               inObject:[asDict objectForKey:key]
                                                fromKey:key];
            }
            if ([key isEqualToString:@"object"])
            {
                ValidationResult* validId = [self validateProperty:@"id"
                                                          inObject:[asDict objectForKey:key]
                                                           fromKey:key];
                
                ValidationResult* validObjectType = [self validateProperty:@"objectType"
                                                                  inObject:[asDict objectForKey:key]
                                                                   fromKey:key];
                
                NSString* objectError = @"";
                if (validId.valid && validObjectType.valid)
                {
                    self.validObject.valid = YES;
                }
                else
                {
                    self.validObject.valid = NO;
                    if(! validId.valid)
                    {
                        objectError = [NSString stringWithFormat:@"%@%@ ", objectError, validId.detail];
                    }
                    if(! validObjectType.valid)
                    {
                        objectError = [NSString stringWithFormat:@"%@%@ ", objectError, validObjectType.detail];
                    }
                }
                self.validObject.detail = objectError;
            }
            if ([key isEqualToString:@"context"])
            {
                self.validContext.valid = [[asDict objectForKey:key] isKindOfClass:[NSDictionary class]];
                if(!self.validContext.valid)
                {
                    self.validContext.detail = @"Context property if supplied must be a NSDictionary.";
                }
            }
        }
    }
    
    if (self.validActor.valid && self.validVerb.valid && self.validGenerator.valid && self.validObject.valid && self.validContext.valid)
    {
        validationResult.valid = YES;
        validationResult.title = @"";
        validationResult.detail = @"";
    }
    else
    {
        validationResult.valid = NO;
        validationResult.title = @"ActivityStream data invalid";
        validationResult.detail = [self buildValidationErrorDetail];
    }
    
    return validationResult;
}

- (NSString*) buildValidationErrorDetail
{
    NSString* errorDetail = @"";
    
    if(! self.validActor.valid)
    {
        errorDetail = [NSString stringWithFormat:@"Actor Error: %@ ", self.validActor.detail];
    }
    if(! self.validVerb.valid)
    {
        errorDetail = [NSString stringWithFormat:@"%@Verb Error: %@ ", errorDetail, self.validVerb.detail];
    }
    if(! self.validObject.valid)
    {
        errorDetail = [NSString stringWithFormat:@"%@Object Error: %@ ", errorDetail, self.validObject.detail];
    }
    if(! self.validGenerator.valid)
    {
        errorDetail = [NSString stringWithFormat:@"%@Generator Error: %@ ", errorDetail, self.validGenerator.detail];
    }
    if(! self.validContext.valid)
    {
        errorDetail = [NSString stringWithFormat:@"%@Context Error: %@ ", errorDetail, self.validContext.detail];
    }
    
    return errorDetail;
}

- (ValidationResult*) validateProperty:(NSString*)prop
                              inObject:(id)obj
                               fromKey:(NSString*)key
{
    ValidationResult* valResult = [ValidationResult new];
    
    BOOL valid = NO;
    
    NSString* validPropError = @"";
    
    if ( [obj isKindOfClass:[NSDictionary class]] )
    {
        if ( [obj objectForKey:prop] )
        {
            if ( [[obj objectForKey:prop] isKindOfClass:[NSString class]] )
            {
                if ( ! [[obj objectForKey:prop] isEqualToString:@""] )
                {
                    valid = YES;
                }
                else
                {
                    validPropError = [NSString stringWithFormat:@"%@ property's %@ property must be a string that is not empty.", key, prop];
                }
            }
            else
            {
                validPropError = [NSString stringWithFormat:@"%@ property's %@ property must be a string.", key, prop];
                
            }
        }
        else
        {
            validPropError = [NSString stringWithFormat:@"%@ property must contain a(n) %@ key-value pair.", key, prop];
        }
    }
    else
    {
        validPropError = [NSString stringWithFormat:@"%@ property must be a NSDictionary.", key];
    }
    
    valResult.valid = valid;
    valResult.detail = validPropError;
    
    return valResult;
}

@end
