//
//  AboutViewController.m
//  PE
//
//  Created by Nithin George on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "LegalViewController.h"

@implementation AboutViewController

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
    self.navigationItem.title = TEXT_ABOUT;
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
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    // bannerView_.backgroundColor=[UIColor redColor];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
    [self.view addSubview:bannerView_];
    [bannerView_ release];
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return ABOUT_SECSSION_COUNT;
}


// Customize the number of rows in the table view.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    if (section == 0) {
        return ABOUT_SECSSION0_ROWCOUNT;
    }
    else if (section == 1){
        return ABOUT_SECSSION1_ROWCOUNT;
    }
    else {
        return ABOUT_SECSSION2_ROWCOUNT;
    }
}
//RootViewController.m
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"";
    else
        return @"";
}

//RootViewController.m
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    

    switch (indexPath.section) {
        case 0:
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            //cell.userInteractionEnabled = NO;
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text        = ABOUT_SECSSION0_ROW0_TEXT;
                    cell.detailTextLabel.text  = ABOUT_SECSSION0_ROW0_DETAILED_TEXT;
                    break;
                    
                case 1:
                    cell.textLabel.text        = ABOUT_SECSSION0_ROW1_TEXT;
                    cell.detailTextLabel.text  = ABOUT_SECSSION0_ROW1_DETAILED_TEXT;
                    break;
            }
            break;
        
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text        = ABOUT_SECSSION1_ROW0_TEXT;
                    break;
                    
                case 1:
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text        = ABOUT_SECSSION1_ROW1_TEXT;
                    break;
                    
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text        = ABOUT_SECSSION2_ROW0_TEXT;
                    break;
                    
                default:
                    break;
            }
            break;
    }
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (indexPath.section) {
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self loadLegalView:indexPath.row];
                    break;
                case 1:
                    [self loadLegalView:indexPath.row];
                    break;
            }
            break;

        case 2:
                    [self loadLegalView:indexPath.section];
            break;
            
    }
}

- (void)loadLegalView:(int)rowIdentifier {
    
    LegalViewController *legalViewController=[[LegalViewController alloc]initWithNibName:@"LegalViewController" bundle:nil];
    legalViewController.viewIdentifier = rowIdentifier;
    [self.navigationController pushViewController:legalViewController animated:YES];
    [legalViewController release];
    legalViewController=nil;
    
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
