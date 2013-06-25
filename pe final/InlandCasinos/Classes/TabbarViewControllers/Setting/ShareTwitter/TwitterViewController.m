//
//  TwitterViewController.m
//  InlandCasinos
//
//  Created by Nithin George on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TwitterViewController.h"
#import "SHK.h"

@implementation TwitterViewController

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
    self.navigationItem.title = TWITTER_TITLE;
    [self createCustomNavigationLeftButton];
    [self checkSocialNetworkLoginStatus];
}

-(void)checkSocialNetworkLoginStatus
{
    bTwitter=NO;
    NSString *twitterAccess=[SHK getAuthValueForKey:@"accessKey" forSharer:SHKTwitterClass];
    
    if(twitterAccess!=nil)
    {
        bTwitter=YES;
    }
}

- (void)createCustomNavigationLeftButton {
    [self.navigationItem hidesBackButton];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 27);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:SETTING_CLOSE_IMAGE] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    button=nil;
    [item release];
    item = nil;
}

#pragma mark - button clicked
- (IBAction)doneButtonClicked:(id)sender {
    
    [[self navigationController] dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

//#define FACEBOOK_SECSSION0_ROW0_DESCRIPTION_TEXT_WITHOUT_LOGIN @"Not Logged In"

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return TWITTER_SECSSION_COUNT;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return TWITTER_SECSSION0_ROWCOUNT;
    }
    else {
        return TWITTER_SECSSION1_ROWCOUNT;
    }
}

//RootViewController.m
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"";
    else
        return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    if(section == 0)
        return @"";
    else
        return TWITTER_SECSSION0_FOOTER;
    
}

//RootViewController.m
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.textAlignment=UITextAlignmentCenter;
    UIFont *myFont = [ UIFont fontWithName: @"Helvetica-Bold" size: 15.0 ];
    cell.textLabel.font  = myFont;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.userInteractionEnabled = NO;
                    cell.textLabel.text        = TWITTER_SECSSION0_ROW0_TEXT;
                    if (bTwitter)
                    {
                        cell.detailTextLabel.text  = TWITTER_SECSSION0_ROW0_DESCRIPTION_TEXT_WITH_LOGIN;  
                    }
                    else
                    {
                        cell.detailTextLabel.text  = TWITTER_SECSSION0_ROW0_DESCRIPTION_TEXT_WITHOUT_LOGIN;  
                    }

                    break;
                    
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    
                    if (bTwitter) {
                        cell.textLabel.textColor = [UIColor blackColor];
                        cell.userInteractionEnabled = YES;
                    }
                    else {
                        cell.textLabel.textColor = [UIColor grayColor];
                        cell.userInteractionEnabled = NO;
                    }
                   // cell.textLabel.backgroundColor = [UIColor redColor];
                    cell.textLabel.textAlignment = UITextAlignmentCenter;
                    cell.textLabel.text        = TWITTER_SECSSION1_ROW0_TEXT;
                    break;
                    
            }
            break;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self logOut];
                    [tableView reloadData];
                    break;
            }
            break;
    }
}

- (void)logOut {
    
    [SHK logoutOfService:@"SHKTwitter"];
    [self checkSocialNetworkLoginStatus];
}

- (void)loadShareFacebook {
    
    /*Sample *shareFacebook=[[Sample alloc]initWithNibName:@"Sample" bundle:nil];
     [self.navigationController pushViewController:shareFacebook animated:YES];
     [shareFacebook release];
     shareFacebook=nil;*/
    
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
