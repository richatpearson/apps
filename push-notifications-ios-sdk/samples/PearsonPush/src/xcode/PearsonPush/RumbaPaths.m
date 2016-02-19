//
//  RumbaPaths.m
//  PearsonPush
//
//  Created by Tomack, Barry on 3/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "RumbaPaths.h"

@implementation RumbaPaths

- (id) init
{
    self = [super init];
    if (self)
    {
        self.tokenPath  = @"https://sso.rumba.int.pearsoncmg.com/sso/loginService?service=https://cert.api.pearsoncmg.com/authentication/v1/user/authentication/okurl?authservice=rumbasso&gateway=true&username=%@&password=%@";
        self.idPath     = @"https://cert.api.pearsoncmg.com/authentication/v1/user/authentication/validate?api_key=2d946ef787869984f5af49179e6c49de";
    }
    return self;
}
@end
