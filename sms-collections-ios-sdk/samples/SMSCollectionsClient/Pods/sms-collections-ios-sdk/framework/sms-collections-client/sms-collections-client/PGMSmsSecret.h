//
//  Secret.h
//  sms-collections-client
//
//  Created by Seals, Morris D on 12/18/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGMSmsSecret : NSObject

+(NSString *)getSecretParameterWithLoginToken:(NSString *)token andSalt:(NSString *) salt;

@end
