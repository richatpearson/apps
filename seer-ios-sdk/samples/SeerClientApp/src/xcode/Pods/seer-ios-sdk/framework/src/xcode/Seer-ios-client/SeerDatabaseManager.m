//
//  SeerDatabaseManager.m
//  Seer-ios-client
//
//  Created by Richard Rosiak on 3/9/15.
//  Copyright (c) 2015 Pearson. All rights reserved.
//

#import "SeerDatabaseManager.h"

@interface SeerDatabaseManager()

@property (nonatomic) sqlite3* seerQueueDB;
@property (nonatomic, strong) NSRecursiveLock* dbLock;

@end

@implementation SeerDatabaseManager

NSString* const kSEER_QueueDir                = @".seerqueue";
NSString* const kSEER_QueueDB                 = @"seerqueue";
NSInteger const kSEER_QueueDBTimeout          = 30;
NSInteger const kSEER_QueueDBMaxSize          = 10485760; //10 MB

-(instancetype) initDatabase {
    if (self = [super init])
    {
        // Ensure that database access is not concurrent and that only one thread has an open
        // transaction at any given time.
        self.dbLock = [[NSRecursiveLock alloc] init];
        
        NSString *dirPath = [self seerQueueDirPath];
        NSLog(@"seer queue dir path: %@", dirPath);
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:dirPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        }
        
        // Attempt to open database. It will be created if it does not exist.
        [self.dbLock lock];
        NSString *dbPath = [self seerQueueDBPath];
        NSLog(@"seer queue DB Path: %@", dbPath);
        
        int code =  sqlite3_open([dbPath UTF8String], &_seerQueueDB);
        
        // If unable to open the database, it is likely corrupted. Remove it and make a new one.
        if (code != SQLITE_OK)
        {
            [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
            code =  sqlite3_open([dbPath UTF8String], &_seerQueueDB);
        }
        [self.dbLock unlock];
        
        // Check db connection and create Seer Queue tables if necessary.
        if (code == SQLITE_OK) {
            sqlite3_busy_timeout(_seerQueueDB, kSEER_QueueDBTimeout);
            if ([self seerQueueVersion] == 0)
            {
                [self createSeerQueueTables];
            }
            
            sqlite3_close(_seerQueueDB);
        }
    }
    
    return self;
}

- (NSString *)seerQueueDirPath
{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingPathComponent:kSEER_QueueDir];
}

- (NSString *)seerQueueDBPath
{
    NSString *path = [[self seerQueueDirPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", kSEER_QueueDB]];
    
    return path;
}

- (NSInteger) seerQueueVersion
{
    int version = 0;
    
    [self.dbLock lock];
    //int code =  sqlite3_open([[self seerQueueDBPath] UTF8String], &_seerQueueDB);
    
    const char *sql = "SELECT MAX(seer_queue_version) FROM Seer_Queue_Info";
    sqlite3_stmt *selectSeerQueueVersion;
    if(sqlite3_prepare_v2(_seerQueueDB, sql, -1, &selectSeerQueueVersion, NULL) == SQLITE_OK)
    {
        if(sqlite3_step(selectSeerQueueVersion) == SQLITE_ROW)
        {
            version = sqlite3_column_int(selectSeerQueueVersion, 0);
        }
    }
    sqlite3_finalize(selectSeerQueueVersion);
    
    sqlite3_close(_seerQueueDB);
    
    [self.dbLock unlock];
    
    return version;
}

- (void) createSeerQueueTables
{
    [self.dbLock lock];
    int code =  sqlite3_open([[self seerQueueDBPath] UTF8String], &_seerQueueDB);
    
    if (code == SQLITE_OK)
    {
        char *errMsg = NULL;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS Seer_Queue (queue_id INTEGER PRIMARY KEY AUTOINCREMENT, request_id INTEGER NOT NULL, request_type TEXT NOT NULL, request_payload TEXT NOT NULL, request_created INTEGER NOT NULL, request_status INTEGER)";
        
        code = sqlite3_exec(_seerQueueDB, sql_stmt, NULL, NULL, &errMsg);
    }
    
    if (code != SQLITE_OK)
    {
        NSLog(@"FAILED TO CREATE table Seer_Queue");
    }
    else
    {
        NSString* viewSQL = [NSString stringWithFormat:@"CREATE VIEW IF NOT EXISTS Seer_Queue_Report_View AS SELECT rowid AS rowid, queue_id, request_id, request_type, request_payload, request_created, request_status FROM Seer_Queue WHERE request_status <> %u ORDER BY request_status", kServerRequestStatusSuccess];
        char *errMsg = NULL;
        const char *view_sql = [viewSQL UTF8String];
        
        code = sqlite3_exec(_seerQueueDB, view_sql, NULL, NULL, &errMsg);
    }
    
    if (code != SQLITE_OK)
    {
        NSLog(@"FAILED TO CREATE view Seer_Queue_Report_View");
    }
    else
    {
        char *errMsg = NULL;
        const char *queue_info_sql = "CREATE TABLE IF NOT EXISTS Seer_Queue_Info (seer_queue_version INTEGER PRIMARY KEY, last_upload INTEGER, sdk_version TEXT )";
        
        code = sqlite3_exec(_seerQueueDB, queue_info_sql, NULL, NULL, &errMsg);
    }
    
    if (code != SQLITE_OK)
    {
        NSLog(@"FAILED TO CREATE table Seer_Queue_Info");
    }
    else
    {
        sqlite3_stmt *insertInfo;
        sqlite3_prepare_v2(_seerQueueDB, "INSERT INTO Seer_Queue_Info (seer_queue_version, last_upload) VALUES (1, 0, 1.0.0)", -1, &insertInfo, NULL);
        
        code = sqlite3_step(insertInfo);
        sqlite3_finalize(insertInfo);
    }
    
    if (code == SQLITE_OK || code == SQLITE_DONE)
    {
        sqlite3_exec(_seerQueueDB, "COMMIT", NULL, NULL, NULL);
    }
    
    [self.dbLock unlock];
}

# pragma mark Init Methods End


- (NSUInteger)databaseSize
{
    NSUInteger size = 0;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager]
                                    attributesOfItemAtPath:[self seerQueueDBPath]
                                    error:nil];
    
    size = [[fileAttributes objectForKey:NSFileSize] unsignedIntegerValue];
    
    return size;
}

- (NSUInteger) requestSeerQueueRowCount
{
    NSUInteger rows = 0;
    
    [_dbLock lock];
    
    int code =  sqlite3_open([[self seerQueueDBPath] UTF8String], &_seerQueueDB);
    
    if (code == SQLITE_OK)
    {
        const char *get_count = "SELECT COUNT(*) FROM Seer_Queue";
        
        sqlite3_stmt *getCount;
        
        code = sqlite3_prepare_v2(_seerQueueDB, get_count, -1, &getCount, NULL);
        
        if (code == SQLITE_OK)
        {
            while (sqlite3_step(getCount) == SQLITE_ROW)
            {
                rows = sqlite3_column_int(getCount, 0);
            }
        }
        
        sqlite3_finalize(getCount);
        sqlite3_close(_seerQueueDB);
    }
    
    [_dbLock unlock];
    
    return rows;
}

-(int) insertSeerQueueRowForSqlStatement:(NSString*)statement {
    [_dbLock lock];
    
    int code =  sqlite3_open([[self seerQueueDBPath] UTF8String], &_seerQueueDB);
    
    if (code == SQLITE_OK)
    {
        const char *insert_stmt = [statement UTF8String];
        
        sqlite3_stmt *insertEvent;
        sqlite3_prepare_v2(_seerQueueDB, insert_stmt, -1, &insertEvent, NULL);
        
        code = sqlite3_step(insertEvent);
        sqlite3_finalize(insertEvent);
        sqlite3_close(_seerQueueDB);
    }
    
    [_dbLock unlock];
    
    return code;
}

-(NSString*) createSeeqQueueInsertStatementForRequest:(SeerServerRequest*)request {
    
    return [NSString stringWithFormat:@"INSERT INTO Seer_Queue (request_id, request_type, request_payload, \
            request_created, request_status) \
            VALUES (\'%ld\', \'%@\', \'%@\', \'%f\', \'%d\')", (long)request.requestId, request.requestType,
            request.requestJSON, request.requestCreated, request.requestStatus];
}

-(SeerQueueDBItem*) getSeerQueueRowForStatement:(NSString*)statement {
    
    SeerQueueDBItem *rowResponse = nil;
    
    [_dbLock lock];
    
    int code =  sqlite3_open([[self seerQueueDBPath] UTF8String], &_seerQueueDB);
    
    if (code == SQLITE_OK)
    {
        const char* get_oldest = [statement UTF8String];
        
        sqlite3_stmt *get_stmt;
        
        if (sqlite3_prepare_v2(_seerQueueDB, get_oldest, -1, &get_stmt, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(get_stmt) == SQLITE_ROW)
            {
                rowResponse = [[SeerQueueDBItem alloc]
                               initSeerQueueDBItemWithQueueId:sqlite3_column_int(get_stmt, 0)
                                                    requestId:sqlite3_column_int(get_stmt, 1)
                                                  requestType:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(get_stmt, 2)]
                                                      payload:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(get_stmt, 3)]
                                               requestCreated:sqlite3_column_int(get_stmt, 4)
                                                requestStatus:sqlite3_column_int(get_stmt, 5)];
            }
        }
        sqlite3_finalize(get_stmt);
        sqlite3_close(_seerQueueDB);
    }
    
    [_dbLock unlock];
    
    return rowResponse;
}

-(NSString*) createGetSeerQueueOldestRowStatementForOffset:(int)offset {

    return [NSString stringWithFormat:@"SELECT queue_id, request_id, request_type, request_payload, request_created, \
            request_status \
            FROM Seer_Queue \
            ORDER BY request_created asc \
            LIMIT 1 \
            OFFSET %u", offset];
}

-(BOOL) deleteSeerQueueRowForStatement:(NSString*)statement {
    [_dbLock lock];
    
    int code =  sqlite3_open([[self seerQueueDBPath] UTF8String], &_seerQueueDB);
    
    if (code == SQLITE_OK)
    {
        const char *delete_stmt = [statement UTF8String];
        
        sqlite3_stmt *deleteSuccessEvent;
        sqlite3_prepare_v2(_seerQueueDB, delete_stmt, -1, &deleteSuccessEvent, NULL);
        
        code = sqlite3_step(deleteSuccessEvent);
        sqlite3_finalize(deleteSuccessEvent);
        sqlite3_close(_seerQueueDB);
    }
    
    [_dbLock unlock];
    
    return (code == SQLITE_DONE);
}

-(NSString*) createDeleteSeerQueueRowStatementForRequestStatus:(int)status {
    return [NSString stringWithFormat:@"DELETE FROM Seer_Queue \
                                        WHERE request_status=%d", status];
}

-(BOOL) deleteSeerQueueRowsForQueueIds:(NSArray*)queueIds {
    
    BOOL rowsDeletedSuccessfully = true;
    [_dbLock lock];
    
    if (sqlite3_open([[self seerQueueDBPath] UTF8String], &_seerQueueDB) == SQLITE_OK)
    {
        for (int i = 0; i < queueIds.count ; i++) {
            NSString* deleteItem = [NSString stringWithFormat:@"DELETE FROM Seer_Queue \
                                                                WHERE queue_id=%@", [queueIds objectAtIndex:i]];
            
            const char *delete_stmt = [deleteItem UTF8String];
            
            sqlite3_stmt *deleteOldest;
            sqlite3_prepare_v2(_seerQueueDB, delete_stmt, -1, &deleteOldest, NULL);
            
            if (sqlite3_step(deleteOldest) != SQLITE_DONE) {
                sqlite3_finalize(deleteOldest);
                sqlite3_close(_seerQueueDB);
                [_dbLock unlock];
                return false;
            }
            sqlite3_finalize(deleteOldest);
        }
        sqlite3_close(_seerQueueDB);
    }
    else {
        rowsDeletedSuccessfully = false;
    }
    
    [_dbLock unlock];
    
    return rowsDeletedSuccessfully;
}

-(SeerQueueDBItem*) getSeerQueueViewRowForStatement:(NSString*)statement {
    
    SeerQueueDBItem *rowResponse = nil;
    
    [_dbLock lock];
    
    int code =  sqlite3_open([[self seerQueueDBPath] UTF8String], &_seerQueueDB);
    
    if (code == SQLITE_OK)
    {
        const char* get_request = [statement UTF8String];
        
        sqlite3_stmt *getRequest;
        
        if (sqlite3_prepare_v2(_seerQueueDB, get_request, -1, &getRequest, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(getRequest) == SQLITE_ROW)
            {
                rowResponse = [[SeerQueueDBItem alloc]
                               initSeerQueueDBItemWithQueueId:sqlite3_column_int(getRequest, 0)
                               requestId:sqlite3_column_int(getRequest, 1)
                               requestType:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(getRequest, 2)]
                               payload:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(getRequest, 3)]
                               requestCreated:sqlite3_column_int(getRequest, 4)
                               requestStatus:sqlite3_column_int(getRequest, 5)];
            }
        }
        sqlite3_finalize(getRequest);
        sqlite3_close(_seerQueueDB);
    }
    
    [_dbLock unlock];
    
    return rowResponse;
}

-(NSString*) createGetSeerQueueViewStatementForRequestType:(NSString*)requestType
                                                    offset:(int)offset {
    return [NSString stringWithFormat:@"SELECT queue_id, request_id, request_type, request_payload, request_created, \
            request_status \
            FROM Seer_Queue_Report_View \
            WHERE request_type=\'%@\' \
            LIMIT 1 \
            OFFSET %u", requestType, offset];
}

-(BOOL) updateSeerQueueItems:(NSArray*)itemIds
                  withStatus:(SeerServerRequestStatus)status {
    BOOL rowsUpdated = true;
    [_dbLock lock];
    
    if (sqlite3_open([[self seerQueueDBPath] UTF8String], &_seerQueueDB) == SQLITE_OK)
    {
        for (int i = 0; i < itemIds.count ; i++) {
            
            NSString* updateQuery = [NSString stringWithFormat:@"UPDATE Seer_Queue \
                                                                 SET request_status=%u \
                                                                 WHERE request_id=%ld",
                                     status, (long)[[itemIds objectAtIndex:i] integerValue]];
            
            const char *updata_status_stmt = [updateQuery UTF8String];
            
            sqlite3_stmt *updateStatus;
            if (sqlite3_prepare_v2(_seerQueueDB, updata_status_stmt, -1, &updateStatus, NULL) == SQLITE_OK)
            {
                if(sqlite3_step(updateStatus) != SQLITE_DONE)
                {
                    rowsUpdated = false;
                }
            }
            sqlite3_finalize(updateStatus);
        }
        
        sqlite3_close(_seerQueueDB);
    }
    else {
        rowsUpdated = false;
    }
    
    [_dbLock unlock];
    
    return rowsUpdated;
}

-(void) removeEmptyPagesFromDB {
    
    char *errMsg;
    [_dbLock lock];
    
    if (sqlite3_open([[self seerQueueDBPath] UTF8String], &_seerQueueDB) == SQLITE_OK)
    {
        if (sqlite3_exec(_seerQueueDB, "VACUUM;", NULL, NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Failed execute VACUUM on DB");
        }
        sqlite3_close(_seerQueueDB);
    }
    
    [_dbLock unlock];
}

-(NSInteger) getSeerQueueMaxRequestIdValue {
    NSInteger maxRequestId = 0;
    
    [_dbLock lock];
    
    if (sqlite3_open([[self seerQueueDBPath] UTF8String], &_seerQueueDB) == SQLITE_OK) {
        NSString *selectMax = @"SELECT MAX(request_id) FROM SEER_QUEUE";
        
        const char *selectMaxStatement = [selectMax UTF8String];
        
        sqlite3_stmt *selectMax_stmt;
        if (sqlite3_prepare_v2(_seerQueueDB, selectMaxStatement, -1, &selectMax_stmt, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(selectMax_stmt) == SQLITE_ROW)
            {
                maxRequestId = sqlite3_column_int(selectMax_stmt, 0);
            }
        }
        sqlite3_finalize(selectMax_stmt);
        sqlite3_close(_seerQueueDB);
    }
    
    [_dbLock unlock];
    
    return maxRequestId;
}

@end
