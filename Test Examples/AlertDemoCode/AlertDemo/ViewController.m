//
//  ViewController.m
//  AlertDemo
//
//  Created by Mark Hammonds on 10/26/11.
//  Copyright (c) 2011 CogniFORGE. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)showMessage:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"What is your phone number?"
                                                      message:nil
                                                     delegate:self 
                                            cancelButtonTitle:@"Cancel" 
                                            otherButtonTitles:@"Continue", nil];
        
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
    [message show];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText length] >= 10 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
