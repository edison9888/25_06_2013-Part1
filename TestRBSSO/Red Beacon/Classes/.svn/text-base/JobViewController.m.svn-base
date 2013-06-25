//
//  JobViewController.m
//  Red Beacon
//
//  Created by Nithin George on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JobViewController.h"
#import "GridCell.h"
#import "JobRequestViewController.h"
#import "InfoPage.h"
#import "UINavigationItem + RedBeacon.h"
#import "ManagedObjectContextHandler.h"
#import "Reachability.h"
#import "Red_BeaconAppDelegate.h"

@interface JobViewController (Private)
- (void)populateJobCategories;
@end

@implementation JobViewController
@synthesize jobTable;
@synthesize delegate;
@synthesize defaultScreen;


#pragma mark - initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupNavigationBar {
    
    [self.navigationItem setRBIconImage];
    
    //right bar button item
    UIButton * settingsButton = [[UIButton alloc] initWithFrame:jvcBarButtonItemFrame];
    NSString * imagePath = [[NSBundle mainBundle] pathForResource:kRBInfoImage ofType:kRBImageType];
    UIImage * image  = [UIImage imageWithContentsOfFile:imagePath]; 
    [settingsButton setImage:image forState:UIControlStateNormal];
//    [settingsButton setBackgroundImage:image forState:UIControlStateNormal];    
    [settingsButton addTarget:self action:@selector(showInfoView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * settingsBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    [self.navigationItem setRightBarButtonItem:settingsBarButtonItem];
    [settingsButton release];
    settingsButton = nil;
    [settingsBarButtonItem release];
    settingsBarButtonItem = nil;
    
    //to adjust the title position
    UIButton * button = [[UIButton alloc] initWithFrame:jvcBarButtonItemFrame];
    UIBarButtonItem * barbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barbuttonItem];
    [button release];
    button = nil;
    [barbuttonItem release];
    barbuttonItem = nil;
}

- (void)populateJobCategories {
    job = [[NSMutableArray alloc]init];
    NSMutableArray * occupations = [[ManagedObjectContextHandler sharedInstance] fetchAllOccupations];
    for (OccupationModel * occupation in occupations) {
        [job addObject:occupation.displayName];
    }
    //more soon option removed
    //[job addObject:@"more soon..."];
}

- (void)checkForJobCategories {
    
    if ([Reachability connected])
    {
        if (!mobileContent)
        {
            mobileContent = [[RBMobileContentHandler alloc] init];
        }
        
        mobileContent.delegate = self;
        requestType = kContent;
        [mobileContent sendContentRequest];
    } 

}

- (void)setupTableView {
    UILabel *tableHeader = [[UILabel alloc]initWithFrame:CGRectMake(0,0,320,10)];
    tableHeader.backgroundColor = [UIColor clearColor];
    tableHeader.text = @"";
    jobTable.tableHeaderView = tableHeader;
    [tableHeader release];
    tableHeader = nil;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self populateJobCategories];
    [self setupNavigationBar];
    [self checkForJobCategories];
}


/*- (void)populateHardCorededArray {

    job = [[NSMutableArray alloc]init];
     [job addObject:@"Carpet Cleaner"];
     [job addObject:@"Movers"];
     [job addObject:@"Carpenter"];
     [job addObject:@"Painter"];
     [job addObject:@"Contracter"];
     [job addObject:@"Plumber"];
     [job addObject:@"Electrician"];
     [job addObject:@"Roofer"];
     [job addObject:@"Handyman"];
     [job addObject:@"Yard Worker"];
     [job addObject:@"Maid"];
    [job addObject:@"more soon..."];
    [jobTable reloadData];
}*/

- (void)addSettingButton
{
    // Info button
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight]; 
    [infoButton addTarget:self action:@selector(showInfoView:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];

}

#pragma mark -
#pragma mark Table view data source
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

  if ([job count]%COL_COUNT==0) {
        
        return ([job count]/COL_COUNT);
    }
    
    else {
        
        return ([job count]/COL_COUNT)+1;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    GridCell *cell = (GridCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil)
    {
        cell=[[[GridCell alloc] init] autorelease];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [[cell subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell displayCellItems:[self readHomeSectionItems:indexPath.row*COL_COUNT]];
	// Configure the cell.
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -
#pragma mark Home Section Items

- (NSMutableArray *)readHomeSectionItems:(int)index
{
    
    NSMutableArray *secions;
    secions=[[[NSMutableArray alloc]init] autorelease];
    for(int item=index ,col=0;item<[job count];item++,col++)
    {
        if (col<COL_COUNT) 
        {
            [secions addObject:[job  objectAtIndex:item]];
        }
        else
        {
            break;
        }
    }
    
    return secions;
}


#pragma mark - Button Events

- (void)sectionButtonPresssed:(UIButton *)section
{
    UIButton *button = (UIButton *)section;
    
    if ([button.titleLabel.text isEqualToString:JOB_LAST_ITEM]) 
    {
        
    }
    else 
    {        
        [delegate jobViewDidUnload:button.titleLabel.text];
    }
}

- (void)showJobRequestViewWithTitle:(NSString*)title
{
    self.navigationItem.title = HOME_NAVIGATION_TITLE;
    JobRequestViewController *jobRequestViewController = [[JobRequestViewController alloc] 
                                                          initWithNibName:@"JobRequestViewController" 
                                                          bundle:nil];
    
    jobRequestViewController.jobTitle = title;
    [self.navigationController pushViewController:jobRequestViewController animated:YES];
    
    [jobRequestViewController release];
    jobRequestViewController = nil;
}

- (void)showInfoView:(id)sender
{
    InfoPage *infoController = [[InfoPage alloc] initWithNibName:@"InfoPage" bundle:nil];
    
    UINavigationController *infoPageNavigationController = [[UINavigationController alloc]
                                                            initWithRootViewController:infoController];
    [self.navigationController presentModalViewController:infoPageNavigationController animated:YES];
    
    [infoPageNavigationController release];
    infoPageNavigationController = nil;
    
    [infoController release];
    infoController = nil;
}

- (IBAction)callButtonClick:(id)sender
{
    [[UIApplication sharedApplication] 
                               openURL:[NSURL URLWithString:@"tel:1-855-723-2266"]];
}

#pragma mark -

- (void)viewDidUnload
{
    self.jobTable = nil;
    [super viewDidUnload];
}


#pragma mark - memory relese

- (void)dealloc
{
    [job release];
    job = nil;
    
    [mobileContent release];
    mobileContent = nil;
    
    [jobTable release];
    jobTable = nil;
    
    [super dealloc];

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - HTTP Delegate Methods
- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request
{      
    [self populateJobCategories];
    [jobTable reloadData];
}

- (void)requestCompletedWithErrors:(ASIHTTPRequest*)request
{
    NSLog(@"Job Categories request failed");
}

@end
