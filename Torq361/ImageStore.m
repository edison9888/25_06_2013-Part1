//
//  ImageStore.m
//  Torq361
//
//  Created by Nithin George on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageStore.h"


@implementation ImageStore

@synthesize imageFrame;
@synthesize downloadStatus;

-(void)dealloc {
	
	[imageFrame release];
    
    imageFrame = nil;
	
	[super dealloc];
}

@end
