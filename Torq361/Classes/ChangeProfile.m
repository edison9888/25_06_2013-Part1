    //
//  ChangeProfile.m
//  Torq361
//
//  Created by Nithin George on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChangeProfile.h"


@implementation ChangeProfile

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


- (void)viewDidLoad {
	
    @try {
		
		[super viewDidLoad];
		
		scrollView.contentSize = CGSizeMake(540,700);
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
		//label.font = [UIFont boldSystemFontOfSize:14.0];
		//label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		label.textColor = [UIColor whiteColor];
		[label setFont:[UIFont fontWithName:@"Arial" size:22]];
		self.navigationItem.titleView = label;
		label.text = @" Edit Profile";
		[label release];
		
		UIImage *image;
		
		image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"login_here" ofType:@"png"]];
		backgroundImageView.image = image;
		[image release];
		image=nil;
		
	}
	
	@catch (NSException * e) {
		
		
	}
	
	@finally {
		
	}	
	
	
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
