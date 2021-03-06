//
//  img3.m
//  Green Volt 2
//
//  Created by Timmi Thomas on 19/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScrubberRightView.h"

@implementation ScrubberRightView

@synthesize delegate;

- (id) initWithImage:(UIImage *)image    //over ridding init with images in uiimageview;
{       
	if (self = [super initWithImage:image]) //in order to use init with images in the parent class               that is ui imageview we use super ...
    {
		[self setUserInteractionEnabled:YES]; 
		[self setMultipleTouchEnabled:YES];
	} return self;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{ 
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	
    //AppDelegate *imap=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITouch *touch=[[event allTouches]anyObject];
    CGPoint point= [touch locationInView:touch.view];
    CGPoint point1= [touch previousLocationInView:touch.view];
    
    [self.delegate draggingEndDateOfGraphRange:point:point1];
	
	
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.delegate GraphRangeEndDateDragEnded];
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	[self touchesEnded:touches withEvent:event];
}



@end
