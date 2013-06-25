//
//  SyncDB.h
//  Torq361
//
//  Created by Binoy on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JsonParser.h"

@class SyncDB;

@protocol SyncDBDelegate<NSObject>

-(void)didfinishedSync:(SyncDB *)objSyncDB;

-(void)didfailedSyncwitherror:(SyncDB *)objSyncDB;

@end


@interface SyncDB : NSObject<JsonParserDelegate> {

	id<SyncDBDelegate>delegate;
	
}

@property(nonatomic,retain) id<SyncDBDelegate>delegate;

-(void)onSyncDB;

-(void)addTOCatalogTable:(id)value;

-(void)addToSyncTable:(id)value :(NSArray*)keyarrb;

-(void)addTOCategoryTable:(id)value;

-(void)addTOContentTable:(id)value;

-(void)addTOProductTable:(id)value;

-(NSString*)getTablename:(NSString*)strTable;

//-(void)deleteLocalContent:(NSString*)strstatus :(NSString*)strLast_updated_date :(NSString*)strContentUpdatedDate :(NSString*)strId :(NSString*)strContent_type :(NSString*)strPath;

@end
