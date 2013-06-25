//
//  RequestDetails.m
//  Torq361
//
//  Created by Binoy on 11/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RequestDetails.h"


@implementation RequestDetails

@synthesize request,contentID,strContentType,strContentUrl,strParentcategory;

-(void)dealloc{	
	
	[request release];
	[strContentType release];
	[strContentUrl release];
    [strParentcategory release];
	[super dealloc];
}

@end
