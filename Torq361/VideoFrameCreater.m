//
//  VideoFrameCreater.m
//  Torq361
//
//  Created by Nithin George on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VideoFrameCreater.h"
#import "VideoViewer.h"

@implementation VideoFrameCreater

@synthesize thumnailImage;
@synthesize tagValue;
@synthesize timeLabel;
@synthesize delegate;
@synthesize playImage;
@synthesize frameCheckVariable;
@synthesize actindicator;
@synthesize actindicatorSetValue;

@synthesize xAxix;
@synthesize yAxix;
@synthesize wWidth;
@synthesize hHight;

@synthesize xLabel;
@synthesize yLabel;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*-(void)drawRect:(CGRect)rect	{
	
}*/

- (void)setThumnailImage:(UIImage *)thumbImage {

	CGRect value;
	value.origin.x = xAxix;// 0;
	value.origin.y = yAxix;//0;
	value.size.width = wWidth;//100;
	value.size.height = hHight;//100;

	UIButton *button;
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame =  value;
    [button setBackgroundImage:thumbImage forState:UIControlStateNormal];
	button.tag = tagValue;
    NSLog(@"RETAIN COUNT OF BUTTON %d",[button retainCount]);
	[self addSubview:button];
    NSLog(@"RETAIN COUNT OF BUTTON %d",[button retainCount]);
    
   // [button release];
  //  button = nil;
    
    NSLog(@"RETAIN COUNT OF BUTTON %d",[button retainCount]);
}


- (void)setPlayImage:(UIImage *)playImage {
	
	CGRect value;
	value.origin.x = xAxix;// 0;
	value.origin.y = yAxix;//0;
	value.size.width = wWidth;//100;
	value.size.height = hHight;//100;

	UIButton *playButton;
	playButton = [UIButton buttonWithType:UIButtonTypeCustom];
	playButton.frame = value;
	
	//For selecting the play image large and small
	if (frameCheckVariable == 1) { 
		
			[playButton setBackgroundImage:playImage forState:UIControlStateNormal];
		
	}
	
	else {
		
		[playButton setImage:playImage forState:UIControlStateNormal];
	}

     
	[playButton addTarget:self action:@selector(thumbnailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	 playButton.tag = tagValue;
	
	[self addSubview:playButton];
    
   // [playButton release];
    //playButton = nil;
	
}

//For setting the activity indicator
- (void)setActindicatorSetValue:(int)setValue {
	
	//For content scrollview
	if (setValue == 11) {
		
		actindicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		actindicator.frame = CGRectMake(120, 150, 30, 30);
		
	/*	CGRect myRect = self.frame;
		CGRect activityIndicatorRect;
		activityIndicatorRect.origin.x		= myRect.size.width/2;
		activityIndicatorRect.origin.y		= myRect.size.height/2;
		activityIndicatorRect.size.width	= 21;
		activityIndicatorRect.size.height	= 21;
		
		actindicator.frame = activityIndicatorRect;
	*/	
		[actindicator startAnimating];
		actindicator.hidden = NO;
		[self addSubview:actindicator];	
        
      // [actindicator release];
      //  actindicator = nil;
	}
	
	//For thumbscrollview
	else {
		
		actindicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		actindicator.frame = CGRectMake(30, 30, 20, 20);
		[actindicator startAnimating];
		actindicator.hidden = NO;
		[self addSubview:actindicator];
        
       // [actindicator release];
       // actindicator = nil;
		
	}

}

	
- (void)setTimeLabel:(NSString *)time {
	
	
	CGRect value;
	value.origin.x = xLabel;//50;
	value.origin.y = yLabel;//40;
	value.size.width = wWidth;//100;
	value.size.height = hHight;//100;
	
	timeLabel = [[UILabel alloc] initWithFrame:value];
	
	if (frameCheckVariable == 3) {
		
		[timeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
	}
	
	else {
		
		[timeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
	}

	[timeLabel setBackgroundColor:[UIColor clearColor]];
	[timeLabel setTextColor:[UIColor blueColor]];
	//[timeLabel setTextColor:[UIColor colorWithRed:255.0/255.0 alpha:1.0]];
	[timeLabel setText:time];

	[self addSubview:timeLabel];
    
    [timeLabel release];
   // timeLabel = nil;
	
}



- (IBAction)thumbnailButtonClicked :(id)sender {
	
	UIButton *button = (UIButton *)sender;
	
	int buttonTagValue = button.tag;
	
	[delegate thumbnailButtonClicked:buttonTagValue];
	
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	NSLog(@"touchessss.......");
}
 
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	
    //self.delegate       = nil;
	self.thumnailImage	= nil;
	self.timeLabel		= nil;
	self.playImage      = nil;
	self.actindicator   = nil;
	
    [super dealloc];
}


@end
