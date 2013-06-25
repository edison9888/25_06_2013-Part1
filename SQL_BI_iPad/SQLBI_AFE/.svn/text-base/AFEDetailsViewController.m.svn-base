//
//  AFEDetailsViewController.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 04/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFEDetailsViewController.h"

@interface AFEDetailsViewController ()
{
    NSArray* listOfVC;
    int selectedIndex;
}

@end

@implementation AFEDetailsViewController
@synthesize viewControllersList = listOfVC;
@synthesize selectedIndex = selectedIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithViewControllers:(NSArray*) listOfViewControllers
{
    self = [super init];
    
    if(self)
    {
        selectedIndex = 0;
        self.viewControllersList = listOfViewControllers; 
    }

    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}



-(void) setViewControllersList:(NSArray *)listOfViewControllers
{
    listOfVC = listOfViewControllers;
    
    [Utility removeAllSubViewsFromSuperView:self.view];
}


-(void) setSelectedIndex:(int)index
{
    selectedIndex = index;
}

@end
