/**************************************************************************************
/*  File Name      : FMDatabase.m
/*  Project Name   : <nil> Generic Class
/*  Description    : N/A
/*  Version        : 1.1
/*  Created by     : Naveen Shan
/*  Created on     : 11/10/10
/*  Copyright (C) 2010 RapidValue IT Services Pvt. Ltd. All Rights Reserved.
/**************************************************************************************/

#import "FMDatabase.h"
#import "unistd.h"

@implementation FMDatabase

#pragma mark -
#pragma mark FMDatabase Initialization

+ (id)databaseWithPath:(NSString*)aPath {
    return [[[self alloc] initWithPath:aPath] autorelease];
}

- (id)initWithPath:(NSString*)aPath {
    self = [super init];
	 if (self) {
        databasePath        = [aPath copy];
        db                  = 0x00;
        logsErrors          = 0x00;
        crashOnErrors       = 0x00;
        busyRetryTimeout    = 0x00;
    }
	
	return self;
}

#pragma mark -

- (sqlite3*) sqliteHandle {
    return db;
}

- (NSString *) databasePath {
    return databasePath;
}

+ (NSString*) sqliteLibVersion {
    return [NSString stringWithFormat:@"%s", sqlite3_libversion()];
}

- (BOOL) open {
	int err = sqlite3_open([databasePath fileSystemRepresentation], &db );
	if(err != SQLITE_OK) {
        DebugLog(@"error opening DB!: %d", err);
		return NO;
	}
	
	return YES;
}

#if SQLITE_VERSION_NUMBER >= 3005000
- (BOOL) openWithFlags:(int)flags {
    int err = sqlite3_open_v2([databasePath fileSystemRepresentation], &db, flags, NULL /* Name of VFS module to use */);
	if(err != SQLITE_OK) {
		DebugLog(@"error opening DB!: %d", err);
		return NO;
	}
	return YES;
}
#endif


- (void) close {
    
    [self clearCachedStatements];
    
	if (!db) {
        return;
    }
    
    int  rc;
    BOOL retry;
    int numberOfRetries = 0;
    do {
        retry   = NO;
        rc      = sqlite3_close(db);
        if (SQLITE_BUSY == rc) {
            retry = YES;
            usleep(20);
            if (busyRetryTimeout && (numberOfRetries++ > busyRetryTimeout)) {
                DebugLog(@"%s:%d", __FUNCTION__, __LINE__);
                DebugLog(@"Database busy, unable to close");
                return;
            }
        }
        else if (SQLITE_OK != rc) {
            DebugLog(@"error closing!: %d", rc);
        }
    }
    while (retry);
    
	db = nil;
}

#pragma mark -

- (FMStatement*) cachedStatementForQuery:(NSString*)query {
    return [cachedStatements objectForKey:query];
}

- (void) setCachedStatement:(FMStatement*)statement forQuery:(NSString*)query {
	
    DebugLog(@"setting query to cache : %@", query);
    query = [query copy]; // in case we got handed in a mutable string...
    [statement setQuery:query];
    [cachedStatements setObject:statement forKey:query];
    [query release];
}

- (void) clearCachedStatements {
    
    NSEnumerator *e = [cachedStatements objectEnumerator];
    FMStatement *cachedStmt;
	
    while ((cachedStmt = [e nextObject])) {
    	[cachedStmt close];
    }
    
    [cachedStatements removeAllObjects];
}

#pragma mark -
#pragma mark Encryption methods.

- (BOOL) rekey:(NSString*)key {
#ifdef SQLITE_HAS_CODEC
    if (!key) {
        return NO;
    }
    
    int rc = sqlite3_rekey(db, [key UTF8String], strlen([key UTF8String]));
    
    if (rc != SQLITE_OK) {
        DebugLog(@"error on rekey: %d", rc);
        DebugLog(@"%@", [self lastErrorMessage]);
    }
    
    return (rc == SQLITE_OK);
#else
    return NO;
#endif
}

- (BOOL) setKey:(NSString*)key {
#ifdef SQLITE_HAS_CODEC
    if (!key) {
        return NO;
    }
    
    int rc = sqlite3_key(db, [key UTF8String], strlen([key UTF8String]));
    
    return (rc == SQLITE_OK);
#else
    return NO;
#endif
}

#pragma mark -
#pragma mark FMDatabase Error Handles

- (BOOL) goodConnection {
    
    if (!db) {
        return NO;
    }
    
    FMResultSet *rs = [self executeQuery:@"select name from sqlite_master where type='table'"];
    
    if (rs) {
        [rs close];
        return YES;
    }
    
    return NO;
}

- (void) compainAboutInUse {
    DebugLog(@"The FMDatabase %@ is currently in use.", self);
    
    if (crashOnErrors) {
        NSAssert1(false, @"The FMDatabase %@ is currently in use.", self);
    }
}

- (int) lastErrorCode {
    return sqlite3_errcode(db);
}

- (NSString*) lastErrorMessage {
    return [NSString stringWithUTF8String:sqlite3_errmsg(db)];
}

- (BOOL) hadError {
    int lastErrCode = [self lastErrorCode];
    
    return (lastErrCode > SQLITE_OK && lastErrCode < SQLITE_ROW);
}

#pragma mark -

- (sqlite_int64) lastInsertRowId {
    
    if (inUse) {
        [self compainAboutInUse];
        return NO;
    }
    [self setInUse:YES];
    
    sqlite_int64 ret = sqlite3_last_insert_rowid(db);
    
    [self setInUse:NO];
    
    return ret;
}

- (void) bindObject:(id)obj toColumn:(int)idx inStatement:(sqlite3_stmt*)pStmt; {
    
    if ((!obj) || ((NSNull *)obj == [NSNull null])) {
        sqlite3_bind_null(pStmt, idx);
    }
    
    // FIXME - someday check the return codes on these binds.
    else if ([obj isKindOfClass:[NSData class]]) {
        sqlite3_bind_blob(pStmt, idx, [obj bytes], [obj length], SQLITE_STATIC);
    }
    else if ([obj isKindOfClass:[NSDate class]]) {
        sqlite3_bind_double(pStmt, idx, [obj timeIntervalSince1970]);
    }
    else if ([obj isKindOfClass:[NSNumber class]]) {
        
        if (strcmp([obj objCType], @encode(BOOL)) == 0) {
            sqlite3_bind_int(pStmt, idx, ([obj boolValue] ? 1 : 0));
        }
        else if (strcmp([obj objCType], @encode(int)) == 0) {
            sqlite3_bind_int64(pStmt, idx, [obj longValue]);
        }
        else if (strcmp([obj objCType], @encode(long)) == 0) {
            sqlite3_bind_int64(pStmt, idx, [obj longValue]);
        }
        else if (strcmp([obj objCType], @encode(long long)) == 0) {
            sqlite3_bind_int64(pStmt, idx, [obj longLongValue]);
        }
        else if (strcmp([obj objCType], @encode(float)) == 0) {
            sqlite3_bind_double(pStmt, idx, [obj floatValue]);
        }
        else if (strcmp([obj objCType], @encode(double)) == 0) {
            sqlite3_bind_double(pStmt, idx, [obj doubleValue]);
        }
        else {
            sqlite3_bind_text(pStmt, idx, [[obj description] UTF8String], -1, SQLITE_STATIC);
        }
    }
    else {
        sqlite3_bind_text(pStmt, idx, [[obj description] UTF8String], -1, SQLITE_STATIC);
    }
}

#pragma mark -
#pragma mark executeQuery

- (id) executeQuery:(NSString *)sql withArgumentsInArray:(NSArray*)arrayArgs orVAList:(va_list)args {
    
    if (inUse) {
        [self compainAboutInUse];
        return nil;
    }
    
    [self setInUse:YES];
    
    FMResultSet *rs = nil;
    
    int rc                  = 0x00;;
    sqlite3_stmt *pStmt     = 0x00;;
    FMStatement *statement  = 0x00;
    
    if (traceExecution && sql) {
        DebugLog(@"%@ executeQuery: %@", self, sql);
    }
    
    if (shouldCacheStatements) {
        statement = [self cachedStatementForQuery:sql];
        pStmt = statement ? [statement statement] : 0x00;
    }
    
    int numberOfRetries = 0;
    BOOL retry          = NO;
    
    if (!pStmt) {
        do {
            retry   = NO;
            rc      = sqlite3_prepare_v2(db, [sql UTF8String], -1, &pStmt, 0);
            
            if (SQLITE_BUSY == rc) {
                retry = YES;
                usleep(20);
                
                if (busyRetryTimeout && (numberOfRetries++ > busyRetryTimeout)) {
                    DebugLog(@"%s:%d Database busy (%@)", __FUNCTION__, __LINE__, [self databasePath]);
                    DebugLog(@"Database busy");
                    sqlite3_finalize(pStmt);
                    [self setInUse:NO];
                    return nil;
                }
            }
            else if (SQLITE_OK != rc) {
                
                
                if (logsErrors) {
                    DebugLog(@"DB Error: %d \"%@\"", [self lastErrorCode], [self lastErrorMessage]);
                    DebugLog(@"DB Query: %@", sql);
                    if (crashOnErrors) {
						//#if defined(__BIG_ENDIAN__) && !TARGET_IPHONE_SIMULATOR
						//     asm{ trap };
						//#endif
                        NSAssert2(false, @"DB Error: %d \"%@\"", [self lastErrorCode], [self lastErrorMessage]);
                    }
                }
                
                sqlite3_finalize(pStmt);
                
                [self setInUse:NO];
                return nil;
            }
        }
        while (retry);
    }
    
    id obj;
    int idx = 0;
    int queryCount = sqlite3_bind_parameter_count(pStmt);
    
    while (idx < queryCount) {
        
        if (arrayArgs) {
            obj = [arrayArgs objectAtIndex:idx];
        }
        else {
            obj = va_arg(args, id);
        }
        
        if (traceExecution) {
            DebugLog(@"obj: %@", obj);
        }
        
        idx++;
        
        [self bindObject:obj toColumn:idx inStatement:pStmt];
    }
    
    if (idx != queryCount) {
        DebugLog(@"Error: the bind count is not correct for the # of variables (executeQuery)");
        sqlite3_finalize(pStmt);
        [self setInUse:NO];
        return nil;
    }
    
    [statement retain]; // to balance the release below
    
    if (!statement) {
        statement = [[FMStatement alloc] init];
        [statement setStatement:pStmt];
        
        if (shouldCacheStatements) {
            [self setCachedStatement:statement forQuery:sql];
        }
    }
    
    // the statement gets close in rs's dealloc or [rs close];
    rs = [FMResultSet resultSetWithStatement:statement usingParentDatabase:self];
    [rs setQuery:sql];
    
    statement.useCount = statement.useCount + 1;
    
    [statement release];    
    
    [self setInUse:NO];
    
    return rs;
}

- (id) executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments {
    return [self executeQuery:sql withArgumentsInArray:arguments orVAList:nil];
}

- (id) executeQuery:(NSString*)sql, ... {
    va_list args;
    va_start(args, sql);
    
    id result = [self executeQuery:sql withArgumentsInArray:nil orVAList:args];
    
    va_end(args);
    return result;
}

#pragma mark -
#pragma mark executeUpdate Query

- (BOOL) executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray*)arrayArgs orVAList:(va_list)args {
    
    if (inUse) {
        [self compainAboutInUse];
        return NO;
    }
    
    [self setInUse:YES];
    
    int rc                   = 0x00;
    sqlite3_stmt *pStmt      = 0x00;
    FMStatement *cachedStmt = 0x00;
    
    if (traceExecution && sql) {
        DebugLog(@"%@ executeUpdate: %@", self, sql);
    }
    
    if (shouldCacheStatements) {
        cachedStmt = [self cachedStatementForQuery:sql];
        pStmt = cachedStmt ? [cachedStmt statement] : 0x00;
    }
    
    int numberOfRetries = 0;
    BOOL retry          = NO;
    
    if (!pStmt) {
        
        do {
            retry   = NO;
            rc      = sqlite3_prepare_v2(db, [sql UTF8String], -1, &pStmt, 0);
            if (SQLITE_BUSY == rc) {
                retry = YES;
                usleep(20);
                
                if (busyRetryTimeout && (numberOfRetries++ > busyRetryTimeout)) {
                    DebugLog(@"%s:%d Database busy (%@)", __FUNCTION__, __LINE__, [self databasePath]);
                    DebugLog(@"Database busy");
                    sqlite3_finalize(pStmt);
                    [self setInUse:NO];
                    return NO;
                }
            }
            else if (SQLITE_OK != rc) {
                
                if (logsErrors) {
                    DebugLog(@"DB Error: %d \"%@\"", [self lastErrorCode], [self lastErrorMessage]);
                    DebugLog(@"DB Query: %@", sql);
                    if (crashOnErrors) {
						//#if defined(__BIG_ENDIAN__) && !TARGET_IPHONE_SIMULATOR
						//                        asm{ trap };
						//#endif
                        NSAssert2(false, @"DB Error: %d \"%@\"", [self lastErrorCode], [self lastErrorMessage]);
                    }
                }
                
                sqlite3_finalize(pStmt);
                [self setInUse:NO];
                
                return NO;
            }
        }
        while (retry);
    }
    
    id obj;
    int idx = 0;
    int queryCount = sqlite3_bind_parameter_count(pStmt);
    
    while (idx < queryCount) {
        
        if (arrayArgs) {
            obj = [arrayArgs objectAtIndex:idx];
        }
        else {
            obj = va_arg(args, id);
        }
        
        
        if (traceExecution) {
            DebugLog(@"obj: %@", obj);
        }
        
        idx++;
        
        [self bindObject:obj toColumn:idx inStatement:pStmt];
    }
    
    if (idx != queryCount) {
        DebugLog(@"Error: the bind count is not correct for the # of variables (%@) (executeUpdate)", sql);
        sqlite3_finalize(pStmt);
        [self setInUse:NO];
        return NO;
    }
    
    /* Call sqlite3_step() to run the virtual machine. Since the SQL being
     ** executed is not a SELECT statement, we assume no data will be returned.
     */
    numberOfRetries = 0;
    do {
        rc      = sqlite3_step(pStmt);
        retry   = NO;
        
        if (SQLITE_BUSY == rc) {
            // this will happen if the db is locked, like if we are doing an update or insert.
            // in that case, retry the step... and maybe wait just 10 milliseconds.
            retry = YES;
            usleep(20);
            
            if (busyRetryTimeout && (numberOfRetries++ > busyRetryTimeout)) {
                DebugLog(@"%s:%d Database busy (%@)", __FUNCTION__, __LINE__, [self databasePath]);
                DebugLog(@"Database busy");
                retry = NO;
            }
        }
        else if (SQLITE_DONE == rc || SQLITE_ROW == rc) {
            // all is well, let's return.
        }
        else if (SQLITE_ERROR == rc) {
            DebugLog(@"Error calling sqlite3_step (%d: %s) SQLITE_ERROR", rc, sqlite3_errmsg(db));
            DebugLog(@"DB Query: %@", sql);
        }
        else if (SQLITE_MISUSE == rc) {
            // uh oh.
            DebugLog(@"Error calling sqlite3_step (%d: %s) SQLITE_MISUSE", rc, sqlite3_errmsg(db));
            DebugLog(@"DB Query: %@", sql);
        }
        else {
            // wtf?
            DebugLog(@"Unknown error calling sqlite3_step (%d: %s) eu", rc, sqlite3_errmsg(db));
            DebugLog(@"DB Query: %@", sql);
        }
        
    } while (retry);
    
    assert( rc!=SQLITE_ROW );
    
    
    if (shouldCacheStatements && !cachedStmt) {
        cachedStmt = [[FMStatement alloc] init];
        
        [cachedStmt setStatement:pStmt];
        
        [self setCachedStatement:cachedStmt forQuery:sql];
        
        [cachedStmt release];
    }
    
    if (cachedStmt) {
        cachedStmt.useCount = cachedStmt.useCount + 1;
        rc = sqlite3_reset(pStmt);
    }
    else {
        /* Finalize the virtual machine. This releases all memory and other
         ** resources allocated by the sqlite3_prepare() call above.
         */
        rc = sqlite3_finalize(pStmt);
    }
    
    [self setInUse:NO];
    
    return (rc == SQLITE_OK);
}

- (BOOL) executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments {
    return [self executeUpdate:sql withArgumentsInArray:arguments orVAList:nil];
}

- (BOOL) executeUpdate:(NSString*)sql, ... {
    va_list args;
    va_start(args, sql);
    
    BOOL result = [self executeUpdate:sql withArgumentsInArray:nil orVAList:args];
    
    va_end(args);
    return result;
}

#pragma mark -

- (BOOL) commit {
    BOOL b =  [self executeUpdate:@"COMMIT TRANSACTION;"];
    if (b) {
        inTransaction = NO;
    }
    return b;
}

- (BOOL) rollback {
    BOOL b = [self executeUpdate:@"ROLLBACK TRANSACTION;"];
    if (b) {
        inTransaction = NO;
    }
    return b;
}

- (BOOL) beginTransaction {
    BOOL b =  [self executeUpdate:@"BEGIN EXCLUSIVE TRANSACTION;"];
    if (b) {
        inTransaction = YES;
    }
    return b;
}

- (BOOL) beginDeferredTransaction {
    BOOL b =  [self executeUpdate:@"BEGIN DEFERRED TRANSACTION;"];
    if (b) {
        inTransaction = YES;
    }
    return b;
}

#pragma mark -

- (BOOL)inUse {
    return inUse || inTransaction;
}

- (void) setInUse:(BOOL)b {
    inUse = b;
}

- (BOOL)inTransaction {
    return inTransaction;
}
- (void)setInTransaction:(BOOL)flag {
    inTransaction = flag;
}

- (BOOL)logsErrors {
    return logsErrors;
}
- (void)setLogsErrors:(BOOL)flag {
    logsErrors = flag;
}

- (BOOL)crashOnErrors {
    return crashOnErrors;
}

- (void)setCrashOnErrors:(BOOL)flag {
    crashOnErrors = flag;
}

- (BOOL)traceExecution {
    return traceExecution;
}
- (void)setTraceExecution:(BOOL)flag {
    traceExecution = flag;
}

- (BOOL)checkedOut {
    return checkedOut;
}
- (void)setCheckedOut:(BOOL)flag {
    checkedOut = flag;
}

- (int)busyRetryTimeout {
    return busyRetryTimeout;
}
- (void)setBusyRetryTimeout:(int)newBusyRetryTimeout {
    busyRetryTimeout = newBusyRetryTimeout;
}

- (BOOL)shouldCacheStatements {
    return shouldCacheStatements;
}

- (void)setShouldCacheStatements:(BOOL)value {
    
    shouldCacheStatements = value;
    
    if (shouldCacheStatements && !cachedStatements) {
        [self setCachedStatements:[NSMutableDictionary dictionary]];
    }
    
    if (!shouldCacheStatements) {
        [self setCachedStatements:nil];
    }
}

- (NSMutableDictionary *) cachedStatements {
    return cachedStatements;
}

- (void)setCachedStatements:(NSMutableDictionary *)value {
    if (cachedStatements != value) {
        [cachedStatements release];
        cachedStatements = [value retain];
    }
}

- (int)changes {
    return(sqlite3_changes(db));
}

#pragma mark -

- (void)dealloc {
	[self close];
    
    [cachedStatements release];
    [databasePath release];
	
    [super dealloc];
}

@end

#pragma mark -
#pragma mark FMStatement

@implementation FMStatement


- (NSString *) query {
    return query;
}

- (void)setQuery:(NSString *)value {
    if (query != value) {
        [query release];
        query = [value retain];
    }
}

- (long)useCount {
    return useCount;
}

- (void)setUseCount:(long)value {
    if (useCount != value) {
        useCount = value;
    }
}

- (sqlite3_stmt *) statement {
    return statement;
}

- (void)setStatement:(sqlite3_stmt *)value {
    statement = value;
}


- (NSString*) description {
    return [NSString stringWithFormat:@"%@ %d hit(s) for query %@", [super description], useCount, query];
}

- (void) close {
    if (statement) {
        sqlite3_finalize(statement);
        statement = 0x00;
    }
}

- (void) reset {
    if (statement) {
        sqlite3_reset(statement);
    }
}

#pragma mark -

- (void)dealloc {
	[self close];
    [query release];
	[super dealloc];
}

@end

