//
//  TDMSignatureDishViewController.m
//  TheDailyMeal
//
//  Created by Nibin V on 24/03/2012.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMSignatureDishViewController.h"
#import "TDMSignatureDishModel.h"
#import "BussinessModel.h"
#import "AsyncButtonImage.h"
#import "TDMSignatureDishDetailsViewController.h"
#import "TDMSignatureDishModel.h"
#import "TDMBusinessDetails.h"
#import "TDMMapViewAddress.h"
#import "DisplayMap.h"
#import "TDMBusinessViewController.h"

@interface TDMSignatureDishViewController()
{
    TDMBestDishService *bestDishService;
    
}
@property (nonatomic) int transitionStyle;
- (void)initializeViews;
- (void)sendBestDishAPICall;

- (void)stopGPSScan;
- (void)startGPSScan;
- (void)showOverlayView;
- (void)removeOverlayView;
- (void)hideScrollView:(BOOL)value;

//- (void)createImagesInScroll;
- (void)addDishNameToScrollView:(int)XValue signatureDishDetail:(TDMSignatureDishModel *)signatureDish inView:(UIView *)view;
- (void)addDishRestaurantNameToScrollView:(int)XValue signatureDishDetail:(TDMSignatureDishModel *) signatureDish inView:(UIView *)view;
- (IBAction)signatureDishImageButtonClicked:(id)sender;

@end

@implementation TDMSignatureDishViewController
@synthesize scrollView;
@synthesize backgroundImageView;
@synthesize contentBackgroundImageView;
@synthesize contentView;
@synthesize signatureDataArray;
@synthesize noDishesLabel;
@synthesize nextButton;
@synthesize pageViews;
@synthesize lastBestDishLocationLongitude;
@synthesize lastBestDishLocationLatitude;
@synthesize currentPageIndex;
@synthesize previousButton;
@synthesize bestDishName;
@synthesize arrayOfAddressID;
@synthesize segmentControl;
@synthesize mapView;
@synthesize selectedSegmentIndex;
@synthesize transitionStyle;
@synthesize mainView;
#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //this will create the navigation Title as My Profile
       [self.navigationItem setTDMIconImage];
        
        self.lastBestDishLocationLatitude = KDEFAULTLATITUDE;
        self.lastBestDishLocationLongitude = KDEFAULTLONGITUDE;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  
    self.imageVerticalSpacing = 120;
    self.imageHorizontalSpacing = 50;
    nextButton.hidden = YES;
    previousButton.hidden = YES;
    if ([self needToUpdateBestDishList] || self.lastBestDishLocationLatitude == KDEFAULTLATITUDE)
    {
        [self initialiseView];
    }
    else    {
        self.signatureDataArray = [TDMBusinessDetails sharedBusinessDetails].bestDishHeaders;
    }
    [[LocationManager sharedManager] setDelegate:self];
    [super viewDidLoad];
    [self initializeViews];  
    
    //Get the best dish details
    if ([[TDMDataStore sharedStore] lastLocationUpdateDateTime] == nil)
    {
        [self startGPSScan];
    }

    [self hideScrollView:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[LocationManager sharedManager] setDelegate:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[LocationManager sharedManager] setDelegate:self];
    [self addSegmentedControl];
    [self createRefreshButtonOnNavBarForViewController];
    [self.mapView setHidden:YES];
//    if([self needToUpdateBestDishList])
    {
        [self initialiseView];
    }
}
-(void)initialiseView
{
    for (UIView *scrollImages in [self.scrollView subviews]) {
        [scrollImages removeFromSuperview];
    }

    [self sendBestDishAPICall];
}

- (void)viewDidUnload
{    
    REMOVE_FROM_MEMORY(scrollView)
    REMOVE_IMAGEVIEW_FROM_MEMORY(backgroundImageView)
    [self setContentView:nil];
    [self setContentBackgroundImageView:nil];
    [self setSignatureDataArray:nil];
    [self setNoDishesLabel:nil];
    [self setNextButton:nil];
    [self setPreviousButton:nil];
    [self setMapView:nil];
    [self setSegmentControl:nil];
    [super viewDidUnload];
}

#pragma mark - View Initializations

- (void)initializeViews
{
    //this will show the Tabbar
    [self showTabbar];
    
    //creates Accountbar on Navigation Bar
    [self createAccountButtonOnNavBar];
    
    //creates Adv View
    [self createAdView];
    if(![[NSUserDefaults standardUserDefaults] objectForKey:K_CURRENT_LATITUDE])
    {
        [[LocationManager sharedManager] startGPSScan];
    }
        
}

//Function to add the dish name under the Dish image.
- (void)addDishNameToScrollView:(int)XValue signatureDishDetail:(TDMSignatureDishModel *)signatureDish inView:(UIView *)view
{
    UILabel *dishName = [[UILabel alloc] initWithFrame:CGRectMake(XValue, 200, 200, 18)];
    
    
    [dishName setBackgroundColor:[UIColor clearColor]];
    [dishName setTextColor:[UIColor grayColor]];
    [dishName setFont:kGET_REGULAR_FONT_WITH_SIZE(16)];
    [dishName setTextAlignment:UITextAlignmentCenter];
    NSString *dishNameString = signatureDish.dishName;
    if(dishNameString.length<=0)
    {
       dishName.text = @"";

    }
    else
    {
        dishName.text = [NSString stringWithFormat:@"\"%@\"",dishNameString];
    }
    [view addSubview:dishName];
    REMOVE_FROM_MEMORY(dishName);
}

//Function to add the restaurant name under the Dish image.
- (void)addDishRestaurantNameToScrollView:(int)XValue signatureDishDetail:(TDMSignatureDishModel *) signatureDish inView:(UIView *)view
{
    
    UILabel *dishRestaurantName=[[UILabel alloc]initWithFrame:CGRectMake(XValue, 218, 250, 20)];
    [dishRestaurantName setBackgroundColor:[UIColor clearColor]];
    [dishRestaurantName setTextColor:[UIColor grayColor]];
    [dishRestaurantName setFont:kGET_REGULAR_FONT_WITH_SIZE(12)];
    [dishRestaurantName setTextAlignment:UITextAlignmentCenter];
    
    NSString *restaurantNameString = signatureDish.venuTitle;
    dishRestaurantName.text = restaurantNameString;
    [view addSubview:dishRestaurantName];
    REMOVE_FROM_MEMORY(dishRestaurantName);
}

//#pragma mark  - Button Actions
- (IBAction)signatureDishImageButtonClicked:(id)sender
{    
    UIButton *signatureDishButton = (UIButton *)sender;
    int index = signatureDishButton.tag;
        
    if (self.signatureDataArray && [self.signatureDataArray count] > index) 
    {
        TDMSignatureDishDetailsViewController *signatureDishDetailView = [[TDMSignatureDishDetailsViewController alloc] initWithNibName:@"TDMSignatureDishDetailsViewController"                                                                                                                             bundle:nil];
        signatureDishDetailView.signatureDishModel = [self.signatureDataArray objectAtIndex:index];
        [self.navigationController pushViewController:signatureDishDetailView animated:YES];
        [signatureDishDetailView release];
        signatureDishDetailView = nil;
    }
}

#pragma mark - Send API Call

//For fetching the best dish details from the server
- (void)sendBestDishAPICall
{    
    [self showOverlayView];
    
    if (bestDishService) 
    {
        bestDishService.bestDishdelegate = nil;
        bestDishService = nil;
    }
    
    bestDishService = [[TDMBestDishService alloc] init];
    bestDishService.bestDishdelegate = self;
    [bestDishService getBestDishesVenu];
}

#pragma mark - Memory Management

- (void)dealloc
{
    if (bestDishService) 
    {
        [bestDishService release];
        bestDishService = nil;
    }
    [signatureDataArray release];
    REMOVE_FROM_MEMORY(scrollView)
    REMOVE_IMAGEVIEW_FROM_MEMORY(backgroundImageView)
    [contentView release];
    [contentBackgroundImageView release];
    [noDishesLabel release];
    [nextButton release];
    [previousButton release];
    [mapView release];
    [segmentControl release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - Handle Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -   Check and Verify API Calls
- (BOOL)needToUpdateBestDishList
{
    BOOL needUpdate = NO;
    
    if ([[TDMDataStore sharedStore] lastLocationUpdateDateTime] != nil)
    {
        double currentLocationLongitude = [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LONGITUDE];
        double currentLocationLatitude = [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LATITUDE];
        
        if (self.lastBestDishLocationLatitude != KDEFAULTLATITUDE && 
            self.lastBestDishLocationLongitude != KDEFAULTLONGITUDE)
        {
            if (currentLocationLatitude != self.lastBestDishLocationLatitude || 
                currentLocationLongitude != self.lastBestDishLocationLongitude)
            {
                needUpdate = YES;
            }
        }
    }
    
    return needUpdate;
}

- (IBAction)showNextBestDish:(id)sender 
{
  
    [self gotoPageAtIndex:currentPageIndex + 1];
}

- (IBAction)showPreviousBestDish:(id)sender {
    
      [self gotoPageAtIndex:currentPageIndex - 1];
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
    if ([[TDMDataStore sharedStore] lastLocationUpdateDateTime] == nil || 
        [self needToUpdateBestDishList] || 
        (self.lastBestDishLocationLatitude == KDEFAULTLATITUDE && 
         self.lastBestDishLocationLongitude == KDEFAULTLONGITUDE))
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

//    self.noDishesLabel.hidden = NO;
    [self hideScrollView:YES];
}

#pragma mark - best dish name method

-(void) getDishName:(TDMSignatureDishModel *)bestDishModel forIndex:(int)index
{

    bestDishName = [[TDMBestDishNameService alloc]init];
    bestDishName.bestDishNameDelegate = self;
    [bestDishName getBestDishNameForSignatureDish:bestDishModel forIndex:index];
}

-(void) getBestDishNamesForBusinesses:(NSMutableArray *) bestDishArray
{
    static int index = 0;
    for (TDMSignatureDishModel *bestDishModel in bestDishArray) {
        [self getDishName:bestDishModel forIndex:index++];
    }
    index =0;
}

-(void) bestDishNameServiceResponse:(NSMutableArray *)responseArray
{
    [self removeOverlayView];
    [self hideScrollView:NO];
    self.signatureDataArray = [TDMBusinessDetails sharedBusinessDetails].bestDishHeaders;
    responseArray = nil;
    [self setTotalPages:[self.signatureDataArray count]];
    [self reloadPageViews];
    nextButton.hidden = NO;
    previousButton.hidden = NO;
    if (self.currentPageIndex == 0) 
    {
        previousButton.hidden = YES;
    }
    else
        
    {
        previousButton.hidden = NO;
    }
    

    
    //Resets last updated longitude and latitude for Bars data
    if ([[TDMDataStore sharedStore] lastLocationUpdateDateTime] != nil)
    {
        double currentLocationLongitude = [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LONGITUDE];
        double currentLocationLatitude = [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LATITUDE];
        
        self.lastBestDishLocationLatitude = currentLocationLatitude;
        self.lastBestDishLocationLongitude = currentLocationLongitude;
    }
    
    

    
}


- (void)hideScrollView:(BOOL)value {
    
    self.noDishesLabel.hidden = !value;
    [self.scrollView setHidden:value];

}

-(void) networkErrorInBestDishNameService
{
    [self hideScrollView:YES];
    nextButton.hidden = YES;
    [self removeOverlayView];
}

#pragma mark - TDMBestDishService Delegate Methods
- (void)networkError
{
    [self hideScrollView:YES];
    [self removeOverlayView];
    self.noDishesLabel.text = @"Sorry, Network Error.";
    self.noDishesLabel.hidden = NO;
    self.noDishesLabel.numberOfLines = 0;
    nextButton.hidden = YES;
}
- (void)requestCompletedSuccessfullyWithData:(NSMutableArray *)bestDishArray
{
        [self hideScrollView:NO];
    if ([bestDishArray count]) 
    {
        self.signatureDataArray = bestDishArray;
        [[TDMBusinessDetails sharedBusinessDetails] initializebestDishHeaders:self.signatureDataArray];
        [self getBestDishNamesForBusinesses:self.signatureDataArray];
        bestDishArray = nil;

    }
    else 
    {        
        [self hideScrollView:YES];
        nextButton.hidden = YES;
        previousButton.hidden = YES;
        [self removeOverlayView];
    }
    
    //Resets last updated longitude and latitude for Bars data
    if ([[TDMDataStore sharedStore] lastLocationUpdateDateTime] != nil)
    {
        double currentLocationLongitude = [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LONGITUDE];
        double currentLocationLatitude = [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LATITUDE];
        
        self.lastBestDishLocationLatitude = currentLocationLatitude;
        self.lastBestDishLocationLongitude = currentLocationLongitude;
    }
    
}

- (void)requestFailed
{    
    [self hideScrollView:YES];
    [self removeOverlayView];
    
    self.noDishesLabel.text = @"No Best Dishes Near You";
    self.noDishesLabel.hidden = NO;
    nextButton.hidden = YES;
}

#pragma mark - AsyncButtonImage Delegate Method

-(void)didLoadImage:(UIImage *)image forIndex:(int)indexForRow
{
    if (self.signatureDataArray && [self.signatureDataArray count] >= indexForRow) 
    {
        TDMSignatureDishModel *signatureDishModel = [self.signatureDataArray objectAtIndex:indexForRow];
        signatureDishModel.dishImageData = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.0)];        
    }
}

- (void)didFailedLoadingImageForIndex:(int)indexForRow
{
    if (self.signatureDataArray && [self.signatureDataArray count] >= indexForRow) 
    {
        UIImage *noImageFound = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"imageNotAvailable"                                                                                                 ofType:@"png"]];
        TDMSignatureDishModel *signatureDishModel = [self.signatureDataArray objectAtIndex:indexForRow];
        signatureDishModel.dishImageData = [NSData dataWithData:UIImageJPEGRepresentation(noImageFound, 0.0)];
    }
}

#pragma mark - Overlay View Management
- (void)showOverlayView
{
    if (overlayView) 
    {
        [self removeOverlayView];
    }
    noDishesLabel.hidden = YES;
    overlayView = [[TDMOverlayView alloc] initWithSyncStyleAndTitle:@"Loading Dishes..."];
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

#pragma mark -

- (CGSize)pageSize  {
    
    return  CGSizeMake(220, 380);
    //return CGSizeMake(200, (240 + self.imageVerticalSpacing));
}

- (CGRect)alignView:(UIView *)view forPage:(int)pageIndex {

	CGSize pageSize = [self pageSize];
    
    CGRect scrollViewRect;
    scrollViewRect.origin.x     = 0;
    scrollViewRect.origin.y     = 0;
    scrollViewRect.size.width   = ((2*imageHorizontalSpacing) + pageSize.width);
    scrollViewRect.size.height  = pageSize.height;
	[self.scrollView setFrame:scrollViewRect];
    CGSize scrollContentSize;
    scrollContentSize.width     = (self.totalPages*(pageSize.width+ (2*imageHorizontalSpacing)));
    scrollContentSize.height    = pageSize.height;
	[self.scrollView setContentSize:scrollContentSize];
    CGRect pageRect;
    pageRect.origin.x   = imageHorizontalSpacing +(pageIndex *  ((2*imageHorizontalSpacing) + pageSize.width));
    pageRect.origin.y   = imageVerticalSpacing;
    pageRect.size.width = pageSize.width;
    pageRect.size.height= pageSize.height;
	return pageRect;
}

- (UIView *)loadViewForPage:(int)pageIndex {
	
	UIView *controller;
    
    @try {
        
        controller=[[UIView alloc] init];
        
         TDMSignatureDishModel *signatureDish = [self.signatureDataArray objectAtIndex:pageIndex];
        
        AsyncButtonImage *signatureDishImageButton = [[AsyncButtonImage alloc]initWithFrame:CGRectMake(10, 2, 200, 196)];
        dishImageview=[[UIImageView alloc]initWithFrame:CGRectMake(8,0 , 204, 200)];
        dishImageview.layer.borderWidth=1.0f;
        dishImageview.layer.borderColor=[[UIColor colorWithWhite:0.6 alpha:0.5]CGColor];
        [dishImageview.layer setMasksToBounds:YES];
        [dishImageview.layer setCornerRadius:10.0];
        [controller addSubview:dishImageview]; 
        [dishImageview release];
        dishImageview=nil;
        signatureDishImageButton.delegate = self;
        [signatureDishImageButton setBackgroundColor:[UIColor clearColor]];
        [signatureDishImageButton.layer setCornerRadius:10.0];
        [signatureDishImageButton addTarget:self 
                                     action:@selector(signatureDishImageButtonClicked:) 
                           forControlEvents:UIControlEventTouchUpInside];
        
        signatureDishImageButton.layer.masksToBounds = YES;
        [signatureDishImageButton setTag:pageIndex];
        NSString *urlString = nil;
        NSURL *url = nil;
        
        if(signatureDish.venuImagePath){
            
            if([signatureDish.venuImagePath rangeOfString:@"http://"].location == NSNotFound)
            {
                urlString = [NSString stringWithFormat:@"%@/%@",DAILYMEAL_SEVER_PROD,signatureDish.venuImagePath];
            }
            else
            {
                urlString = [NSString stringWithFormat:@"%@",signatureDish.venuImagePath];
            }
            urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            url = [NSURL URLWithString:urlString];
        }
        [signatureDishImageButton loadImageFromURL:url];                
        [controller addSubview:signatureDishImageButton];
        
        REMOVE_FROM_MEMORY(signatureDishImageButton); 
        [self.view addSubview:self.previousButton];
        [self.view addSubview:self.nextButton];
        [self.previousButton setFrame:CGRectMake(7, 176,18 , 94)];
        [self.nextButton setFrame:CGRectMake(295, 205, 18, 27)];
        [self addDishNameToScrollView:5 signatureDishDetail:signatureDish inView:controller];
        [self addDishRestaurantNameToScrollView:-10 signatureDishDetail:signatureDish inView:controller];
        self.scrollView.contentSize = CGSizeMake((self.totalPages)*(200 + 2*imageHorizontalSpacing), 0);
    }
    @catch (NSException *exception) {
        NSLog(@"Exception on loadViewForPage at Index %d : %@",pageIndex,[exception description]);
    }
	self.mainView = controller;
	return controller;
}

#pragma mark -

-(void)didChangePageIndex:(int)pageIndex    {
    //a method for overriding....
    if([self.signatureDataArray count]>0){
        if (pageIndex == ([self.signatureDataArray count] -1)) 
        {
            nextButton.hidden = YES;
        }
        else
        {
            nextButton.hidden = NO;
        }  
        
        if (self.currentPageIndex  == 0) 
        {
            previousButton.hidden = YES;
        }
        else
        {
            previousButton.hidden = NO;
        }  
    }
}
-(void) refreshBarButtonClicked
{
    [self initialiseView];   
}



#pragma mark -  MapKit

- (void)addMapLatitudeAndLogitude
{
    self.arrayOfAddressID = [NSMutableArray array];
    for (int i = 0; i < [self.signatureDataArray count]; i++) {
        TDMMapViewAddress *addrModal = [[TDMMapViewAddress alloc]init];
        
        
        TDMSignatureDishModel *signatureDish = [self.signatureDataArray objectAtIndex:i];
        
        BussinessModel * header = signatureDish.businessModel;
        addrModal.latitude          = header.locationLatitude;
        addrModal.longitude         = header.locationLongitude;
        [self.arrayOfAddressID addObject:addrModal];
        REMOVE_FROM_MEMORY(addrModal);
        
    }
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
            
            TDMSignatureDishModel *signatureDish = [self.signatureDataArray objectAtIndex:count];
            
            BussinessModel *header = signatureDish.businessModel;
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
                annotation.signatureModelObj = signatureDish;
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    DisplayMap *map = view.annotation;
    NSInteger index = [self.signatureDataArray indexOfObject:map.signatureModelObj];
    TDMBusinessViewController *businessHomeViewController = (TDMBusinessViewController *)[self getClass:@"TDMBusinessViewController"];
    businessHomeViewController.indexForBusiness = index;
    businessHomeViewController.tpyeForBusiness = 1;
    @try {
        TDMSignatureDishModel *dishObject = [self.signatureDataArray objectAtIndex:index];
        
        businessHomeViewController.model = dishObject.businessModel;
        [self.navigationController pushViewController:businessHomeViewController animated:YES];

    }
    @catch (NSException *exception) {
        NSLog(@"Exception :- %@",exception);
    }

    
    
    
    
}



#pragma mark - Segment Control 
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
- (void) addSegmentedControl 
{
    NSArray * segmentItems = [NSArray arrayWithObjects: @"Map", @"List", nil];
    self.segmentControl = [[[UISegmentedControl alloc] initWithItems: segmentItems] autorelease];
    [self.segmentControl setFrame:CGRectMake(210, 76, 100, 30)];
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
    [self.view addSubview:self.segmentControl];
}

- (IBAction)segmentControlClicked:(id)sender 
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 5)
        [self changeUISegmentFont:self.segmentControl];

    if (self.segmentControl.selectedSegmentIndex == SEGMENT_CONTROL_LIST_BUTTON) 
    { 
        [self.mapView setHidden:YES];
        selectedSegmentIndex        = SEGMENT_CONTROL_LIST_BUTTON; 
        self.contentView.hidden    = NO;
        [self.contentView setUserInteractionEnabled:YES];
        self.transitionStyle        = UIViewAnimationOptionTransitionFlipFromRight;
        self.signatureDataArray = [TDMBusinessDetails sharedBusinessDetails].bestDishHeaders;
        [self setTotalPages:[self.signatureDataArray count]];
        [self reloadPageViews];
        [UIView transitionFromView:self.mapView toView:self.mainView duration:.8 options: self.transitionStyle  completion:NULL];
    }
    else
    {
        [self setTotalPages:-1];
         [self reloadPageViews];
        for (id <MKAnnotation> annotation in mapView.annotations)
        {
            [mapView removeAnnotation:annotation];
        }
        [self.mapView setHidden:NO];
        [self addMapLatitudeAndLogitude];
        [self mapAllLocationsInOneView];
        selectedSegmentIndex        = SEGMENT_CONTROL_MAP_BUTTON; 
        self.contentView.hidden   = NO;
        self.mapView.hidden        = NO;
        self.nextButton.hidden = YES;
        self.previousButton.hidden = YES;
        self.transitionStyle        = UIViewAnimationOptionTransitionFlipFromLeft;
        self.mainView.hidden = YES;
        //[self.view addSubview:mapView];
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        [UIView transitionFromView:self.mainView toView:self.mapView duration:.8 options:self.transitionStyle completion:NULL];
    }
}



@end
