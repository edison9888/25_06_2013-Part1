//
//  img1.m
//  Green Volt 2
//
//  Created by Timmi Thomas on 19/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScrubberMiddleView.h"


@implementation ScrubberMiddleView

@synthesize delegate;

- (id) initWithImage:(UIImage *)image
{
	    if(self=[super initWithImage:image])
        {
		[self setUserInteractionEnabled:YES]; 
		[self setMultipleTouchEnabled:YES];
        }
        return self;
        
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //AppDelegate *imap2=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITouch *touch=[[event allTouches]anyObject];
    CGPoint point= [touch locationInView:touch.view];
    CGPoint point1= [touch previousLocationInView:touch.view];
    //[[imap2 viewcontroller] draggingCompleteGraphRange:point:point1];
    
    [self.delegate draggingCompleteGraphRange:point:point1];
    	
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
		[self.delegate GraphRangeCompleteDragEnded];
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	[self touchesEnded:touches withEvent:event];
}

@end
