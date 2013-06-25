//
//  RequestDetails.h
//  Torq361
//
//  Created by Binoy on 11/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface RequestDetails : NSObject {
	
	ASIHTTPRequest *request;
	int contentID;
	NSString *strContentType;
	NSString *strContentUrl;
    NSString *strParentcategory;

}

@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic) int contentID;
@property (nonatomic,retain) NSString *strContentType;
@property (nonatomic,retain) NSString *strContentUrl;
@property (nonatomic,retain) NSString *strParentcategory;
@end
