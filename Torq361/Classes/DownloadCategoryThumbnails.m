//
//  DownloadCategoryThumbnails.m
//  Torq361
//
//  Created by Binoy on 11/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadCategoryThumbnails.h"
#import "RequestDetails.h"
#import "ZipArchive.h"

@implementation DownloadCategoryThumbnails

@synthesize delegate;

- (void)downloadThumbnailImages {
	
	if([requestDetailsArray count] == 0) {
		
		requestDetailsArray = [[NSMutableArray alloc] init];
		
		downloadQueue = [[ASINetworkQueue alloc] init];
		[downloadQueue setMaxConcurrentOperationCount:3];
		[downloadQueue cancelAllOperations];
		[downloadQueue setShouldCancelAllRequestsOnFailure:NO];
		
	}
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [paths objectAtIndex:0];

	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://ziparchive.googlecode.com/files/ZipArchive.zip"]];
	
	[request setDelegate:self];
	[request setDownloadDestinationPath:[NSString stringWithFormat:@"%@/ZipArchive.zip",documentPath]];
		
	RequestDetails *requestDetails = [[RequestDetails alloc]init];
	
	requestDetails.request = request;
	requestDetails.contentID = 12;
	
	[requestDetailsArray addObject:requestDetails];
			
	[requestDetails release];
	
	if ([requestDetailsArray count] == 1) {
		
		[downloadQueue addOperation:request];
		[downloadQueue go];
	}
			
	else {
		[downloadQueue addOperation:request];
	}

	if ([requestDetailsArray count]==0) {
		
		if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(downloadCategoryThumbinalFinished)]) {
			
			[self.delegate downloadCategoryThumbinalFinished];
		}
	}
		
}

#pragma mark -
#pragma mark ASIHTTPRequest Delegates

- (void)requestStarted:(ASIHTTPRequest *)request {
	
	NSLog(@"Requested category thumbnail download started!!!....");
	
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	
	RequestDetails *requestDetails;
	
	NSString *response = [request responseString];
	
	for(int i=0;i<[requestDetailsArray count];i++) {
		
		requestDetails = [requestDetailsArray objectAtIndex:i];
		
		if(requestDetails.request == request) {
			
			[requestDetailsArray removeObjectAtIndex:i];
			
		}
		
	}
	
	//NSLog(@"File Download completed Successfully!!!....%@",response);
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [paths objectAtIndex:0];
	
	////
	
	ZipArchive* zipArchive = [[ZipArchive alloc] init];
	
	
	if( [zipArchive UnzipOpenFile: [NSString stringWithFormat:@"%@/ZipArchive.zip",documentPath]] ) {
		
		BOOL success = [zipArchive UnzipFileTo: [NSString stringWithFormat: @"%@/",documentPath ] overWrite:YES];
        if( NO==success ) {
			
            NSLog(@"Failed to decompress content");
			
        }
		
		else {
            NSError *error = nil;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL success1 = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/ZipArchive.zip",documentPath] error:&error];
            if (success1 == NO) {
                NSLog(@"Failed to remove downloaded item, %@", error);
            }
        }
        [zipArchive UnzipCloseFile];
    }
	[zipArchive release];
	
	
	
	////
	
	
	
	if ([requestDetailsArray count]==0) {
		
		if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(downloadCategoryThumbinalFinished)]) {
			
			[self.delegate downloadCategoryThumbinalFinished];
			
		}
	}
}


- (void)requestFailed:(ASIHTTPRequest *)request {
	
	NSError *error = [request error];
	
	NSLog(@"Error occured during File download!!!....%@",[error localizedDescription]);
	
	RequestDetails *requestDetails;

	
	for(int i=0;i<[requestDetailsArray count];i++) {
		
		requestDetails = [requestDetailsArray objectAtIndex:i];
		
		if(requestDetails.request == request) {
			
			[requestDetailsArray removeObjectAtIndex:i];
			
		}
		
	}
	
		
	if ([requestDetailsArray count]==0) {
		
		if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(downloadCategoryThumbinalFinished)]) {
			
			[self.delegate downloadCategoryThumbinalFinished];
			
		}
	}
	
	
}

#pragma mark -


- (void)dealloc {
	
	[requestDetailsArray release];
	
	[super dealloc];
}

@end