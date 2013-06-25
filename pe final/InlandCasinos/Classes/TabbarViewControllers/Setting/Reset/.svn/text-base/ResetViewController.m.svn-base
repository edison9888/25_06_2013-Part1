//
//  ResetViewController.m
//  PE
//
//  Created by Nithin George on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResetViewController.h"


@implementation ResetViewController

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
    self.navigationItem.title = SETTING_SECSSION1_ROW2_TEXT;
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return RESET_SECSSION_COUNT;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return RESET_SECSSION0_ROWCOUNT;
    }
    else {
        return RESET_SECSSION1_ROWCOUNT;
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
        return RESET_SECSSION1_FOOTER;
    
}

//RootViewController.m
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.textAlignment=UITextAlignmentCenter;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text        = RESET_SECSSION0_ROW0_TEXT;
                    break;

            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text        = RESET_SECSSION1_ROW0_TEXT;
                    break;
                    
                case 1:
                    cell.textLabel.text        = RESET_SECSSION1_ROW1_TEXT;
                    break;
 
            }
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSString *actionButtonTitle =   nil;
    NSString *actionTitle   =   nil;
    int      actionSheetTagValue = 0;
   
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    actionTitle         = CLEAR_CACHE_TITLE;
                    actionButtonTitle   = ACTION_BUTTON_TITLE;
                    actionSheetTagValue =1;
                    break;
                    
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    actionTitle         = RESET_CACHE_TITLE; 
                    actionButtonTitle   = RESET_BUTTON_TITLE;
                    actionSheetTagValue = 2;
                    break;
                    
                case 1:
                    actionTitle         = RESET_ALL_CACHE_TITLE;
                    actionButtonTitle   = RESET_ALL_BUTTON_TITLE;
                    actionSheetTagValue = 3;
                    break;
                    
            }
            break;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle delegate:self cancelButtonTitle:@"Cancel"destructiveButtonTitle:nil otherButtonTitles:actionButtonTitle,nil];
    actionSheet.tag = actionSheetTagValue;
    [actionSheet showInView:self.view];
    [self.view bringSubviewToFront:actionSheet];
    [actionSheet release]; 
}

#pragma mark Action sheet delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //sharebutton Action sheet
    switch (actionSheet.tag) {
        case 1:
            switch (buttonIndex) {
                case 0:
                    DebugLog(@"clear");
                    break;
             }
            break;
        case 2:
            switch (buttonIndex) {
                case 0:
                    DebugLog(@"Reset");
                    break;
            }
            break;
        case 3:
            switch (buttonIndex) {
                case 0:
                     DebugLog(@"Reset All");
                    break;
            }
            break;
    }
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
