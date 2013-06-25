//
//  MediaDownloader.h
//  Brighton
//
//  Created by Timmi on 24/06/10.
//  Copyright 2010 RVS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
//#import "DownloadStatusCustomCell.h"

@interface MediaDownloader : NSObject {
	ASIHTTPRequest *request;
	int iindex;
	//DownloadStatusCustomCell *m_objCell;
	BOOL bDownloadStatus; //YES for Finished and NO for in Progress
	NSString *strTempPath;
	UIProgressView *m_objProgressView;
	NSString *strThumbImagePath;
	NSString *strTitle;
	NSString *strID;
	NSString *strCompletedTimestamp;
	NSString *strType;
	
	NSString *strContentID;
	NSString *strProductID;
	NSString *strCatalogID;
	
	NSString *strDownloadStatusMSG;  //"added" if added to RequestQueueArr/"downloading" if Download Started/"failed" if Download Failed/"finished" if Download Failed  
	NSString *strDownloadDestinationPath;
	NSString *strDownloadURL;
}

@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic) int iindex;
//@property (nonatomic, retain) DownloadStatusCustomCell *m_objCell;
@property (nonatomic) BOOL bDownloadStatus;
@property (nonatomic, retain) NSString *strTempPath;
@property (nonatomic, retain) UIProgressView *m_objProgressView;
@property (nonatomic, retain) NSString *strThumbImagePath;
@property (nonatomic, retain) NSString *strTitle;
@property (nonatomic, retain) NSString *strID;
@property (nonatomic, retain) NSString *strCompletedTimestamp;
@property (nonatomic, retain) NSString *strDownloadStatusMSG;
@property (nonatomic, retain) NSString *strDownloadDestinationPath;
@property (nonatomic, retain) NSString *strDownloadURL;
@property (nonatomic, retain) NSString *strType;
@property (nonatomic, retain) NSString *strContentID;
@property (nonatomic, retain) NSString *strProductID;
@property (nonatomic, retain) NSString *strCatalogID;
@end
