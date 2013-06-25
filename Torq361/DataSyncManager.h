//
//  DataSyncManager.h
//  Torq361
//
//  Created by Binoy on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyncDB.h"
#import "DownloadThumbinals.h"
#import "DatabaseManager.h"

@interface DataSyncManager : UIViewController<SyncDBDelegate> {
	
	
	SyncDB *syncDB;
	
	UILabel *message;
	
	UIImageView *m_objImgViewSyncStatus;
	
	UIImageView *m_objImgViewBackground;
	
	
	BOOL bBackgroundImgStatus;
	//DownloadThumbinals *objDownloadCatalogThumbnails;
	//DownloadThumbinals *objDownloadCategoryThumbnails;
	//DownloadThumbinals *objDownloadThumbnails;
    DownloadThumbinals *objDownloadThumbnails;
}

@property (nonatomic,retain) IBOutlet UIImageView *m_objImgViewSyncStatus;
@property (nonatomic,retain) IBOutlet UIImageView *m_objImgViewBackground;

-(void)checkDBSyncStatus;


-(void)setPortrateView;
-(void)setLandscapeView;

-(void)setBackgroundImageStatus :(BOOL)bStatus;
-(BOOL)getBackgroundImageStatus; 

-(void)loadThumbImages;
@end
