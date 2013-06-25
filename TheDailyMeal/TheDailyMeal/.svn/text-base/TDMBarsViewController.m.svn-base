//
//  TDMBarsViewController.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 13/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMBarsViewController.h"
#import "TDMMapViewAddress.h"
#import "BussinessModel.h"
#import "TDMBusinessDetails.h"
#import "TDMBusinessViewController.h"
#import "DatabaseManager.h"
#import "TDMNavigationController.h"
#import "BussinessModel.h"
#import "BussinessCellView.h"

@interface TDMBarsViewController()

@property (nonatomic) int transitionStyle;
@property (nonatomic,retain) NSMutableArray *arrayOfAddressID;

- (void) customiseCurrentView;
- (void) addSegmentedControl;
- (void) dismissKeyBoardAndSetNavBar;

#pragma mark - GPS Location Scanning
- (void)stopGPSScan;
- (void)startGPSScan;

#pragma mark    -
#pragma mark    Overlay View Management
- (void)showOverlayView;
- (void)removeOverlayView;

#pragma mark    TableView reload data
- (void)reloadTableView;

#pragma mark    -
#pragma mark    Check and Verify API Calls
- (BOOL)needToUpdateBarsList;

@end

@implementation TDMBarsViewController
@synthesize stausOfBarLabel;
@synthesize searchBar;
@synthesize contentView;
@synthesize segmentControl;
@synthesize selectedSegmentIndex;
@synthesize mapView;
@synthesize barHeadersArray;
@synthesize barTableView;
@synthesize transitionStyle;
@synthesize arrayOfAddressID;
@synthesize  isFromFavorites;
@synthesize searchView;
@synthesize lastBarsLocationLongitude;
@synthesize lastBarsLocationLatitude;
@synthesize searchRestaurant;
@synthesize searchAddress;
@synthesize advancedButton;
@synthesize cancelButton;
#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc 
{
    [stausOfBarLabel release];
    [searchBar release];
    [contentView release];
    [barTableView release];
    [mapView release];
    
    [cancelButton release];
    [super dealloc];
}


- (void)viewDidUnload
{
    [self setStausOfBarLabel:nil];
    [self setSearchBar:nil];
    [self setContentView:nil];
    [self setBarTableView:nil];
    [self setMapView:nil];
    [imageCache removeAllObjects];
    
    [self setCancelButton:nil];
    [super viewDidUnload];
}


#pragma mark - Gets Bar Details

- (void)adjustSearchBar:(int)length
{
    CGRect searchBarRect = searchBar.frame;
    searchBarRect.size.width = length;
    searchBar.frame = searchBarRect;
    self.searchBar.backgroundColor =[UIColor clearColor];
    if (length == 206) {
        self.segmentControl.hidden = NO;
        CGRect tableFrame = self.barTableView.frame;
        tableFrame.size.height = 255;
        self.barTableView.frame = tableFrame;
    }
    else {
        CGRect tableFrame = self.barTableView.frame;
        tableFrame.size.height = 320;
        self.barTableView.frame = tableFrame;
    }
    
}
- (void)displaySearchView:(BOOL)value{
    
    self.searchView.hidden = !(value);
    self.barTableView.hidden = value;
    if (value) {
       
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        if (searchBar.text.length>0) {
             self.searchRestaurant.text = searchBar.text;
        }
        else {
            self.searchRestaurant.text = nil;
        }
        self.searchAddress.text  = nil;
    }
    if (segmentControl.selectedSegmentIndex == 0) {
        self.mapView.hidden = value;
    }
    
    [self.stausOfBarLabel setHidden:value];
    
}
- (void)displayAdvancedButton:(BOOL)value{
    
    advancedButton.hidden = !(value);
}


-(void) getBarDetails
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    TDMBusinessService *baseHandler = [[TDMBusinessService alloc] init] ;//fix memory leak.
    [baseHandler getBars];
    baseHandler.serviceDelegate = self;
    [baseHandler getBars];
    [pool drain];
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        [self.navigationItem setTDMIconImage];
        
        self.lastBarsLocationLatitude = KDEFAULTLATITUDE;
        self.lastBarsLocationLongitude = KDEFAULTLONGITUDE;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageCache = [[NSMutableDictionary alloc] init];
    [self customiseCurrentView];
    [[self.searchBar.subviews objectAtIndex:0] removeFromSuperview];
    [self addSegmentedControl];
    if (!fullData)
    {
        fullData = [[NSMutableArray alloc] init];
    }
    if (isFromFavorites == 1) 
    {
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
    }
    [self createRefreshButtonOnNavBarForViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self displaySearchView:NO];
    [self displayAdvancedButton:NO];
     self.cancelButton.hidden = YES;
     [self adjustSearchBar:206];
    
    if ([self.barHeadersArray count] == 0) 
    {
        self.barTableView.hidden = YES;        
    }
    else
    {
        self.barTableView.hidden = NO;
        self.stausOfBarLabel.hidden = YES;
    }

    
     

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[LocationManager sharedManager] setDelegate:self];
    if (animated) {
        if ([self needToUpdateBarsList])
        {
            [self initialiseView];
        }
    }
    else if([self needToUpdateBarsList])
    {
        [self initialiseView];
    }
    
}

#pragma mark - Handle Orientations

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark  - ViewCreations

- (void)initialiseView
{
    [self showOverlayView];
    
    [NSThread detachNewThreadSelector:@selector(getBarDetails) toTarget:self withObject:nil];
}

- (void)customiseCurrentView
{
    [self showTabbar];
    self.mapView.hidden = YES;
    stausOfBarLabel.hidden = YES;
    [self createAdView];
    searchRestaurant.autocorrectionType=UITextAutocorrectionTypeNo;
    searchAddress.autocorrectionType=UITextAutocorrectionTypeNo;
    //If any location update date is present then there is 
    if ([[TDMDataStore sharedStore] lastLocationUpdateDateTime] == nil)
    {
        [self startGPSScan];
    }
    else
    {
        //For the first time, bars's longitude and latitude will be default one. 
        [self initialiseView];  
    }
    
    [self createAccountButtonOnNavBar];
    [self.contentView setFrame:CGRectMake(0, 70, 320, 460)];
    //    [self segmentControlClicked:segmentControl];
}

#pragma mark - Segment Control 
- (void) addSegmentedControl 
{
    NSArray * segmentItems = [NSArray arrayWithObjects: @"Map", @"List", nil];
    self.segmentControl = [[[UISegmentedControl alloc] initWithItems: segmentItems] autorelease];
    [self.segmentControl setFrame:CGRectMake(210, 8, 100, 30)];
    self.segmentControl.segmentedControlStyle = UISegmentedControlStylePlain;
    self.segmentControl.selectedSegmentIndex = SEGMENT_CONTROL_LIST_BUTTON;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:kGET_BOLD_FONT_WITH_SIZE(13)
                                                               forKey:UITextAttributeFont];
        
        [self.segmentControl setTitleTextAttributes:attributes 
                                           forState:UIControlStateNormal];
        attributes = nil;
    }
    else{
        
        [self changeUISegmentFont:self.segmentControl];
    }
    [self.segmentControl addTarget: self action: @selector(segmentControlClicked:) 
                  forControlEvents: UIControlEventValueChanged];
    [self.contentView addSubview:self.segmentControl];
    
}

-(void) changeUISegmentFont:(UIView*) myView 
{
    if ([myView isKindOfClass:[UILabel class]]) {  // Getting the label subview of the passed view
        UILabel* label = (UILabel*)myView;
        [label setTextAlignment:UITextAlignmentCenter];
        [label setFont:kGET_BOLD_FONT_WITH_SIZE(13)]; // Set the font size you want to change to
        
    }
    
    NSArray* subViewArray = [myView subviews]; // Getting the subview array
    
    NSEnumerator* iterator = [subViewArray objectEnumerator]; // For enumeration
    
    UIView* subView;
    
    while (subView = [iterator nextObject]) { // Iterating through the subviews of the view passed
        
        [self changeUISegmentFont:subView]; // Recursion
        
    }
    
}
- (IBAction)segmentControlClicked:(id)sender 
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 5)
        [self changeUISegmentFont:self.segmentControl];
    [self dismissKeyBoardAndSetNavBar];
    if (self.segmentControl.selectedSegmentIndex == SEGMENT_CONTROL_LIST_BUTTON) 
    {
        selectedSegmentIndex        = SEGMENT_CONTROL_LIST_BUTTON;
        self.mapView.hidden         = YES;
        self.barTableView.hidden    = NO;
        self.transitionStyle        = UIViewAnimationOptionTransitionFlipFromRight;
        [UIView transitionFromView:self.mapView toView:self.barTableView duration:.8 options: self.transitionStyle  completion:NULL];
        if([self.barHeadersArray count]==0)
        {
            self.barTableView.hidden = YES;
            self.stausOfBarLabel.hidden = NO;
        }
        [self.barTableView reloadData];
    }
    else
    {
        for (id <MKAnnotation> annotation in mapView.annotations)
        {
            [mapView removeAnnotation:annotation];
        }
        
        [self addMapLatitudeAndLogitude];
        [self mapAllLocationsInOneView];
        selectedSegmentIndex        = SEGMENT_CONTROL_MAP_BUTTON; 
        self.barTableView.hidden   = YES;
        self.mapView.hidden        = NO;
        self.barTableView.scrollEnabled = YES;
        self.transitionStyle        = UIViewAnimationOptionTransitionFlipFromLeft;
        [UIView transitionFromView:self.barTableView toView:self.mapView duration:.8 options:self.transitionStyle completion:NULL];
    }
}

#pragma mark- Search Helper Functions

- (NSArray*)filterSearchText:(NSString*)searchText
{
    NSMutableArray *data = [[NSMutableArray alloc]init];
    for (BussinessModel *dictionaray in fullData) {
        [data addObject:dictionaray];
    }
    NSArray *filtered = [data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name CONTAINS [cd] %@",searchText]];
    [data release];
    return filtered ;
}

#pragma mark -  UISearchBarDelegate
- (IBAction)searchViewCancelButtonTouched:(id)sender
{
    [self displaySearchView:NO];
    [self displayAdvancedButton:NO];
    [self adjustSearchBar:206];
    self.segmentControl.hidden = NO;
    self.stausOfBarLabel.text = @"Sorry , No bars Found";
    [self.searchBar resignFirstResponder];
    [self.searchAddress resignFirstResponder];
    [self.searchRestaurant resignFirstResponder];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if ([self.barHeadersArray count] == 0) {
        self.barTableView.hidden = YES;
        self.stausOfBarLabel.hidden = NO;
    }
    else
    {
        self.barTableView.hidden = NO;
        self.stausOfBarLabel.hidden = YES;
        
    }
    //self.searchBar.text = @"";
}
-(BOOL)textFieldValidation
{
    NSString *restaurantString=[searchRestaurant.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    NSString *cityStateString=[searchAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([restaurantString length]>0 ) {//&& [cityStateString length]>0){
        
        valid=YES;
    }
    
    else
    {
        valid=NO;
    }
    return valid;
}

- (IBAction)searchViewDoneButtonClicked:(id)sender
{
    [searchBar resignFirstResponder];
    [searchAddress resignFirstResponder];
    [searchRestaurant resignFirstResponder];
    if([self textFieldValidation])
    {
        
        [self showOverlayView];
         [self.navigationController setNavigationBarHidden:NO animated:NO];
        if([searchAddress.text length]>0){
            TDMFoursquareSearchService *service = [[TDMFoursquareSearchService alloc] init];
            service.searchDelegate = self;
            [service searchForName:searchRestaurant.text withAddress:searchAddress.text withSearchType:SearchTypeBars];
        }
        else{
            
            TDMFoursquareSearchService *service = [[TDMFoursquareSearchService alloc] init];
            service.searchDelegate = self;
            [service searchForName:searchRestaurant.text withSearchType:SearchTypeBars];
        }
        
        
    }
    else
    {
        kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Please fill empty fields")
        self.barTableView.hidden=YES;
    }
    
}
- (IBAction)adVancedSearchButtonClicked:(id)sender
{
    [self.searchRestaurant becomeFirstResponder];
    [self displaySearchView:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)tableSearchBar {
    
    [self displayAdvancedButton:YES];
    self.segmentControl.hidden = YES;
    self.searchRestaurant.text = self.searchBar.text;
     self.cancelButton.hidden = NO;
    [self adjustSearchBar:160];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //self.searchBar.showsCancelButton = YES;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)tableSearchBar {
    
    //self.barTableView.scrollEnabled = YES;
   // self.searchBar.showsCancelButton = NO;
     self.cancelButton.hidden = YES;
  self.searchRestaurant.text = self.searchBar.text;
}

//- (void)searchBar:(UISearchBar *)tableSearchBar textDidChange:(NSString *)searchText {
//    
//    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if([searchText isEqualToString:@""] || searchText==nil) {
//        searchBar.showsCancelButton = NO;
//        emptySearchResult.hidden = YES;
//        if (barTableView) {
//            barTableView.hidden = NO;
//            self.barHeadersArray = [TDMBusinessDetails sharedBusinessDetails].barHeaders;
//            emptySearchResult.hidden = YES;
//            [self addMapLatitudeAndLogitude];
//            [self mapAllLocationsInOneView];
//            [self reloadTableView];
//        }
//        return;
//    }
//    fullData = [TDMBusinessDetails sharedBusinessDetails].barHeaders;
//    NSLog(@"bar headers %@",fullData);
//    NSArray* tempDataArray = [self filterSearchText:self.searchBar.text];
//    self.barHeadersArray = nil;
//    self.barHeadersArray = (NSMutableArray *)tempDataArray;
//    if ([tempDataArray count]>0) {
//        emptySearchResult.hidden = YES;
//        self.barTableView.hidden = NO;
//        self.barHeadersArray = (NSMutableArray *)tempDataArray;
//        [self addMapLatitudeAndLogitude];
//        [self mapAllLocationsInOneView];
//        [self reloadTableView];
//        
//    }
//    else    {
//        self.barHeadersArray  = nil;
//        self.barHeadersArray = [TDMBusinessDetails sharedBusinessDetails].barHeaders;
//        emptySearchResult.hidden = NO;
//        self.barTableView.hidden = YES;
//        [self addMapLatitudeAndLogitude];
//        [self mapAllLocationsInOneView];
//        [searchBar resignFirstResponder];
//        [self reloadTableView];
//    }
//    
//    for (id <MKAnnotation> annotation in mapView.annotations) {
//        [mapView removeAnnotation:annotation];
//    }
//    [self addMapLatitudeAndLogitude];
//    [self mapAllLocationsInOneView];
//}
- (IBAction)searchBarCancelButtonTouched:(id)sender;
{
    [self displayAdvancedButton:NO];
    self.segmentControl.hidden = NO;
    [self adjustSearchBar:206];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    searchBar.text =@"";
    barTableView.hidden = NO;
    self.stausOfBarLabel.hidden = YES;
    self.barHeadersArray = [TDMBusinessDetails sharedBusinessDetails].barHeaders;
    @try{
        
        if (barTableView) 
        {
            [imageCache removeAllObjects];
            [self reloadTableView];
            [self addMapLatitudeAndLogitude];
            [self mapAllLocationsInOneView];
        }
        
    }
    
    @catch(NSException *e){
        
    }
    
    [searchBar resignFirstResponder];  
}
//- (void)searchBarCancelButtonClicked:(UISearchBar *)tableSearchBar {
//    
//    [self displayAdvancedButton:NO];
//    self.segmentControl.hidden = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    searchBar.text =@"";
//    barTableView.hidden = NO;
//    self.stausOfBarLabel.hidden = YES;
//    self.barHeadersArray = [TDMBusinessDetails sharedBusinessDetails].barHeaders;
//    @try{
//        
//        if (barTableView) 
//        {
//            [imageCache removeAllObjects];
//            [self reloadTableView];
//            [self addMapLatitudeAndLogitude];
//            [self mapAllLocationsInOneView];
//        }
//        
//    }
//    
//    @catch(NSException *e){
//        
//    }
//    
//    [searchBar resignFirstResponder];    
//}

//keyboard button
- (void)searchBarSearchButtonClicked:(UISearchBar *)tableSearchBar{
    
    [self displayAdvancedButton:NO];
    self.segmentControl.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [searchBar resignFirstResponder];
    [self adjustSearchBar:206];
    
    NSString* searchText = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([searchText length] > 0){
        [self showOverlayView];
        TDMFoursquareSearchService *service = [[TDMFoursquareSearchService alloc] init];
        service.searchDelegate = self;
        [service searchForName:searchBar.text withSearchType:SearchTypeBars];
    }
}

-(void) searchSuccessfullWithResults:(NSMutableArray *)searchedItems{
    
    [self displayAdvancedButton:NO];
    self.segmentControl.hidden = NO;
    [self adjustSearchBar:206];
    if(self.searchRestaurant.text.length>0)
        self.searchBar.text = self.searchRestaurant.text;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self displaySearchView:NO];
    self.barTableView.hidden = NO;
    self.stausOfBarLabel.hidden = YES;
    if ([searchedItems count] == 0) {
        for (id <MKAnnotation> annotation in mapView.annotations)
        {
            [mapView removeAnnotation:annotation];
        }
        self.barHeadersArray = searchedItems;
        
        self.barTableView.hidden = YES;
        self.stausOfBarLabel.hidden = NO;
        self.stausOfBarLabel.text = @"Sorry , No bars Found";
        [self.barHeadersArray removeAllObjects];
        
        if (![self.barHeadersArray count]) {
            NSLog(@"++++++++++++++Array is empty");
        }
        
        [self.arrayOfAddressID removeAllObjects];
        [self addMapLatitudeAndLogitude];
        [self mapAllLocationsInOneView];
    }
    else
    {
        for (id <MKAnnotation> annotation in mapView.annotations)
        {
            [mapView removeAnnotation:annotation];
        }
        self.barHeadersArray = searchedItems;
        [self.arrayOfAddressID removeAllObjects];
        [imageCache removeAllObjects];
        self.barTableView.hidden = NO;
        [self addMapLatitudeAndLogitude];
        [self mapAllLocationsInOneView];
    }
    [self.barTableView reloadData];
    [self removeOverlayView];
    self.searchBar.text = self.searchRestaurant.text;
}

-(void) failedToSearch{
    [self removeOverlayView];
    [self displayAdvancedButton:NO];
    self.segmentControl.hidden = NO;
    [self displaySearchView:NO];
    self.searchBar.text = @"";
     [self adjustSearchBar:206];
    self.searchBar.text = self.searchRestaurant.text;
    self.barTableView.hidden = YES;
    self.stausOfBarLabel.hidden = NO;
    self.stausOfBarLabel.text = @"Sorry , No bars Found";
    [self.barHeadersArray removeAllObjects];
}

#pragma mark- dismiss Keyboard

- (void)dismissKeyBoardAndSetNavBar
{
    [searchBar resignFirstResponder];  
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - Custom Cell

- (void)sendRequestForUrls:(BussinessModel *)bussiness {
    
    TDMBusinessImageService *image = [[TDMBusinessImageService alloc]init];
    image.businessImageDelegate = self;
    [image getCategoryImagesForBusiness:bussiness];
}

- (void)loadImageFromBusiness:(BussinessModel *)bussiness {
    
    if(!bussiness.categoryImages){
        [self sendRequestForUrls:bussiness]; 
    }
}

-(void) thumbnailReceivedForBusiness:(BussinessModel *)businessModel
{
    [self.barTableView reloadData];
}
-(void) failedToFecthPhoto
{
    
}

- (void)cofigureCell:(UITableViewCell *)aCell withRow:(int)aRow
{
    
    if ([self.barHeadersArray count] > aRow) {
        BussinessModel *tempBarModel  = [self.barHeadersArray objectAtIndex:aRow];
        BussinessCellView *bussinessCellView = (BussinessCellView *)[aCell.contentView viewWithTag:8989];
        if(bussinessCellView){
            [bussinessCellView setvaluesToTheContents:tempBarModel];
        }
        else{
            bussinessCellView = [[BussinessCellView alloc] initWithFrame:CGRectMake(0, 0, aCell.frame.size.width, aCell.frame.size.height)];
            bussinessCellView.tag = 8989;
            [aCell.contentView addSubview:bussinessCellView];
            [bussinessCellView setvaluesToTheContents:tempBarModel];
            [bussinessCellView release];
            bussinessCellView = nil;
        }
        
        [self loadImageFromBusiness:tempBarModel];
        
        NSString *urlpath = @"";
        if([tempBarModel.categoryImages count] > 0){
            urlpath = [tempBarModel.categoryImages lastObject];
        } 
        
        TDMAsyncImage * oldasyncImageView = (TDMAsyncImage *)[aCell.contentView viewWithTag:9999];
        if(oldasyncImageView)
            [oldasyncImageView removeFromSuperview];
        
        TDMAsyncImage * asyncImageView;
        if(tempBarModel.categoryImages != nil
           && [NSNull null]!=(NSNull *)(tempBarModel.categoryImages)
           && ([tempBarModel.categoryImages count]>0))   {
            
            if(![imageCache objectForKey:[NSNumber numberWithInt:aRow]]) {
                
                asyncImageView = [[[TDMAsyncImage alloc]initWithFrame:CGRectMake(10, 5, 65, 65)] autorelease];
                asyncImageView.tag = 9999;
                
                NSURL *url = [[NSURL alloc] initWithString:urlpath];
                [asyncImageView loadImageFromURL:url isFromHome:YES];
                [url release];
                url = nil;
                [imageCache setObject:asyncImageView forKey:[NSNumber numberWithInt:aRow]];
            } 
            else  {
                asyncImageView  = [imageCache objectForKey:[NSNumber numberWithInt:aRow]];
            }
            [aCell.contentView addSubview:asyncImageView];
        } 
        else if(tempBarModel.categoryImagesFetched){
            //no category images after fetching too
            asyncImageView  = [[[TDMAsyncImage alloc]initWithFrame:CGRectMake(10, 5, 65, 65)] autorelease];
            asyncImageView.tag = 9999;
            [asyncImageView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
            [aCell.contentView addSubview:asyncImageView];
        }

    }
    
}

#pragma mark    -
#pragma mark    TableView reload data
- (void)reloadTableView
{
    if ([NSThread isMainThread] == NO)
    {
        [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
        
        return;
    }
    
    [self.barTableView reloadData];
}

#pragma  mark - TableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [self.barHeadersArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kBARS_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    [self cofigureCell:cell withRow:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font=[UIFont fontWithName:@"Trebuchet MS" size:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *isFromFavoritess = [[NSUserDefaults standardUserDefaults]objectForKey:@"isFromFavourites"];
    if ([isFromFavoritess isEqualToString:@"1"]) 
    {
        [self addBusinessToWishList:indexPath.row];
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meal" message:@"Business Added To Wish List" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
        //        [alert release];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"isFromFavourites"];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate selectTabItem:6];
        
        
    }
    else
    {
        [self dismissKeyBoardAndSetNavBar];
        
        TDMBusinessViewController *businessHomeViewController = (TDMBusinessViewController *)[self getClass:@"TDMBusinessViewController"];
        businessHomeViewController.indexForBusiness = indexPath.row;
        businessHomeViewController.tpyeForBusiness = 0;
        businessHomeViewController.model = [self.barHeadersArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:businessHomeViewController animated:YES];
    }
}

#pragma mark -  MapKit

- (void)addMapLatitudeAndLogitude
{
    self.arrayOfAddressID = [NSMutableArray array];
    [self.arrayOfAddressID removeAllObjects];
    for (int i = 0; i < [self.barHeadersArray count]; i++)
    {
        TDMMapViewAddress *addrModal = [[TDMMapViewAddress alloc]init];
        
        BussinessModel * header = [self.barHeadersArray objectAtIndex:i];
        addrModal.latitude          = header.locationLatitude;
        addrModal.longitude         = header.locationLongitude;
        [self.arrayOfAddressID addObject:addrModal];
        REMOVE_FROM_MEMORY(addrModal);
    }
}

- (void)mapAllLocationsInOneView
{
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setDelegate:self];
    NSMutableArray *arrayOfAnnotations = [[NSMutableArray alloc]init];
    if ([arrayOfAddressID count]>0) {
        int count = 0;
        int limit =[arrayOfAddressID count];
        for (; count<limit; count++) {
            BussinessModel *header = [self.barHeadersArray objectAtIndex:count];
            TDMMapViewAddress *addrModal = (TDMMapViewAddress *)[self.arrayOfAddressID objectAtIndex:count];
            if (![addrModal.latitude isKindOfClass:[NSNull class]]) {
                MKCoordinateRegion region;
                region.center.latitude = [addrModal.latitude floatValue];
                region.center.longitude = [addrModal.longitude floatValue];
                region.span.longitudeDelta = 0.01f;
                region.span.latitudeDelta = 0.01f;
                [mapView setRegion:[mapView regionThatFits:region] animated:YES]; 
                DisplayMap *annotation = [[DisplayMap alloc] init];
                annotation.title = header.name;
                annotation.businessModelObj = header;
                annotation.coordinate = region.center; 
                [arrayOfAnnotations addObject:annotation];
                REMOVE_FROM_MEMORY(annotation)
            }
        }
    }
    [mapView addAnnotations:arrayOfAnnotations];
    REMOVE_FROM_MEMORY(arrayOfAnnotations)
    [self makeMapViewRectInCaseOfMutlipleAnnotations];
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
	MKPinAnnotationView *pinView = nil; 
	if(annotation != mapView.userLocation) 
	{
		static NSString *defaultPinID = kDEFAULTPINID;
		pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
		if ( pinView == nil ) pinView = [[[MKPinAnnotationView alloc]
										  initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
        
		pinView.pinColor = MKPinAnnotationColorRed; 
		pinView.canShowCallout = YES;
		pinView.animatesDrop = YES;
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        rightButton.tag = 10;
        
        [rightButton addTarget:self action:@selector(beaconButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        pinView.rightCalloutAccessoryView = rightButton;
        
    } 
	else {
		[mapView.userLocation setTitle:@"I"];
	}
	return pinView;
}

- (IBAction)beaconButtonClicked:(id)sender
{
    
}

- (void)makeMapViewRectInCaseOfMutlipleAnnotations{
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    [mapView setVisibleMapRect:zoomRect animated:YES];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    DisplayMap *map = view.annotation;
    NSUInteger index = [self.barHeadersArray indexOfObject:map.businessModelObj];
    TDMBusinessViewController *businessHomeViewController = (TDMBusinessViewController *)[self getClass:@"TDMBusinessViewController"];
    businessHomeViewController.indexForBusiness = index;
    businessHomeViewController.tpyeForBusiness = 0;  
    businessHomeViewController.model = [self.barHeadersArray objectAtIndex:index];
    [self.navigationController pushViewController:businessHomeViewController animated:YES];
    
}



#pragma mark - Service Response

- (void)serviceResponse:(NSMutableArray *)responseArray
{
    [self.barTableView setHidden:NO];
    [self.stausOfBarLabel setHidden:YES];
    self.barHeadersArray = responseArray;
    [self addMapLatitudeAndLogitude];
    [self mapAllLocationsInOneView];
    if ([self.barHeadersArray count] > 0) 
    {
        self.stausOfBarLabel.hidden = YES;
        [[TDMBusinessDetails sharedBusinessDetails]initializeBarHeaders:self.barHeadersArray];
        
        [self reloadTableView];
    }
    else
    {
        self.barTableView.hidden = YES;
        self.stausOfBarLabel.text = @"Sorry , No bars Found";
        self.stausOfBarLabel.hidden = NO;
    }
    
    //Resets last updated longitude and latitude for Bars data
    if ([[TDMDataStore sharedStore] lastLocationUpdateDateTime] != nil)
    {
        double currentLocationLongitude = [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LONGITUDE];
        double currentLocationLatitude = [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LATITUDE];
        
        self.lastBarsLocationLatitude = currentLocationLatitude;
        self.lastBarsLocationLongitude = currentLocationLongitude;
    }
    
    [self removeOverlayView];
    
}
-(void) bussinessServiceFailed {
    
    self.stausOfBarLabel.text = @"Sorry , No bars Found";
    self.stausOfBarLabel.font=[UIFont fontWithName:@"Trebuchet MS" size:17.0];
    self.barTableView.hidden = YES;
    self.stausOfBarLabel.hidden = NO;
    [self removeOverlayView];
    
}

- (void)networkError
{
    self.stausOfBarLabel.frame=CGRectMake(1, 120,320, 80);
    self.stausOfBarLabel.text = @"Sorry, Network Error. Please try after some time.";
    self.stausOfBarLabel.numberOfLines = 2;
    self.stausOfBarLabel.font=[UIFont fontWithName:@"Trebuchet MS" size:17.0];
    
    self.barTableView.hidden = YES;
    self.stausOfBarLabel.hidden = NO;
    [self removeOverlayView];
}

-(void) requestTimeout
{
    self.stausOfBarLabel.frame=CGRectMake(10, 120,300, 80);
    self.stausOfBarLabel.text = @"Sorry, Server Error. Please try after some time.";
    self.stausOfBarLabel.font=[UIFont fontWithName:@"Trebuchet MS" size:17.0];
    self.barTableView.hidden = YES;
    self.stausOfBarLabel.hidden = NO;
    [self removeOverlayView];
}

#pragma mark    -
#pragma mark    Check and Verify API Calls
- (BOOL)needToUpdateBarsList
{
    BOOL needUpdate = NO;
    
    if ([[TDMDataStore sharedStore] lastLocationUpdateDateTime] != nil)
    {
        double currentLocationLongitude = [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LONGITUDE];
        double currentLocationLatitude = [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LATITUDE];
        
        if (self.lastBarsLocationLatitude != KDEFAULTLATITUDE && 
            self.lastBarsLocationLongitude != KDEFAULTLONGITUDE)
        {
            if (currentLocationLatitude != self.lastBarsLocationLatitude || 
                currentLocationLongitude != self.lastBarsLocationLongitude)
            {
                needUpdate = YES;
            }
        }
    }
    
    return needUpdate;
}

#pragma mark - GPS Location Scanning
- (void)stopGPSScan
{
    [[LocationManager sharedManager] setDelegate:nil];
    [[LocationManager sharedManager] stopGPSScan];
}

- (void)startGPSScan
{
    [[LocationManager sharedManager] setDelegate:self];
    [[LocationManager sharedManager] startGPSScan];
}

#pragma mark    - Delegate Methods

- (void)locationUpdate:(CLLocation *)location 
{
    //We need to stop location update feature only if the user do not want the feature
    //like continously update the location as he/she moves on.
    if ([[TDMDataStore sharedStore] doesUserNeedChangeOnLocationUpdate] == NO)
    {
        [self stopGPSScan];
    }
    if ([[TDMDataStore sharedStore] lastLocationUpdateDateTime] == nil || [self needToUpdateBarsList])
    {
        [self initialiseView];
    }
}

- (void)locationError:(NSError *)error 
{
    //We need to stop location update feature only if the user do not want the feature
    //like continously update the location as he/she moves on.
    if ([[TDMDataStore sharedStore] doesUserNeedChangeOnLocationUpdate] == NO)
    {
        [self stopGPSScan];
    }
    
    if ([[TDMDataStore sharedStore] lastLocationUpdateDateTime] == nil)
    {
        //        [TDMUtilities showAlert:TDM_TITLE message:@"Sorry, your location can not be identified." delegateObject:nil];
    }
    
    self.barTableView.hidden = YES;
    self.stausOfBarLabel.text = @"Sorry, your location can not be identified.";
    self.stausOfBarLabel.frame=CGRectMake(10, 120,300, 80);
    self.stausOfBarLabel.numberOfLines = 0;
    self.stausOfBarLabel.font=[UIFont fontWithName:@"TrebuchetMS" size:17.0];
    self.stausOfBarLabel.hidden = NO;
}

#pragma mark    -TextField delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL retValue= YES;
    
    if([string isEqualToString:@"\n"])
    {
        if(textField == self.searchRestaurant)
        {
            [self.searchAddress becomeFirstResponder];
        }
        else
        {
            [textField resignFirstResponder];
            retValue=NO;
            if([self textFieldValidation])
            {
                if(textField == searchRestaurant)
                {
                    [searchAddress becomeFirstResponder];
                }
                else if(textField == searchAddress) 
                {
                    [self showOverlayView];
                    [self.navigationController setNavigationBarHidden:NO animated:NO];
                    if([searchAddress.text length]>0){
                        TDMFoursquareSearchService *service = [[TDMFoursquareSearchService alloc] init];
                        service.searchDelegate = self;
                        [service searchForName:searchRestaurant.text withAddress:searchAddress.text withSearchType:SearchTypeBars];
                    }
                    else{
                        
                        TDMFoursquareSearchService *service = [[TDMFoursquareSearchService alloc] init];
                        service.searchDelegate = self;
                        [service searchForName:searchRestaurant.text withSearchType:SearchTypeBars];
                    }
                    
                }
            }
            else
            {
                kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Please fill empty fields")
                self.barTableView.hidden=YES;
            }
        }
        
        
    }
    
    
    return retValue; 
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

- (void)addBusinessToWishList:(int)index
{
    
    BussinessModel *detailsDict = [barHeadersArray objectAtIndex:index];
    NSDictionary *diction;
    if (![detailsDict.fourSquareId isEqualToString:@""]) 
    {
        diction = [[DatabaseManager sharedManager]getWishListForFoursquareId:detailsDict.fourSquareId];
    }
    else
    {
        diction = [[DatabaseManager sharedManager]getWishListForBusinessId:[NSString stringWithFormat:@"%@", detailsDict.venueId]];
    }
    if (diction) 
    {
        kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Business already exists!!!")
    }
    else
    {
        NSDictionary *dict = [[DatabaseManager sharedManager]getUserDetailsFromDataBase];
        NSString *userId = [dict objectForKey:@"userid"];
        NSString *businesType = [NSString stringWithFormat:@"%d",0];
        [[DatabaseManager sharedManager]insertIntoFavoritesTable:detailsDict userId:userId type:businesType];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE
                                                        message:@"Business Added To Wish List"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
}
#pragma mark - refresh action

-(void)refreshBarButtonClicked
{
    [self showOverlayView];
    if(segmentControl.selectedSegmentIndex == 0)
    {
        for (id <MKAnnotation> annotation in mapView.annotations)
        {
            [mapView removeAnnotation:annotation];
        }
    }
    self.searchBar.text = @"";
    [self getBarDetails];
}



@end