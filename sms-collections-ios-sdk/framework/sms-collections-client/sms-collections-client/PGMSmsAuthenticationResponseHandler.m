//
//  PGMSmsAuthenticationResponseHandler.m
//  sms-collections-client
//
//  Created by Joe Miller on 12/9/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMSmsAuthenticationResponseHandler.h"
#import "PGMSmsError.h"
#import "NSString+Numeric.h"
#import "PGMSmsTokenParser.h"

@implementation PGMSmsAuthenticationResponseHandler

- (PGMSmsResponse *)handleAuthenticationResponse:(NSURLResponse *)urlResponse withError:(NSError *)error
{
    PGMSmsResponse *response = [PGMSmsResponse new];
    if (error) {
        response.error = [PGMSmsError createErrorForErrorCode:PGMSmsNetworkCallError
                                               andDescription:error.description];
    }
    else {
        NSString *value = [PGMSmsTokenParser parseTokenFromUrl:urlResponse.URL];
        //NSLog(@"Url in response is %@", [urlResponse.URL absoluteString]);
        NSLog(@"value    %@", value);
        if ([value isNumeric]) {
            response.smsToken = value;
        }
        else {
            NSString *msg = @"Invalid login name/password combination OR you don't have a subscription to this site.";
            response.error = [PGMSmsError createErrorForErrorCode:PGMSmsAuthenticationError andDescription:msg];
        }
    }

    return response;
}

@end
