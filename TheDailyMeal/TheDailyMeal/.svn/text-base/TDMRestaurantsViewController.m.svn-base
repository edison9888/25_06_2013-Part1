//
//  TDMRestaurantsViewController.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 15/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMRestaurantsViewController.h"
#import "BussinessModel.h"
#import "BussinessModel.h"
#import "TDMBusinessDetails.h"
#import "TDMMapViewAddress.h"
#import "DisplayMap.h"
#import "TDMBusinessViewController.h"
#import "TDMReviewRestaurant.h"
#import "DatabaseManager.h"
#import "TDMNavigationController.h"
#import "BussinessModel.h"
#import "TDMBusinessImageService.h"
#import "BussinessCellView.h"
#import "DatabaseManager.h"
#import "Constants.h"

@interface TDMRestaurantsViewController()
//private

@property (nonatomic) int transitionStyle;

- (void) addSegmentedControl;
- (void)customiseCurrentView;
- (void)cofigureCell:(UITableViewCell *)aCell withRow:(int)aRow;
- (void)dismissKeyBoardAndSetNavBar;

#pragma mark    Overlay View Management
- (void)showOverlayView;
- (void)removeOverlayView;

#pragma mark - GPS Location Scanning
- (void)stopGPSScan;
- (void)startGPSScan;

@end

@implementation TDMRestaurantsViewController
@synthesize searchRestaurant;
@synthesize searchAddress;
@synthesize contentView;
@synthesize searchBar;
@synthesize statusOfRestaurants;
@synthesize restaurantsTableView;
@synthesize mapView;
@synthesize segmentControl;
@synthesize selectedSegmentIndex;
@synthesize transitionStyle;
@synthesize restaurantsHeadersArray;
@synthesize arrayOfAddressID;
@synthesize isFromFavorites;
@synthesize searchView;
@synthesize lastRestaurantLocationLatitude;
@synthesize searchCancelButton;
@synthesize lastRestaurantLocationLongitude;
@synthesize searchAddressButton;
@synthesize advancedButton;
@synthesize cancelButton;

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [self setContentView:nil];
    [self setSearchBar:nil];
    [self setStatusOfRestaurants:nil];
    [self setRestaurantsTableView:nil];
    [self setMapView:nil];
    [imageCache removeAllObjects];
    [self setSearchView:nil];
    [self setSearchCancelButton:nil];
    [self setSearchRestaurant:nil];
    [self setSearchAddress:nil];
    [self setCancelButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
    [contentView release];
    [searchBar release];
    [statusOfRestaurants release];
    [restaurantsTableView release];
    [mapView release];
    [searchView release];
    [searchCancelButton release];
    [searchRestaurant release];
    [searchAddress release];
    [cancelButton release];
    [super dealloc];
}


#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
//        [self createCustomisedNavigationTitleWithString:kTABBAR_TITLE_RESTAURANTS];
        [self.navigationItem setTDMIconImage];
        self.lastRestaurantLocationLatitude = KDEFAULTLATITUDE;
        self.lastRestaurantLocationLongitude = KDEFAULTLONGITUDE;
    }
    return self;
}



//-(void) initialiseSearchPlaceholderButton
//{
//    if(!self.searchAddressButton)
//        {
//            self.searchAddressButton =[UIButton buttonWithType:UIButtonTypeCustom];
//            self.searchAddressButton.frame = CGRectMake(20, 119, 112, 25);
//        }
//        [self.searchAddressButton setTitle:@"Current Location" forState:UIControlStateNormal];
//        [self.searchAddressButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        
//        self.searchAddressButton.titleLabel.font = [UIFont fontWithName:kFONT_FAMILY_NAME size:12.0];
//        [self.searchAddressButton setTitle:@"Current Location" forState:UIControlStateSelected];
//
//        
//        [self.searchAddressButton setBackgroundImage:[UIImage imageNamed:@"selectedButton"] forState:UIControlStateSelected];
//            [self.searchAddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        [self.searchAddressButton addTarget:self action:@selector(searchAddressButton:) forControlEvents:UIControlEventTouchUpInside];
//
//}

- (void)adjustSearchBar:(int)length
{
    CGRect searchBarRect = searchBar.frame;
    searchBarRect.size.width = length;
    searchBar.frame = searchBarRect;
    self.searchBar.backgroundColor =[UIColor clearColor];
    if (length == 206) {
        self.segmentControl.hidden = NO;
        CGRect tableFrame = self.restaurantsTableView.frame;
        tableFrame.size.height = 255;
        self.restaurantsTableView.frame = tableFrame;
    }
    else {
        CGRect tableFrame = self.restaurantsTableView.frame;
        tableFrame.size.height = 320;
        self.restaurantsTableView.frame = tableFrame;
    }
    
}
-(BOOL)textFieldValidation
{
    BOOL valid;
    NSString *restaurantString=[searchRestaurant.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // NSString *cityStateString=[searchAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
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
     [self.navigationController setNavigationBarHidden:NO animated:NO];
    if([self textFieldValidation])
    {
        
        [self showOverlayView];
        if([searchAddress.text length]>0){
            TDMFoursquareSearchService *service = [[TDMFoursquareSearchService alloc] init];
            service.searchDelegate = self;
            [service searchForName:searchRestaurant.text withAddress:searchAddress.text withSearchType:SearchTypeRestaurant];
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
        self.restaurantsTableView.hidden=YES;
    }
    
}
-(void) displaySearchView:(BOOL)value
{
    self.searchView.hidden = !(value);
    self.segmentControl.hidden = value;
    self.restaurantsTableView.hidden = value;
    [self.navigationController setNavigationBarHidden:value animated:NO];
    if (value) {
        if (searchBar.text.length>0) {
            self.searchRestaurant.text = searchBar.text;
        }
        else {
            self.searchRestaurant.text = nil;
        }
        
        self.searchAddress.text  = nil;
    }
    if (segmentControl.selectedSegmentIndex == 0) {
        mapView.hidden = value;
    }
    [self.statusOfRestaurants setHidden:value];
}

- (IBAction)adVancedSearchButtonClicked:(id)sender
{
    [self.searchRestaurant becomeFirstResponder];
    [self displaySearchView:YES];
}

- (void)displayAdvancedButton:(BOOL)value{
    
    advancedButton.hidden = !(value);

 
}


-(void) searchAddressButton:(id)sender
{
    [self.searchAddressButton setSelected:YES];
    
}

-(void) clearSearchFields
{
    [self.searchRestaurant setText:@""];
    [self.searchAddress setText:@""];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createRefreshButtonOnNavBarForViewController];
    imageCache = [[NSMutableDictionary alloc] init];
    
    //[self initialiseView];
    [self customiseCurrentView];
    [self addSegmentedControl];
    [[self.searchBar.subviews objectAtIndex:0] removeFromSuperview];
    if (!fullData)
        fullData = [[NSMutableArray alloc] init];
    if (isFromFavorites == 1) 
    {
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
    }
   
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    
//    [[LocationManager sharedManager] setDelegate:self];
//    if (animated) {
//        if ([self needToUpdateRestaurantList])
//        {
//            [self initialiseView];
//        }
//        else if([self needToUpdateRestaurantList])
//        {
//            [self initialiseView];
//        }
//    }
//    [super viewDidAppear:animated];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [[LocationManager sharedManager] setDelegate:self];
    if (animated) {
        if ([self needToUpdateRestaurantList])
        {
            [self initialiseView];
        }
    }
    else if([self needToUpdateRestaurantList])
    {
        [self initialiseView];
    }
    [self displaySearchView:NO];
    [self displayAdvancedButton:NO];
    self.cancelButton.hidden = YES;
    [super viewWillAppear:animated];
    [self adjustSearchBar:206];
    if ([self.restaurantsHeadersArray count]==0) {
        self.restaurantsTableView.hidden = YES;
    }
    else
    {
        self.restaurantsTableView.hidden = NO;
        self.statusOfRestaurants.hidden = YES;
    }
   
   
}

#pragma mark - Gets Restaurant Details

-(void) getRestaurantDetails
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    TDMBusinessService *restaurantHandler = [[TDMBusinessService alloc] init];
    restaurantHandler.serviceDelegate = self;
    [restaurantHandler getRestauarnts];
    [pool drain];
    
}
-(void) serviceResponse:(NSMutableArray *)responseArray
{
    self.restaurantsTableView.hidden = NO;
    self.statusOfRestaurants.hidden = YES;
    self.restaurantsHeadersArray = responseArray;
    [self addMapLatitudeAndLogitude];
    [self mapAllLocationsInOneView];
    if([responseArray count]>0) {
        self.statusOfRestaurants.hidden = YES;
        [[TDMBusinessDetails sharedBusinessDetails]initializeRestaurantHeaders:self.restaurantsHeadersArray];
        [imageCache removeAllObjects];
        [self.restaurantsTableView reloadData];
    }
    else 
    {
        self.statusOfRestaurants.hidden = NO;
        self.statusOfRestaurants.text = @"Sorry, No Restaurants Found";
        self.restaurantsTableView.hidden = YES;
    }
    
    //Resets last updated longitude and latitude for Bars data
    if ([[TDMDataStore sharedStore] lastLocationUpdateDateTime] != nil)
    {
        double currentLocationLongitude = [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LONGITUDE];
        double currentLocationLatitude = [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LATITUDE];
        
        self.lastRestaurantLocationLatitude = currentLocationLatitude;
        self.lastRestaurantLocationLongitude = currentLocationLongitude;
    }
    
    [self removeOverlayView];
}

-(void) bussinessServiceFailed {
    
    self.statusOfRestaurants.text = @"Sorry, No Restaurants Found";
    self.restaurantsTableView.hidden = YES;
    self.statusOfRestaurants.hidden = NO;
    [self removeOverlayView];
}

-(void) networkError
{
    self.statusOfRestaurants.text = @"Sorry, Network Error. Please try after some time.";
    self.statusOfRestaurants.frame=CGRectMake(1, 120,320, 80);
    self.statusOfRestaurants.numberOfLines=0;
    self.restaurantsTableView.hidden = YES;
    self.statusOfRestaurants.hidden = NO;
    [self removeOverlayView];
}
-(void) requestTimeout
{
    self.statusOfRestaurants.text = @"Sorry, Server Error. Please try after some time.";
    self.restaurantsTableView.hidden = YES;
    self.statusOfRestaurants.hidden = NO;
    [self removeOverlayView];
}
#pragma mark - Handle orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Segment Control 
- (void) addSegmentedControl 
{
    NSArray * segmentItems = [NSArray arrayWithObjects: @"Map", @"List", nil];
    self.segmentControl = [[[UISegmentedControl alloc] initWithItems: segmentItems] autorelease];
    [self.segmentControl setFrame:CGRectMake(210, 8, 100, 30)];
    self.segmentControl.segmentedControlStyle = UISegmentedControlStylePlain ;
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
        self.restaurantsTableView.hidden    = NO;
        self.transitionStyle        = UIViewAnimationOptionTransitionFlipFromRight;
        [UIView transitionFromView:self.mapView toView:self.restaurantsTableView duration:.8 options: self.transitionStyle  completion:NULL];
        if([self.restaurantsHeadersArray count]==0)
        {
            self.restaurantsTableView.hidden = YES;
            self.statusOfRestaurants.hidden = NO;
        }
        [self.restaurantsTableView reloadData];
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
        self.restaurantsTableView.hidden   = YES;
        self.mapView.hidden        = NO;
        self.restaurantsTableView.scrollEnabled = YES;
        self.transitionStyle        = UIViewAnimationOptionTransitionFlipFromLeft;
        [UIView transitionFromView:self.restaurantsTableView toView:self.mapView duration:.8 options:self.transitionStyle completion:NULL];
    }
}

#pragma search cancel button action
- (IBAction)searchViewCancelButtonTouched:(id)sender
{
    [self displaySearchView:NO];
    [self displayAdvancedButton:NO];
    [self adjustSearchBar:206];
    self.segmentControl.hidden = NO;
    [searchBar resignFirstResponder];
    [searchAddress resignFirstResponder];
    [searchRestaurant resignFirstResponder];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (![self.restaurantsHeadersArray count]) {
        self.restaurantsTableView.hidden = YES;
    }
    else
    {
        self.restaurantsTableView.hidden = NO;
        self.statusOfRestaurants.hidden = YES;
    }
  //   searchBar.text =@"";
}

- (IBAction)searchCancelButtonTapped:(id)sender {
   // self.searchBar.showsCancelButton = NO;
    self.searchAddressButton.hidden = YES;
    [self.searchAddressButton setSelected:NO];
    [self displaySearchView:NO];
    [self clearSearchFields];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    searchBar.text =@"";
    restaurantsTableView.hidden = NO;
    self.statusOfRestaurants.hidden = YES;
    self.restaurantsHeadersArray = [TDMBusinessDetails sharedBusinessDetails].restaurantHeaders;
    @try{
        
        if (restaurantsTableView) 
        {
            [imageCache removeAllObjects];
            [self.restaurantsTableView reloadData];
            [self addMapLatitudeAndLogitude];
            [self mapAllLocationsInOneView];
        }
    }
    
    @catch(NSException *e){
        
    }
    [self.restaurantsTableView setHidden:NO];
    [self.searchAddress resignFirstResponder];
    [self.searchRestaurant resignFirstResponder];
    if (![self.restaurantsHeadersArray count]) {
        self.restaurantsTableView.hidden = YES;
    }
    else
    {
        self.restaurantsTableView.hidden = NO;
        self.statusOfRestaurants.hidden = YES;
    }

}

#pragma mark - Initialisation

- (void) initialiseView
{
    [self showOverlayView];
    [NSThread detachNewThreadSelector:@selector(getRestaurantDetails) toTarget:self withObject:nil];
}

- (void)customiseCurrentView 
{
    [self showTabbar];
    self.mapView.hidden = YES;
    statusOfRestaurants.hidden = YES;
    [self createAdView];
    [self createAccountButtonOnNavBar];
    
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
    [self.contentView setFrame:CGRectMake(0, 70, 320, 460)];
//    [self segmentControlClicked:segmentControl];
    
}

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
    [self.restaurantsTableView reloadData];
}
-(void) failedToFecthPhoto
{
    
}

//this will configure the Cell accordingly
- (void)cofigureCell:(UITableViewCell *)aCell withRow:(int)aRow{
    
    if ([self.restaurantsHeadersArray count]>aRow) {
        BussinessModel *tempResturantModel  = [self.restaurantsHeadersArray objectAtIndex:aRow];
        BussinessCellView *bussinessCellView = (BussinessCellView *)[aCell.contentView viewWithTag:8989];
        if(bussinessCellView){
            [bussinessCellView setvaluesToTheContents:tempResturantModel];
        }else{
            bussinessCellView = [[BussinessCellView alloc] initWithFrame:CGRectMake(0, 0, aCell.frame.size.width, aCell.frame.size.height)];
            bussinessCellView.tag = 8989;
            [aCell.contentView addSubview:bussinessCellView];
            [bussinessCellView setvaluesToTheContents:tempResturantModel];
            [bussinessCellView release];
        }
        
        
        [self loadImageFromBusiness:tempResturantModel];
        
        NSString *urlpath = @"";
        if([tempResturantModel.categoryImages count] > 0){
            urlpath = [tempResturantModel.categoryImages lastObject];
        } 
        
        TDMAsyncImage * oldasyncImageView = (TDMAsyncImage *)[aCell.contentView viewWithTag:9999];
        if(oldasyncImageView){
            [oldasyncImageView removeFromSuperview];
        }
        
        TDMAsyncImage * asyncImageView;
        if(tempResturantModel.categoryImages != nil && [NSNull null]!=(NSNull *)(tempResturantModel.categoryImages) && ([tempResturantModel.categoryImages count]>0))   {
            
            if(![imageCache objectForKey:[NSNumber numberWithInt:aRow]] )    {
                
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
        else if(tempResturantModel.categoryImagesFetched){
            //no category images after fetching too
            asyncImageView  = [[[TDMAsyncImage alloc]initWithFrame:CGRectMake(10, 5, 65, 65)] autorelease];
            asyncImageView.tag = 9999;
            [asyncImageView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
            [aCell.contentView addSubview:asyncImageView];
            
        }

    }
}

#pragma mark- dismiss Keyboard

- (void)dismissKeyBoardAndSetNavBar
{
    [searchBar resignFirstResponder];  
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


#pragma  mark - TableView datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kBARS_CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.restaurantsHeadersArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    for (UIView *cellView in [cell.contentView subviews]) {
        [cellView removeFromSuperview];
    }
    [self cofigureCell:cell withRow:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *isFromFavoritess = [[NSUserDefaults standardUserDefaults]objectForKey:@"isFromFavourites"];
    if ([isFromFavoritess isEqualToString:@"1"]) 
    {
        [self addBusinessToWishList:indexPath.row];

         [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"isFromFavourites"];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate selectTabItem:6];
    }
    else
    {

        [self dismissKeyBoardAndSetNavBar];
        TDMBusinessViewController *businessHomeViewController = [[TDMBusinessViewController alloc] initWithNibName:@"TDMBusinessViewController" bundle:nil];
        businessHomeViewController.indexForBusiness = indexPath.row;
        businessHomeViewController.tpyeForBusiness = 1;
        businessHomeViewController.model = [self.restaurantsHeadersArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:businessHomeViewController animated:YES];
        [businessHomeViewController release];
        businessHomeViewController = nil;
    }
    
}
#pragma mark -  MapKit

- (void)addMapLatitudeAndLogitude
{
    self.arrayOfAddressID = [NSMutableArray array];
    for (int i = 0; i < [self.restaurantsHeadersArray count]; i++) {
        TDMMapViewAddress *addrModal = [[TDMMapViewAddress alloc]init];
        
        BussinessModel * header = [self.restaurantsHeadersArray objectAtIndex:i];
        addrModal.latitude          = header.locationLatitude;
        addrModal.longitude         = header.locationLongitude;
        [self.arrayOfAddressID addObject:addrModal];
        REMOVE_FROM_MEMORY(addrModal);
        
    }
}

- (void)mapAllLocationsInOneView
{
    
    //MapViewModal *mapModal;
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setDelegate:self];
    NSMutableArray *arrayOfAnnotations = [[NSMutableArray alloc]init];
    
    if ([arrayOfAddressID count]>0) {
        int count = 0;
        int limit =[arrayOfAddressID count];
        for (; count<limit; count++) {
            //TDMMapViewAddress *addrModal = [[TDMMapViewAddress alloc]init];
            BussinessModel *header = [self.restaurantsHeadersArray objectAtIndex:count];
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
    NSInteger index = [self.restaurantsHeadersArray indexOfObject:map.businessModelObj];
    TDMBusinessViewController *businessHomeViewController = (TDMBusinessViewController *)[self getClass:@"TDMBusinessViewController"];
    businessHomeViewController.indexForBusiness = index;
    businessHomeViewController.tpyeForBusiness = 1; 
    businessHomeViewController.model = [self.restaurantsHeadersArray objectAtIndex:index];
    [self.navigationController pushViewController:businessHomeViewController animated:YES];
    
}



#pragma mark -  UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)tableSearchBar {
    
 
    [self displayAdvancedButton:YES];
    self.cancelButton.hidden = NO;
    self.segmentControl.hidden = YES;
    [self adjustSearchBar:160];
    self.searchRestaurant.text = self.searchBar.text;
   self.searchBar.backgroundColor =[UIColor clearColor];
//    self.searchBar.showsCancelButton = YES;
//    NSLog(@"%@",self.searchBar.frame);
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)tableSearchBar {
    
      self.cancelButton.hidden = YES;
 self.searchRestaurant.text = self.searchBar.text;
   // self.searchBar.showsCancelButton = NO;
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)tableSearchBar {
    
    [self adjustSearchBar:206];
    [self displaySearchView:NO];
    [self displayAdvancedButton:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    searchBar.text =@"";
    restaurantsTableView.hidden = NO;
    self.statusOfRestaurants.hidden = YES;
    self.restaurantsHeadersArray = [TDMBusinessDetails sharedBusinessDetails].restaurantHeaders;
    @try{
        
        if (restaurantsTableView) 
        {
            [imageCache removeAllObjects];
            [self.restaurantsTableView reloadData];
            [self addMapLatitudeAndLogitude];
            [self mapAllLocationsInOneView];
        }
    }
    
    @catch(NSException *e){
        
    }
    if (![self.restaurantsHeadersArray count]) {
        self.restaurantsTableView.hidden = YES;
    }
    else
    {
        self.restaurantsTableView.hidden = NO;
        self.statusOfRestaurants.hidden = YES;
    }
    [searchBar resignFirstResponder];    
}
- (IBAction)searchBarCancelButtonTouched:(id)sender
{
    [self displaySearchView:NO];
    [self displayAdvancedButton:NO];
    [self adjustSearchBar:206];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    searchBar.text =@"";
    restaurantsTableView.hidden = NO;
    self.statusOfRestaurants.hidden = YES;
    self.restaurantsHeadersArray = [TDMBusinessDetails sharedBusinessDetails].restaurantHeaders;
    @try{
        
        if (restaurantsTableView) 
        {
            [imageCache removeAllObjects];
            self.restaurantsHeadersArray = [TDMBusinessDetails sharedBusinessDetails].restaurantHeaders;
            if ([self.restaurantsHeadersArray count]>0) {
                [self.restaurantsTableView reloadData];
            }
            else
            {
                self.restaurantsTableView.hidden = YES;
                self.statusOfRestaurants.hidden = YES;
                self.statusOfRestaurants.text = @"Sorry, No Restaurants Found";
            }
            
            [self addMapLatitudeAndLogitude];
            [self mapAllLocationsInOneView];
        }
    }
    
    @catch(NSException *e){
        
    }
    
    [searchBar resignFirstResponder];    
}
//keyboard button
- (void)searchBarSearchButtonClicked:(UISearchBar *)tableSearchBar{

    [self.navigationController setNavigationBarHidden:NO animated:NO];
    NSString* searchText = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     [self displayAdvancedButton:NO];
    [self adjustSearchBar:206];
    if([searchText length] > 0){
        [searchBar resignFirstResponder];
        [self showOverlayView];
        TDMFoursquareSearchService *service = [[TDMFoursquareSearchService alloc] init];
        service.searchDelegate = self;
        [service searchForName:searchBar.text withSearchType:SearchTypeRestaurant];
    }
}

#pragma search delegates

-(void) searchSuccessfullWithResults:(NSMutableArray *)searchedItems{
    
    self.restaurantsTableView.hidden = NO;
    if(self.searchRestaurant.text.length>0)
        self.searchBar.text = self.searchRestaurant.text;
    [self displaySearchView:NO];
     [self displayAdvancedButton:NO];
    [self clearSearchFields];
    statusOfRestaurants.hidden = YES;
    [self adjustSearchBar:206];
    // [self.restaurantsHeadersArray removeAllObjects];
    if ([searchedItems count] == 0) {
        for (id <MKAnnotation> annotation in mapView.annotations)
        {
            [mapView removeAnnotation:annotation];
        }
        self.restaurantsTableView.hidden = YES;
        self.statusOfRestaurants.hidden = NO;
        self.statusOfRestaurants.text = @"Sorry, No Restaurants Found";
       
        self.restaurantsHeadersArray = searchedItems;
       
        
        
    }
    else
    {
        for (id <MKAnnotation> annotation in mapView.annotations)
        {
            [mapView removeAnnotation:annotation];
        }
        self.restaurantsHeadersArray = searchedItems;
        [imageCache removeAllObjects];
        self.restaurantsTableView.hidden = NO;
        [self addMapLatitudeAndLogitude];
        [self mapAllLocationsInOneView];
            }
    [self.restaurantsTableView reloadData];

    [self removeOverlayView];
    
}
    
-(void) failedToSearch {
    
    [self removeOverlayView];
     [self displayAdvancedButton:NO];
    [self adjustSearchBar:206];
    self.restaurantsTableView.hidden = YES;
    statusOfRestaurants.hidden = NO;
    statusOfRestaurants.text = @"Sorry, No Restaurants Found";
   // [self.restaurantsHeadersArray removeAllObjects];
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
    BussinessModel *detailsDict = [restaurantsHeadersArray objectAtIndex:index];
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
         NSString *businesType = [NSString stringWithFormat:@"%d",1];
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



#pragma mark    Check and Verify API Calls
- (BOOL)needToUpdateRestaurantList
{
    BOOL needUpdate = NO;
    
    if ([[TDMDataStore sharedStore] lastLocationUpdateDateTime] != nil)
    {
        double currentLocationLongitude = [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LONGITUDE];
        double currentLocationLatitude = [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LATITUDE];
        
        if (self.lastRestaurantLocationLatitude != KDEFAULTLATITUDE && 
            self.lastRestaurantLocationLongitude != KDEFAULTLONGITUDE)
        {
            if (currentLocationLatitude != self.lastRestaurantLocationLatitude || 
                currentLocationLongitude != self.lastRestaurantLocationLongitude)
            {
                needUpdate = YES;
            }
        }
    }
    
    return needUpdate;
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
    if ([[TDMDataStore sharedStore] lastLocationUpdateDateTime] == nil || [self needToUpdateRestaurantList])
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
    self.restaurantsTableView.hidden = YES;
    self.statusOfRestaurants.text = @"Sorry, your location can not be identified.";
    self.statusOfRestaurants.hidden = NO;
    self.statusOfRestaurants.numberOfLines = 0;
    
    self.statusOfRestaurants.frame=CGRectMake(10, 120, 300, 80);
    self.statusOfRestaurants.font=[UIFont fontWithName:@"TrebuchetMS" size:17.0];
  
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
    [self getRestaurantDetails];
}

#pragma textFielddelegates


//-(void) textFieldDidBeginEditing:(UITextField *)textField
//{
//    self.searchAddressButton.hidden = NO;
//    [self.searchAddressButton setSelected:NO];
//    if(textField.tag == 1)
//    {
//        [self.searchAddress becomeFirstResponder];
//        self.searchAddressButton.hidden = YES;
//    }
//}

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
                        [service searchForName:searchRestaurant.text withAddress:searchAddress.text withSearchType:SearchTypeRestaurant];
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
                self.restaurantsTableView.hidden=YES;
                           }
        }
        
        
    }
    
    
    return retValue; 
}

@end
