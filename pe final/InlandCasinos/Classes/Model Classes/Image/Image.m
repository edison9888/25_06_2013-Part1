//
//  Image.m
//  PE
//
//  Created by Nithin George on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Image.h"


@implementation Image

@synthesize idListImage;
@synthesize idList;
@synthesize imageType;
@synthesize imageUrl;


- (void)dealloc {
    
    [imageUrl release];
    [super dealloc];
    
}

@end
