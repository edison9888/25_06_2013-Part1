//
//  TDMViewReviewsViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/13/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMViewReviewsViewController.h"

#define kNORMAL_CELL_HEIGHT 73
#define kNUMBER_OF_ROWS 3
static NSString *CellIdentifier = @"Cell";
@implementation TDMViewReviewsViewController
@synthesize viewReviewCell;

#pragma mark - Memory Management

- (void)dealloc 
{
    [dict release];
    [viewReviewCell release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [self setViewReviewCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //this will create the navigation Title as My Profile
        [self createCustomisedNavigationTitleWithString:kNAVBAR_TITLE_REVIEWS];
        
        //this will create the back button on the navigation bar
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
    // Do any additional setup after loading the view from its nib.
}

- (void)initialize
{
    dict = [[ NSMutableDictionary alloc]init];
    NSMutableDictionary *info = [[NSMutableDictionary alloc]init];
    [info setObject:@"business1" forKey:@"image"];
    [info setObject:@"Review" forKey:@"title"];
    [info setObject:@"It is " forKey:@"description"];
    [dict setObject:info forKey:@"0"];
    [info release];
    NSMutableDictionary *info1 = [[NSMutableDictionary alloc]init];
    [info1 setObject:@"signaturedish" forKey:@"image"];
    [info1 setObject:@"Review" forKey:@"title"];
    [info1 setObject:@"It is for the " forKey:@"description"];
    [dict setObject:info1 forKey:@"1"];
    [info1 release];
    NSMutableDictionary *info2 = [[NSMutableDictionary alloc]init];
    [info2 setObject:@"TabBarSelected" forKey:@"image"];
    [info2 setObject:@"Review" forKey:@"title"];
    [info2 setObject:@"It is for the.....  " forKey:@"description"];
    [dict setObject:info2 forKey:@"2"];
    [info2 release];


}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma  mark TableView datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kNORMAL_CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNUMBER_OF_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSMutableDictionary *info = [dict objectForKey:[NSString  stringWithFormat:@"%d",indexPath.row]];
    static NSString *CellIdentifier = @"TDMViewReviewCustomCell";
    TDMViewReviewCustomCell *reviewCell = (TDMViewReviewCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (reviewCell == nil)
    {
        [[NSBundle mainBundle]loadNibNamed:@"TDMViewReviewCustomCell" owner:self options:nil];
        reviewCell = viewReviewCell;
        self.viewReviewCell = nil;
    }
    [reviewCell populateInformation:info];
    cell = reviewCell;
   return cell;
}



@end
