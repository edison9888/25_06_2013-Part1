/**************************************************************************************
  File Name      : DBHandler.m
  Project Name   : EC Media
  Description    : N/A
  Version        : 1.0
  Created by     : Naveen Shan
  Created on     : 12/10/10
  Copyright (C) 2010 RapidValue IT Services Pvt. Ltd. All Rights Reserved.
**************************************************************************************/

#import "DBHandler.h"
#import "FMDatabase.h"
//model class list
#import "List.h"
//model class grid
#import "Grid.h"
//model class image
#import "Image.h"
//model class imageDetails
#import "ImageDetails.h"

@implementation DBHandler

@synthesize delegate;

static FMDatabase *database;
static DBHandler *sharedManager;

#pragma mark -
#pragma mark database handles

-(id)init	{
	if([super init])	{
	
		return self;
	}
	else {
		return nil;
	}

}

+(DBHandler *)sharedManager{
    
    if (sharedManager==nil) {
        sharedManager=[[DBHandler alloc]init];
        
    }
    
    return sharedManager;
}



#pragma mark -DataBase creation


+ (BOOL)initializeDatabase {
    
    BOOL bIssuccess;
        
    NSArray *strDirectoryPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *strDocumentDirectory=[strDirectoryPaths objectAtIndex:0];
    NSString *strDatabasePath =[strDocumentDirectory stringByAppendingPathComponent:DATABASENAME];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    bIssuccess = [fileManager fileExistsAtPath:strDatabasePath]; 
		
    //If database is not exist coping the database from the resourses
    if(bIssuccess==NO) {
			
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASENAME];
        bIssuccess = [fileManager copyItemAtPath:defaultDBPath 
											  toPath:strDatabasePath 
											   error:&error];
			
        if (!bIssuccess){ 
				
            //handle error
            DebugLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }	
    database=[[FMDatabase databaseWithPath:strDatabasePath] retain];
    [database setBusyRetryTimeout:0.1];
    [database setLogsErrors:YES];
        
    //If database is not able to open
    if (![database open])	{
			
        DebugLog(@"Failed to open FMDatabase ");
        [database release];
        return NO;
    }
    [database setTraceExecution:YES];
    
    return YES;
}

- (void)beginTransaction{
    [database beginTransaction];    
}

- (void)commitTransaction{
    [database commit];    
}

#pragma mark - INSERT VALUE TO TABLE

- (BOOL)insertMenuItems {
   
    //Now insertion is hardcodded.At the time of synching we need to implement the insert query to the Menu Table
    
    return YES;
}


// list table insertion
- (BOOL)insertList:(NSMutableArray *)results
{
    //[[DBHandler sharedManager] beginTransaction];
    NSAutoreleasePool *poolRelease = [[NSAutoreleasePool alloc] init];
    
    //0 false 1 true
    
    int favoriteValue = 0;
    
    BOOL success=NO;
    
    [NSThread sleepForTimeInterval:10.0];
    
    @synchronized(self)
    {
        for (List *item in results)
        {

            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setFormatterBehavior:NSDateFormatterBehavior10_4];
            [df setDateFormat:@"EEE, dd MMM yy HH:mm:ss VVVV"];
            NSDate *convertedDate = [df dateFromString:item.pubDate];
            [df release];
            
        
            if([database executeUpdate:@"INSERT INTO list (title,link,icon_path,last_build_date,parent_idmenu,content,publish_date,favorite) VALUES(?,?,?,?,?,?,?,?);",item.title,item.link,item.title,item.lastBuildDate,[NSNumber numberWithInt:item.parent_idmenu],item.description,convertedDate,[NSNumber numberWithInt:favoriteValue]])
            {
                for (Image *image in item.images )
                {
                    // listImage table insertion
                    if([database executeUpdate:@"INSERT INTO listImage (type,link,image_local_path,idList) VALUES(?,?,?,?);",[NSNumber numberWithInt:image.imageType],image.imageUrl,@"Pending",[NSNumber numberWithInt:[self getImageListIdentifier]]])
                    {
                        success=YES;
                    }
                }
            }
            
            success=YES;
        }
        
        if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(savedData)])
            [self.delegate savedData];
        
        
        //return YES;
        
        return success;
    }
    
    [poolRelease drain];
}

-(void)completeLongRunningTask{
    // [self performSelectorOnMainThread:@selector(completeLongRunningTask) withObject:nil waitUntilDone:YES];
    }


-(int)getImageListIdentifier{
 
@synchronized(self) {
            
    FMResultSet *resultSet=[database executeQuery:@"select max(idList) from List"];
    
    while ([resultSet next]) {
       
            return [resultSet intForColumn:@"max(idList)"];
        
    }
    return 0;
}
    
}

#pragma mark - select Query

//This will return all the home details, which include its link,id etc....
- (NSMutableArray *)getCasionoItems {
    
//@synchronized(self) {
    
    NSMutableArray *results=[[[NSMutableArray alloc] init]autorelease];
    
    NSString *menuType = @"Location";//idProduct = ? and ImagePath != ?;",productID,@"NULL"];
    FMResultSet *resultSet=[database executeQuery:@"select * from menu where parent_idmenu!=? and type!=?",@"NULL",menuType];
    
    while ([resultSet next]) {
        
        //Grid model class objects
        Grid *grid=[[Grid alloc] init];
        
        grid.idmenu         =[resultSet intForColumn:@"idmenu"];
        grid.type           =[resultSet stringForColumn:@"type"];
        grid.link           =[resultSet stringForColumn:@"link"];
        grid.title          =[resultSet stringForColumn:@"title"];
        //grid.icon_path      =[resultSet stringForColumn:@"icon_path"];
        grid.parent_idmenu  =[resultSet intForColumn:@"parent_idmenu"];
        
        //Adding the grid model class objects
        [results addObject:grid];
        [grid release];
        grid=nil;
        
    }
    return results;
//}
    
}

- (NSMutableArray *)readHomeItems:(NSString *)type {
    
@synchronized(self) {
    
    NSMutableArray *results=[[[NSMutableArray alloc] init]autorelease];
    
    FMResultSet *resultSet=[database executeQuery:@"select * from menu where type=?",type];
    
    while ([resultSet next]) {
        
        //Grid model class objects
        Grid *grid=[[Grid alloc] init];
        
        grid.idmenu         =[resultSet intForColumn:@"idmenu"];
        grid.type           =[resultSet stringForColumn:@"type"];
        grid.link           =[resultSet stringForColumn:@"link"];
        grid.title          =[resultSet stringForColumn:@"title"];
        grid.icon_path      =[resultSet stringForColumn:@"icon_path"];
        grid.parent_idmenu  =[resultSet intForColumn:@"parent_idmenu"];
        
        //Adding the grid model class objects
        [results addObject:grid];
        [grid release];
        grid=nil;
        
    }
    //DebugLog(@"Array with zero count");
   // DebugLog(@"home count %d",[results count]);
    return results;
}
    
}


- (NSMutableArray *)readSubItems:(int)parentID {
    
    
@synchronized(self) {
    
    NSMutableArray *results=[[[NSMutableArray alloc] init]autorelease];
    
    FMResultSet *resultSet=[database executeQuery:@"select * from menu where parent_idmenu=? order by menu_order",[NSNumber numberWithInt:parentID]];
    
    while ([resultSet next]) {
        
        //Grid model class objects
        Grid *grid=[[Grid alloc] init];
        
        grid.idmenu        =[resultSet intForColumn:@"idmenu"];
        grid.type          =[resultSet stringForColumn:@"type"];
        grid.link          =[resultSet stringForColumn:@"link"];
        grid.title         =[resultSet stringForColumn:@"title"];
        grid.icon_path     =[resultSet stringForColumn:@"icon_path"];
        grid.parent_idmenu =[resultSet intForColumn:@"parent_idmenu"];
        
        //Adding the grid model class objects
        [results addObject:grid];
        [grid release];
        grid=nil;
        
    }
    return results;
       }
}

- (NSMutableArray *)readlistItems:(int)selectedID {
    
    NSMutableArray *results=[[[NSMutableArray alloc] init]autorelease];
    
    FMResultSet *resultSet=[database executeQuery:@"select * from list where parent_idmenu=? order by publish_date desc",[NSNumber numberWithInt:selectedID]];
    
    while ([resultSet next]) {

        //List model class objects
        List *list=[[List alloc] init];
        
        list.idlist          =[resultSet intForColumn:@"idlist"];
        list.title           =[resultSet stringForColumn:@"title"];
        list.icon_path       =[resultSet stringForColumn:@"icon_path"];
        list.link            =[resultSet stringForColumn:@"link"];
        list.lastBuildDate   =[resultSet stringForColumn:@"last_build_date"];
        list.description     =[resultSet stringForColumn:@"content"];
        list.parent_idmenu   =[resultSet intForColumn:@"parent_idmenu"];
        list.favorite        =[resultSet boolForColumn:@"favorite"];
        
        NSDateFormatter *objDateFormat= [[NSDateFormatter alloc] init];
        [objDateFormat setTimeZone:[NSTimeZone defaultTimeZone]];
        [objDateFormat setDateFormat: @"EEE, dd MMM yy HH:mm:ss"];
        NSString *strDate=[objDateFormat stringFromDate:[resultSet dateForColumn:@"publish_date"]];
        [objDateFormat release];
        objDateFormat=nil;
        
        list.pubDate         =strDate;
        
        //Adding the grid model class objects
        [results addObject:list];
        [list release];
        list=nil;
        
    }
    return results;
    
}

- (NSString *)getBuildDate:(int)parentIDMenu {
    
    NSString *buildDate = @"";
    
    FMResultSet *resultSet=[database executeQuery:@"select last_build_date from list where parent_idmenu =? limit 1",[NSNumber numberWithInt:parentIDMenu]];
    
    while ([resultSet next]) {
        
        buildDate = [resultSet stringForColumn:@"last_build_date"];
    }

    if ([buildDate isEqualToString:@""]) {
        
        buildDate = INITIAL_BUILD_DATE;
    }
    else
        DebugLog(@"LAST BUILD DATE EXIXT");
    
    return buildDate;
    
}

- (NSMutableArray *)readTabBarlistItems:(NSString *)tabBar_Type {
    
    NSMutableArray *results=[[[NSMutableArray alloc] init]autorelease];
    
    FMResultSet *resultSet=[database executeQuery:@"select * from list where parent_idmenu in(select idmenu from menu where type=?)  order by publish_date desc",tabBar_Type];
    
    
    while ([resultSet next]) {
        
        //List model class objects
        List *list=[[List alloc] init];
        list.idlist          =[resultSet intForColumn:@"idlist"];
        list.title           =[resultSet stringForColumn:@"title"];
        list.icon_path       =[resultSet stringForColumn:@"icon_path"];
        list.link            =[resultSet stringForColumn:@"link"];
        list.lastBuildDate   =[resultSet stringForColumn:@"last_build_date"];
        
        NSDateFormatter *objDateFormat= [[NSDateFormatter alloc] init];
        [objDateFormat setTimeZone:[NSTimeZone defaultTimeZone]];
        [objDateFormat setDateFormat: @"EEE, dd MMM yy HH:mm:ss"];
        NSString *strDate=[objDateFormat stringFromDate:[resultSet dateForColumn:@"publish_date"]];
        [objDateFormat release];
        objDateFormat=nil;

        list.pubDate         =strDate;
        list.description     =[resultSet stringForColumn:@"content"];
        list.parent_idmenu   =[resultSet intForColumn:@"parent_idmenu"];
        list.favorite        =[resultSet boolForColumn:@"favorite"];
        
        //Adding the grid model class objects
        [results addObject:list];
        [list release];
        list=nil;
        
    }
    return results;
    
}

- (NSMutableArray *)getFavoriteListItems {
    
    NSMutableArray *results=[[[NSMutableArray alloc] init]autorelease];
    
    FMResultSet *resultSet=[database executeQuery:@"select * from list where favorite =? order by publish_date desc",[NSNumber numberWithInt:1]];
    
    
    while ([resultSet next]) {
        
        //List model class objects
        List *list=[[List alloc] init];
        
        list.idlist          =[resultSet intForColumn:@"idlist"];
        list.title           =[resultSet stringForColumn:@"title"];
        list.icon_path       =[resultSet stringForColumn:@"icon_path"];
        list.link            =[resultSet stringForColumn:@"link"];
        list.lastBuildDate   =[resultSet stringForColumn:@"last_build_date"];
        list.description     =[resultSet stringForColumn:@"content"];
        list.parent_idmenu   =[resultSet intForColumn:@"parent_idmenu"];
        list.favorite        =[resultSet boolForColumn:@"favorite"];
        
        NSDateFormatter *objDateFormat= [[NSDateFormatter alloc] init];
        [objDateFormat setTimeZone:[NSTimeZone defaultTimeZone]];
        [objDateFormat setDateFormat: @"EEE, dd MMM yy HH:mm:ss"];
        NSString *strDate=[objDateFormat stringFromDate:[resultSet dateForColumn:@"publish_date"]];
        [objDateFormat release];
        objDateFormat=nil;
        
        list.pubDate         =strDate;
        
        //Adding the grid model class objects
        [results addObject:list];
        [list release];
        list=nil;
        
    }
    return results;
    
}


- (NSMutableArray *)readListImage {
    
 @synchronized(self) {
     
    NSMutableArray *results=[[[NSMutableArray alloc] init]autorelease];
    
    FMResultSet *resultSet=[database executeQuery:@"select * from listImage where image_local_path=?",IMAGE_DEFAULT_VALUE];
    
    while ([resultSet next]) {
        
        //Image model class objects
        Image *image=[[Image alloc] init];
        
        image.idListImage     =[resultSet intForColumn:@"idListImage"];
        image.imageType       =[resultSet intForColumn:@"type"];
        image.imageUrl        =[resultSet stringForColumn:@"link"];
        image.idList          =[resultSet intForColumn:@"idList"];
        
        //Adding the grid model class objects
        [results addObject:image];
        [image release];
        image=nil;
        
    }
    return results;
 
 }
}

- (NSMutableArray *)getImagePathForManualDownload:(int)idList {
    
    NSMutableArray *results=[[[NSMutableArray alloc] init]autorelease];
     FMResultSet *resultSet=[database executeQuery:@"select * from listImage where image_local_path =? and idList =?",IMAGE_DEFAULT_VALUE,[NSNumber numberWithInt:idList]];
    
    while ([resultSet next]) {
        
        //Image model class objects
        Image *image=[[Image alloc] init];
        
        image.idListImage     =[resultSet intForColumn:@"idListImage"];
        image.imageType       =[resultSet intForColumn:@"type"];
        image.imageUrl        =[resultSet stringForColumn:@"link"];
        image.idList          =[resultSet intForColumn:@"idList"];
        
        //Adding the grid model class objects
        [results addObject:image];
        [image release];
        image=nil;
        
    }
    return results;

}

- (NSMutableArray *)readImageDetails:(int)idList {
    
 @synchronized(self) {
     
    NSMutableArray *results=[[[NSMutableArray alloc] init]autorelease];
    
    FMResultSet *resultSet=[database executeQuery:@"select parent_idmenu,idmenu from menu where idmenu in(select parent_idmenu from list where idList =?)",[NSNumber numberWithInt:idList]];
    
    while ([resultSet next]) {
        
        //ImageDetail model class objects
        ImageDetails *imageDetails=[[ImageDetails alloc] init];
        imageDetails.parent_idmenu     =[resultSet intForColumn:@"parent_idmenu"];
        imageDetails.idmenu              =[resultSet intForColumn:@"idmenu"];
        
        //Adding the grid model class objects
        [results addObject:imageDetails];
        [imageDetails release];
        imageDetails=nil;
        
    }
    return results;
 }
}

- (NSString *)getThumbImagePath:(int)index {
    
    NSString *thumbPath =   nil;
    
    FMResultSet *resultSet=[database executeQuery:@"select link from listImage where idList =? and type =? limit 1",[NSNumber numberWithInt:index],[NSNumber numberWithInt:SMALL_IMAGE]];
    
    while ([resultSet next]) {
        
        thumbPath = [resultSet stringForColumn:@"link"];
        
    }
    return thumbPath;
}

- (NSMutableArray *)getBigImagePath:(int)index
{
    NSMutableArray *results=[[[NSMutableArray alloc] init]autorelease];
    
    NSString *thumbPath =   nil;
    
    FMResultSet *resultSet=[database executeQuery:@"select link from listImage where idList =? and type =?",[NSNumber numberWithInt:index],[NSNumber numberWithInt:LARGE_IMAGE]];
    
    while ([resultSet next]) {
        
        thumbPath = [resultSet stringForColumn:@"link"];
        
        //Adding the grid model class objects
        [results addObject:thumbPath];
    }
    return results;
}

- (NSMutableArray *)getAllHomeAndSubItemDetails {
    
    NSMutableArray *results=[[[NSMutableArray alloc] init]autorelease];
    
    FMResultSet *resultSet=[database executeQuery:@"select * from menu"];
    
    while ([resultSet next]) {
        
        //Grid model class objects
        Grid *grid=[[Grid alloc] init];
        
        grid.idmenu        =[resultSet intForColumn:@"idmenu"];
        grid.type          =[resultSet stringForColumn:@"type"];
        grid.link          =[resultSet stringForColumn:@"link"];
        grid.title         =[resultSet stringForColumn:@"title"];
        grid.icon_path     =[resultSet stringForColumn:@"icon_path"];
        grid.parent_idmenu =[resultSet intForColumn:@"parent_idmenu"];
        
        //Adding the grid model class objects
        [results addObject:grid];
        [grid release];
        grid=nil;
        
    }
    return results;
    
}

- (int)getListImageID:(int)idList {
    
    int imageID = -1;
    
    FMResultSet *resultSet=[database executeQuery:@"select idListImage from listImage where idList =? and type =? limit 1",[NSNumber numberWithInt:idList],[NSNumber numberWithInt:SMALL_IMAGE]];
    
    while ([resultSet next]) {
        
        imageID = [resultSet intForColumn:@"idListImage"];
        
    }
    return imageID;
    
}
//for getting the big images
- (NSMutableArray *)getBigImagesID:(int)idList {
    
    NSMutableArray *results=[[[NSMutableArray alloc] init]autorelease];
    int valueID;
    
    FMResultSet *resultSet=[database executeQuery:@"select idListImage from listImage where idList =? and type =? and image_local_path =?",[NSNumber numberWithInt:idList],[NSNumber numberWithInt:LARGE_IMAGE],IMAGE_DOWNLOAD_VALUE];
    
    while ([resultSet next]) {
        
        valueID =[resultSet intForColumn:@"idListImage"];
        
        [results addObject:[NSNumber numberWithInt:valueID]];
        
    }
    return results;
    
}

- (NSString *)readSubItemName:(int)idMenu {
    
    NSString *subItemName   =   nil;
    
    FMResultSet *resultSet=[database executeQuery:@"select title from menu where idmenu =?",[NSNumber numberWithInt:idMenu]];
    
    while ([resultSet next]) {
        
        subItemName = [resultSet stringForColumn:@"title"];
        
    }
    return subItemName;
    
}

- (int)getparentIDMenu:(int)idmenu {
    
    int parentID    =   -1;
    
    FMResultSet *resultSet=[database executeQuery:@"select parent_idmenu from menu where idmenu =?",[NSNumber numberWithInt:idmenu]];
    
    while ([resultSet next]) {
        
        parentID = [resultSet intForColumn:@"parent_idmenu"];
        
    }
    return parentID;
    
}

-(NSString *)getImageUrlfromDB :(int)idList
{
    @synchronized(self) {
        
        NSMutableArray *results=[[[NSMutableArray alloc] init]autorelease];
        
        NSString    *imageUrl   =   nil;
        
        FMResultSet *resultSet=[database executeQuery:@"select * from listImage where idList=?",[NSNumber numberWithInt:idList]];
        
        while ([resultSet next])
        {            
            //Image model class objects
            Image *image=[[Image alloc] init];
            
            image.idListImage     =[resultSet intForColumn:@"idListImage"];
            image.imageType       =[resultSet intForColumn:@"type"];
            image.imageUrl        =[resultSet stringForColumn:@"link"];
            image.idList          =[resultSet intForColumn:@"idList"];
            
            imageUrl    =   [resultSet stringForColumn:@"link"];
            
            //Adding the grid model class objects
            [results addObject:image];
            [image release];
            image=nil;
            
        }
        return imageUrl;        
    }    
}

#pragma mark - Delete Query

- (void)deleteListImageRows:(int)idlist {
    
       [database executeUpdate:@"delete  from listImage where idList in (select idList from list where parent_idmenu =?)",[NSNumber numberWithInt:idlist]];
}

- (void)deleteListRows:(int)parentid {
    
    [database executeUpdate:@"delete  from list where parent_idmenu =?",[NSNumber numberWithInt:parentid]];
    
}

- (void)deletelist {
   
    [database executeUpdate:@"delete from list"];

}

- (void)deletelistImage {
    
    [database executeUpdate:@"delete from listImage"];

}

#pragma mark - Update Query

- (void)updateDownloadedImagePath:(int)idListImage {
    
    
    [database executeUpdate:@"Update listImage set image_local_path =? where idListImage=?", 
                                                            IMAGE_DOWNLOAD_VALUE,[NSNumber numberWithInt:idListImage]];
}

- (void)updateFavoriteSatusYES:(int)idlist {
    
    //int yesFavorite = 1;
    [database executeUpdate:@"Update list set favorite =? where idList =?",[NSNumber numberWithInt:1],[NSNumber numberWithInt:idlist]];
}

- (void)updateFavoriteSatusNO:(int)idlist {
    
    [database executeUpdate:@"Update list set favorite =? where idList =?",[NSNumber numberWithInt:0],[NSNumber numberWithInt:idlist]];
}

@end
