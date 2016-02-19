//
//  PGMSmsAuthenticationResponseHandler.h
//  sms-collections-client
//
//  Created by Joe Miller on 12/9/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMSmsResponse.h"

@interface PGMSmsAuthenticationResponseHandler : NSObject

- (PGMSmsResponse *)handleAuthenticationResponse:(NSURLResponse *)urlResponse withError:(NSError *)error;

@end
