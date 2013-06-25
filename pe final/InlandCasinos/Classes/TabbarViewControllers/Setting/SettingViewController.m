//
//  SettingViewController.m
//  PE
//
//  Created by Nithin George on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "TwitterViewController.h"
#import "FacebookShareViewController.h"
#import "ResetViewController.h"
#import "DBHandler.h"
#import "DownloadManager.h"
#import "InlandCasinosAppDelegate.h"
#import "ConnectivityCheck.h"

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];

}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = TEXT_SETTING;
    [self createCustomNavigationLeftButton];
    
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

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

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return SETTING_SECSSION_COUNT;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (section == 0) {
//        return SETTING_SECSSION0_ROWCOUNT;
//    }
     if (section == 0) {
        return SETTING_SECSSION1_ROWCOUNT;
    }
    else {
       return SETTING_SECSSION2_ROWCOUNT; 
    }
}
//RootViewController.m
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
//    if(section == 0)
//        return SETTING_SECSSION0_HEADER;
    if(section == 0)
        return SETTING_SECSSION1_HEADER;
    else
       return SETTING_SECSSION2_HEADER; 
}

//RootViewController.m
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    switch (indexPath.section) {
//        case 0:
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            switch (indexPath.row) {
//                case 0:
//                    cell.textLabel.text        = SETTING_SECSSION0_ROW0_TEXT;
//                    break;
//                    
//                case 1:
//                    cell.textLabel.text        = SETTING_SECSSION0_ROW1_TEXT;
//                    break;
//            }
//            break;
            
        case 0:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text        = SETTING_SECSSION1_ROW1_TEXT;//SETTING_SECSSION1_ROW0_TEXT;
                    break;
                case 1:
                    cell.textLabel.text        = SETTING_SECSSION1_ROW1_TEXT;
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text        = SETTING_SECSSION2_ROW0_TEXT;
                    break;
            }
            break;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
//        case 0:
//            switch (indexPath.row) {
//                case 0:
//                    [self loadShareTwitter];
//                    break;
//                    
//                case 1:
//                    [self loadShareFacebook];
//                    break;
//            }
//            break;
            
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self seetingMailBodyComponents:SETTING_MAIL2_TO_ADDRESS:SETTING_MAIL2_SUBJECT:SETTING_MAIL2_BODY];
                    //[self seetingMailBodyComponents:SETTING_MAIL1_TO_ADDRESS:SETTING_MAIL1_SUBJECT:SETTING_MAIL1_BODY];
                    break;
                case 1:
                    [self seetingMailBodyComponents:SETTING_MAIL2_TO_ADDRESS:SETTING_MAIL2_SUBJECT:SETTING_MAIL2_BODY];
                    break;
            }
            break;
       case 1:
            [self showActivitySheet];
            break;
    }
}


#pragma mark - mail composer
- (void)seetingMailBodyComponents:(NSString *)toAddress:(NSString *)subject:(NSString *)body {
    NSArray *toRecipients;
    MFMailComposeViewController *mailController ;
    if ([MFMailComposeViewController  canSendMail]) {
    mailController = [[[MFMailComposeViewController alloc] init] autorelease];
    if(mailController )
    toRecipients = [NSArray arrayWithObjects:toAddress, nil]; 
    [mailController setToRecipients:toRecipients];
	[mailController setSubject:subject];
	[mailController setMessageBody:body isHTML:false];
    mailController.mailComposeDelegate = self;
    [self  presentModalViewController:mailController animated:true];
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                              
                                                        message:@"Kindly configure your system mail"
                              
                                                       delegate:self
                              
                                              cancelButtonTitle:@"OK"
                              
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}



-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EMailsendung fehlgeschlagen!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [controller dismissModalViewControllerAnimated:true];
}

#pragma mark - 

- (void)showActivitySheet {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:CLEAR_CACHE_TITLE delegate:self cancelButtonTitle:@"Cancel"destructiveButtonTitle:nil otherButtonTitles:ACTION_BUTTON_TITLE,nil];
    [actionSheet showInView:self.view];
    [self.view bringSubviewToFront:actionSheet];
    [actionSheet release]; 
    
}
#pragma mark Action sheet delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //sharebutton Action sheet
    switch (buttonIndex) {
        case 0:
            [self clearCache];
            break;
    }
}

- (void)clearCache {
    
    
    ConnectivityCheck *networkCheck = [[ConnectivityCheck alloc] init];
    
    if([networkCheck isHostReachable])
    {

        [[DBHandler sharedManager]deletelist];
        [[DBHandler sharedManager]deletelistImage];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        
        NSString *folderPath = [NSString stringWithFormat:@"%@/PE.com", documentsDirectoryPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:folderPath error:NULL];
        InlandCasinosAppDelegate *appDelegate = (InlandCasinosAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate startSynching];
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"No network connectivity"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        alert.delegate = self;
        [alert show];
        [alert release];
        
    }
    [networkCheck release];
    networkCheck = nil;
    
    

}

- (void)loadShareTwitter {
    
    TwitterViewController *twitterViewController=[[TwitterViewController alloc]initWithNibName:@"ResetViewController" bundle:nil];
    [self.navigationController pushViewController:twitterViewController animated:YES];
    [twitterViewController release];
    twitterViewController=nil;
}

- (void)loadShareFacebook {
    
    FacebookShareViewController *shareFacebook=[[FacebookShareViewController alloc]initWithNibName:@"FacebookShareViewController" bundle:nil];
    [self.navigationController pushViewController:shareFacebook animated:YES];
    [shareFacebook release];
    shareFacebook=nil;
    
}
/*
- (void)loadResetView {
    
    ResetViewController *resetViewController=[[ResetViewController alloc]initWithNibName:@"ResetViewController" bundle:nil];
    [self.navigationController pushViewController:resetViewController animated:YES];
    [resetViewController release];
    resetViewController=nil;
}*/


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
