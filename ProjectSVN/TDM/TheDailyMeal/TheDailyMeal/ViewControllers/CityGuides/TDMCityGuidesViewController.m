///////////
//  TDMCityGuidesViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/3/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMCityGuidesViewController.h"
#import "TDMFilterViewController.h"
#import "TDMMapViewAddress.h"
#import "TDMBusinessHomeViewController.h"
#import "TDMCityGuideListOfRestaurantsHandler.h"
#import "TDMRestaurantDetails.h"
#import "TDMCityGuideListOfBarsHandler.h"
#import "MBProgressHUD.h"
#import "TDMFilterShared.h"
#import "TDMFoursquareBrowse.h"
#import "TDMAsyncImage.h"

#define NIB_NAME_BUSINESS_HOME_VIEW     @"TDMBusinessHomeViewController"
#define NIB_NAME_FILTER_VIEW            @"TDMFilterViewController"
#define kBARS_CELL_HEIGHT 71;
#define kCELL_IMAGEVIEW_FRAME CGRectMake(10, 6, 67, 59)
#define kBUSINESS_NAME_LABEL_FRAME CGRectMake(85, 0, 182, 21)
#define kBUSINESS_ADDRESS_LABEL_FRAME CGRectMake(85, 25, 182, 21)
#define kBUSINESS_CATEGORIES_STATIC_LABEL_FRAME CGRectMake(85, 46, 62, 21)
#define kBUSINESS_CATERIES_INPUT_LABEL_FRAME CGRectMake(146, 46, 134, 21)
#import "Business.h"
#import "Criteria.h"

@interface TDMCityGuidesViewController ()

@property (nonatomic,retain) NSMutableArray *arrayOfAddressID;

- (void)mapAllLocationsInOneView;
- (void)addMapLatitudeAndLogitude;
- (void)makeMapViewRectInCaseOfMutlipleAnnotations;
- (void)cofigureCell:(UITableViewCell *)aCell withRow:(int)aRow;

- (IBAction)beaconButtonClicked:(id)sender;

@end

@implementation TDMCityGuidesViewController
@synthesize backgroungImage;
@synthesize filterButton;
@synthesize FilterImage;
@synthesize displayNameTable;
@synthesize mapView;
@synthesize segmentedControl;
@synthesize filterText;
@synthesize arrayOfAddressID;
@synthesize arrayBars;
@synthesize arrayRestaurants;
@synthesize cityRestaurantsHeaders;
@synthesize cityBarsHeaders;
@synthesize currentLatitude;
@synthesize currentLongitude;
static int offset;
static int count;
static int currentOffset;
static int lastOffset;
@synthesize currentCityBusinessHeaders;


BOOL loadesBars = NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         [self createCustomisedNavigationTitleWithString:kTABBAR_TITLE_CITYGUIDES];
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
    currentOffset = 0;
    lastOffset =0;
    name = @"Best Restaurant >>";
    self.filterText.text = @"Best Restaurant >>";
    [segmentedControl setSelectedSegmentIndex:[segmentedControl selectedSegmentIndex]];
    displayNameTable.dataSource =self;
    displayNameTable.delegate =self;
    [filterButton setTitle:@"Best Restaurant >>" forState:UIControlStateNormal];
    mapView.mapType = MKMapTypeStandard;
    //border map
    UIButton *borderButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 56, 305, 160)];
    borderButton.userInteractionEnabled = NO;
    [borderButton.layer setBorderWidth:1.0];
    [borderButton.layer setCornerRadius:5.0];
    [borderButton.layer setBorderColor:[[UIColor colorWithWhite:0.5 alpha:0.5] CGColor]];
    [self.view addSubview:borderButton];
    REMOVE_FROM_MEMORY(borderButton);
    [TDMFilterShared sharedFilterDetails].isCriteriaSearch = NO;
    NSLog(@"criteria search value is %d",[TDMFilterShared sharedFilterDetails].isCriteriaSearch);
    TDMAppDelegate * TMDdelegate = (TDMAppDelegate*)[UIApplication sharedApplication].delegate;
    [TMDdelegate startGPSScan];
    TMDdelegate.delegate = self;
    //[handler release];
    offset = 0;
    count = 5;
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setFilterImage:nil];
    [self setFilterButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.backgroungImage  = nil;
    self.displayNameTable = nil;
    self.mapView          = nil;
    self.segmentedControl = nil; 
    self.filterText       = nil;
}

- (void)dealloc{
    [filterButton release];

    [FilterImage release];
    [backgroungImage release];
    [displayNameTable release];
    [mapView release];
    [segmentedControl release];
    [filterText release];

}

- (void)viewWillAppear:(BOOL)animated{
    static int k = 0;
    [segmentedControl setSelectedSegmentIndex:0];
    if(k==0)
    {
    switch ([segmentedControl selectedSegmentIndex]) {
        case 0:
            [TDMFilterShared sharedFilterDetails].guideName = @"Top_Restaurants";
            break;
        case 1:
            [TDMFilterShared sharedFilterDetails].guideName = @"Best_Bars";
        default:
                break;
        }
    }
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows objectAtIndex:0] animated:YES];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    if(k++==0)
    {
        [segmentedControl setSelectedSegmentIndex:[segmentedControl selectedSegmentIndex]];
        [TDMFilterShared sharedFilterDetails].guideName = @"Top_Restaurants";
        [TDMFilterShared sharedFilterDetails].isARestaurant = YES;
        TDMCityGuideListOfRestaurantsHandler *restaurantHandler =[[TDMCityGuideListOfRestaurantsHandler alloc]init];
        restaurantHandler.restaurantDelegate = self;
        [restaurantHandler getListOfRestaurantsForCity:[kARRAY_OF_CITYGUIDE_NAMES objectAtIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"tabelindexselectedforcity"]intValue]] :[TDMFilterShared sharedFilterDetails].guideName:count:offset];
        

        [self addMapLatitudeAndLogitude];
        [self mapAllLocationsInOneView];
    }
    else if(![TDMFilterShared sharedFilterDetails].isCriteriaSearch)
    {

        if([TDMFilterShared sharedFilterDetails].isARestaurant)
        {
            [segmentedControl setSelectedSegmentIndex:[segmentedControl selectedSegmentIndex]];
            TDMCityGuideListOfRestaurantsHandler *restaurantHandler =[[TDMCityGuideListOfRestaurantsHandler alloc]init];
            restaurantHandler.restaurantDelegate = self;
            [restaurantHandler getListOfRestaurantsForCity:[kARRAY_OF_CITYGUIDE_NAMES objectAtIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"tabelindexselectedforcity"]intValue]] :[TDMFilterShared sharedFilterDetails].guideName:count:offset];
            
        }
        else
        {
            if(![TDMFilterShared sharedFilterDetails].isARestaurant)
            {
                [segmentedControl setSelectedSegmentIndex:[segmentedControl selectedSegmentIndex]];
                TDMCityGuideListOfBarsHandler *barHandler = [[TDMCityGuideListOfBarsHandler alloc]init];
                barHandler.barDelegate= self;
                [barHandler getListOfBarsForCity:[kARRAY_OF_CITYGUIDE_NAMES objectAtIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"tabelindexselectedforcity"]intValue]]:[TDMFilterShared sharedFilterDetails].guideName:count:offset];

            }
            else
            {
                [segmentedControl setSelectedSegmentIndex:[segmentedControl selectedSegmentIndex]];
                TDMCityGuideListOfRestaurantsHandler *restaurantHandler =[[TDMCityGuideListOfRestaurantsHandler alloc]init];
                restaurantHandler.restaurantDelegate = self;
                [restaurantHandler getListOfRestaurantsForCity:[kARRAY_OF_CITYGUIDE_NAMES objectAtIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"tabelindexselectedforcity"]intValue]] :[TDMFilterShared sharedFilterDetails].guideName:count:offset];
            }
        }
    }
    else
    {
        [TDMFilterShared sharedFilterDetails].isCriteriaSearch = NO;
        TDMFoursquareBrowse *fourSquare = [[TDMFoursquareBrowse alloc]init];
        fourSquare.foursquareBrowseDelgate=self;
        [fourSquare makeFourSquareBrowseRequestWithQuery:[TDMFilterShared sharedFilterDetails].criteriaCountry forLatitude:currentLatitude andLongitude:currentLongitude];
    }
    [self.displayNameTable reloadData];
}

#pragma mark-MapKit

- (void)addMapLatitudeAndLogitude
{
    self.arrayOfAddressID = [NSMutableArray array];
    for (int i = 0; i < [self.currentCityBusinessHeaders count]; i++) {
        NSDictionary *currentBusiness = [self.currentCityBusinessHeaders objectAtIndex:i];
        TDMMapViewAddress *addrModal = [[TDMMapViewAddress alloc]init];
        addrModal.latitude          = [currentBusiness objectForKey:@"latitude"];
        addrModal.longitude         = [currentBusiness objectForKey:@"longitude"];        
        [self.arrayOfAddressID addObject:addrModal];
//        [currentBusiness release];
        REMOVE_FROM_MEMORY(addrModal);
    }
}

- (void)mapAllLocationsInOneView{
    

    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setDelegate:self];
    NSMutableArray *arrayOfAnnotations = [[NSMutableArray alloc]init];
    if ([arrayOfAddressID count]>0) {
        int count = 0;
        int limit =[arrayOfAddressID count];
        for (; count<limit; count++) {
            NSDictionary *currentBusiness = [self.currentCityBusinessHeaders objectAtIndex:count];
            TDMMapViewAddress *addrModal = (TDMMapViewAddress *)[self.arrayOfAddressID objectAtIndex:count];
            if (![addrModal.latitude isKindOfClass:[NSNull class]]) {
                MKCoordinateRegion region;
                region.center.latitude = [addrModal.latitude floatValue];
                region.center.longitude = [addrModal.longitude floatValue];
                region.span.longitudeDelta = 0.01f;
                region.span.latitudeDelta = 0.01f;
                [mapView setRegion:[mapView regionThatFits:region] animated:YES]; 
                DisplayMap *annotation = [[DisplayMap alloc] init];
                annotation.title = [currentBusiness objectForKey:@"title"];
                annotation.coordinate = region.center; 
                [arrayOfAnnotations addObject:annotation];
//                [currentBusiness release];
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
-(void)removeMapViewPins{
    for (id <MKAnnotation> annotation in mapView.annotations)
    {
        [annotation release];
    }
}

#pragma mark -
#pragma  mark - TableView datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kBARS_CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.currentCityBusinessHeaders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    [self cofigureCell:cell withRow:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
                [self beaconButtonClicked:nil];
}

//this will configure the Cell accordingly
- (void)cofigureCell:(UITableViewCell *)aCell withRow:(int)aRow{

    if ([[aCell.contentView subviews] count]) {
        for (UIView *viewA in [aCell.contentView subviews]) {
            [viewA removeFromSuperview];
        }
    }
    
    NSLog(@"self.currentCityBusinessHeaders dictionary %@",self.currentCityBusinessHeaders);
    
    NSMutableDictionary *dictionary = [self.currentCityBusinessHeaders objectAtIndex:aRow];
    NSLog(@"dictionary %@",dictionary);
    UIView *businessCustomCellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, aCell.frame.size.width, aCell.frame.size.height)];
    TDMAsyncImage * asyncImageView = [[TDMAsyncImage alloc]initWithFrame:CGRectMake(10, 6, 67, 59)];
    asyncImageView.tag = 9999;
    NSString *urlpath = [dictionary objectForKey:@"image"];
    if (!([urlpath isKindOfClass:[NSNull class]] )) {
        if(![urlpath isEqualToString:@""]) {
            NSURL *url = [[NSURL alloc] initWithString:urlpath];
            [asyncImageView loadImageFromURL:url isFromHome:YES];
            [url release];
            url = nil;
        }
        else
        {
            [asyncImageView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
        }
    }
    else    {
        [asyncImageView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
    
    }
    [businessCustomCellView addSubview:asyncImageView];  
    
    UILabel *businessNameLabel =  [[UILabel alloc]initWithFrame:kBUSINESS_NAME_LABEL_FRAME];
    businessNameLabel.text = [dictionary objectForKey:@"title"];
    businessNameLabel.font = kGET_REGULAR_FONT_WITH_SIZE(16.0f);
    [businessCustomCellView addSubview:businessNameLabel];
    REMOVE_FROM_MEMORY(businessNameLabel)
    
    UILabel *businessAddressLabel = [[UILabel alloc]initWithFrame:kBUSINESS_ADDRESS_LABEL_FRAME];
    businessAddressLabel.text = [dictionary objectForKey:@"street"];
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
    categoriesInputLabel.text = @"";
    [businessCustomCellView addSubview:categoriesInputLabel];
    REMOVE_FROM_MEMORY(categoriesInputLabel)
    
    [aCell.contentView addSubview:businessCustomCellView];
    REMOVE_FROM_MEMORY(businessCustomCellView)
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark- Button Clicked

- (IBAction)segmentButtonClicked:(id)sender {
    
    if (self.segmentedControl.selectedSegmentIndex == 0)    {
        
        isFilterByRestaurant        = YES;
        self.filterText.text        = @"Best Restaurant >>";
        [filterButton setTitle:@"Best Restaurant >>" forState:UIControlStateNormal];
        
        self.currentCityBusinessHeaders = nil;
        self.currentCityBusinessHeaders = [TDMRestaurantDetails sharedCityRestaurantDetails].cityRestaurantsHeaders;
        NSLog(@"current header after segment click in restaurants %@",self.currentCityBusinessHeaders);
        
        for (id <MKAnnotation> annotation in mapView.annotations)   {
            [mapView removeAnnotation:annotation];
        }
        [self.displayNameTable reloadData];
        [self addMapLatitudeAndLogitude];
        [self mapAllLocationsInOneView];
    } 
    else if (self.segmentedControl.selectedSegmentIndex == 1)   {

        if(!loadesBars) {
            [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows objectAtIndex:0] animated:YES];
            TDMCityGuideListOfBarsHandler *barHandler = [[TDMCityGuideListOfBarsHandler alloc]init];
            [barHandler getListOfBarsForCity:[kARRAY_OF_CITYGUIDE_NAMES objectAtIndex:[[[NSUserDefaults standardUserDefaults]objectForKey:@"tabelindexselectedforcity"]intValue]]:@"Best_Bars":count:offset];
            barHandler.barDelegate= self;
            loadesBars = YES;
        }
        
        isFilterByRestaurant        = NO;
        self.filterText.text        = @"Best Bar >>";
        [filterButton setTitle:@"Best Bar >>" forState:UIControlStateNormal];
        
        self.currentCityBusinessHeaders = nil;
        self.currentCityBusinessHeaders = [TDMRestaurantDetails sharedCityBarDetails].cityBarsHeaders;
        NSLog(@"currentCityBusinessHeaders in bars %@",self.currentCityBusinessHeaders);

        for (id <MKAnnotation> annotation in mapView.annotations)   {
            [mapView removeAnnotation:annotation];
        }
        
        [self.displayNameTable reloadData];
        [self addMapLatitudeAndLogitude];
        [self mapAllLocationsInOneView];
    }

}

- (IBAction)filterButtonClicked:(id)sender { 
    
    TDMFilterViewController *filterViewController = [[TDMFilterViewController alloc] initWithNibName:NIB_NAME_FILTER_VIEW bundle:nil];
    if([filterButton.titleLabel.text isEqualToString:@"Best Restaurant >>"])
        filterViewController.isFilterByRestaurant = YES;
    else if([filterButton.titleLabel.text isEqualToString:@"Best Bar >>"])
        filterViewController.isFilterByRestaurant = NO;
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                                      initWithRootViewController:filterViewController];
    [self.navigationController presentModalViewController:navigationController animated:YES];
    
    REMOVE_FROM_MEMORY(navigationController);
    REMOVE_FROM_MEMORY(filterViewController);
}



- (IBAction)beaconButtonClicked:(id)sender {
    
        
    TDMBusinessHomeViewController *businessHomeViewController = [[TDMBusinessHomeViewController alloc] initWithNibName:NIB_NAME_BUSINESS_HOME_VIEW bundle:nil];

    [self.navigationController pushViewController:businessHomeViewController animated:YES];
    
    REMOVE_FROM_MEMORY(businessHomeViewController);
    
}

-(void) foundCityRestaurants
{
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    
    self.currentCityBusinessHeaders = [TDMRestaurantDetails sharedCityRestaurantDetails].cityRestaurantsHeaders;
    NSLog(@"currentBusinessHeaders in found Restaurants %@",self.currentCityBusinessHeaders);
    
    for (id <MKAnnotation> annotation in mapView.annotations)   {
        [mapView removeAnnotation:annotation];
    }
    [self.displayNameTable reloadData];
    [self addMapLatitudeAndLogitude];
    [self mapAllLocationsInOneView];
}

-(void) noCityRestaurantsFound
{
    NSLog(@"No restaurants found");
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
}

-(void) foundCityBars
{
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    
    self.currentCityBusinessHeaders = [TDMRestaurantDetails sharedCityBarDetails].cityBarsHeaders;
    NSLog(@"in foundBars currentCityBusinessHeaders is %@",self.currentCityBusinessHeaders);
    
    for (id <MKAnnotation> annotation in mapView.annotations)   {
        [mapView removeAnnotation:annotation];
    }
    [self.displayNameTable reloadData];
    [self addMapLatitudeAndLogitude];
    [self mapAllLocationsInOneView];
}
-(void) noCityBarsFound
{
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    NSLog(@"No bars found");
}

-(void) errorInFindingBars
{
 [MBProgressHUD hideHUDForView:self.view.window animated:YES];   
}
-(void) errorInNetwork
{
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    NSLog(@"Error in network");
}
-(void)gotListOfCites
{
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
}
-(void)gotNoCites
{
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
}
-(void)requestFailed
{
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
}
-(void)failedToFetchListofRestaurants
{
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
}
-(void)finishedFetchingListofResturants
{
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
}
-(void)toGetFilterText
{
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    NSLog(@"got");   
}


-(void)currentLocationDidSaved:(CLLocation *)location {
    NSLog(@"latitude %f",location.coordinate.latitude);
    NSLog(@"longitude %f",location.coordinate.longitude);
    currentLatitude = location.coordinate.latitude;
    currentLongitude = location.coordinate.longitude;
}
-(void)criteriaSearchFinishedSuccessfully
{
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];

    self.currentCityBusinessHeaders = [TDMRestaurantDetails sharedCriteriaSearchDetails].criteriaSearchHeaders;
    NSLog(@"%@",self.currentCityBusinessHeaders);
    for (id <MKAnnotation> annotation in mapView.annotations)   {
        [mapView removeAnnotation:annotation];
    }
    [self.displayNameTable reloadData];
    [self addMapLatitudeAndLogitude];
    [self mapAllLocationsInOneView];}
-(void)criteriaSearchNoResult
{
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
}
-(void)criteriaSearchFailed
{
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
}
-(void)gotFilterCriteria
{
    
}
@end
