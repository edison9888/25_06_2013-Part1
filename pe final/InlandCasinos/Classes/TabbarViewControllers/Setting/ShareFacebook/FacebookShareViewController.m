//
//  FacebookShareViewController.m
//  PE
//
//  Created by Nithin George on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookShareViewController.h"
#import "SHK.h"

@implementation FacebookShareViewController

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
    self.navigationItem.title = FACEBOOK_TITLE;
    [self createCustomNavigationLeftButton];
    [self checkLiginStatus];
}

- (void)checkLiginStatus {
    
    loginStatus = [[NSUserDefaults standardUserDefaults]  integerForKey:@"FBUserId"];
    DebugLog(@"value==%d",loginStatus); 
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
    
    return FACEBOOK_SECSSION_COUNT;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return FACEBOOK_SECSSION0_ROWCOUNT;
    }
    else {
        return FACEBOOK_SECSSION1_ROWCOUNT;
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
//    UIFont *myFont = [ UIFont fontWithName: @"Helvetica-Bold" size: 15.0 ];
//    cell.textLabel.font  = myFont;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.userInteractionEnabled = NO;
                    UIFont *myFont = [ UIFont fontWithName: @"Helvetica-Bold" size: 15.0 ];
                    cell.textLabel.font  = myFont;
                    cell.textLabel.text        = TWITTER_SECSSION0_ROW0_TEXT;
                    
                    if (loginStatus!=0) {
                        UIFont *myFont = [ UIFont fontWithName: @"Helvetica-Bold" size: 15.0 ];
                        cell.textLabel.font  = myFont;
                      cell.detailTextLabel.text  = FACEBOOK_SECSSION0_ROW0_DESCRIPTION_TEXT_WITH_LOGIN;  
                    }
                    else {
                        UIFont *myFont = [ UIFont fontWithName: @"Helvetica-Bold" size: 15.0 ];
                        cell.textLabel.font  = myFont;
                        cell.detailTextLabel.text  = FACEBOOK_SECSSION0_ROW0_DESCRIPTION_TEXT_WITHOUT_LOGIN;
                    }
                    
                    break;
                    
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    if (loginStatus!=0) {
                        UIFont *myFont = [ UIFont fontWithName: @"Helvetica-Bold" size: 15.0 ];
                        cell.textLabel.font  = myFont;
                        cell.textLabel.textColor = [UIColor blackColor];
                        cell.userInteractionEnabled = YES;
                    }
                    else {
                        UIFont *myFont = [ UIFont fontWithName: @"Helvetica-Bold" size: 15.0 ];
                        cell.textLabel.font  = myFont;
                    cell.textLabel.textColor = [UIColor grayColor];
                       cell.userInteractionEnabled = NO;
                        //cell.textLabel.
                    }
                    cell.textLabel.textAlignment = UITextAlignmentCenter;
                    cell.textLabel.text        = FACEBOOK_SECSSION1_ROW0_TEXT;
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
                    break;
            }
            break;
    }
}


- (void)logOut {
    //SHKTwitter
    [SHK logoutOfService:@"SHKFacebook"];
    [self checkLiginStatus];
    [contentTable reloadData];
}

- (void)dealloc
{
    [super dealloc];
    contentTable = nil;
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
