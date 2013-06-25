//
//  DownloadCategoryThumbnails.h
//  Torq361
//
//  Created by Binoy on 11/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

@protocol DownloadCategoryDelegate<NSObject>

-(void)downloadCategoryThumbinalFinished;


@end


@interface DownloadCategoryThumbnails : NSObject {
	
	ASINetworkQueue *downloadQueue;
	
	NSMutableArray *requestDetailsArray;
	
	id<DownloadCategoryDelegate>delegate;

}

@property(nonatomic,retain)id<DownloadCategoryDelegate>delegate;

- (void)downloadThumbnailImages;

@end
