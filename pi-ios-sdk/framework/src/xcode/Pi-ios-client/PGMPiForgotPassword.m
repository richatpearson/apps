//
//  PGMPiForgotPassword.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 8/22/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiForgotPassword.h"

@implementation PGMPiForgotPassword

+ (void) requestPasswordWithUsername:(NSString*)username
                            clientId:(NSString*)clientId
                       piEnvironment:(PGMPiEnvironment*)piEnvironment
                          piResponse:(PGMPiResponse*)piResponse
                          onComplete:(PiRequestComplete)onComplete
{
    NSMutableString *postString = [NSMutableString stringWithFormat:@"username=%@", username];
    [postString appendFormat:@"&client_id=%@", clientId];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSString* urlStr = [piEnvironment piForgotPasswordUrl];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if (error)
        {
            NSLog(@"Error,%@", [error localizedDescription]);
            piResponse.error = error;
            piResponse.requestStatus = PiRequestFailure;
        }
        else
        {
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData: data
                                                                     options: kNilOptions
                                                                       error: &error];
            if(jsonDict)
            {
                piResponse.requestStatus = PiRequestFailure;
                [piResponse setObject:jsonDict forOperationType:PiForgotPassword];
            }
            else
            {
                piResponse.requestStatus = PiRequestSuccess;
                NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                [piResponse setObject:jsonString forOperationType:PiForgotPassword];
            }
        }
         
        if (onComplete)
        {
            onComplete(piResponse);
        }
    }];
}

@end
