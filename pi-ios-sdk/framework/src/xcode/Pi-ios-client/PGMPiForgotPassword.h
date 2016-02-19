//
//  PGMPiForgotPassword.h
//  Pi-ios-client
//
//  Created by Tomack, Barry on 8/22/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMPiResponse.h"
#import "PGMPiEnvironment.h"

@interface PGMPiForgotPassword : NSObject
{
    
}

+ (void) requestPasswordWithUsername:(NSString*)username
                            clientId:(NSString*)clientId
                       piEnvironment:(PGMPiEnvironment*)piEnvironment
                          piResponse:(PGMPiResponse*)piResponse
                          onComplete:(PiRequestComplete)onComplete;

@end
