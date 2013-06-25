//
//  TDMMyFavoritesViewController.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 23/02/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMMyFavoritesViewController.h"
#define kNORMAL_CELL_HEIGHT 73
#define kNUMBER_OF_ROWS 3
@implementation TDMMyFavoritesViewController
@synthesize favoritesCell;
@synthesize segment;
@synthesize detailsTable;

#pragma mark - Memory Management

- (void)dealloc 
{
    [favoritesCell release];
    [segment release];
    [detailsTable release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setFavoritesCell:nil];
    [self setSegment:nil];
    [self setDetailsTable:nil];
    [super viewDidUnload];
   
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = kTABBAR_TITLE_FAVORITES;
        [self createCustomisedNavigationTitleWithString:kNAVBAR_TITLE_FAVOURITES];
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    businesIdArray = [[NSMutableArray alloc]init];
    restaurantArray = [[NSMutableArray alloc]init];   
    barArray = [[NSMutableArray alloc]init];
    infoArray = [[NSMutableArray alloc]init];
    [self initialize];
   
    // Do any additional setup after loading the view from its nib.
}

- (void)initialize
{
    dict = [[DatabaseManager sharedManager]getUserDetailsFromDataBase];
    NSString *userId = [dict objectForKey:@"userid"];
   
    //testing 
    
    businessIDArray = [[[DatabaseManager sharedManager] getAllBusinessIDForUserID:userId] mutableCopy];
    NSLog(@"%d",[businessIDArray count]);
    for (int i = 0; i < [businessIDArray count]; i++) 
    {
        NSDictionary *data = [businessIDArray objectAtIndex:i];
        
        if ([[data objectForKey:@"type"]intValue] == 0) 
        {    
            [barArray addObject:data];
            NSLog(@"barArray array:%@",barArray);
            infoArray = [barArray mutableCopy]; 
        }
        else
        {
            [restaurantArray addObject:data];
            NSLog(@"restaurant array:%@",restaurantArray);
            infoArray = [restaurantArray mutableCopy];
        }
    }
    [segment setSelectedSegmentIndex:0];
    infoArray = [restaurantArray mutableCopy];
}

- (IBAction)segmentClicked:(id)sender 
{
    if (segment.selectedSegmentIndex == 0) 
    {
        infoArray = [restaurantArray mutableCopy];
    }
    else
    {
        infoArray = [barArray mutableCopy];
    }
    
    [detailsTable reloadData];
}

#pragma mark - Handle Orientations

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
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
    int count = [infoArray count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    info = [infoArray objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"TDMFavoritesCustomCell";
    TDMFavoritesCustomCell *favCell = (TDMFavoritesCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (favCell == nil)
    {
        [[NSBundle mainBundle]loadNibNamed:@"TDMFavoritesCustomCell" owner:self options:nil];
        favCell = favoritesCell;
        self.favoritesCell = nil;
    }
    [favCell populateInformation:info];
    cell = favCell;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    TDMBusinessHomeViewController *busHomeViewController = (TDMBusinessHomeViewController *)[self getClass:@"TDMBusinessHomeViewController"];
    [[TDMBusinessDetails sharedCurrentBusinessDetails] initializeBusinessHeaders:infoArray];
    busHomeViewController.businessId = indexPath.row;
    busHomeViewController.businesType = kWISH_LIST_TABBAR_INDEX;
    [self.navigationController pushViewController:busHomeViewController animated:YES];
    
}

@end
