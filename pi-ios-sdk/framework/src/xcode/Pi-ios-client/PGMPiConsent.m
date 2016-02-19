//
//  PGMPiConsent.m
//  Pi-ios-client
//
//  Created by Richard Rosiak on 6/13/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiConsent.h"
#import "PGMPiConsentPolicy.h"

@interface PGMPiConsent()

@end

NSTimeInterval const PGMPiTimeout = 10.0;

@implementation PGMPiConsent

- (NSArray*) requestPoliciesWithEscrowTicket:(NSString*)ticket
                                 environment:(PGMPiEnvironment*)environment;
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    NSString *stringUrl = [environment escrowPathWithTicket:ticket];
    NSLog(@"Will request escrow GET for this url: %@", stringUrl);
    
    [request setURL:[NSURL URLWithString:stringUrl]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    // TODO: Possibly change to asynchronous call
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    //NSLog(@"Escrow raw data: %@", [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
    
    if([responseCode statusCode] != 200)
    {
        NSLog(@"Error getting %@, HTTP status code %ld", stringUrl, (long)[responseCode statusCode]);
        return nil;
    }
    
    return [self parseEscrowPolicyData:responseData];
}

- (NSArray*) parseEscrowPolicyData:(NSData*)data {
    
    NSMutableArray *consentPolicyArray = [[NSMutableArray alloc]init];
    
    NSError *jsonError = nil;
    NSDictionary* jsonDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
//    NSLog(@"JSON from escrow is: %@:::error: %@", jsonDict, jsonError);
    
    if (jsonError) {
        return nil;
    }
    
    NSDictionary *consentPolicies = [self parseConsentPoliciesFromDict:jsonDict];
    
    if (!consentPolicies) {
        return nil;
    }
    
    for (NSDictionary *item in consentPolicies) {
        NSString *policyId = [item objectForKey:@"id"];
        NSString *consentUrl = [item objectForKey:@"url"];
        [consentPolicyArray addObject:[self createConsentPolicyWithPolicyId:policyId consentUrl:consentUrl]];
    }
    
    return consentPolicyArray;
}

- (NSDictionary*) parseConsentPoliciesFromDict:(NSDictionary*)jsonDict
{
    NSString *escrowValue = [jsonDict objectForKey:@"value"];
//    NSLog(@"Json for key value is %@", escrowValue);
    
    NSError *jsonError = nil;
    NSDictionary *escrowValueDict =
    [NSJSONSerialization JSONObjectWithData: [escrowValue dataUsingEncoding:NSUTF8StringEncoding]
                                    options: kNilOptions
                                      error: &jsonError];
    if (jsonError)
    {
        return nil;
    }
    
    NSDictionary *consentPolicies = [escrowValueDict objectForKey:@"policyId"];
    
    return consentPolicies;
}

- (PGMPiConsentPolicy*) createConsentPolicyWithPolicyId:(NSString*)policyId
                                             consentUrl:(NSString*)url {
    PGMPiConsentPolicy *consent = [[PGMPiConsentPolicy alloc] initWithPolicyId:policyId
                                                                    consentUrl:url
                                                                   isConsented:NO
                                                                    isReviewed:NO];
    
    return consent;
}

- (void) postConsentForPolicyIds:(NSArray*)policyIds
                 andEscrowTicket:(NSString*)escrowTicket
                  forEnvironment:(PGMPiEnvironment*)environment
              withResponseObject:(PGMPiResponse*)response
                      onComplete:(PiRequestComplete)onComplete
{
    NSLog(@"Will issue POST for consents to this url: %@", [environment postConsentPathWithTicket:escrowTicket]);
    NSURL* url = [NSURL URLWithString:[environment postConsentPathWithTicket:escrowTicket]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:PGMPiTimeout];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[self createPostConsentJsonDataFromArray:policyIds]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:
     ^(NSURLResponse *urlresponse, NSData *data, NSError *error) {
         
         if ([urlresponse isKindOfClass:[NSHTTPURLResponse class]])
         {
             
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)urlresponse;
//             NSLog(@"The url response from Pi for posting consent is %ld", (long)httpResponse.statusCode);
//             NSLog(@"...and the data is: %@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
             
             if (httpResponse.statusCode != 200)
             {
                 NSString *errorDesc = [NSString stringWithFormat:@"Consent POST failure: POST request failed with status code %@", [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]];
                 
                 NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                 [errorDetail setValue:NSLocalizedString(errorDesc, @"Consent POST failure")
                                forKey:NSLocalizedDescriptionKey];

                 response.error = [NSError errorWithDomain:PGMPiErrorDomain code:PGMPiPostConsentError userInfo:errorDetail];
                 onComplete(response);
                 return;
                 
             }else {
                 onComplete(response);
             }
         }
         else {
             NSLog(@"url response is not NSHTTPURLResponse.");
             if (error) {
                 NSLog(@"Consent POST to Pi failed with error code %ld and desc %@", (long)error.code, error.description);
                 response.error = error;
             }
             if (data) {
//                 NSLog(@"...and the data is %@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
                 onComplete(response);
             }
         }
     }];
}

- (NSData*) createPostConsentJsonDataFromArray:(NSArray*)policyIds
{
    NSMutableDictionary * postConsentDict = [[NSMutableDictionary alloc] init];
    [postConsentDict setObject:policyIds forKey:@"policyIds"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postConsentDict
                                                       options:kNilOptions
                                                         error:&error];
    if (error) {
        return nil;
    }
    return jsonData; //[NSKeyedArchiver archivedDataWithRootObject:postConsentDict];
}

@end
