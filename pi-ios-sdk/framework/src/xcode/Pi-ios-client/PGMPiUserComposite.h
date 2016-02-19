//
//  PGMPiUserComposite.h
//  Pi-ios-client
//
//  Created by Tomack, Barry on 6/16/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMPiIdentityProfile.h"
#import "PGMPiUserConsents.h"
#import "PGMPiCredentials.h"

@interface PGMPiUserComposite : NSObject

@property (nonatomic, strong) PGMPiIdentityProfile *piIdentityProfile;
@property (nonatomic, strong) PGMPiUserConsents *piUserConsents;
@property (nonatomic, strong) PGMPiCredentials *piCredentials;

@end
