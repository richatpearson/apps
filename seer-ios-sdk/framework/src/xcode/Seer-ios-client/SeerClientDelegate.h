//
//  SeerClientDelegate.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/16/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeerClientResponse.h"
#import "SeerClientBatchResponse.h"

/*!
 SeerClientDelegate protocol would be adopted by an object that will be receiving
 callbacks from SeerClient requests.
 */
@protocol SeerClientDelegate <NSObject>

/*!
 Called after any request (other than the Batch reporting request) is completed.
 
 @param seerClientRepsonse The returned response to be processed by the delegate
 */
- (void) seerClientDelegateResponse:(SeerClientResponse*)seerClientRepsonse;


/*!
 Called after a specific Batch report request is made.
 
 @param seerClientBatchResponse <#seerClientBatchResponse description#>
 */
- (void) seerClientDelegateBatchResponse:(SeerClientBatchResponse*)seerClientBatchResponse;

@end
