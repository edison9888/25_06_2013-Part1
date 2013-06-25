/**************************************************************************************
  File Name      : DBHandler.h
  Project Name   : EC Media
  Description    : Database Query Functions
  Version        : 1.0
  Created by     : Naveen Shan
  Created on     : 12/10/10
  Copyright (C) 2010 RapidValue IT Services Pvt. Ltd. All Rights Reserved.
**************************************************************************************/

#import <Foundation/Foundation.h>

@protocol DBDelegate <NSObject>
-(void)savedData;
@end

@interface DBHandler : NSObject {
	id <DBDelegate> delegate;
}	


@property(nonatomic,retain) id <DBDelegate> delegate;

+(DBHandler *)sharedManager;

//DATABASE Initialize
+ (BOOL)initializeDatabase;

//Insert Query method
- (BOOL)insertMenuItems;
  //- (BOOL)insertItems:(id)items;
- (BOOL)insertList:(NSMutableArray *)listObjectsArray;

//select Query
- (NSMutableArray *)getCasionoItems; 
- (NSMutableArray *)readHomeItems:(NSString *)type;
- (NSMutableArray *)readSubItems:(int)parentID;
- (NSString *)getBuildDate:(int)parentIDMenu;
- (NSMutableArray *)readlistItems:(int)selectedID;
- (NSMutableArray *)readTabBarlistItems:(NSString *)tabBar_Type;
- (NSMutableArray *)getFavoriteListItems;
- (NSMutableArray *)readListImage;
- (NSMutableArray *)getImagePathForManualDownload:(int)idList;
- (NSMutableArray *)readImageDetails:(int)idList;
- (NSMutableArray *)getBigImagesID:(int)idList;

//select query for creating the filder structure
- (NSMutableArray *)getAllHomeAndSubItemDetails;

- (NSString *)readSubItemName:(int)idMenu;
- (NSString *)getThumbImagePath:(int)index;

- (NSMutableArray *)getBigImagePath:(int)index;

- (int)getListImageID:(int)idList;
- (int)getImageListIdentifier;

- (int)getparentIDMenu:(int)idmenu;

-(NSString *)getImageUrlfromDB :(int)idList;

//delete query
- (void)deleteListImageRows:(int)idlist;
- (void)deleteListRows:(int)parentid;
//for clear content
- (void)deletelist;
- (void)deletelistImage;

//update query
- (void)updateDownloadedImagePath:(int)idListImage;
- (void)updateFavoriteSatusYES:(int)idlist;
- (void)updateFavoriteSatusNO:(int)idlist;


@end
