//
//  DownloadEngine.h
//  Torq361
//
//  Created by Rapidvalue on 29/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "ASIProgressDelegate.h"
#import "ASIHTTPRequestDelegate.h"
#import "MediaDownloader.h"
#import "DatabaseManager.h"
#import "ConnectivityCheck.h"

@interface DownloadEngine : NSObject {

	ASINetworkQueue *m_objASINetworkQueue;
	NSMutableArray *m_objRequestQueueArr;
	
	ConnectivityCheck *m_objConnectivityCheck;
}
+(DownloadEngine*)sharedManager;
-(void)addTODownloadQueue:(MediaDownloader *)obj;
-(void)createRequest:(MediaDownloader*)objMedia;

-(void)cancelAllDownload;

-(BOOL)getFailedRequest;
- (int)addFailedRequestToDownloadQueue:(MediaDownloader *)obj;

-(void)StartAutoDownload;
-(void)StartManualDownload:(int)iProductId;

@end
