/**************************************************************************************
/*  File Name      : FMDatabaseAdditions.h
/*  Project Name   : <nil> Generic Class
/*  Description    : Sqlite wrapper class for Database Management - additions
/*  Version        : 1.1
/*  Created by     : Naveen Shan
/*  Created on     : 11/10/10
/*  Copyright (C) 2010 RapidValue IT Services Pvt. Ltd. All Rights Reserved.
/**************************************************************************************/

#import <Foundation/Foundation.h>

@interface FMDatabase (FMDatabaseAdditions)

- (int) intForQuery:(NSString*)objs, ...;
- (long) longForQuery:(NSString*)objs, ...; 
- (BOOL) boolForQuery:(NSString*)objs, ...;
- (double) doubleForQuery:(NSString*)objs, ...;
- (NSString*) stringForQuery:(NSString*)objs, ...; 
- (NSData*) dataForQuery:(NSString*)objs, ...;

// Notice that there's no dataNoCopyForQuery:.
// That would be a bad idea, because we close out the result set, and then what
// happens to the data that we just didn't copy?  Who knows, not I.

- (BOOL) tableExists:(NSString*)tableName;
- (FMResultSet*) getSchema;
- (FMResultSet*) getTableSchema:(NSString*)tableName;
- (BOOL) columnExists:(NSString*)tableName columnName:(NSString*)columnName;

@end
