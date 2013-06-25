//
//  ListViewDetails.m
//  PE
//
//  Created by Nithin George on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "List.h"


@implementation List

@synthesize title;
@synthesize icon_path;
@synthesize images;
@synthesize link;
@synthesize lastBuildDate;
@synthesize pubDate;
@synthesize description;
@synthesize parent_idmenu;
@synthesize idlist;
@synthesize favorite;


- (void)dealloc {
    
    [icon_path release];
    [images release];
	[title release];
    [link release];
	[lastBuildDate release];
    [pubDate release];
	[description release];
    //[image release];
    [super dealloc];
    
}


@end
