//
//  PGMPiClientDelegate.h
//  Pi-ios-client
//
//  Created by Tomack, Barry on 5/23/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PGMPiResponse;

/*!
 Classes wishing to receive responses for their request to the PGMPiClient must 
 conform to this protocol.
 */
@protocol PGMPiClientDelegate <NSObject>

/*!
 The callback method for any requests made by a PGMPiClient Delegate.
 
 @param piRepsonse Response to the PGMPiClient request
 */
- (void) delegateResponse:(PGMPiResponse *)piRepsonse;

@end
