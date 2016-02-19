//
//  RumbaUserIdFetcher.h
//  PearsonPush
//
//  Created by Tomack, Barry on 3/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RumbaFetcher.h"

@interface RumbaUserIdFetcher : RumbaFetcher

@property (nonatomic, weak) NSString* userIdPath;

- (id) initWithDelegate:(id<RumbaFetcherDelegate>)delegate
             userIdPath:(NSString*)idPath;

- (void) fetchUserIdWithAuthToken:(NSString*)token;

@end
