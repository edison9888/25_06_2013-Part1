//
//  MapViewController.m
//  PE
//
//  Created by Nithin George on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"


@implementation MapViewController

@synthesize mapLink;
@synthesize selectedButtonID;

@synthesize locationSelectedCasinosName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    if (selectedButtonID != 0) {
        
        //[self createCustomNavigationBackButton];
    }
    self.navigationItem.title = MAPIDETEFIER;
    
    NSString *urlAddress = mapLink;
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [mapDisplay loadRequest:requestObj];
    [super viewDidLoad];
    [self playAdmob];

}

-(void)playAdmob{
    
    // Create a view of the standard size at the bottom of the screen.
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            320,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = activePublisherID;
    bannerView_.rootViewController = self;
    // bannerView_.backgroundColor=[UIColor redColor];

    [bannerView_ loadRequest:[GADRequest request]];
    [self.view addSubview:bannerView_];
    [bannerView_ release];
}

- (void)createCustomNavigationBackButton {
    
    //navigation back button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 30);
    
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:12.0];
    
    [button setTitle:locationSelectedCasinosName forState:UIControlStateNormal];
   [button setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
    item = nil;
}

#pragma mark -
#pragma mark Button Clicked

- (void)backButtonClicked:(id)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
}


#pragma mark - Orientations methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	//return YES;
       return NO;
}

#pragma mark - Memory Release methods

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    mapDisplay.delegate = nil;
 
}

- (void)dealloc
{
    [super dealloc];
    //[mapLink release];
    self.mapLink = nil;
   // [selectedCasinosName release];
   self.locationSelectedCasinosName = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


@end
