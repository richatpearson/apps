//
//  SeerDatabaseManager.h
//  Seer-ios-client
//
//  Created by Richard Rosiak on 3/9/15.
//  Copyright (c) 2015 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SeerQueueDBItem.h"

@interface SeerDatabaseManager : NSObject

extern NSString* const kSEER_QueueDir;
extern NSString* const kSEER_QueueDB;
extern NSInteger const kSEER_QueueDBTimeout;
extern NSInteger const kSEER_QueueDBMaxSize;

-(instancetype) initDatabase;

- (NSUInteger)databaseSize;

- (NSUInteger) requestSeerQueueRowCount;

-(int) insertSeerQueueRowForSqlStatement:(NSString*)statement;

-(NSString*) createSeeqQueueInsertStatementForRequest:(SeerServerRequest*)request;

-(SeerQueueDBItem*) getSeerQueueRowForStatement:(NSString*)statement;

-(NSString*) createGetSeerQueueOldestRowStatementForOffset:(int)offset;

-(BOOL) deleteSeerQueueRowForStatement:(NSString*)statement;

-(NSString*) createDeleteSeerQueueRowStatementForRequestStatus:(int)status;

-(BOOL) deleteSeerQueueRowsForQueueIds:(NSArray*)queueIds;

-(SeerQueueDBItem*) getSeerQueueViewRowForStatement:(NSString*)statement;

-(NSString*) createGetSeerQueueViewStatementForRequestType:(NSString*)requestType
                                                    offset:(int)offset;

-(BOOL) updateSeerQueueItems:(NSArray*)itemIds
                  withStatus:(SeerServerRequestStatus)status;

-(void) removeEmptyPagesFromDB;

-(NSInteger) getSeerQueueMaxRequestIdValue;

@end
