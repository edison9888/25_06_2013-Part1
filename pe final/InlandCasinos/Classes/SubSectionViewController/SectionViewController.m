//
//  SectionViewController.m
//  PE
//
//  Created by God bless you... on 26/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SectionViewController.h"
#import "Helper.h"
#import "GridCell.h"
#import "ListViewController.h"
#import "MapViewController.h"
#import "DBHandler.h"
#import "Grid.h"
#import "SettingViewController.h"



@implementation SectionViewController

@synthesize sectionID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark - View lifecycle

- (void)viewDidLoad  {
    
    [super viewDidLoad];
    //[self createCustomNavigationBackButton];
    [self createCustomNavigationLeftButton];
    //For getting the data from the table
    sectionItems=[[[DBHandler sharedManager]readSubItems:sectionID] retain];
    
    selectedCasinosName       = [[DBHandler sharedManager] readSubItemName:sectionID];
    self.navigationItem.title = selectedCasinosName;

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [listView reloadData];
}

- (void)createCustomNavigationBackButton {
    
   // [self.navigationItem hidesBackButton];
    //navigation back button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 76, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"CasinoBackButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
    item = nil;
}

- (void)createCustomNavigationLeftButton {
    
    [self.navigationItem hidesBackButton];
    //navigation back button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 25);
    
    [button setBackgroundImage:[UIImage imageNamed:SETTING_IMAGE] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(iconButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    item = nil;
}

#pragma mark -
#pragma mark Button Clicked

- (void)backButtonClicked:(id)sender {

    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)iconButtonClicked:(id)sender {
    
    SettingViewController *settingViewController=[[SettingViewController alloc]initWithNibName:SETTINGVIEWCONTROLLER_NIB_NAME bundle:nil];
    UINavigationController *settingNavigationController=[[UINavigationController alloc]initWithRootViewController:settingViewController];
    [self.navigationController presentModalViewController:settingNavigationController animated:YES];
    [settingViewController release];
    settingViewController=nil;
    [settingNavigationController release];
    settingNavigationController = nil;
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath	{
	// Return the height of rows in the section.
	return 125;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([sectionItems count]%COL_COUNT==0) {

        return ([sectionItems count]/COL_COUNT);
    }
    else {
     
        return ([sectionItems count]/COL_COUNT)+1;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    GridCell *cell = (GridCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[GridCell alloc] init] autorelease];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //clear all the views if allready exists
    [[cell subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
  	// Configure the cell.
    [cell displayCellItems:[self readSubSectionItems:indexPath.row*COL_COUNT]:2];
    //cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Navigation logic may go here. Create and push another view controller.	
}


#pragma mark -
#pragma mark SUBSECTION ITEMS

//For reading sub section items
-(NSMutableArray *)readSubSectionItems:(int)index{

    NSMutableArray *items=[[[NSMutableArray alloc]init] autorelease];
    
    for(int section=index ,col=0;section<[sectionItems count];section++,col++){
        if (col<COL_COUNT) 
            [items addObject:[sectionItems  objectAtIndex:section]];
        else
            break;
    }
    return items;
}

#pragma mark - Button Events

-(void)sectionButtonPresssed:(UIButton *)section
{
    
    Grid *grid=[sectionItems objectAtIndex:0];
    UIButton *button = (UIButton *)section;
   // [button.layer setBorderWidth:1.0];
   // [button.layer setCornerRadius:5.0];
   // [button.layer setBorderColor:[[UIColor redColor] CGColor]];
    //for map
    if (button.tag == grid.idmenu) {
        
        MapViewController *mapViewController=[[MapViewController alloc]initWithNibName:MAPVIEWCONTROLLER_NIB_NAME bundle:nil];
        mapViewController.mapLink = grid.link;
        mapViewController.selectedButtonID = button.tag;
        mapViewController.locationSelectedCasinosName= selectedCasinosName;
        [self.navigationController pushViewController:mapViewController animated:YES];
        [mapViewController release];
         mapViewController = nil;
    }
    else {
        
        ListViewController *listViewController=[[ListViewController alloc]initWithNibName:LISTVIEWCONTROLLER_NIB_NAME bundle:nil];
        listViewController.homeSelectionID    = self.sectionID;
        listViewController.selectedButtonID   = button.tag;
        listViewController.selectedCasinosName= selectedCasinosName;
        [self.navigationController pushViewController:listViewController animated:YES];
        [listViewController release];
        listViewController=nil;
    }

}

#pragma mark - View Memory Release

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{

    [super dealloc];
    [sectionItems release];
    sectionItems=nil;
    listView = nil;
    //[selectedCasinosName release];
    // selectedCasinosName = nil;
    
}

- (void)viewWillDisappear:(BOOL)animated {

}

- (void)viewDidDisappear:(BOOL)animated {
     
    //DebugLog(@"RETAIN COUNT%d",[self retainCount]);   
    
}
- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
       return NO;
}

@end
