//
//  DownloadEngine.m
//  Torq361
//
//  Created by Rapidvalue on 29/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadEngine.h"
#import "UserCredentials.h"

@implementation DownloadEngine
static DownloadEngine *m_objDownloadEngine;

+(DownloadEngine*)sharedManager{
	if (!m_objDownloadEngine) {
		m_objDownloadEngine=[[DownloadEngine alloc] init];			
	}
	return m_objDownloadEngine;
}

-(void)StartAutoDownload{
    [self cancelAllDownload];
    
	NSMutableArray *mediaDetails=[[DatabaseManager sharedManager] getDownloadAllMedia:@"SELECT * from Content where ContentImgStatus='N';"];
	
	//NSLog(@"Pending Downloading Content Count %d",[mediaDetails count]);
	
	for (int i=0; i<[mediaDetails count]; i++) {
		[self createRequest:[mediaDetails objectAtIndex:i]];
	}
}

-(void)StartManualDownload:(int)iProductId{
	
    
	NSMutableArray *mediaDetails=[[DatabaseManager sharedManager] getDownloadAllMedia:[NSString stringWithFormat:@"SELECT * from Content where idProduct=%d and ContentImgStatus='N';",iProductId]];
    
    NSLog(@"Pending Downloading Content Count in manual download %d",[mediaDetails count]);
    
    if([mediaDetails count]<=0){
        return;
    }
    
    [self cancelAllDownload];
    
	for (int i=0; i<[mediaDetails count]; i++) {
		[self createRequest:[mediaDetails objectAtIndex:i]];
	}
}

-(void)createRequest:(MediaDownloader*)objMedia{
	
	NSString *strCompanyID=[[UserCredentials sharedManager] getCompanyID];
	
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [paths objectAtIndex:0];
	
	NSString *strCompanyId= [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",@"CompanyId",strCompanyID]];
	NSString *strdownloadPath=@"";
	if([objMedia.strType isEqualToString:@"image"]){
	  strdownloadPath=[strCompanyId stringByAppendingPathComponent:@"ProductContent/Portrait/image"];
	}
	if([objMedia.strType isEqualToString:@"pdf"]){
		strdownloadPath=[strCompanyId stringByAppendingPathComponent:@"ProductContent/Portrait/pdf"];
	}
	if([objMedia.strType isEqualToString:@"video"]){
		strdownloadPath=[strCompanyId stringByAppendingPathComponent:@"ProductContent/Portrait/video"];
	}
	
	NSString *temporaryPath=[NSString stringWithFormat:@"%@/tmp/%@_%@_%@.download",strdownloadPath,objMedia.strType,strCompanyID,objMedia.strContentID];
		
	
	
	MediaDownloader *obj_MediaDownloader=[[MediaDownloader alloc] init];
	obj_MediaDownloader.strContentID=objMedia.strContentID;
	obj_MediaDownloader.strProductID=objMedia.strProductID;
	obj_MediaDownloader.strCatalogID=objMedia.strCatalogID;
	obj_MediaDownloader.strType=objMedia.strType;
	obj_MediaDownloader.strDownloadURL=objMedia.strDownloadURL;
	obj_MediaDownloader.strTempPath=temporaryPath;
	obj_MediaDownloader.bDownloadStatus=NO;
	
	
	obj_MediaDownloader.strThumbImagePath=@"";
	
	obj_MediaDownloader.strDownloadStatusMSG = @"started";
	
	NSArray *objExtension = [objMedia.strDownloadURL componentsSeparatedByString:@"."];
	
	obj_MediaDownloader.strDownloadDestinationPath = [NSString stringWithFormat:@"%@/%@_%@_%@.%@",strdownloadPath,objMedia.strType,strCompanyID,objMedia.strContentID,[objExtension lastObject]];
		
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:obj_MediaDownloader.strDownloadURL]];		
	[request setDownloadDestinationPath:[NSString stringWithFormat:@"%@/%@_%@_%@.%@",strdownloadPath,objMedia.strType,strCompanyID,objMedia.strContentID,[objExtension lastObject]]];
	

	[request setTemporaryFileDownloadPath:temporaryPath];
	[request setShowAccurateProgress:YES];
	[request setAllowResumeForFileDownloads:YES];	
	[request setDelegate:self];
	[request setDownloadProgressDelegate:(UIProgressView *)obj_MediaDownloader.m_objProgressView];
	
	obj_MediaDownloader.request=request;
	
	[[DatabaseManager sharedManager] insertInToDownload:obj_MediaDownloader.strType 
													   :obj_MediaDownloader.strContentID 
													   :[NSString stringWithFormat:@"%@/%@_%@_%@.%@",strdownloadPath,objMedia.strType,strCompanyID,objMedia.strContentID,[objExtension lastObject]] 
													   :@"" 
													   :@"" 
													   :temporaryPath 
													   :@"downloading"
													   :strCompanyID];
	
	
	
	[self addTODownloadQueue:obj_MediaDownloader];	
	
}
-(void)addTODownloadQueue:(MediaDownloader *)obj{
	
	if (m_objDownloadEngine) {
		if(!m_objASINetworkQueue){
			m_objASINetworkQueue=[[ASINetworkQueue alloc] init];
		}
		if(!m_objRequestQueueArr){
			m_objRequestQueueArr=[[NSMutableArray alloc] init];
		}
	}	
	[m_objRequestQueueArr addObject:obj];	
	if([m_objRequestQueueArr count]==1){
		[m_objASINetworkQueue cancelAllOperations];
		[m_objASINetworkQueue setShouldCancelAllRequestsOnFailure:NO];
		[m_objASINetworkQueue setShowAccurateProgress:YES];
		[m_objASINetworkQueue setMaxConcurrentOperationCount:1];
		[m_objASINetworkQueue addOperation:obj.request];
		[m_objASINetworkQueue go];
	}
	else {
		[m_objASINetworkQueue addOperation:obj.request];
	}
	
}


- (void)requestStarted:(ASIHTTPRequest *)request {
	//NSLog(@"Requested content file Download Started!!!....");
	int i=0;

	MediaDownloader *reqObj;
	for (i=0;i<[m_objRequestQueueArr count]; i++) {
		
		reqObj = [m_objRequestQueueArr objectAtIndex:i];
		if (reqObj.request == request) {
			reqObj.strDownloadStatusMSG = @"downloading";

		}
		
	}
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	NSString *response = [request responseString];
	int i=0;	

	MediaDownloader *retObj;
	for (i=0;i<[m_objRequestQueueArr count];i++){
		retObj = [m_objRequestQueueArr objectAtIndex:i];		
		if (retObj.request == request){
			retObj.bDownloadStatus=YES;
			
			retObj.strDownloadStatusMSG = @"finished";
			[[DatabaseManager sharedManager] deleteFromDownload:retObj.strContentID];
			[[DatabaseManager sharedManager] updateContentStatus:retObj.strContentID];
			
			
			[m_objRequestQueueArr removeObjectAtIndex:i];
			
			if ([m_objRequestQueueArr count]==0) {
				[self StartAutoDownload];
			}
			
			
			break;
		}
	}

	//NSLog(@"File Download completed Successfully!!!....%@",response);
	
	if ([m_objASINetworkQueue requestsCount] <= 1) {
		if (![self getFailedRequest]) {
			[m_objRequestQueueArr removeAllObjects];
		}
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	int i=0;
	NSError *error = [request error];
	NSLog(@"Error occured during File download!!!....%@",[error localizedDescription]);
	
	MediaDownloader *retObj;
	for (i=0;i<[m_objRequestQueueArr count];i++){
		retObj = [m_objRequestQueueArr objectAtIndex:i];
		
		if (retObj.request == request){
			retObj.strDownloadStatusMSG = @"failed";
			[retObj.request cancel];
			[[DatabaseManager sharedManager] updateDownloadStatusInToDownload:retObj.strContentID :@"failed"];
			break;
		}
	}
	
	if ([m_objASINetworkQueue requestsCount] <= 1) {
		if (![self getFailedRequest]) {
			[m_objRequestQueueArr removeAllObjects];
		}
	}
	
}

//Get failed requests
-(BOOL)getFailedRequest {
	BOOL bFailed=NO;
	int iConnectivityStatus = 1;
	for (int i=0;i<[m_objRequestQueueArr count]; i++) {
		MediaDownloader *objFailedMedia=[m_objRequestQueueArr objectAtIndex:i];
		if ([objFailedMedia.strDownloadStatusMSG isEqualToString:@"failed"]) {
			iConnectivityStatus = [self addFailedRequestToDownloadQueue:objFailedMedia];
			bFailed=YES;
		}
	}
	
	return bFailed;
}

//Add the failed request to download Queue
- (int)addFailedRequestToDownloadQueue:(MediaDownloader *)obj {
	
	int iConnectivityStatus = 1;
	
	ASIHTTPRequest *tmpRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:obj.strDownloadURL]];		
	[tmpRequest setDownloadDestinationPath:obj.strDownloadDestinationPath];
	[tmpRequest setTemporaryFileDownloadPath:obj.strTempPath];
	[tmpRequest setShowAccurateProgress:YES];
	[tmpRequest setAllowResumeForFileDownloads:YES];	
	[tmpRequest setDelegate:self];
	[tmpRequest setDownloadProgressDelegate:(UIProgressView *)obj.m_objProgressView];
	
	obj.request=tmpRequest;
	
	if (m_objDownloadEngine) {
		if(!m_objASINetworkQueue){
			m_objASINetworkQueue=[[ASINetworkQueue alloc] init];
		}
		if(!m_objRequestQueueArr){
			m_objRequestQueueArr=[[NSMutableArray alloc] init];
		}
	}	
	
	if([m_objRequestQueueArr count]==1){
		[m_objASINetworkQueue cancelAllOperations];
		[m_objASINetworkQueue setShouldCancelAllRequestsOnFailure:NO];
		[m_objASINetworkQueue setShowAccurateProgress:YES];
		[m_objASINetworkQueue setMaxConcurrentOperationCount:1];
		
		
		if (!m_objConnectivityCheck) {
			m_objConnectivityCheck = [[ConnectivityCheck alloc] init];
		}
		
		if (m_objConnectivityCheck) {
			
			if([m_objConnectivityCheck isHostReachable]){
				[[DatabaseManager sharedManager] updateDownloadStatusInToDownload:obj.strContentID :@"downloading"];
				
				[m_objASINetworkQueue addOperation:obj.request];
				iConnectivityStatus = 1;
			}
			else {
				iConnectivityStatus = 0;
			}
		}
		
		[m_objASINetworkQueue go];
	}
	else {
		if (!m_objConnectivityCheck) {
			m_objConnectivityCheck = [[ConnectivityCheck alloc] init];
		}
		
		if (m_objConnectivityCheck) {
			
			if([m_objConnectivityCheck isHostReachable]){
				[[DatabaseManager sharedManager] updateDownloadStatusInToDownload:obj.strContentID :@"downloading"];
				[m_objASINetworkQueue addOperation:obj.request];
				iConnectivityStatus = 1;
			}
			else {
				iConnectivityStatus = 0;
			}
		}
	}
	return iConnectivityStatus;
}

//Cancel All currently running downloads
-(void)cancelAllDownload{
	if (m_objDownloadEngine) {
               
		if(m_objRequestQueueArr){
			
			MediaDownloader *retObj;
			for (int i=0;i<[m_objRequestQueueArr count];i++){
				retObj = [m_objRequestQueueArr objectAtIndex:i];
				
				if (![retObj.strDownloadStatusMSG isEqualToString:@"finished"]){
                    [retObj.request setDelegate:nil]; // CLEAR REQUEST
                    [retObj.request cancel]; 

					retObj.strDownloadStatusMSG = @"failed";
					[[DatabaseManager sharedManager] updateDownloadStatusInToDownload:retObj.strContentID :@"failed"];
				}
			}
			[m_objRequestQueueArr removeAllObjects];
		}
		
	}
    if(m_objASINetworkQueue){
        [m_objASINetworkQueue setDelegate:nil]; // CLEAR THE NETWORKQUEUE
        [m_objASINetworkQueue cancelAllOperations];
        //[m_objASINetworkQueue release];
        //m_objASINetworkQueue = nil;
    }

}

@end
