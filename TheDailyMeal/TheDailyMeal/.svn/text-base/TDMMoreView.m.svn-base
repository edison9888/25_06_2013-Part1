//
//  TDMMoreView.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 23/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMMoreView.h"
#import "TDMChannelsViewController.h"
#import "TDMOverlayView.h"

@implementation TDMMoreView

@synthesize cityService;
@synthesize cityGuideArray;

#define MORE_FAV_ROW_COUNT 1
#define MORE_SECSSION_COUNT 3
#define CHANNEL_SECTION_IMAGE @"ChannelTableSection.png"
#define WISH_LIST_RECT CGRectMake(0,0,320,40)
#define WISH_LIST_TITLE_FRAME CGRectMake(15,15,100,21)
#define IMAGE_FRAME CGRectMake(83,15,20,20)


-(void) dealloc
{
    self.cityGuideArray = nil;
    self.cityService = nil;
    moreTable.dataSource = nil;
    moreTable.delegate = nil;
    [moreTable release];
    [super dealloc];
}


#pragma mark    Overlay View Management
- (void)showOverlayView
{
    [self removeOverlayView];
    
    overlayView = [[TDMOverlayView alloc] initWithSyncStyleAndTitle:@"Loading..."];
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


#pragma mark - View Initialisation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addMoreView];
       
    }
    return self;
}

-(void) getCityList
{

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    cityService = [[TDMCityListService alloc]init];
    cityService.cityListDelegate = self;
    [self showOverlayView];
    [cityService getListOfCities];
    [pool drain];
}

- (void)addMoreView
{
    if([TDMDataStore sharedStore].needToUpdateCityList)
    {
        [NSThread detachNewThreadSelector:@selector(getCityList) toTarget:self withObject:nil];
    }
    else
    {
        
        [moreTable setHidden:NO];
        [moreTable reloadData];
        CGRect rect = CGRectMake(0,0, 320,500);
        [self startAnimation:rect uiview:self];
    }
    self.backgroundColor    = [UIColor clearColor];
    
    moreTable      = [[UITableView alloc]initWithFrame:CGRectMake(100,15, 270,470)];
    moreTable.backgroundColor    = [UIColor colorWithRed:((float)77.0)/255.0 
                                                   green:((float)80.0)/255.0 
                                                    blue:((float)93.0)/255.0 alpha:1.0];
    moreTable.showsVerticalScrollIndicator = NO;
    moreTable.dataSource = self;
    moreTable.delegate = self;
    moreTable.tag = 113;
    moreTable.scrollEnabled     = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag=111;
    button.frame = CGRectMake(0,0, 100,500);
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"arr.png"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(removeMoreViewButtonClicked:) 
                        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [self addSubview:moreTable];

}

#pragma mark - Animation

- (void)startAnimation:(CGRect )rect uiview:(UIView *)animatedView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.6];
    animatedView.frame  = rect;
    [UIView commitAnimations];
}

- (void)removeCurrentViewAnimated
{
    CGRect rect = CGRectMake(400,0, 250,500);
    [self startAnimation:rect uiview:self];
    [self performSelector:@selector(removeView:) withObject:self afterDelay:0.6];
    
}

- (void)removeView:(UIView *)currentView    
{
    [currentView removeFromSuperview];
    
}

#pragma mark - Button Actions

- (void)removeMoreViewButtonClicked:(id)sender
{   

    [self removeCurrentViewAnimated];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return MORE_SECSSION_COUNT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath	
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([[TDMDataStore sharedStore].cityListArray count]==0)
    {
        moreTable.hidden =YES;
    }
    
    if (section == FIRST_SECTION) {
        
        return MORE_FAV_ROW_COUNT;
    }
    else if (section == SECOND_SECTION)
    {
        //return [kARRAY_OF_CITYGUIDE_NAMES count];
        return [[TDMDataStore sharedStore].cityListArray count];
    }
    else if (section == THIRD_SECTION)
    {
        return [kARRAY_OF_CHANNEL_NAMES count]-1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int heightForHeader = 0;
    
    if (section != FIRST_SECTION) 
    {
        heightForHeader = 20;
    }
    
    return heightForHeader;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = nil;
    
    if (section != FIRST_SECTION) 
    {
        CGRect rect = CGRectMake(0, 0, tableView.frame.size.width, 20);
        headerView = [[[UIView alloc] initWithFrame:rect] autorelease];
        headerView.backgroundColor  = [UIColor clearColor];
        
        UIImageView *headerImage    = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CHANNEL_SECTION_IMAGE]];
        headerImage.frame           = rect;
        headerImage.backgroundColor = [UIColor clearColor];
        headerImage.alpha           = .9;
        
        UILabel *headerTitle        = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 20)];
        headerTitle.textColor       = [UIColor colorWithRed:159/255.0f green:162/255.0f blue:174/255.0f alpha:1.0];
        headerTitle.shadowColor=[UIColor darkGrayColor];
        headerTitle.shadowOffset=CGSizeMake(1, 1);
        
        headerTitle.font            = kGET_BOLD_FONT_WITH_SIZE(14);
        headerTitle.text            = [kARRAY_OF_SECTIONHEADING_NAMES objectAtIndex:section - 1];
        headerTitle.backgroundColor = [UIColor clearColor];
        headerTitle.textAlignment   = UITextAlignmentLeft;
        [headerImage addSubview:headerTitle];
        [headerTitle release];
        headerTitle=nil;
        
        [headerView addSubview:headerImage];
        [headerImage release];
        headerImage = nil;
    }
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell setBackgroundColor:[UIColor colorWithRed:((float)77.0)/255.0 green:((float)80.0)/255.0 blue:((float)93.0)/255.0 alpha:1.0]];
    [tableView setSeparatorColor:[UIColor colorWithRed:((float)43.0)/255.0 green:((float)49.0)/255.0 blue:((float)64.0)/255.0 alpha:1.0]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.font = kGET_REGULAR_FONT_WITH_SIZE(15);
    cell.textLabel.textColor    = [UIColor colorWithRed:197/255.0f green:205/255.0f blue:218/255.0f alpha:1.0];

    
    if ([cell.contentView subviews]){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    
    cell.textLabel.text = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == FIRST_SECTION) {
        
        [cell.contentView addSubview:[self addWishList]];
        
    }
    else if (indexPath.section == SECOND_SECTION)
    {
        cell.textLabel.text = [[TDMDataStore sharedStore].cityListArray objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == THIRD_SECTION)
    {
        cell.textLabel.text = [kARRAY_OF_CHANNEL_NAMES objectAtIndex:indexPath.row];
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect rect = CGRectMake(0,0, 250,500);
    [self startAnimation:rect uiview:self];
    
    [[NSUserDefaults standardUserDefaults] setInteger:kCHANNEL_TABBAR_INDEX  forKey:PREVIOUSLY_SELECTED_TAB_ID];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
   
    if (indexPath.section == FIRST_SECTION) {
        
        [appDelegate selectTabItem:6];
    }
    else if (indexPath.section == SECOND_SECTION)
    {
        [TDMDataStore sharedStore].cityName = [[TDMDataStore sharedStore].cityListArray objectAtIndex:indexPath.row];
        [TDMDataStore sharedStore].isCriteriaSearch = NO;
        [TDMDataStore sharedStore].guideType =@"Top Restaurants";
        [appDelegate selectTabItem:4];
    }
    else if (indexPath.section == THIRD_SECTION)
    {
        if (![Reachability connected]) {
            
            kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, NO_NETWORK_CONNECTIVITY);
        }
        else
        {
           //selected channel row
            [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row  forKey:SELECTED_CHANNEL_CATEGORY_ID_KEY];
            [appDelegate selectTabItem:5];
        }
    }
    
    [self removeCurrentViewAnimated];
}

#pragma mark - Wish List

- (UIView *)addWishList
{
    UIView *moreListView = [[[UIView alloc]initWithFrame:WISH_LIST_RECT] autorelease];

    [moreListView setBackgroundColor:[UIColor colorWithRed:((float)77.0)/255.0 green:((float)80.0)/255.0 blue:((float)93.0)/255.0 alpha:1.0]];
    // Heading
    UILabel *heading=[[UILabel alloc]initWithFrame:WISH_LIST_TITLE_FRAME];
    heading.textColor       = [UIColor colorWithRed:197/255.0f green:205/255.0f blue:218/255.0f alpha:1.0];
    heading.font = kGET_BOLD_FONT_WITH_SIZE(15);
    heading.backgroundColor  = [UIColor clearColor];
    heading.textAlignment=UITextAlignmentLeft;
    heading.text= @"Wish List";
    [moreListView addSubview:heading];
    [heading release];
    heading = nil;
    
    //ImgPath
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"wishListIcon"                                                                         
                                                        ofType:@"png"];
    UIImage *image   = [UIImage imageWithContentsOfFile:imgPath];
    
    UIImageView *wishListImageThumbnail=[[UIImageView alloc]init];
    wishListImageThumbnail.frame=IMAGE_FRAME;
    wishListImageThumbnail.backgroundColor=[UIColor clearColor];
    wishListImageThumbnail.userInteractionEnabled = NO;
    wishListImageThumbnail.image    = image;
    [moreListView addSubview:wishListImageThumbnail];
    [wishListImageThumbnail release];
    wishListImageThumbnail = nil;
    
    return moreListView;
}

#pragma mark - service delagates

-(void) gotCityList:(NSMutableArray *)responseArray
{
    if(cityService){
        cityService.cityListDelegate = nil;
        [cityService release];
        cityService = nil;
    }
    self.cityGuideArray = responseArray;
    [TDMDataStore sharedStore].cityListArray = self.cityGuideArray;
    [moreTable reloadData];
    [moreTable setHidden:NO];
        [self removeOverlayView];
    CGRect rect = CGRectMake(0,0, 320,500);
    [TDMDataStore sharedStore].needToUpdateCityList =NO;
    [self startAnimation:rect uiview:self];
}
-(void) failedToGetCityList
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:TDM_TITLE message:@"Failed to get City And Channel Details. Please try after some times" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [[TDMDataStore sharedStore].cityListArray removeAllObjects];
    [TDMDataStore sharedStore].needToUpdateCityList =YES;
    if(cityService){
        cityService.cityListDelegate = nil;
        [cityService release];
        cityService = nil;
    }
    [self removeOverlayView];
}

- (void)networkError
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:TDM_TITLE message:@"Network Error. Please try after some times" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [self removeOverlayView];
    [[TDMDataStore sharedStore].cityListArray removeAllObjects];
    [TDMDataStore sharedStore].needToUpdateCityList =YES;
    if(cityService){
        cityService.cityListDelegate = nil;
        [cityService release];
        cityService = nil;
    }

    
}

@end
