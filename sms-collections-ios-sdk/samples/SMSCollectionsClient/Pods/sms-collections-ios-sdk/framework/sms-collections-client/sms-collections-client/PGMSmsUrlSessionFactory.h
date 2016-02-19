//
//  PGMSmsUrlSessionFactory.h
//  sms-collections-client
//
//  Created by Joe Miller on 12/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGMSmsUrlSessionFactory : NSObject

- (NSURLSession *)newUrlSession;

@end
