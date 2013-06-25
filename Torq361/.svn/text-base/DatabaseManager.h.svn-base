//
//  DatabaseManager.h
//  Torq361
//
//  Created by Binoy on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sqlite.h" 

@protocol DatabaseManagerDelegate <NSObject>

@end

@interface DatabaseManager : NSObject {
	
	Sqlite *m_objSqlite;
	
}

@property(nonatomic,retain)	Sqlite *m_objSqlite;

+ (DatabaseManager*)sharedManager;

//DELEGATES

+(id)delegate;	
+(void)setDelegate:(id)newDelegate;

//DATABASE FUCTIONS

- (BOOL) CREATEDATABASE :(NSString*)dbName; 
- (void) CREATETABLES;
- (void) COPY_DB_TO_DOCUMENT_FOLDER;
- (void) removeOldDbAndCreateNewOne;
- (BOOL) checkForVersionTable:(float)fVersion;
- (void) deleteDB:(NSString *)filename;

// INSERT STATEMENTS

- (void) INSERT_VERSION_NUMBER;

- (void) INSERT_VALUES_TO_SYNC_TABLE;

- (void) insertIntoSyncTable:(NSString *)tableName :(NSString *)lastModified;

-(void)resetDatabase;

- (void) insertIntoCatalogTable:(NSString *)idCatalog :(NSString *)name :(NSString *)description :(NSString *)thumbnailImgPath :(NSString *)validityFromDate :(NSString *)validityToDate :(NSString *)active :(NSString *)deleted;

- (void) insertInToCategoryTable:(NSString *)idCategory :(NSString *)idCatalog :(NSString *)idParentCategory :(NSString *)name :(NSString *)description :(NSString *)thumbNailImgPath :(NSString *)active :(NSString *)deleted;
	
- (void) insertIntoProductTable:(NSString *)idProduct :(NSString *)name :(NSString *)description : (NSString*)prodDetails:(NSString*)techDetails:(NSString *)thumbnailImgPath :(NSString *)idCategory :(NSString *)lastModified :(NSString *)active :(NSString *)deleted;

- (void) insertInToContentTable:(NSString *)idContent :(NSString *)idProduct :(NSString *)idCatalog :(NSString *)imagePath :(NSString *)pdfPath :(NSString *)videoPath :(NSString *)deleted;

- (BOOL)insertInToDownload:(NSString*)strContent_type :(NSString*)strId :(NSString*)strContent_path :(NSString*)strThumbnail_path :(NSString*)strTitle :(NSString*)strTmp_path :(NSString *)strDownloadStatus :(NSString *)strRollId;

// SELECT QUERIES


- (NSMutableArray *)getthumbimage:(NSString *)strTable;
- (NSMutableArray *)getSyncTables;
- (NSMutableArray*)getCategoryByParentID:(int)parentID;
- (NSMutableArray*)getProductByCategoryID:(NSMutableArray *)proArray;
- (NSMutableArray*)getBottomLevelCategoriesUnderCategoryID:(NSString *)categoryID;



- (BOOL)checkForEntryWithID :(NSString *)uniqueID withValue:(NSString *)value inTable:(NSString *)tableName;

- (NSString *)getCategoryNameWithID:(int)categoryID;

-(NSString*)getCategoryIDWithCategoryName:(NSString *)catName;

- (NSMutableArray *)getImagePathArrayForProductID:(NSString *)productID;
- (NSMutableArray *)getPDFPathArrayForProductID:(NSString *)productID;
- (NSMutableArray *)getVideoPathArrayForProductID:(NSString *)productID;

-(NSMutableArray *)getDownloadAllMedia:(NSString*)str_query;

- (void)clearTablesForNewCompany;
- (void)clearTablesForNewRollid;

- (BOOL)updateDownloadStatusInToDownload :(NSString *)strId :(NSString *)strStatus;
- (BOOL)updateContentStatus :(NSString *)strId;

- (BOOL)updateThumbnailImgStatus :(NSString *)strId parentCategory:(NSString*)strParentCategory;

- (void) deleteLocalContent:(NSString*)idContent :(NSString*)idProduct :(NSString*)idCatalog :(NSString*)Path :(NSString*)type;
- (void)deleteFromDownload:(NSString *)strId;
//- (NSMutableArray *)getImagePathArrayForProductID:(NSString *)productID ;
- (NSMutableArray *)getContentsForProductID:(NSString *)productID:(NSString *)contentType;
@end
