//
//  PearsonOperationHeader.h
//  PushNotifications
//
//  Created by Tomack, Barry on 7/25/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<PearsonAppServicesiOSSDK/PearsonDataClient.h>

@interface PearsonOperationHeader : NSObject

@property (nonatomic, strong) NSString *authTokenHeader;
@property (nonatomic, strong) NSString *authProviderHeader;

+ (instancetype) operationHeadersForAuthProvider:(NSString*)authProvider;

- (PearsonDataClient *) clearPiClientHeaders:(PearsonDataClient *)dataClient;

@end
