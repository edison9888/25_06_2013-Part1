//
//  TDMRestaurantsViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/3/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMRestaurantsViewController.h"
#import "Business.h"
#import "Criteria.h"
#import "TDMBusinessHomeViewController.h"
#import "TDMMapViewAddress.h"
#import "TDMRestaurantDetails.h"
#import "MBProgressHUD.h"
#import "TDMRestaurantDetails.h"
#import "TDMFoursquareBrowse.h"
#import "TDMBusinessDetails.h"

//@implementation UISearchBar (Additions)

//-(void)setNeedsLayout   {
//    
//    NSLog(@"self.searchBar.subviews : %@",self.subviews);
//    [super setNeedsLayout];
//    for (UIView *subView in self.subviews) {
//        if ([[[subView class] description] isEqualToString:@"UISearchBarTextField"]) {
//            
//            CALayer *searchTextField = subView.layer;
//            NSLog(@"searchTextField.cornerRadius : %f",searchTextField.cornerRadius);
//            searchTextField.cornerRadius = 10.0;
//        }
//    }
//    
//    //[[self.subviews objectAtIndex:0] removeFromSuperview];
//}
//
//@end

@interface TDMRestaurantsViewController()
//private

@property (nonatomic) int transitionStyle;
//@property (nonatomic,retain) NSMutableArray *arrayBars;

@property (nonatomic,retain) NSMutableArray *arrayOfAddressID;

- (void) addSegmentedControl;
- (void)addGestureRecognizer;
- (void)customiseCurrentView;
- (void)deallocContentsInView;
- (void)cofigureCell:(UITableViewCell *)aCell withRow:(int)aRow;
- (void)addMapLatitudeAndLogitude;
- (void)mapAllLocationsInOneView;
- (void)makeMapViewRectInCaseOfMutlipleAnnotations;
- (void)dismissKeyBoardAndSetNavBar;
- (void)setTableFrame;
- (void)addNoSearchResultLabel;
- (void)dismissKeyBoardAndSetNavBar;

@end

#define TABLE_SCROLLABLE_SIZE  284
#define kBARS_CELL_HEIGHT 75;
#define kCELL_IMAGEVIEW_FRAME CGRectMake(10, 6, 67, 59)
#define kBUSINESS_NAME_LABEL_FRAME CGRectMake(85, 0, 200, 21)
#define kBUSINESS_ADDRESS_LABEL_FRAME CGRectMake(85, 25, 182, 21)
#define kBUSINESS_CATEGORIES_STATIC_LABEL_FRAME CGRectMake(85, 46, 62, 21)
#define kBUSINESS_CATERIES_INPUT_LABEL_FRAME CGRectMake(146, 46, 134, 21)


#define SEGMENT_CONTROL_LIST_BUTTON 0
#define SEGMENT_CONTROL_MAP_BUTTON  1

@implementation TDMRestaurantsViewController
//@synthesize arrayBars;
@synthesize contentView;
@synthesize restaurantTableView;
@synthesize backgroundImageView;
@synthesize contentBackgroundImageView;
@synthesize searchBarBackGroundImage;
@synthesize viewTitleImageView;
@synthesize fourSquareLogoImage;
@synthesize viewImageTitleLabel;
@synthesize segmentControl;
@synthesize searchBar;
@synthesize mapView;
@synthesize arrayOfAddressID;
@synthesize transitionStyle;
@synthesize selectedSegmentIndex;
@synthesize tableGesture;
@synthesize restaurantsHeadersArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self createCustomisedNavigationTitleWithString:kTABBAR_TITLE_RESTAURANTS];
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
    if ([[TDMRestaurantDetails sharedResturantDetails].restaurantHeaders count]  > 0) 
    {
         self.restaurantsHeadersArray = [[TDMRestaurantDetails sharedResturantDetails].restaurantHeaders mutableCopy];
    }
   
    [[self.searchBar.subviews objectAtIndex:0] removeFromSuperview];
    TDMAppDelegate * TMDdelegate = (TDMAppDelegate*)[UIApplication sharedApplication].delegate;
    [TMDdelegate startGPSScan];
    TMDdelegate.delegate = self;
    self.tabBarItem.enabled = NO;
    mapView.hidden = YES;
    //[self addGestureRecognizer];
    [self addSegmentedControl];
    [self addNoSearchResultLabel];
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows objectAtIndex:0] animated:YES];
    [segmentControl setSelectedSegmentIndex:0];
    [self initializeView];
}

- (void)viewDidUnload
{
    
    [self deallocContentsInView];
    [self setContentView:nil];
    [self setViewTitleImageView:nil];
    [self setViewImageTitleLabel:nil];
    [self setContentBackgroundImageView:nil];
    [self setSearchBarBackGroundImage:nil];
    [self setSegmentControl:nil];
    [self setSearchBar:nil];
    [self setMapView:nil];
    [self setFourSquareLogoImage:nil];
    [self setTableGesture:nil];
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self initializeView];
    if ([[TDMRestaurantDetails sharedResturantDetails].restaurantHeaders count]  > 0) 
    {
        self.restaurantsHeadersArray = [[TDMRestaurantDetails sharedResturantDetails].restaurantHeaders mutableCopy];
    }
    
}


- (void)initializeView
{
   CGRect frame = contentView.frame;
    frame.origin.y = 25;
    contentView.frame = frame;
    contentView.backgroundColor = [UIColor redColor];
   // [self.contentView setFrame:CGRectMake(0, 25, 320, 460)];
    
    self.mapView.hidden      = YES;
    
    
    //this will customise the CurrentView
    [self customiseCurrentView];
    fullData = nil;
    if (!fullData)
    {
        fullData       = [[NSMutableArray alloc] init];
    }
    [segmentControl setSelectedSegmentIndex:[segmentControl selectedSegmentIndex]];
    [self segmentControllClicked:segmentControl];
    restaurantTableView.hidden = NO; 
    [self setTableFrame];
  
}

- (void)addNoSearchResultLabel {
    
    emptySearchResult = [[UILabel alloc] initWithFrame:CGRectMake(100, 150, 150, 20)];
    emptySearchResult.text = @"No Result Found";
    [emptySearchResult setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
	[emptySearchResult setBackgroundColor:[UIColor clearColor]];
	[emptySearchResult setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:emptySearchResult];
    [emptySearchResult release];
    emptySearchResult.hidden = YES;
}

- (void)setTableFrame
{
    
}

- (void) addSegmentedControl 
{
    
    NSArray * segmentItems = [NSArray arrayWithObjects: @"List", @"Map", nil];
    self.segmentControl = [[[UISegmentedControl alloc] initWithItems: segmentItems] autorelease];
    [self.segmentControl setFrame:CGRectMake(210, 3, 100, 35)];
    self.segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentControl addTarget: self action: @selector(segmentControllClicked:) 
                  forControlEvents: UIControlEventValueChanged];
    [self.contentView addSubview:self.segmentControl];
    
}

#pragma mark - gesture recognizer
- (void)addGestureRecognizer
{
    // Create gesture recognizer 
    self.tableGesture = 
    [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureClicled:)] autorelease];
    
    // Set required taps and number of touches
    [self.tableGesture setNumberOfTapsRequired:1];
    [self.tableGesture setNumberOfTouchesRequired:1];
    
    // Add the gesture to the view
    [restaurantTableView  addGestureRecognizer:self.tableGesture];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View Creations
//this will customise the Current View

- (void)customiseCurrentView 
{
    
    [self showTabbar];
    [self createAccountButtonOnNavBar];
    
}
//this will configure the Cell accordingly
- (void)cofigureCell:(UITableViewCell *)aCell withRow:(int)aRow{

    if ([[aCell.contentView subviews] count]) {
        NSLog(@"teh cell contentview count:%d",[[aCell.contentView subviews] count]);
        for (UIView *viewA in [aCell.contentView subviews]) {
            [viewA removeFromSuperview];
        }
    }
    NSDictionary * restaurantsDict  = [self.restaurantsHeadersArray objectAtIndex:aRow];

    UIView *businessCustomCellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, aCell.frame.size.width, aCell.frame.size.height)];
    UIImageView *cellImageView = [[UIImageView alloc]initWithFrame:kCELL_IMAGEVIEW_FRAME];
    cellImageView.image = [UIImage imageNamed:@"imageNotAvailable"];
    cellImageView.backgroundColor =[UIColor clearColor];
    //cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    [businessCustomCellView addSubview:cellImageView];
    REMOVE_FROM_MEMORY(cellImageView)

    UILabel *businessNameLabel =  [[UILabel alloc]initWithFrame:kBUSINESS_NAME_LABEL_FRAME];
    businessNameLabel.text = [restaurantsDict objectForKey:@"name"];
    NSLog(@"title label %@",[restaurantsDict objectForKey:@"name"]);
    businessNameLabel.font = kGET_REGULAR_FONT_WITH_SIZE(16.0f);
    [businessCustomCellView addSubview:businessNameLabel];
    REMOVE_FROM_MEMORY(businessNameLabel)
    
    UILabel *businessAddressLabel = [[UILabel alloc]initWithFrame:kBUSINESS_ADDRESS_LABEL_FRAME];
    businessAddressLabel.text = [restaurantsDict  objectForKey:@"city"];
    businessAddressLabel.font = kGET_REGULAR_FONT_WITH_SIZE(12.0f);
    [businessCustomCellView addSubview:businessAddressLabel];
    REMOVE_FROM_MEMORY(businessAddressLabel)
    
    UILabel *staticCategoriesLabel = [[UILabel alloc]initWithFrame:kBUSINESS_CATEGORIES_STATIC_LABEL_FRAME];
    staticCategoriesLabel.font = kGET_BOLD_FONT_WITH_SIZE(11.0f);
    staticCategoriesLabel.text = @"Categories:";
    [businessCustomCellView addSubview:staticCategoriesLabel];
    REMOVE_FROM_MEMORY(staticCategoriesLabel)
    
    UILabel *categoriesInputLabel = [[UILabel alloc]initWithFrame:kBUSINESS_CATERIES_INPUT_LABEL_FRAME];
    categoriesInputLabel.font = kGET_REGULAR_FONT_WITH_SIZE(11.0f);
    categoriesInputLabel.text = [restaurantsDict  objectForKey:@"category"];
    [businessCustomCellView addSubview:categoriesInputLabel];
    REMOVE_FROM_MEMORY(categoriesInputLabel)
    
    [aCell.contentView addSubview:businessCustomCellView];
    
}

#pragma mark -  UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)tableSearchBar {
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.searchBar.showsCancelButton = YES;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)tableSearchBar {

    self.searchBar.showsCancelButton = NO;
    
}

- (void)searchBar:(UISearchBar *)tableSearchBar textDidChange:(NSString *)searchText {
    
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([searchText isEqualToString:@""] || searchText==nil) {
        searchBar.showsCancelButton = NO;
        emptySearchResult.hidden = YES;
        if (restaurantTableView) {
            restaurantTableView.hidden = NO;
            emptySearchResult.hidden = YES;
            [searchBar resignFirstResponder];
            [self.restaurantTableView reloadData];
        }
        return;
    }
    fullData = [TDMRestaurantDetails sharedResturantDetails].restaurantHeaders;
    NSArray* tempDataArray = [self filterSearchText:self.searchBar.text];
    self.restaurantsHeadersArray = nil;
    self.restaurantsHeadersArray = (NSMutableArray *)tempDataArray;
    if ([tempDataArray count]>0) {
        emptySearchResult.hidden = YES;
        self.restaurantTableView.hidden = NO;
        [self.restaurantTableView reloadData];

    }
    else    {
        self.restaurantsHeadersArray  = nil;
        self.restaurantsHeadersArray = [TDMRestaurantDetails sharedResturantDetails].restaurantHeaders;
        emptySearchResult.hidden = NO;
        self.restaurantTableView.hidden = YES;
        [searchBar resignFirstResponder];
        [self.restaurantTableView reloadData];
    }
    
//    for (id <MKAnnotation> annotation in mapView.annotations) {
//        [mapView removeAnnotation:annotation];
//    }
//    [self addMapLatitudeAndLogitude];
//    [self mapAllLocationsInOneView];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)tableSearchBar {
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    searchBar.text =@"";
    restaurantTableView.hidden = NO;
    self.restaurantsHeadersArray = [[TDMRestaurantDetails sharedResturantDetails].restaurantHeaders mutableCopy];
    @try{
        
        if (restaurantTableView) {
            [self.restaurantTableView reloadData];
        }
        
    }
    
    @catch(NSException *e){
        
    }
    
    [searchBar resignFirstResponder];
}

//keyboard button
- (void)searchBarSearchButtonClicked:(UISearchBar *)tableSearchBar{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [searchBar resignFirstResponder];
    
}

#pragma mark - supported class for search 

- (void)refreshData
{
    //[self.arrayBars removeAllObjects];
    
    //[self.arrayBars addObjectsFromArray:fullData];
    
    [self.restaurantTableView reloadData];
}

#pragma  mark - TableView datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kBARS_CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        NSLog(@"restaurant header in table view %@",self.restaurantsHeadersArray);
    return [self.self.restaurantsHeadersArray count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    [self cofigureCell:cell withRow:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self dismissKeyBoardAndSetNavBar];
    
    TDMBusinessHomeViewController *busHomeViewController = (TDMBusinessHomeViewController *)[self getClass:@"TDMBusinessHomeViewController"];
    [[TDMBusinessDetails sharedCurrentBusinessDetails]initializeBusinessHeaders:restaurantsHeadersArray];
    busHomeViewController.businesType = kRESTAURANTS_TABBAR_INDEX;
    busHomeViewController.businessId = indexPath.row;
    [self.navigationController pushViewController:busHomeViewController animated:YES];
    
}
#pragma mark - Search Helper Functions

- (NSArray*)filterSearchText:(NSString*)searchText
{
    NSLog(@"search text %@",searchText);
    NSArray *filtered = nil;
    NSMutableArray *data = [[NSMutableArray alloc]init];
    for (NSMutableDictionary *dictionaray in fullData) {
        [data addObject:dictionaray];
    }
    if(searchText == nil)
    {
        filtered  = self.restaurantsHeadersArray;
    }
    else
    {
        filtered = [data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name CONTAINS [cd] %@",searchText]];
        NSLog(@"filtered array %@",[[filtered class]description]);
        if(![filtered count]>0)
        {
            filtered  =[[NSArray alloc]init];   
        }
    }
    return filtered ;
}
#pragma mark - Scrolling Overrides
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [searchBar resignFirstResponder];  
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //    if (self.restaurantTableView.frame.size.height < TABLE_SCROLLABLE_SIZE) {
    //        
    //        self.restaurantTableView.scrollEnabled = NO;
    //    }
    //    else
    //    {
    //        self.restaurantTableView.scrollEnabled = YES;
    //    }
}

#pragma mark- dismiss Keyboard

- (void)dismissKeyBoardAndSetNavBar
{
    [searchBar resignFirstResponder];  
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    
}

#pragma mark - Memory Management
- (void)deallocContentsInView{
    REMOVE_FROM_MEMORY(restaurantTableView)
    REMOVE_IMAGEVIEW_FROM_MEMORY(backgroundImageView)
}

- (void)dealloc{
    //this will dealloc all the contents in the view
    //made to prevent the memory shoot up issues
    [self deallocContentsInView];
    [contentView release];
    [viewTitleImageView release];
    [viewImageTitleLabel release];
    [contentBackgroundImageView release];
    [searchBarBackGroundImage release];
    [segmentControl release];
    [searchBar release];
    [mapView release];
    [fourSquareLogoImage release];
   
    //search
    [fullData release];
    //[arrayBars release];
    [tableGesture release];
    [super dealloc];
}


#pragma mark- Segment Controll Events
- (IBAction)segmentControllClicked:(id)sender {
    
    //[self refreshData];
    
    [self dismissKeyBoardAndSetNavBar];
    if (self.segmentControl.selectedSegmentIndex == SEGMENT_CONTROL_LIST_BUTTON) 
    { 
        selectedSegmentIndex        = SEGMENT_CONTROL_LIST_BUTTON; 
        self.mapView.hidden         = YES;
        restaurantTableView.hidden    = NO;
        self.transitionStyle        = UIViewAnimationOptionTransitionFlipFromRight;
        
        [UIView transitionFromView:self.mapView toView:self.restaurantTableView duration:.8 options: self.transitionStyle  completion:NULL];
        restaurantTableView.hidden = NO;
        mapView.hidden =YES;
        
    }
    else
    {
        selectedSegmentIndex        = SEGMENT_CONTROL_MAP_BUTTON; 
        restaurantTableView.hidden   = YES;
        self.mapView.hidden        = NO;
        restaurantTableView.scrollEnabled = YES;
        self.transitionStyle        = UIViewAnimationOptionTransitionFlipFromLeft;
        
        [UIView transitionFromView:restaurantTableView toView:self.mapView duration:.8 options:self.transitionStyle completion:NULL];
        restaurantTableView.hidden = YES;
        mapView.hidden= NO;
        
        
    }
}

- (IBAction)gestureClicled:(id)sender {
    
}


#pragma mark- MapKit

- (void)addMapLatitudeAndLogitude
{
    self.arrayOfAddressID = [NSMutableArray array];
    for (int i = 0; i < [self.restaurantsHeadersArray count]; i++) {
        TDMMapViewAddress *addrModal = [[TDMMapViewAddress alloc]init];
        NSDictionary *header = nil;
        header = [self.restaurantsHeadersArray objectAtIndex:i];
        addrModal.latitude          = [header objectForKey:@"latitude"];
        addrModal.longitude         = [header objectForKey:@"longitude"];
        [self.arrayOfAddressID addObject:addrModal];
        REMOVE_FROM_MEMORY(addrModal);

    }
}

- (void)mapAllLocationsInOneView{
    
    //MapViewModal *mapModal;
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setDelegate:self];
    NSMutableArray *arrayOfAnnotations = [[NSMutableArray alloc]init];
    NSDictionary *header =[[NSDictionary alloc]init];
    //NSLog(@"arrayofAddressID %@",arrayOfAddressID);
    if ([arrayOfAddressID count]>0) {
        int count = 0;
        int limit =[arrayOfAddressID count];
        for (; count<limit; count++) {
            //TDMMapViewAddress *addrModal = [[TDMMapViewAddress alloc]init];
            header = [self.restaurantsHeadersArray objectAtIndex:count];
            TDMMapViewAddress *addrModal = (TDMMapViewAddress *)[self.arrayOfAddressID objectAtIndex:count];
            if (![addrModal.latitude isKindOfClass:[NSNull class]]) {
                MKCoordinateRegion region;
                region.center.latitude = [addrModal.latitude floatValue];
                region.center.longitude = [addrModal.longitude floatValue];
                region.span.longitudeDelta = 0.02f;
                region.span.latitudeDelta = 0.02f;
                [mapView setRegion:[mapView regionThatFits:region] animated:YES]; 
                DisplayMap *annotation = [[DisplayMap alloc] init];
                annotation.title = [header objectForKey:@"name"];
                annotation.coordinate = region.center; 
                [arrayOfAnnotations addObject:annotation];
                REMOVE_FROM_MEMORY(annotation)
                [header release];
                header = nil;
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

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    // Here push your view controller
    TDMBusinessHomeViewController *busHomeViewController = (TDMBusinessHomeViewController *)[self getClass:@"TDMBusinessHomeViewController"];
    NSLog(@"%@",[[view class]description]);
    [self.navigationController pushViewController:busHomeViewController animated:YES];
    
}

#pragma mark- delegates

-(void)currentLocationDidSaved:(CLLocation *)location {
    
    TDMBusinessDetailsProviderAndHandler *businessDetailsHandler = [[TDMBusinessDetailsProviderAndHandler alloc] init];
    businessDetailsHandler.businessDetailsDelegate = self;
    [businessDetailsHandler getCurretLocationBusinessdetailsForQuery:@"restaurants" forLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
}

-(void)gotRestaurantDetails {
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    self.tabBarItem.enabled = YES;
    [self.restaurantsHeadersArray removeAllObjects];
     NSLog(@"restaurant array before:%@",self.restaurantsHeadersArray);
    self.restaurantsHeadersArray = [[TDMRestaurantDetails sharedResturantDetails].restaurantHeaders mutableCopy];
    [fullData removeAllObjects];
    fullData = self.restaurantsHeadersArray;
    [[TDMBusinessDetails sharedCurrentBusinessDetails]initializeBusinessHeaders:self.restaurantsHeadersArray];
    NSLog(@"restaurant array %@",self.restaurantsHeadersArray);
    
    [self.restaurantTableView reloadData];
   // [self setTableFrame];
    [self addMapLatitudeAndLogitude];
    [self mapAllLocationsInOneView];
}

-(void)failedToFetchRestaurantDetails {
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
}
-(void)requestCompletedWithErrors:(ASIHTTPRequest *)theRequest
{
    
}

-(void) criteriaSearchFinishedSuccessfully{}
-(void) criteriaSearchNoResult{}
-(void) criteriaSearchFailed{}
- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request{}
@end
