//
//  TDMFavoritesViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/3/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMFavoritesViewController.h"

@implementation TDMFavoritesViewController
@synthesize businessId;
@synthesize businessType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = kTABBAR_TITLE_FAVORITES;
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
    }
    return self;
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
    [self initialize];
    // Do any additional setup after loading the view from its nib.
}

- (void)initialize
{
     NSDictionary *dict = [[DatabaseManager sharedManager]getUserDetailsFromDataBase];
    detailsArray =  [[TDMBusinessDetails sharedCurrentBusinessDetails].sharedBusinessDetails mutableCopy];
    NSDictionary *detailsDict = [detailsArray objectAtIndex:businessId];
    NSString *userId = [dict objectForKey:@"userid"];
    NSString *businessIds = [detailsDict objectForKey:@"id"];
    NSLog(@"%@:%@",userId,businessIds);
    NSString *name = [detailsDict objectForKey:@"name"];
    NSString *address = [detailsDict objectForKey:@"city"];
    NSString *phone = [detailsDict objectForKey:@"formattedphone"];
    NSString *categoryName = [detailsDict objectForKey:@"category"];
    NSString *url = [detailsDict objectForKey:@"url"];
    NSString *businesType = [NSString stringWithFormat:@"%d",businessType];
   // NSString *bid = [NSString stringWithFormat:@"'%@'",businessIds];
    [[DatabaseManager sharedManager]insertIntoFavoritesTable:userId businessId:@"" foursquareId:businessIds  name:name address:address phno:phone category:categoryName website:url note:@"" hours:@"" lat:@"" lon:@"" type:businesType];
}

- (void)viewDidUnload
{
   
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    
    //this will show the Tabbat
    [self showTabbar];
       
    [self.navigationItem setHidesBackButton:YES animated:NO];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    [super dealloc];
    [detailsArray release];
}

- (IBAction)backButtonAction:(id)sender 
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
