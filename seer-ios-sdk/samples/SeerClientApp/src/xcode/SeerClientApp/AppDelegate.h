//
//  AppDelegate.h
//  SeerClientApp
//
//  Created by Tomack, Barry on 1/6/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Seer-ios-client/SeerClient.h>
#import "SessionRequest.h"
#import "BlockingView.h"


#define kSessionUpdate @"SessionUpdate"
#define kSessionItemsUpdated @"SessionItemsUpdated"

@interface AppDelegate : UIResponder <UIApplicationDelegate, SeerClientDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString* actorName;

@property (nonatomic, strong) NSMutableArray* sessionHistory;

- (void) reportDataDictionary:(NSDictionary*)dataDict
                  requestType:(NSString*)requestType;

- (SeerClientResponse*) queueDataDictionary:(NSDictionary*)dataDict
                                requestType:(NSString*)requestType;

- (void) clearSession;
- (void) reportQueue;
- (NSNumber*)itemsInQueue;
- (NSNumber*)sizeOfQueue;
- (void) startClient;
- (ValidationResult *) userSetBatchSize:(NSInteger)bundleSize;
- (void) changeAutoReportQueue:(BOOL)option;
- (void) changeRemoveOldItemsWhenFullDB:(BOOL)option;

@end
