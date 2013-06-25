//
//  NavigationView.m
//  Torq361
//
//  Created by Nithin George on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NavigationView.h"


@implementation NavigationView

@synthesize image;
@synthesize tittle;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setImage:(UIImage *)settingImage {
	
	CGRect value;
	value.origin.x = 30;
	value.origin.y = 0;
	value.size.width = 49;
	value.size.height = 46;
	
	UIImageView *uiImage;
	uiImage = [[UIImageView alloc]initWithFrame:value];
	uiImage.image = settingImage;
	
	[self addSubview:uiImage];
}


- (void)setTittle:(NSString *)settingLabel {
	
	CGRect value;
	value.origin.x = 87;
	value.origin.y = 9;
	value.size.width = 160;
	value.size.height = 30;
	
	tittle = [[UILabel alloc]initWithFrame:value];
	[tittle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
	[tittle setBackgroundColor:[UIColor clearColor]];
	[tittle setTextColor:[UIColor whiteColor]];
	//[timeLabel setTextColor:[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0]];
	[tittle setText:settingLabel];
	
	[self addSubview:tittle];
	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    
    [image release];
	self.tittle	= nil;
    [image release];
	self.tittle	= nil;
	
	[super dealloc];
}


@end
