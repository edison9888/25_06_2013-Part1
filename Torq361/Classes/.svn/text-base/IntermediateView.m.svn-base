    //
//  IntermediateView.m
//  Torq361
//
//  Created by Binoy on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IntermediateView.h"
#import "AppTmpData.h"
#import "Torq361AppDelegate.h"
#import "Home.h"


@implementation IntermediateView

@synthesize backgroundImage;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if([[AppTmpData sharedManager] getDeviceOrientation]){
		
		[self setPortrateView];
		
	}
	else {
		
		[self setLandscapeView];
	}
	
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1
											 target:self
										   selector:@selector(removeView)
										   userInfo:nil
											repeats:NO];
}

-(void)setPortrateView {
	
	self.view.frame = CGRectMake(0, 0, 768, 1004);
}

-(void)setLandscapeView {
	
	self.view.frame = CGRectMake(0, 0, 1024, 748);
	
}

-(void)removeView {
	
	if (timer) {
	
		[timer invalidate];
		
		timer = nil;
		
	}
	
	Torq361AppDelegate *appDelegate = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
	
	[appDelegate.home showMainCategoryView:YES];	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
