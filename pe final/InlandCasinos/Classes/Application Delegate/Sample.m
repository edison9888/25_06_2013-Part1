//
//  Sample.m
//  InlandCasinos
//
//  Created by Nithin George on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sample.h"

#import "SHK.h"
@implementation Sample

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(IBAction)share:(id)sender{
    
    NSString *someText = @"This is a blurb of text I highlighted from a document.";
    SHKItem *item = [SHKItem text:someText];

	//NSURL *url = [NSURL URLWithString:@"http://getsharekit.com"];
	//SHKItem *item = [SHKItem URL:url title:@"ShareKit is Awesome!"];
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	[actionSheet showFromToolbar:self.navigationController.toolbar];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
