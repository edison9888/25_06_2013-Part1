//
//  DownloadThumbinals.h
//  Torq361
//
//  Created by Rapidvalue on 29/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "DatabaseManager.h"
#import "RequestDetails.h"

@interface DownloadThumbinals : NSObject {

	ASINetworkQueue *downloadQueue;
	
	NSMutableArray *m_mutArrayRequestDetails;
	
	//BrightonAppDelegate *m_objBrightonAppDelegate;
}

- (void)downloadThumbinalImages:(NSString *)parentCategory;

@end
