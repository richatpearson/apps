//
//  PGMPiForgotUsername.h
//  Pi-ios-client
//
//  Created by Tomack, Barry on 8/26/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMPiResponse.h"
#import "PGMPiEnvironment.h"

@interface PGMPiForgotUsername : NSObject
{
    
}

+ (void) requestUsernameForEmail:(NSString*)email
                        clientId:(NSString*)clientId
                   piEnvironment:(PGMPiEnvironment*)piEnvironment
                      piResponse:(PGMPiResponse*)piResponse
                      onComplete:(PiRequestComplete)onComplete;

@end
