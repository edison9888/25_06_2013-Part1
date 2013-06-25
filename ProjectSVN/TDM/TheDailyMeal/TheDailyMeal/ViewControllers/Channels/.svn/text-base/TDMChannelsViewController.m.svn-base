//
//  TDMChannelsViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/3/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMChannelsViewController.h"
#import "TDMChannelListCell.h"
#import "TDMAppDelegate.h"
#import "Reachability.h"

#define LISTVIEW_COL_COUNT 1

#define EMPTY_STRING @""

int const quotesCellHeight = 100;

@implementation TDMChannelsViewController
@synthesize overlay;
@synthesize backgroungImage;
@synthesize channelTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self createCustomisedNavigationTitleWithString:kTABBAR_TITLE_CHANNELS];
        self.tabBarItem.image = kTABBAR_CHANNELS_IMAGE;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.channelTable = nil;
    self.backgroungImage = nil;
}

- (void)dealloc
{
    self.channelTable = nil;
    self.backgroungImage = nil;
    REMOVE_FROM_MEMORY(channelDetails);
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    if (![Reachability connected]) {
        
        kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, NO_NETWORK_CONNECTIVITY);
    }
    else
    {
            
        channelDetails = [[NSMutableArray alloc]init];
        
        TDMAppDelegate *appDelegate = (TDMAppDelegate *)[UIApplication sharedApplication].delegate;
        
        self.overlay = [TDMLoadingOverlay loadOverView:appDelegate.window
                                           withMessage:@"Fetching channel information..." 
                                              animated:YES];
        [self performSelector:@selector(parseChannelsContents) withObject:nil afterDelay:0.05];
        [self.navigationItem setHidesBackButton:YES animated:NO];
    }

}

#pragma mark - Overlay Method
- (void)hideOverlay {
    [self.overlay removeFromSuperview:YES];
    self.overlay = nil;
}

#pragma mark -
#pragma mark Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath	{
    
	return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        
    return [channelDetails count] ;     
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    static NSString *cellIdentifier = @"cellIdentifier";
    TDMChannelListCell *channelListCell  = (TDMChannelListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (channelListCell == nil) {
        channelListCell = [[TDMChannelListCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                               reuseIdentifier:cellIdentifier];
        [channelListCell autorelease];
        channelListCell.frame = CGRectMake(0.0, 0.0, 320.0, quotesCellHeight);
    }
     
    [channelListCell displayCellItems:[channelDetails objectAtIndex:indexPath.row]];
    
    return channelListCell; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id channel = [channelDetails objectAtIndex:indexPath.row];
    TDMChannelDetails *rssLink   = (TDMChannelDetails *)channel;
    NSString *storyLink = rssLink.channelLink;
    
    // clean up the link - get rid of spaces, returns, and tabs...
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@" " withString:EMPTY_STRING];
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@"\n" withString:EMPTY_STRING];
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@"	" withString:EMPTY_STRING];

    // open in Safari
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:storyLink]];
    
}


#pragma mark- XML Parser Delegates

-(void)didFinished:(NSMutableArray *)channels{

    channelDetails = [channels mutableCopy];
    [self.channelTable reloadData];
    [self hideOverlay];
}

-(void) didFailedWithError{
    
     [self hideOverlay];
}


#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        
   [self hideOverlay];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
