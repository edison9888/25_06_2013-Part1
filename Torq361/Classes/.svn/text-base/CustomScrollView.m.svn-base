    //
//  CustomScrollView.m
//  Torq361
//
//  Created by Nithin George on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomScrollView.h"
//#import "PDFViewer.h"


@implementation CustomScrollView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
{	
	// If not dragging, send event to next responder
	if ((((UITouch *)[touches anyObject]).tapCount == 2) && (!self.dragging) )
		[self.nextResponder touchesEnded: touches withEvent:event]; 
	//[self touchesEnded: touches withEvent: event];
	else
		[super touchesEnded: touches withEvent: event];
	
	
	//if([self.delegate isKindOfClass:[PDFViewer class]])
		//[(PDFViewer*)self.delegate singleTap];
	
	
}

/*-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event 
 {	
 if (!self.dragging)
 {
 [self.nextResponder touchesBegan: touches withEvent:event]; 
 
 }	
 }*/



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)dealloc {
    [super dealloc];
}


@end
