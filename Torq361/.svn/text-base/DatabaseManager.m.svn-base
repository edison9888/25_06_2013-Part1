//
//  DatabaseManager.m
//  Torq361
//
//  Created by Binoy on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DatabaseManager.h"

#import "CategoryDetails.h"
#import "ProductDetails.h"
#import "RequestDetails.h"
#import "MediaDownloader.h"
#import "UserCredentials.h"
#import "ContentDetails.h"

@implementation DatabaseManager

@synthesize m_objSqlite;

static __weak id<DatabaseManagerDelegate> _delegate;

static DatabaseManager * _sharedManager;

- (void)dealloc {
	
	[_sharedManager release];
	[super dealloc];
}

+ (id)delegate {
	
    return _delegate;
}

+ (void)setDelegate:(id)newDelegate {
	
    _delegate = newDelegate;	
}

+ (DatabaseManager*)sharedManager
{
	@synchronized(self) {
		
        if (_sharedManager == nil) {
			
            [[[self alloc] init]autorelease]; 
			
			_sharedManager.m_objSqlite = [[Sqlite alloc] init];
			
		}
	}
    return _sharedManager;
}


#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone

{	
    @synchronized(self) {
		
        if (_sharedManager == nil) {
			
            _sharedManager = [super allocWithZone:zone];
			
            return _sharedManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;	
}

#pragma mark -
#pragma mark Database Initialization Methods

- (BOOL) CREATEDATABASE :(NSString*)dbName {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];   
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
	if (![m_objSqlite open:writableDBPath])
		return NO;
	
	NSArray *arrSqliteMaster;
	arrSqliteMaster = [m_objSqlite executeQuery:@"SELECT * FROM sqlite_master;"];
	
	//Checking Table Count
	if([arrSqliteMaster count] == 0) {
		
		NSLog(@"No Database exist");
		
		[self CREATETABLES];
		
		[self INSERT_VERSION_NUMBER];
		
		[self INSERT_VALUES_TO_SYNC_TABLE];
		
		return YES;
	}	
	
	NSLog(@"Database exist");
	
	return NO;
}


-(void)removeOldDbAndCreateNewOne{
	
	[self deleteDB:@"Torq361.db"];
	
	[self CREATEDATABASE:@"Torq361.db"];
	
}

-(void)deleteDB:(NSString *)filename{
	
	// For error information
	NSError *error;
	// Create file manager
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	
	// Point to Document directory
	NSString *documentsDirectory = [NSHomeDirectory() 
									stringByAppendingPathComponent:@"Documents"];			
	
	
	NSString *filePath = [documentsDirectory 
						  stringByAppendingPathComponent:filename];
	
	if ([fileMgr removeItemAtPath:filePath error:&error] != YES)
		NSLog(@"Unable to delete file: %@", [error localizedDescription]);
	
	// Show contents of Documents directory
	NSLog(@"Documents directory: %@",
		  [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
}


//Copy Db to document folder if Db not found

- (void)COPY_DB_TO_DOCUMENT_FOLDER {
	
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"Torq361.db"];
    
	success = [fileManager fileExistsAtPath:writableDBPath];
    
	if (success) return;
    
	// The database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Torq361.db"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
	if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
	
}

-(BOOL)checkForVersionTable:(float)fVersion {
	
	float fVersionNumber=0.0f;
	
	NSArray *results = [m_objSqlite executeQuery: @"SELECT name FROM sqlite_master WHERE type='table' AND name='Version';"];  
    for (NSDictionary *dictionary in results) {
		NSString *strcount  =  [dictionary objectForKey:@"name"];
		if([strcount isEqualToString:@"Version"]){
			
			NSArray *tmpResults = [m_objSqlite executeQuery:@"SELECT version from Version;"];
			
			for (NSDictionary *tmpDictionary in tmpResults) {
				
				fVersionNumber = [[tmpDictionary objectForKey:@"version"] floatValue];
				
				if (fVersionNumber < fVersion) {
					
					return NO;    // current app version is higher, so replace the DB
					
				}
				else {
					
					return YES;  // Don't replace the DB
					
				}
				
			}
			
		}
		else {
			
			return NO; // No version table exists, so replace the DB
		}
		
    }   
	
	return NO;  // No version table exists, so replace the DB
	
}


- (void) CREATETABLES {
	

	
	//New Table 
	
	// Version Table
	[m_objSqlite executeNonQuery:@"CREATE TABLE Version (version TEXT);"];
	
	//Catalog Table
	[m_objSqlite executeNonQuery:@"CREATE TABLE Catalog (idCatalog INTEGER NOT NULL PRIMARY KEY,Name VARCHAR(45) NOT NULL,Description VARCHAR(100) NULL,ThumbNailImgPath VARCHAR(150),ValidityFromDate TIMESTAMP NULL,ValidityToDate TIMESTAMP NULL,Active integer, Deleted integer DEFAULT 0, ThumbNailImgStatus text DEFAULT N);"];

	// Category Table
	/*[m_objSqlite executeNonQuery:@"CREATE TABLE Category (idCategory INTEGER PRIMARY KEY NOT NULL,idCatalog INTEGER NOT NULL,idParentCategory INTEGER NOT NULL,Name VARCHAR(50) NOT NULL,Description VARCHAR(100) NOT NULL,ThumbNailImgPath VARCHAR(150) NOT NULL, Deleted integer DEFAULT 0, Active integer, ThumbNailImgStatus text DEFAULT N, FOREIGN KEY(idCatalog) REFERENCES Catalog(idCatalog));"];*/
    [m_objSqlite executeNonQuery:@"CREATE TABLE Category (idCategory INTEGER PRIMARY KEY NOT NULL,idCatalog INTEGER NOT NULL,idParentCategory INTEGER NULL,Name VARCHAR(50) NOT NULL,Description VARCHAR(100) NULL,ThumbNailImgPath VARCHAR(150) NULL, Deleted integer DEFAULT 0, Active integer, ThumbNailImgStatus text DEFAULT N);"];
    
	
	// Content Table
	/*/[m_objSqlite executeNonQuery:@"CREATE TABLE Content (idContent INTEGER NOT NULL PRIMARY KEY,idProduct INTEGER NOT NULL,idCatalog INTEGER NOT NULL,Path text,Type text,Deleted integer DEFAULT 0, ContentImgStatus text DEFAULT N);"];*/
    [m_objSqlite executeNonQuery:@"CREATE TABLE Content (idContent INTEGER NOT NULL PRIMARY KEY,idProduct INTEGER NOT NULL,idCatalog INTEGER NOT NULL,Path text NOT NULL,Type text NOT NULL,Deleted integer DEFAULT 0, ContentImgStatus text DEFAULT N);"];
	
	// Product
	/*[m_objSqlite executeNonQuery:@"CREATE TABLE Product (idProduct INTEGER NOT NULL PRIMARY KEY,idCategory INTEGER NOT NULL,Name VARCHAR(45) NOT NULL,Description VARCHAR(500) NOT NULL,ThumbNailImgPath VARCHAR(150) NOT NULL,LastModified TIMESTAMP NOT NULL,Deleted integer DEFAULT 0,Active integer,ThumbNailImgStatus text DEFAULT N);"];*/
    [m_objSqlite executeNonQuery:@"CREATE TABLE Product (idProduct INTEGER NOT NULL PRIMARY KEY,idCategory INTEGER NOT NULL,Name VARCHAR(45) NOT NULL,Description VARCHAR(500) NULL,productDetails VARCHAR(2000) NULL,technicalDetails VARCHAR(2000) NULL,ThumbNailImgPath VARCHAR(150) NULL,LastModified TIMESTAMP NOT NULL,Deleted integer DEFAULT 0,Active integer,ThumbNailImgStatus text DEFAULT N);"];
	
	// SyncTable
	[m_objSqlite executeNonQuery:@"CREATE TABLE SyncTable (TableName VARCHAR(20) NOT NULL,LastModified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP);"];
	
	//Download table
	[m_objSqlite executeNonQuery:@"CREATE TABLE download (content_type varchar(10),id integer PRIMARY KEY,content_path varchar(200),thumbnail_path varchar(200),title varchar(100),tmp_path varchar(200),download_status varchar(20), roll_id integer);"];
	
}


#pragma mark -

#pragma mark INSERT METHODS

- (void) INSERT_VERSION_NUMBER {
	
	[m_objSqlite executeNonQuery:@"INSERT INTO Version (version) VALUES(?);", @"1.0"];
	
}

- (void) INSERT_VALUES_TO_SYNC_TABLE {
	
	
	// Insert values in SyncTable with some older LastModified date
	
	[m_objSqlite executeNonQuery:@"INSERT INTO SyncTable (TableName,LastModified) VALUES(?,?);", @"Catalogs",@"2010-06-08 17:17:00"];
	
	[m_objSqlite executeNonQuery:@"INSERT INTO SyncTable (TableName,LastModified) VALUES(?,?);", @"Category",@"2010-06-08 17:17:00"];
	
	[m_objSqlite executeNonQuery:@"INSERT INTO SyncTable (TableName,LastModified) VALUES(?,?);", @"Product",@"2010-06-08 17:17:00"];
	
	[m_objSqlite executeNonQuery:@"INSERT INTO SyncTable (TableName,LastModified) VALUES(?,?);", @"ProductContent",@"2010-06-08 17:17:00"];
	
	
	
}

-(void)resetDatabase{
    [m_objSqlite executeNonQuery:@"DELETE FROM Catalog"];
    [m_objSqlite executeNonQuery:@"DELETE FROM Category"];
    [m_objSqlite executeNonQuery:@"DELETE FROM Content"];
    [m_objSqlite executeNonQuery:@"DELETE FROM Product"];
    [m_objSqlite executeNonQuery:@"DELETE FROM SyncTable"];
    [m_objSqlite executeNonQuery:@"DELETE FROM download"];
    [self INSERT_VALUES_TO_SYNC_TABLE];
}



// Insert Values to Catalog Table

- (void) insertIntoSyncTable:(NSString *)tableName :(NSString *)lastModified {
	
	[m_objSqlite executeNonQuery:@"UPDATE SyncTable set LastModified = ? where TableName = ?;", lastModified, tableName];
	
}

// Insert Values to Catalog Table

- (void) insertIntoCatalogTable:(NSString *)idCatalog :(NSString *)name :(NSString *)description :(NSString *)thumbnailImgPath :(NSString *)validityFromDate :(NSString *)validityToDate :(NSString *)active :(NSString *)deleted {
	
	
	if ([deleted intValue] == 1 || [active intValue] == 0) {  
		
		// Delete the already existing entry
		
		[m_objSqlite executeNonQuery:@"DELETE FROM Catalog WHERE  idCatalog = ?",idCatalog];
	}
	
	else {
		
		if ([self checkForEntryWithID:@"idCatalog" withValue:idCatalog inTable:@"Catalog"]) {
			
			// Update the already existing entry
			
			[m_objSqlite executeNonQuery:@"UPDATE Catalog set Name = ?, Description = ?, ThumbNailImgPath = ?, ValidityFromDate = ?, ValidityToDate = ?, Active=?  where idCatalog = ?;",name,description,thumbnailImgPath,validityFromDate,validityToDate,active,idCatalog];
			
		}
		
		else {
			
			// New entry, So insert the entry
			
			[m_objSqlite executeNonQuery:@"INSERT INTO Catalog (idCatalog,Name,Description,ThumbNailImgPath,ValidityFromDate,ValidityToDate,Active) VALUES(?,?,?,?,?,?,?);",idCatalog,name,description,thumbnailImgPath,validityFromDate,validityToDate,active];
			
		}

	}

}

// Insert Values to Category Table

- (void) insertInToCategoryTable:(NSString *)idCategory :(NSString *)idCatalog :(NSString *)idParentCategory :(NSString *)name :(NSString *)description :(NSString *)thumbNailImgPath :(NSString *)active :(NSString *)deleted {
	
	
	if ([deleted intValue] == 1 || [active intValue] == 0) {  
		
		// Delete the already existing entry
		
		[m_objSqlite executeNonQuery:@"DELETE FROM Category WHERE  idCategory = ?",idCategory];
	}
	
	else {
		
		if ([self checkForEntryWithID:@"idCategory" withValue:idCategory inTable:@"Category"]) {
			
			// Update the already existing entry
			
			[m_objSqlite executeNonQuery:@"UPDATE Category set idCatalog = ?, idParentCategory = ?, Name = ?, Description = ?, ThumbNailImgPath = ?, Active=?  where idCategory = ?;",idCatalog,idParentCategory,name,description,thumbNailImgPath,active,idCategory];
			
		}
		
		else {
			
			// New entry, So insert the entry
			
			[m_objSqlite executeNonQuery:@"INSERT INTO Category (idCategory,idCatalog,idParentCategory,Name,Description,ThumbNailImgPath,Active) VALUES(?,?,?,?,?,?,?);",idCategory,idCatalog,idParentCategory,name,description,thumbNailImgPath,active];
			
			
		}
			
	}
}
	


// Insert Values to Product Table

- (void) insertIntoProductTable:(NSString *)idProduct :(NSString *)name :(NSString *)description : (NSString*)prodDesc :(NSString*)techDesc : (NSString *)thumbnailImgPath :(NSString *)idCategory :(NSString *)lastModified :(NSString *)active :(NSString *)deleted {

	
	if ([deleted intValue] == 1 || [active intValue] == 0) {  
		
		// Delete the already existing entry
		
		[m_objSqlite executeNonQuery:@"DELETE FROM Product WHERE  idProduct = ?",idProduct];
	}
	
	else {
		
		if ([self checkForEntryWithID:@"idProduct" withValue:idProduct inTable:@"Product"]) {
			
			// Update the already existing entry
			
			[m_objSqlite executeNonQuery:@"UPDATE Product set idCategory = ?, Name = ?, Description = ?,productDetails = ?,technicalDetails = ?,ThumbNailImgPath = ?, LastModified = ?, Active=?  where idProduct = ?;",idCategory,name,description,prodDesc,techDesc,thumbnailImgPath,lastModified,active,idProduct];
			
		}
		
		else {
			
			// New entry, So insert the entry
			
			[m_objSqlite executeNonQuery:@"INSERT INTO Product (idProduct,idCategory,Name,Description,productDetails,technicalDetails,ThumbNailImgPath,LastModified,Active) VALUES(?,?,?,?,?,?,?,?,?);",idProduct,idCategory,name,description,prodDesc,techDesc,thumbnailImgPath,lastModified,active];
			
		}
		
	}

}


// Insert Values to Content Table

- (void) insertInToContentTable:(NSString *)idContent :(NSString *)idProduct :(NSString *)idCatalog :(NSString *)Path :(NSString *)type :(NSString *)videoPath :(NSString *)deleted {

	/*if([type isEqualToString:@"video"]){
	
		
		Path = @"http://ec2-174-129-59-74.compute-1.amazonaws.com:8084/Torq361Contents/Company1/ProductContent/Potrait/video/video_1_4.mov";
		
		//Path = @"http://ec2-174-129-59-74.compute-1.amazonaws.com:8084/Torq361Contents/Company1/ProductContent/Potrait/video/video_1_6.mov";
		
	}*/
	
	if ([deleted intValue] == 1) {  
		
		// Delete the already existing entry
		
		[m_objSqlite executeNonQuery:@"DELETE FROM Content WHERE  idContent = ?;",idContent];
		
		[self deleteLocalContent:idContent :idProduct :idCatalog :Path :type];
		
	}
	
	else {
		
		if ([self checkForEntryWithID:@"idContent" withValue:idContent inTable:@"Content"]) {
						
			// Update the already existing entry
			
			[m_objSqlite executeNonQuery:@"UPDATE Content set idProduct = ?, idCatalog = ?, Path = ?, Type = ?, ContentImgStatus='N'  where idContent = ?;",idProduct,idCatalog,Path,type,idContent];
			[self deleteLocalContent:idContent :idProduct :idCatalog :Path :type ];
		}
		
		else {
			
			// New entry, So insert the entry
			
			[m_objSqlite executeNonQuery:@"INSERT INTO Content (idContent,idProduct,idCatalog,Path,Type) VALUES(?,?,?,?,?);",idContent,idProduct,idCatalog,Path,type];
			
			// delete the saved contents, as its upadates
			
			
			
		}
	}

}



//Insert to download
-(BOOL)insertInToDownload:(NSString*)strContent_type :(NSString*)strId :(NSString*)strContent_path :(NSString*)strThumbnail_path :(NSString*)strTitle :(NSString*)strTmp_path :(NSString *)strDownloadStatus :(NSString *)strRollId{
    
    if ([self checkForEntryWithID:@"id" withValue:strId inTable:@"download"]){
        if([m_objSqlite executeNonQuery:@"UPDATE download set content_type=?,content_path=?,thumbnail_path=?,title=?,tmp_path=?,download_status=?,roll_id=? where id=?;",strContent_type,strContent_path,strThumbnail_path,strTitle,strTmp_path,strDownloadStatus,strRollId,strId]){
            return YES;
    }else
        
        if([m_objSqlite executeNonQuery:@"INSERT INTO download (content_type,id,content_path,thumbnail_path,title,tmp_path,download_status,roll_id) VALUES(?,?,?,?,?,?,?,?);",strContent_type,strId,strContent_path,strThumbnail_path,strTitle,strTmp_path,strDownloadStatus,strRollId]){
            return YES;
        }
    }
	return NO;
}



#pragma mark -

#pragma mark SELECT METHODS

//Get thumbimage

-(NSMutableArray *)getthumbimage:(NSString *)strTable{
	NSMutableArray *tmpArr=[[NSMutableArray alloc] init];
	
	RequestDetails *obj_RequestDetails;
	
	NSArray *results;
	
	if ([strTable isEqualToString:@"Catalog"]) {
		results = [m_objSqlite executeQuery:@"SELECT * from Catalog where ThumbNailImgStatus='N';"];
	}
	else if ([strTable isEqualToString:@"Category"]) {
		results = [m_objSqlite executeQuery:@"SELECT * from Category where ThumbNailImgStatus='N';"];
	}
	else if ([strTable isEqualToString:@"Product"]) {
		results = [m_objSqlite executeQuery:@"SELECT * from Product where ThumbNailImgStatus='N';"];
	}
	//NSArray *results = [m_objSqlite executeQuery:@"SELECT * from Category where idParentCategory=?;",[NSString stringWithFormat:@"%d",parentID]];
	
	for (NSDictionary *dictionary in results) {
		
		obj_RequestDetails = [[RequestDetails alloc] init];
		
		obj_RequestDetails.strContentType=strTable;
		obj_RequestDetails.strContentUrl=[dictionary objectForKey:@"ThumbNailImgPath"];
		
		if ([strTable isEqualToString:@"Catalog"]) {
			obj_RequestDetails.contentID=[[dictionary objectForKey:@"idCatalog"] intValue];
		}
		else if ([strTable isEqualToString:@"Category"]) {
			obj_RequestDetails.contentID=[[dictionary objectForKey:@"idCategory"] intValue];
		}
		else if ([strTable isEqualToString:@"Product"]) {
			obj_RequestDetails.contentID=[[dictionary objectForKey:@"idProduct"] intValue];
		}
		
		[tmpArr addObject:obj_RequestDetails];
		
		[obj_RequestDetails release];
	}
    
  /*  if(m_objResultArray){
        //[m_objResultArray removeAllObjects];
        [m_objResultArray release];
        m_objResultArray=nil;
    }
	
	m_objResultArray=[tmpArr mutableCopy];
	
	[tmpArr release];
	
	return m_objResultArray;*/
    
    return [tmpArr autorelease];
}

//Get All items for Auto Download

-(NSMutableArray *)getDownloadAllMedia:(NSString*)str_query{			
	//if(iChoice==0){
	NSMutableArray *tmpArr=[[NSMutableArray alloc] init];
	
	NSArray *results = [m_objSqlite executeQuery:str_query];
	for (NSDictionary *dictionary in results)
	{
		MediaDownloader *obj_MediaDownloader=[[MediaDownloader alloc] init];
		obj_MediaDownloader.strContentID = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"idContent"]];
		obj_MediaDownloader.strProductID = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"idProduct"]];
		obj_MediaDownloader.strCatalogID = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"idCatalog"]];
		obj_MediaDownloader.strType= [dictionary objectForKey:@"Type"];
		obj_MediaDownloader.strDownloadURL = [dictionary objectForKey:@"Path"];
		
		[tmpArr addObject:obj_MediaDownloader];
		[obj_MediaDownloader release];
		
	}
    
  /*  if(m_objResultArray){
        //[m_objResultArray removeAllObjects];
        [m_objResultArray release];
        m_objResultArray=nil;
    }
	m_objResultArray=[tmpArr mutableCopy];
	[tmpArr release];
	//}	
	return m_objResultArray;*/
    
    return [tmpArr autorelease];
	
}


// Get Sync Table Details

- (NSMutableArray *)getSyncTables {
	
	NSArray *results = [m_objSqlite executeQuery:@"SELECT TableName, LastModified FROM SyncTable;"];
	
	NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:results];
    
 /*   if(m_objResultArray){
       // [m_objResultArray removeAllObjects];
        [m_objResultArray release];
        m_objResultArray=nil;
    }
	
	m_objResultArray=[tmpArray mutableCopy];
	
	[tmpArray release];
	
	return m_objResultArray;*/	
    return [tmpArray autorelease];
}


// Get Category Details based on parent category id

-(NSMutableArray*)getCategoryByParentID:(int)parentID {
	
	NSMutableArray *tmpArr=[[NSMutableArray alloc] init];
	
	CategoryDetails *categoryDetails;
	
	NSArray *results;
	
	NSString *temp = @"";
	
	if (parentID == 0) {
		
		results = [m_objSqlite executeQuery:@"SELECT * from Category where idParentCategory=?;",[NSString stringWithFormat:@"%@",temp]];		
	
	}
	
	else {
	
		results = [m_objSqlite executeQuery:@"SELECT * from Category where idParentCategory=?;",[NSString stringWithFormat:@"%d",parentID]];//,@"",temp];//[m_objSqlite executeQuery:@"SELECT * from Category where idCatalog=?;",[NSString stringWithFormat:@"%d",parentID]];ParentCategory(In previous cases)
	
	}
	
	for (NSDictionary *dictionary in results) {
		
		categoryDetails = [[CategoryDetails alloc] init];
		
		categoryDetails.idCategory = [dictionary objectForKey:@"idCategory"];
		categoryDetails.idCatalog = [dictionary objectForKey:@"idCatalog"];
		categoryDetails.idParentCategory = [dictionary objectForKey:@"idParentCategory"];
		categoryDetails.Name = [dictionary objectForKey:@"Name"];
		categoryDetails.Description = [dictionary objectForKey:@"Description"];
		categoryDetails.ThumbNailImgPath = [dictionary objectForKey:@"ThumbNailImgPath"];
		
		[tmpArr addObject:categoryDetails];
		
		[categoryDetails release];
	}
	
  /*  if(m_objResultArray){
       // [m_objResultArray removeAllObjects];
        [m_objResultArray release];
        m_objResultArray=nil;
    }
	m_objResultArray=[tmpArr mutableCopy];
	
	[tmpArr release];
	
	return m_objResultArray;*/
    return [tmpArr autorelease];
}


// Get Product Details based on category id


- (NSMutableArray*)getProductByCategoryID:(NSMutableArray *)proArray {
	
	//NSMutableArray *objResultArray;
    NSMutableArray *objResultArray=[[NSMutableArray alloc ]init ];
	
	for (int j=0;j<[proArray count];j++) {
		
		//[objResultArray addobject :[self getBottomLevelCategoriesUnderCategoryID:[NSString stringWithFormat:@"%d",[[proArray objectAtIndex:j] intValue]]];
		//[objResultArray retain];
        
        NSMutableArray *bottomLevelCetegories=[self getBottomLevelCategoriesUnderCategoryID:[NSString stringWithFormat:@"%d",[[proArray objectAtIndex:j]intValue]]];
        if(bottomLevelCetegories){
            [objResultArray addObject:bottomLevelCetegories];
        }
	}
	
	NSString *categoryList = @"";
	
	categoryList = [categoryList stringByAppendingFormat:@"%@",[objResultArray objectAtIndex:0]];
					
	for (int i=1 ; i < [objResultArray count]; ++i) {
		
		//For select IN[values]
		categoryList = [categoryList stringByAppendingFormat:@",%@",[objResultArray objectAtIndex:i]];
		
	}
	
	//[m_objResultArray removeAllObjects];
	[objResultArray release];
    objResultArray=nil;
	
	NSString *query = [NSString stringWithFormat:@"SELECT * from Product where idCategory IN (%@) ORDER BY LastModified desc;",categoryList];
	
	NSMutableArray *tmpArr=[[NSMutableArray alloc] init];
	
	ProductDetails *productDetails;
	
	NSArray *results = [m_objSqlite executeQuery:query];
	
	for (NSDictionary *dictionary in results) {
		
		productDetails = [[ProductDetails alloc] init];
		
        if([dictionary objectForKey:@"idProduct"]==nil||[[dictionary objectForKey:@"idProduct"] isEqual:[NSNull null]]){
            productDetails.idProduct = @"";
        }else{
            productDetails.idProduct = [dictionary objectForKey:@"idProduct"];
        }
       
        if([dictionary objectForKey:@"idCategory"]==nil||[[dictionary objectForKey:@"idCategory"] isEqual:[NSNull null]]){
            productDetails.idCategory = @"";
        }else{
            productDetails.idCategory = [dictionary objectForKey:@"idCategory"];
        }
        
        if([dictionary objectForKey:@"Name"]==nil||[[dictionary objectForKey:@"Name"] isEqual:[NSNull null]]){
            productDetails.Name=@"";
        }else{
            productDetails.Name = [dictionary objectForKey:@"Name"];
        }
		
        
        if([[dictionary objectForKey:@"Description"] isEqual:[NSNull null]]){
            productDetails.Description =@"";
        }else{
            productDetails.Description = [dictionary objectForKey:@"Description"];
        }
        
        if([dictionary objectForKey:@"ThumbNailImgPath"]==nil||[[dictionary objectForKey:@"ThumbNailImgPath"] isEqual:[NSNull null]]){
            productDetails.ThumbNailImgPath=@"";
        }else{
            productDetails.ThumbNailImgPath = [dictionary objectForKey:@"ThumbNailImgPath"];
        }
        if([dictionary objectForKey:@"productDetails"]==nil||[[dictionary objectForKey:@"productDetails"] isEqual:[NSNull null]]){
            productDetails.prodDetails=@"";
        }else{
            productDetails.prodDetails= [dictionary objectForKey:@"productDetails"];
        }
        if([dictionary objectForKey:@"technicalDetails"]==nil||[[dictionary objectForKey:@"technicalDetails"] isEqual:[NSNull null]]){
            productDetails.techDetails=@"";
        }else{
            productDetails.techDetails= [dictionary objectForKey:@"technicalDetails"];
        }
		
		[tmpArr addObject:productDetails];
		[productDetails release];
	}
	
  /*  if(m_objResultArray){
        //[m_objResultArray removeAllObjects];
        [m_objResultArray release];
        m_objResultArray=nil;
    }
	m_objResultArray=[tmpArr mutableCopy];
	
	[tmpArr release];
	
	return m_objResultArray;*/
    return [tmpArr autorelease];
}

// Get list of bottom level categories under a specified category

- (NSMutableArray*)getBottomLevelCategoriesUnderCategoryID:(NSString *)categoryID {
	
    NSMutableArray *objResultArray=[[NSMutableArray alloc]init ];
	[objResultArray addObject:categoryID];
	
	NSArray *results = [m_objSqlite executeQuery:@"SELECT idCategory from Category where idParentCategory = ?;",categoryID];
	
/*	if ([results count] == 0) {
		
		//bottom level category, so add to array
		
		//[m_objResultArray addObject:categoryID];
		
		return;
	}*/
	
	for (NSDictionary *dictionary in results) {
	
		[self getBottomLevelCategoriesUnderCategoryID:[NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"idCategory"] intValue]]];
				
	}
	return [objResultArray autorelease];
}
 
/////////////////////////////////////////////////////////


// Checks whether an entry with a specified id is present in the specified table

- (BOOL)checkForEntryWithID :(NSString *)uniqueID withValue:(NSString *)value inTable:(NSString *)tableName {
	
	NSString *query = [NSString stringWithFormat:@"SELECT %@ from %@ where %@ = %@;",uniqueID,tableName,uniqueID,value];
	
	//NSLog(@"Query : %@",query);
	
	NSArray *results=[m_objSqlite executeQuery:query];
	
	for (NSDictionary *dictionary in results) {	
	
		NSLog(@"Entry Exists : %@",[dictionary objectForKey:uniqueID]);
		
		return YES;	
	}
	
	return NO;
	
}

// Returns the Category Name of the specified category ID.

- (NSString *)getCategoryNameWithID:(int)categoryID {

	NSArray *results = [m_objSqlite executeQuery:@"SELECT Name from Category where idCategory=?;",[NSString stringWithFormat:@"%d",categoryID]];
	
	for (NSDictionary *dictionary in results) {
		
		return [dictionary objectForKey:@"Name"];
		
	}
	
	return @"";
	
}

//Returns the category Id of the specified category Name

-(NSString*)getCategoryIDWithCategoryName:(NSString *)catName {

	NSArray *result=[m_objSqlite executeQuery:@"SELECT idCategory from Category where Name=?;",catName];

	for (NSDictionary *dictionary in result) {
		
		return [dictionary objectForKey:@"idCategory"];
	}
	return @"";
}



- (NSMutableArray *)getImagePathArrayForProductID:(NSString *)productID {
	
	NSString *temp = productID;// productDetails.idProduct;
	
	NSLog(@"product id is%@",temp);
	
	NSMutableArray *tmpArr=[[NSMutableArray alloc] init];
	
	NSArray *results = [m_objSqlite executeQuery:@"SELECT Path FROM Content WHERE idProduct = ? and Type = ?;",productID,@"image"];
	
	//NSArray *results = [m_objSqlite executeQuery:@"SELECT ImagePath FROM Content WHERE idProduct = ? and ImagePath != ?;",productID,@"NULL"];
	
	for (NSDictionary *dictionary in results) {
		
		[tmpArr addObject:[dictionary objectForKey:@"Path"]];
		
		//[tmpArr addObject:[dictionary objectForKey:@"ImagePath"]];
		
	}
	
    /*if(m_objResultArray){
       // [m_objResultArray removeAllObjects];
        [m_objResultArray release];
        m_objResultArray=nil;
    }
	m_objResultArray=[tmpArr mutableCopy];
	
	[tmpArr release];
	
	return m_objResultArray;*/
    return [tmpArr autorelease];
}


 


- (NSMutableArray *)getContentsForProductID:(NSString *)productID:(NSString *)contentType {
	
	NSString *temp = productID;// productDetails.idProduct;
	
	NSLog(@"product id is%@",temp);
	
	NSMutableArray *tmpArr=[[NSMutableArray alloc] init];
	
	NSArray *results = [m_objSqlite executeQuery:@"SELECT idContent,idProduct,idCatalog,Path,Type FROM Content WHERE idProduct = ? and Type = ?;",productID,contentType];
	
	//NSArray *results = [m_objSqlite executeQuery:@"SELECT ImagePath FROM Content WHERE idProduct = ? and ImagePath != ?;",productID,@"NULL"];
    ContentDetails *contentDetails;
	for (NSDictionary *dictionary in results) {
		
        contentDetails=[[ContentDetails alloc] init];
        contentDetails.idContent= [[dictionary objectForKey:@"idContent"] intValue];
        contentDetails.idProduct= [[dictionary objectForKey:@"idProduct"] intValue];
        contentDetails.idCatalog= [[dictionary objectForKey:@"idCatalog"] intValue];
        contentDetails.Path= [dictionary objectForKey:@"Path"];
        contentDetails.Type= [dictionary objectForKey:@"Type"];
        
        [tmpArr addObject:contentDetails];
		
		[contentDetails release];
        
    }
	/*if(m_objResultArray){
        //[m_objResultArray removeAllObjects];
        [m_objResultArray release];
        m_objResultArray=nil;
    }
	m_objResultArray=[tmpArr mutableCopy];
	
	[tmpArr release];
	
	return m_objResultArray;*/
    return [tmpArr autorelease];

    
}






- (NSMutableArray *)getPDFPathArrayForProductID:(NSString *)productID {
	
	NSMutableArray *tmpArr=[[NSMutableArray alloc] init];
	
	NSArray *results = [m_objSqlite executeQuery:@"SELECT Path FROM Content WHERE idProduct = ? and Type = ?;",productID,@"pdf"];
	
	//NSArray *results = [m_objSqlite executeQuery:@"SELECT PDFPath FROM Content WHERE idProduct = ? and PDFPath != ?;",productID,@"NULL"];
	
	for (NSDictionary *dictionary in results) {
		
		[tmpArr addObject:[dictionary objectForKey:@"Path"]];
		 
	}
/*	if(m_objResultArray){
       // [m_objResultArray removeAllObjects];
        [m_objResultArray release];
        m_objResultArray=nil;
    }
	m_objResultArray=[tmpArr mutableCopy];
	
	[tmpArr release];
	
	return m_objResultArray;*/
    return [tmpArr autorelease];
		 
}

- (NSMutableArray *)getVideoPathArrayForProductID:(NSString *)productID {
	
	NSMutableArray *tmpArr=[[NSMutableArray alloc] init];
	
	NSArray *results = [m_objSqlite executeQuery:@"SELECT Path FROM Content WHERE idProduct = ? and Type = ?;",productID,@"video"];
	
	//NSArray *results = [m_objSqlite executeQuery:@"SELECT VideoPath FROM Content WHERE idProduct = ? and VideoPath != ?;",productID,@"NULL"];
	
	for (NSDictionary *dictionary in results) {
		
		[tmpArr addObject:[dictionary objectForKey:@"Path"]];
		
	}
/*	if(m_objResultArray){
       // [m_objResultArray removeAllObjects];
        [m_objResultArray release];
        m_objResultArray=nil;
    }
	m_objResultArray=[tmpArr mutableCopy];
	
	[tmpArr release];
	
	return m_objResultArray;
*/
    return [tmpArr autorelease];
		 		 
	
}

#pragma mark Update Methods

- (BOOL)updateDownloadStatusInToDownload :(NSString *)strId :(NSString *)strStatus {
	if([m_objSqlite executeNonQuery:@"update download set download_status=? where id=?;",strStatus,strId]){
		return YES;
	}
	return NO;
}

- (BOOL)updateContentStatus :(NSString *)strId {
	if([m_objSqlite executeNonQuery:@"update Content set ContentImgStatus='Y' where idContent=?;",strId]){
		return YES;
	}
	return NO;
}



- (BOOL)updateThumbnailImgStatus :(NSString *)strId parentCategory:(NSString*)strParentCategory {
    
    if(strParentCategory==@"Category"){
        if([m_objSqlite executeNonQuery:@"update Category set ThumbNailImgStatus='Y' where idCategory=?;",strId]){
            return YES;
        }
    }
    else if(strParentCategory==@"Product"){
        if([m_objSqlite executeNonQuery:@"update Product set ThumbNailImgStatus='Y' where idProduct=?;",strId]){
            return YES;
        }
    }
    else if(strParentCategory==@"Catalog"){
        if([m_objSqlite executeNonQuery:@"update Catalog set ThumbNailImgStatus='Y' where idCatalog=?;",strId]){
            return YES;
        }
    }
	return NO;
}

#pragma mark -

#pragma mark DELETE METHODS

-(void) clearTablesForNewCompany {
	
	[m_objSqlite executeNonQuery:@"DELETE * FROM Catalog"];
	
	[m_objSqlite executeNonQuery:@"DELETE * FROM Category"];
	
	[m_objSqlite executeNonQuery:@"DELETE * FROM Product"];
	
	[m_objSqlite executeNonQuery:@"DELETE * FROM Content"];
	
	[m_objSqlite executeNonQuery:@"DELETE * FROM SyncTable"];
	
	[self INSERT_VALUES_TO_SYNC_TABLE];
	
	
}

-(void) clearTablesForNewRollid {
	
	[m_objSqlite executeNonQuery:@"DELETE * FROM Product"];
	
	[m_objSqlite executeNonQuery:@"DELETE * FROM Content"];
	
	// Update the LastModified date of Product and Content in SyncTable to a older value
	
	[m_objSqlite executeNonQuery:@"UPDATE SyncTable set LastModified = ? where TableName = ?;",@"2010-06-08 17:17:00",@"Content"]; 
	
	[m_objSqlite executeNonQuery:@"UPDATE SyncTable set LastModified = ? where TableName = ?;",@"2010-06-08 17:17:00",@"Product"];
	
}

#pragma mark -

-(void)deleteFromDownload:(NSString *)strId{
	[m_objSqlite executeNonQuery:@"DELETE from download where id=?;",strId];
}


- (void) deleteLocalContent:(NSString*)idContent :(NSString*)idProduct :(NSString*)idCatalog :(NSString*)Path :(NSString*)type {
	
	// delete the contents from local folder, as it has been modified or deleted
	
	NSError *error;
	NSString *strCompanyID=[[UserCredentials sharedManager] getCompanyID];
	
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [paths objectAtIndex:0];
	
	NSString *strCompanyId= [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",@"CompanyId",strCompanyID]];
	NSString *strdownloadPath=@"";
	if([type isEqualToString:@"image"]){
		strdownloadPath=[strCompanyId stringByAppendingPathComponent:@"ProductContent/Portrait/image"];
	}
	if([type isEqualToString:@"pdf"]){
		strdownloadPath=[strCompanyId stringByAppendingPathComponent:@"ProductContent/Portrait/pdf"];
	}
	if([type isEqualToString:@"video"]){
		strdownloadPath=[strCompanyId stringByAppendingPathComponent:@"ProductContent/Portrait/video"];
	}
	
	
	NSArray *objExtension = [Path componentsSeparatedByString:@"."];
	
	strdownloadPath = [NSString stringWithFormat:@"%@/%@_%@_%@.%@",strdownloadPath,type,strCompanyID,idContent,[objExtension lastObject]];
	
	
	
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:strdownloadPath ]) 
	{
		[[NSFileManager defaultManager] removeItemAtPath:strdownloadPath error:&error];
		
	}
	
}


@end
