//
//  PGMSmsResponse.h
//  sms-collections-client
//
//  Created by Joe Miller on 12/1/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMSmsUserProfile.h"

@interface PGMSmsResponse : NSObject

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSString *smsToken;
@property (nonatomic, strong) PGMSmsUserProfile *userProfile;


@end
