//
//  RumbaTokenFetcher.h
//  PearsonPush
//
//  Created by Tomack, Barry on 3/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RumbaFetcher.h"

@interface RumbaTokenFetcher : RumbaFetcher

@property (nonatomic, weak) NSString* tokenPath;

- (id) initWithDelegate:(id<RumbaFetcherDelegate>)delegate
              tokenPath:(NSString*)tokenPath;

- (void) fetchTokenWithUsername:username
                       password:password;

@end
