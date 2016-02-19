//
//  TincanValidator.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/16/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "TincanValidator.h"

@implementation TincanValidator

- (id) init
{
    self = [super init];
    
    if(self)
    {
        self.validActor     = [ValidationResult new];
        self.validVerb      = [ValidationResult new];
        self.validObject    = [ValidationResult new];
        self.validContext   = [ValidationResult new];
        
        self.validActor.valid     = NO;
        self.validVerb.valid      = NO;
        self.validObject.valid    = NO;
        self.validContext.valid   = NO;
    }
    
    return self;
}

- (ValidationResult*) validTincan:(NSDictionary *)tcDict
{
    ValidationResult* validationResult = [ValidationResult new];
    
    for (NSString* key in tcDict)
    {
        if ([key isEqualToString:@"actor"])
        {
            self.validActor = [ self testForValidActor:[tcDict objectForKey:key]];
        }
        if ([key isEqualToString:@"verb"])
        {
            self.validVerb = [ self testForValidVerb:[tcDict objectForKey:key]];
        }
        if ([key isEqualToString:@"object"])
        {
            self.validObject = [self testForValidObject:[tcDict objectForKey:key]];
        }
        if ([key isEqualToString:@"context"])
        {
            self.validContext = [self testForValidContext:[tcDict objectForKey:key]];
        }
    }
    
    if (self.validActor.valid && self.validVerb.valid && self.validObject.valid && self.validContext.valid)
    {
        validationResult.valid = YES;
        validationResult.title = @"";
        validationResult.detail = @"";
    }
    else
    {
        validationResult.valid = NO;
        validationResult.title = @"Tincan data invalid";
        validationResult.detail = [self buildValidationErrorDetail];
    }
    
    return validationResult;
}

- (NSString*) buildValidationErrorDetail
{
    NSString* errorDetail = @"";
    
    if(! self.validActor.valid)
    {
        errorDetail = [NSString stringWithFormat:@"%@Actor Error: %@ ", errorDetail, self.validActor.detail];
    }
    if(! self.validVerb.valid)
    {
        errorDetail = [NSString stringWithFormat:@"%@Verb Error: %@ ", errorDetail, self.validVerb.detail];
    }
    if(! self.validObject.valid)
    {
        errorDetail = [NSString stringWithFormat:@"%@Object Error: %@ ", errorDetail, self.validObject.detail];
    }
    if(! self.validContext.valid)
    {
        errorDetail = [NSString stringWithFormat:@"%@Context Error: %@ ", errorDetail, self.validContext.detail];
    }
    
    return errorDetail;
}

- (ValidationResult*) testForValidActor:(id)actor
{
    ValidationResult* validActor = [ValidationResult new];
    
    ValidationResult* validMbox = [self validateProperty:@"mbox"
                                                 asClass:[NSString class]
                                                inObject:actor
                                                 fromKey:@"actor"];
    
    ValidationResult* validMboxSha1Sum = [self validateProperty:@"mbox_sha1sum"
                                                        asClass:[NSString class]
                                                       inObject:actor
                                                        fromKey:@"actor"];
    
    ValidationResult* validOpenId = [self validateProperty:@"openid"
                                                   asClass:[NSString class]
                                                  inObject:actor
                                                   fromKey:@"actor"];
    
    ValidationResult* validAccount = [self validateProperty:@"account"
                                                    asClass:[NSDictionary class]
                                                   inObject:actor
                                                    fromKey:@"actor"];
    
    NSString* errorDetail = @"";
    if (validMbox.valid || validMboxSha1Sum.valid || validOpenId.valid || validAccount.valid)
    {
        validActor.valid = YES;
    }
    else
    {
        validActor.valid = NO;
        errorDetail = @"requires an inverse functional identifier such as mbox, mbox_sha1sum, openid, or account";
    }
    validActor.detail = errorDetail;
    
    return validActor;
}

- (ValidationResult*) testForValidVerb:(id)verb
{
    ValidationResult* validVerb = [self validateProperty:@"id"
                                                 asClass:[NSString class]
                                                inObject:verb
                                                 fromKey:@"verb"];
    
    return validVerb;
}

- (ValidationResult*) testForValidObject:(id)object
{
    ValidationResult* validObject = [ValidationResult new];
    
    ValidationResult* validId = [self validateProperty:@"id"
                                               asClass:[NSString class]
                                              inObject:object
                                               fromKey:@"object"];
    
    ValidationResult* validDefinition = [self validateProperty:@"definition"
                                                       asClass:[NSDictionary class]
                                                      inObject:object
                                                       fromKey:@"object"];
    
    ValidationResult* validDefinitionType = [ValidationResult new];
    validDefinitionType.valid = NO;
    if( (NSDictionary*)object )
    {
        NSDictionary* objectDict = (NSDictionary*)object;
        for (NSString* objKey in objectDict)
        {
            if ([objKey isEqualToString:@"definition"])
            {
                validDefinitionType = [self validateProperty:@"type"
                                                     asClass:[NSString class]
                                                    inObject:[objectDict objectForKey:objKey]
                                                     fromKey:objKey];
            }
        }
    }
    NSString* errorDetail = @"";
    if (validId.valid && validDefinition.valid && validDefinitionType.valid)
    {
        validObject.valid = YES;
        
    }
    else
    {
        validObject.valid = NO;
        
        if(! validId.valid)
        {
            errorDetail = [NSString stringWithFormat:@"%@%@", errorDetail, validId.detail];
        }
        if(! validDefinition.valid)
        {
            errorDetail = [NSString stringWithFormat:@"%@%@", errorDetail, validDefinition.detail];
        }
        if(! validDefinitionType.valid)
        {
            errorDetail = [NSString stringWithFormat:@"%@%@", errorDetail, validDefinitionType.detail];
        }
    }
    validObject.detail = errorDetail;
    return validObject;
}

- (ValidationResult*) testForValidContext:(id)context
{
    ValidationResult* validContext = [ValidationResult new];
    
    ValidationResult* validExtension = [self validateProperty:@"extensions"
                                                      asClass:[NSDictionary class]
                                                     inObject:context
                                                      fromKey:@"context"];
    
    ValidationResult* validExtensionAppId = [ValidationResult new];
    validExtensionAppId.valid = NO;
    if( (NSDictionary*)context )
    {
        NSDictionary* contextDict = (NSDictionary*)context;
        for (NSString* contextKey in contextDict)
        {
            if ([contextKey isEqualToString:@"extensions"])
            {
                validExtensionAppId = [self validateProperty:@"appId"
                                                     asClass:[NSString class]
                                                    inObject:[contextDict objectForKey:contextKey]
                                                     fromKey:contextKey];
            }
        }
    }
    
    validContext.detail = [NSString stringWithFormat:@"%@:%@",  validExtension.detail,
                                                                validExtensionAppId.detail];
    NSString* errorDetail = @"";
    if (validExtension.valid && validExtensionAppId.valid)
    {
        validContext.valid = YES;
    }
    else
    {
        validContext.valid = NO;
        
        if(! validExtension.valid)
        {
            errorDetail = [NSString stringWithFormat:@"%@%@", errorDetail, validExtension.detail];
        }
        if(! validExtensionAppId.valid)
        {
            errorDetail = [NSString stringWithFormat:@"%@%@", errorDetail, validExtensionAppId.detail];
        }
    }
    validContext.detail = errorDetail;
    
    return validContext;
}

- (ValidationResult*) validateProperty:(NSString*)prop
                               asClass:(Class)classs
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
            if ( [[obj objectForKey:prop] isKindOfClass:classs] )
            {
                if([[obj objectForKey:prop] isKindOfClass:[NSString class]])
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
                if([[obj objectForKey:prop] isKindOfClass:[NSDictionary class]])
                {
                    if ( [[obj objectForKey:prop] count] > 0 )
                    {
                        valid = YES;
                    }
                    else
                    {
                        validPropError = [NSString stringWithFormat:@"%@ property's %@ property must be a string that is not empty.", key, prop];
                    }
                }
            }
            else
            {
                validPropError = [NSString stringWithFormat:@"%@ property's %@ property must be a %@.", key, prop, NSStringFromClass(classs)];
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
