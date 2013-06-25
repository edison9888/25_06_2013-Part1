//
//  DownloadThumbinals.m
//  Torq361
//
//  Created by Rapidvalue on 29/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadThumbinals.h"
#import "UserCredentials.h"

@implementation DownloadThumbinals

- (void)downloadThumbinalImages:(NSString *)parentCategory{
	ASIHTTPRequest *request;
	NSString *urlString;//,*strFileExtension,*strContentType;
	NSString *strDownloadDestiantionPath;
	int i=0;	
	NSString *strCompanyID=[[UserCredentials sharedManager] getCompanyID];
	
	urlString=@"";
	strDownloadDestiantionPath=@"";
	
	NSArray *objArray;
	if ([parentCategory isEqualToString:@"Catalog"]) {
		objArray=[[DatabaseManager sharedManager] getthumbimage:parentCategory];
	}
	else if ([parentCategory isEqualToString:@"Category"]) {
		objArray=[[DatabaseManager sharedManager] getthumbimage:parentCategory];
	}
	else if ([parentCategory isEqualToString:@"Product"]) {
		objArray=[[DatabaseManager sharedManager] getthumbimage:parentCategory];
	}
	if([objArray count]<=0){
        return;
    }
    if([m_mutArrayRequestDetails count] == 0) {
    //if(m_mutArrayRequestDetails==nil){
		m_mutArrayRequestDetails = [[NSMutableArray alloc] init];
		downloadQueue = [[ASINetworkQueue alloc] init];
		[downloadQueue setMaxConcurrentOperationCount:3];
		[downloadQueue cancelAllOperations];
		[downloadQueue setShouldCancelAllRequestsOnFailure:NO];
		
	}
	//NSLog("Category :%@",parentCategory);

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [paths objectAtIndex:0];
	
	NSString *strThumbImages=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@/%@Thumb",@"CompanyId",strCompanyID,parentCategory]];
	

	for (i=0;i<[objArray count];i++){
		RequestDetails *objRequestDetails=[objArray objectAtIndex:i];
        
        objRequestDetails.strParentcategory=parentCategory;
        
        if( objRequestDetails.strContentUrl ==(NSString*)[NSNull null] || objRequestDetails.strContentUrl== nil || [objRequestDetails.strContentUrl isEqualToString:@""])
            continue;
		
		request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:objRequestDetails.strContentUrl]];
		
		objRequestDetails.request = request;
		
		NSArray *objExtension = [objRequestDetails.strContentUrl componentsSeparatedByString:@"."]; //storing the url in separate words,by dot so will get the the last .jpg
		
		strDownloadDestiantionPath=[NSString stringWithFormat:@"%@/thumb_%@_%d.%@",strThumbImages,strCompanyID,objRequestDetails.contentID,[objExtension lastObject]];
				
		//NSLog("Path %@",strDownloadDestiantionPath);
		[request setDelegate:self];
		[request setDownloadDestinationPath:strDownloadDestiantionPath];
		//[request startAsynchronous];
		
		[m_mutArrayRequestDetails addObject:objRequestDetails];
		//[objRequestDetails release];
		
		if([m_mutArrayRequestDetails count] == 1) {
			
			[downloadQueue addOperation:request];
			[downloadQueue go];
		}
		else {
			[downloadQueue addOperation:request];
		}
		
	}
	
}



- (void)requestStarted:(ASIHTTPRequest *)request{
	//NSLog(@"Requested file Download Started!!!....");
}

- (void)requestFinished:(ASIHTTPRequest *)request{
	RequestDetails *objDetails ;
	NSString *response = [request responseString];
	
	for(int i=0;i<[m_mutArrayRequestDetails count];i++)
	{
		objDetails = [m_mutArrayRequestDetails objectAtIndex:i];
		if(objDetails.request == request)
		{
            [[DatabaseManager sharedManager] updateThumbnailImgStatus:[NSString stringWithFormat: @"%d",objDetails.contentID] parentCategory:objDetails.strParentcategory];
			break;
		}
		
	}

	//NSLog(@"File Download completed Successfully!!!....%@",response);
	
}

- (void)requestFailed:(ASIHTTPRequest *)request{
	NSError *error = [request error];
	NSLog(@"Error occured during File download!!!....%@",[error localizedDescription]);

}

- (void)dealloc{
    if(downloadQueue){
        [downloadQueue cancelAllOperations];
        [downloadQueue release];
        downloadQueue=nil;
    }
	[m_mutArrayRequestDetails release];
	[super dealloc];
}


@end
