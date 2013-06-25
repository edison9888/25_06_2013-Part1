//
//  TDMChannelsViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/3/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMChannelsViewController.h"
#import "TDMChannelListCell.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "TDMChannelDetails.h"

#define LISTVIEW_COL_COUNT 1

#define EMPTY_STRING @""

int const quotesCellHeight = 100;

@implementation TDMChannelsViewController
@synthesize backgroungImage;
@synthesize channelsName;
@synthesize channelTable;

#pragma mark - Memory management

- (void)viewDidUnload
{
    [self setChannelsName:nil];
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
    
    [channelsName release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self createCustomisedNavigationTitleWithString:@"Channels"];
         [self.navigationItem setTDMIconImage];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    int row = [[[NSUserDefaults standardUserDefaults]objectForKey:SELECTED_CHANNEL_CATEGORY_ID_KEY]intValue];
    NSString *channelName = [kARRAY_OF_CHANNEL_NAMES objectAtIndex:row];
    self.channelsName.text = channelName;
    [self.navigationItem setTDMIconImage];
    if ([self.tabBarController.moreNavigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        UIImage *backgroundImage = [UIImage imageNamed:@"navigationBar.png"];
        [self.tabBarController.moreNavigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
  
}


- (void)refreshView 
{
    if (![Reachability connected]) {
        
        kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, NO_NETWORK_CONNECTIVITY);
    }
    else
    {
        
        channelDetails = [[NSMutableArray alloc]init];
        
        [self showOverlayView];
        
        [self performSelector:@selector(parseChannelsContents) withObject:nil afterDelay:0.05];
        [self.navigationItem setHidesBackButton:YES animated:NO];
    }
    int row = [[[NSUserDefaults standardUserDefaults]objectForKey:SELECTED_CHANNEL_CATEGORY_ID_KEY]intValue];
    NSString *channelName = [kARRAY_OF_CHANNEL_NAMES objectAtIndex:row];
    self.channelsName.text = channelName;

}


#pragma mark - Overlay Method

- (void)showOverlayView
{
    [self removeOverlayView];
    
    overlayView = [[TDMOverlayView alloc] initWithSyncStyleAndTitle:@"Fetching information.."];
}

- (void)removeOverlayView
{
    if (overlayView)
    {
        [overlayView removeFromSuperview];
        [overlayView release];
        overlayView = nil;
    }
}

#pragma mark - Table view data source


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
    [self performSelector:@selector(removeOverlayView) withObject:self afterDelay:2.5];
}

-(void) didFailedWithError{
    
   [self removeOverlayView];
}


#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        
   [self removeOverlayView];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
