//
//  MediaDownloader.m
//  Brighton
//
//  Created by Timmi on 24/06/10.
//  Copyright 2010 RVS. All rights reserved.
//

#import "MediaDownloader.h"


@implementation MediaDownloader

@synthesize request;
@synthesize iindex;
//@synthesize m_objCell;
@synthesize bDownloadStatus;
@synthesize strTempPath;
@synthesize m_objProgressView;
@synthesize strThumbImagePath;
@synthesize strTitle;
@synthesize strID;
@synthesize strCompletedTimestamp;

@synthesize strDownloadStatusMSG;
@synthesize strDownloadDestinationPath;
@synthesize	strDownloadURL;
@synthesize strType;
@synthesize strContentID;
@synthesize strProductID;
@synthesize strCatalogID;

- (id) init{
	self = [super init];
	if (self != nil){
		m_objProgressView=[[UIProgressView alloc] init];
	}
	return self;
}

-(void)dealloc{
	[request release];
	//[m_objCell release];
	[strTempPath release];
	[m_objProgressView release];
	[strThumbImagePath release];
	[strTitle release];
	[strID release];
	[strCompletedTimestamp release];
	[strDownloadStatusMSG release];
	[strDownloadDestinationPath release];
	[strDownloadURL release];
	[strType release];
	[strContentID release];
	[strProductID release];
	[strCatalogID release];
	[super dealloc];
}

@end
