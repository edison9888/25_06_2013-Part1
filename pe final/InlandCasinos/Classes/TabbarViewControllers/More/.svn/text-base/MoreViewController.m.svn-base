//
//  MoreViewController.m
//  PE
//
//  Created by Nibin_Mac on 25/06/11.
//  Copyright 2011 Rapidvalue Inc. All rights reserved.
//

#import "MoreViewController.h"
#import "AboutViewController.h"
#import "ListViewController.h"
#import "SettingViewController.h"

@implementation MoreViewController

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
    [super viewDidLoad];
    [self createCustomNavigationLeftButton];
    self.navigationItem.title = TABBAR_MORE;
    // Do any additional setup after loading the view from its nib.
}


- (void)createCustomNavigationLeftButton {
    
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
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MORE_SECSSION_COUNT;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MORE_SECSSION0_ROWCOUNT;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = TEXT_ABOUT;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case 1:
            cell.textLabel.text = TEXT_FAVORITES; 
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
            cell.textLabel.text = TEXT_SETTING;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
    }
 
	// Configure the cell.
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Navigation logic may go here. Create and push another view controller.
    
    switch (indexPath.row) {
        case 0:
            [self loadAboutViewController];
            break;
            
        case 1:
            [self loadFavoriteViewController];
            break;
        case 2:
            [self loadSettingViewController];
            break;
    }
}

- (void)loadAboutViewController {
        
    AboutViewController *aboutViewController      = [[AboutViewController alloc]initWithNibName:ABOUTVIEWCONTROLLER_NIB_NAME bundle:nil];
    [self.navigationController pushViewController:aboutViewController animated:YES];
    [aboutViewController release];
    aboutViewController=nil;
} 

- (void)loadFavoriteViewController {
        
    ListViewController *FavoritesListViewController = [[ListViewController alloc]initWithNibName:LISTVIEWCONTROLLER_NIB_NAME bundle:nil];
    [self.navigationController pushViewController:FavoritesListViewController animated:YES];
    [FavoritesListViewController release];
    FavoritesListViewController=nil;
    activePublisherID = PremierPagePublisherID;
}

- (void)loadSettingViewController
{
    SettingViewController *settingViewController   =  [[SettingViewController alloc]initWithNibName:SETTINGVIEWCONTROLLER_NIB_NAME bundle:nil];
    UINavigationController *settingNavigationController=[[UINavigationController alloc]initWithRootViewController:settingViewController];
    
    [self.navigationController presentModalViewController:settingNavigationController animated:YES];
    
    [settingNavigationController release];
    
    [settingViewController release];
    
    settingViewController=nil;
}	


#pragma  mark - Button Events

- (void)iconButtonClicked:(id)sender {
    
    [self loadSettingViewController];
}

#pragma mark - Orientation methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory Release methods

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


@end
