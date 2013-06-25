//
//  TDMCityGuideViewController.m
//  TheDailyMeal
//
//  Created by Apple on 23/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMCityGuideViewController.h"
#import "BussinessModel.h"
#import "TDMMapViewAddress.h"
#import "DisplayMap.h"
#import "TDMCityGuideService.h"
#import "TDMAsyncImage.h"
#import "TDMFilterViewController.h"
#import "TDMDataStore.h"
#import "TDMBusinessDetails.h"
#import "TDMBusinessViewController.h"
#import "TDMDataStore.h"
#import "BussinessCellView.h"
#import "TDMBusinessService.h"


#define TOP_RESTAURANT          @"Top Restaurants"
#define ONE_NOT_ONE_RESTAURANT  @"101 Best Restaurants"
#define CHEAP_EATS              @"Cheap Eats"
#define TOP_BAR                 @"Best Bars"
#define ONE_NOT_ONE_BAR         @"Best Dive Bars"
#define DRINK_HOT_LIST          @"Drink Hot List"
#define HOT_LIST                @"Hot List"
#define CRITERIA_SEARCH         @"Criteria Search"
#define FILTER_ARRAY [NSArray arrayWithObjects: TOP_RESTAURANT,ONE_NOT_ONE_RESTAURANT,CHEAP_EATS,TOP_BAR,ONE_NOT_ONE_BAR,DRINK_HOT_LIST,HOT_LIST,CRITERIA_SEARCH,nil]

#define CRITERIA_ARRAY [NSArray arrayWithObjects: @"African Restaurant",@"American Restaurant",@"Asian Restaurant",@"Indian Restaurant",@"Australian Restaurant",nil]



@interface TDMCityGuideViewController()

#pragma mark    Overlay View Management
- (void)showOverlayView;
- (void)removeOverlayView;

@end

@implementation TDMCityGuideViewController

@synthesize goButton;
@synthesize searchBar;
@synthesize segmentControl;
@synthesize contentView;
@synthesize mapView;
@synthesize cityGuideTable;
@synthesize arrayOfAddressID;
@synthesize cityGuideHeadersArray;
@synthesize filterButton;
@synthesize cityGuideLabel;
@synthesize errorLabel;
@synthesize cityGuideScrollView;
@synthesize previousGuideType;
@synthesize filter;
@synthesize previousCity;
@synthesize cityService;
@synthesize businessService;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createAdView];
    self.navigationItem.hidesBackButton = YES;
    [self createCustomisedNavigationTitleWithString:@""];
    imageCache = [[NSMutableDictionary alloc] init];
    [self.navigationItem setTDMIconImage];
    [[self.searchBar.subviews objectAtIndex:0] removeFromSuperview];
    if ([self.tabBarController.moreNavigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        
        UIImage *backgroundImage = [UIImage imageNamed:@"navigationBar.png"];
        [self.tabBarController.moreNavigationController.navigationBar 
         setBackgroundImage:backgroundImage 
              forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setSegmentControl:nil];
    [self setContentView:nil];
    [self setMapView:nil];
    [self setCityGuideTable:nil];
    [self setFilterButton:nil];
    [self setCityGuideLabel:nil];
    [self setErrorLabel:nil];
    [self setGoButton:nil];
    [self setCityGuideScrollView:nil];
    [self setFilter:nil];
    [self setPreviousGuideType:nil];
    [self setPreviousCity:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [searchBar release];
    [segmentControl release];
    [contentView release];
    [mapView release];
    [cityGuideTable release];
    [filterButton release];
    [cityGuideLabel release];
    [errorLabel release];
    [goButton release];
    [cityGuideScrollView release];
    [filter release];
    [previousGuideType release];
    [super dealloc];
}

-(void) viewWillAppear:(BOOL)animated {
    
    if(![self.cityGuideLabel.text isEqualToString:@""]){
        self.cityGuideLabel.text=@"";
    }
    [self.cityGuideScrollView setScrollEnabled:YES];
    [self.cityGuideLabel setText:[NSString stringWithFormat:@"%@%@",[TDMDataStore sharedStore].cityName,@" City Guide"]];
    for (id <MKAnnotation> annotation in mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    if(self.cityGuideHeadersArray)
    {
        [self addMapLatitudeAndLogitude];
        [self mapAllLocationsInOneView];
    }
    if([TDMDataStore sharedStore].guideType.length == 0) {
        
        [TDMDataStore sharedStore].guideType = @"Top Restaurants";
    }
    if(!self.previousGuideType) {
        
        self.previousGuideType = @"";
    }
    if(!self.previousCity) {
        
        self.previousCity = @"";
    }
     [self getCityDetails];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}


#pragma mark - Image service delegates

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
    [self.cityGuideTable reloadData];
}
-(void) failedToFecthPhoto
{
    
}

#pragma  mark - TableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
     return [cityGuideHeadersArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return kBARS_CELL_HEIGHT;
    return 71;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    cell.textLabel.font=[UIFont fontWithName:@"Trebuchet MS" size:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDMBusinessViewController *businessHomeViewController = (TDMBusinessViewController *)[self getClass:@"TDMBusinessViewController"];
    self.previousGuideType = [TDMDataStore sharedStore].guideType;
    self.previousCity = [TDMDataStore sharedStore].cityName;
    businessHomeViewController.indexForBusiness = indexPath.row;
   // self.cityGuideTable.userInteractionEnabled = NO;
    NSString *guideType = [TDMDataStore sharedStore].guideType;
    if([guideType isEqualToString:@"Best Bars"]||[guideType isEqualToString:@"Best Dive Bars"]||[guideType isEqualToString:@"Drink Hot List"]||[guideType isEqualToString:@"Hot List"])
    {
        businessHomeViewController.tpyeForBusiness = 0;
    }
    else
    {
        businessHomeViewController.tpyeForBusiness = 1;
    }
    businessHomeViewController.model = [self.cityGuideHeadersArray objectAtIndex:indexPath.row];
    businessHomeViewController.bID = [businessHomeViewController.model.venueId intValue];
    [self.navigationController pushViewController:businessHomeViewController animated:YES];
}

- (void)cofigureCell:(UITableViewCell *)aCell withRow:(int)aRow
{
    BussinessModel *tempCityGuideModel  = [cityGuideHeadersArray objectAtIndex:aRow];
    tempCityGuideModel.categoryName = [TDMDataStore sharedStore].guideType;
    if(tempCityGuideModel.fourSquareId)
    {
        [self loadImageFromBusiness:tempCityGuideModel];
    }
    if(!tempCityGuideModel.imageURL)
    {
        if([tempCityGuideModel.categoryImages count]>0)
        {
            tempCityGuideModel.imageURL = [tempCityGuideModel.categoryImages lastObject];
        }
    }
    BussinessCellView *bussinessCellView = (BussinessCellView *)[aCell.contentView viewWithTag:8989];
    if(bussinessCellView){
        [bussinessCellView setvaluesToTheContents:tempCityGuideModel];
    }
    else{
        bussinessCellView = [[BussinessCellView alloc] initWithFrame:CGRectMake(0, 0, aCell.frame.size.width, aCell.frame.size.height)];
        bussinessCellView.tag = 8989;
        
        [aCell.contentView addSubview:bussinessCellView];
        [bussinessCellView setvaluesToTheContents:tempCityGuideModel];
        [bussinessCellView.disatanceInputLabel setHidden:YES];
        [bussinessCellView release];
        bussinessCellView = nil;
    }
    
    if([TDMDataStore sharedStore].isCriteriaSearch)
    {
        tempCityGuideModel.imageURL = [tempCityGuideModel.categoryImages lastObject];
    }
    
    
    TDMAsyncImage * oldasyncImageView = (TDMAsyncImage *)[aCell.contentView viewWithTag:9999];
    if(oldasyncImageView)
        [oldasyncImageView removeFromSuperview];
    
    
    TDMAsyncImage * asyncImageView;
    if(tempCityGuideModel.imageURL)   {
        if(![imageCache objectForKey:[NSNumber numberWithInt:aRow]] )    {
            asyncImageView  = [[[TDMAsyncImage alloc] initWithFrame:CGRectMake(10, 2, 65, 65)] autorelease];
            asyncImageView.tag = 9999;
            
            NSURL *url = [[NSURL alloc] initWithString:tempCityGuideModel.imageURL];
            [asyncImageView loadImageFromURL:url isFromHome:YES];
            [url release];
            url = nil;
            
            [imageCache setObject:asyncImageView forKey:[NSNumber numberWithInt:aRow]];
        } 
        else
            asyncImageView  = [imageCache objectForKey:[NSNumber numberWithInt:aRow]];
        
        [aCell.contentView addSubview:asyncImageView];

    }  
    else {
        //no category images after fetching too
        asyncImageView  = [[[TDMAsyncImage alloc]initWithFrame:CGRectMake(10, 5, 65, 65)] autorelease];
        asyncImageView.tag = 9999;
        [asyncImageView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
        [aCell.contentView addSubview:asyncImageView];
    }

}


- (void)dismissKeyBoardAndSetNavBar
{
    [searchBar resignFirstResponder];  
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark -  MapKit

- (void)addMapLatitudeAndLogitude
{
    if(!self.arrayOfAddressID)
    {
        self.arrayOfAddressID = [NSMutableArray array];
    }
    [self.arrayOfAddressID removeAllObjects];
    for (int i = 0; i < [self.cityGuideHeadersArray count]; i++)
    {
        if ([self.cityGuideHeadersArray count] > i) {
            TDMMapViewAddress *addrModal = [[TDMMapViewAddress alloc]init];
            
            BussinessModel * header = [self.cityGuideHeadersArray objectAtIndex:i];
            addrModal.latitude          = header.locationLatitude;
            addrModal.longitude         = header.locationLongitude;
            [self.arrayOfAddressID addObject:addrModal];
            REMOVE_FROM_MEMORY(addrModal);
        }
        else    {
            NSLog(@"Exception on addMapLatitudeAndLogitude : Index out of Bound");
        }
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
            BussinessModel *header = [self.cityGuideHeadersArray objectAtIndex:count];
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    DisplayMap *map = view.annotation;
    NSUInteger index = [self.cityGuideHeadersArray indexOfObject:map.businessModelObj];
    TDMBusinessViewController *businessHomeViewController = (TDMBusinessViewController *)[self getClass:@"TDMBusinessViewController"];
    businessHomeViewController.indexForBusiness = index;
    businessHomeViewController.tpyeForBusiness = 2;  
        businessHomeViewController.model = [self.cityGuideHeadersArray objectAtIndex:index];
    [self.navigationController pushViewController:businessHomeViewController animated:YES];
    
}


#pragma mark - city details
-(void) getCityDetails
{

    [NSThread detachNewThreadSelector:@selector(getCityGuideDetails) toTarget:self withObject:nil];
}

-(void)getCityGuideDetails
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];

    if([TDMDataStore sharedStore].guideType.length == 0) {
        [TDMDataStore sharedStore].guideType = @"Top Restaurants";
    }
    if([[TDMDataStore sharedStore].guideType isEqualToString:@"Top Restaurants"]){
    
        [self releaseFilterController];
    }
    
    
    NSLog(@"Previous guide :- %@",self.previousGuideType);
    NSLog(@"Current guide  :- %@",[TDMDataStore sharedStore].guideType);
    
    
    NSLog(@"Previous city :- %@",self.previousCity);
    NSLog(@"Current city  :- %@",[TDMDataStore sharedStore].cityName);
    
    
    if(!([self.previousGuideType isEqualToString:[TDMDataStore sharedStore].guideType]) || !([self.previousCity isEqualToString:[TDMDataStore sharedStore].cityName] ))
    {
        [self showOverlayView];
        if([TDMDataStore sharedStore].isCriteriaSearch) {
            
            self.businessService = [[TDMBusinessService alloc] init];
            self.businessService.serviceDelegate = self;
            [self.businessService getCityGuide];
        }
        else {
            
            self.cityService = [[TDMCityGuideService alloc]init];
            self.cityService.cityGuideDelegate = self;
            [self.cityService getCityGuideDetailsForCity:[TDMDataStore sharedStore].cityName
                                    andForGuideType:[TDMDataStore sharedStore].guideType];
        }
    }
    [pool drain];
}


- (void)releaseFilterController{
    
    if(filter){
        [filter release];
        filter = nil;
    }
}

-(void) serviceResponseCityiGuide:(NSMutableArray *)responseArray
{
    
    [self.cityGuideScrollView scrollRectToVisible:self.mapView.frame animated:NO];
    for (id <MKAnnotation> annotation in mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }


    [self.filterButton setTitle:[TDMDataStore sharedStore].guideType forState:UIControlStateNormal];
    int tableHeight =(71*[responseArray count]);
    int scrollHeight = 400+tableHeight;
    [self.cityGuideTable setFrame:CGRectMake(0, 200, 320, tableHeight)];
    [self.cityGuideScrollView setContentSize:CGSizeMake(320,scrollHeight)];
    self.cityGuideTable.hidden = NO;
    self.mapView.hidden = NO;
    self.filterButton.hidden = NO;
    self.errorLabel.hidden = YES;
    for (id <MKAnnotation> annotation in mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    if([responseArray count]==0)
    {
        self.cityGuideTable.hidden = YES;
        self.mapView.hidden = YES;
        self.errorLabel.hidden = NO;
//        [TDMDataStore sharedStore].guideType = @"Top Restaurants";
        [self.cityGuideScrollView setScrollEnabled:NO];
    }
    [self removeOverlayView];
    [self.cityGuideHeadersArray removeAllObjects];
    self.cityGuideHeadersArray = responseArray;
    [imageCache removeAllObjects];
    [self.cityGuideTable reloadData];
    [self addMapLatitudeAndLogitude];
    [self mapAllLocationsInOneView];
    [[TDMBusinessDetails sharedBusinessDetails] initializeCityGuideHeaders:self.cityGuideHeadersArray];
    
    
    if(self.cityService){
        self.cityService.cityGuideDelegate = nil;
        [self.cityService release];    
        self.cityService = nil;
    }
}

-(void) failedToFecthCityGuideDetails
{

    [self.cityGuideScrollView setScrollEnabled:NO];
    [self removeOverlayView];
    [self.cityGuideScrollView setScrollEnabled:NO];
    for (id <MKAnnotation> annotation in mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    [self.filterButton setTitle:[TDMDataStore sharedStore].guideType forState:UIControlStateNormal];
    self.cityGuideTable.hidden = YES;
    self.mapView.hidden = YES;
    self.errorLabel.hidden = NO;
    if(self.cityService){
        self.cityService.cityGuideDelegate = nil;
        [self.cityService release];    
        self.cityService = nil;
    }
}

-(void) networkErrorInCityGuide
{
    self.errorLabel.text = @"Sorry, Network Error. Please try after some time.";
    self.errorLabel.frame=CGRectMake(1, 120,320, 80);
    self.errorLabel.numberOfLines=0;
    self.goButton.hidden=YES;

    [self removeOverlayView];
    for (id <MKAnnotation> annotation in mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    [self.cityGuideScrollView setScrollEnabled:NO];
    [TDMDataStore sharedStore].guideType = @"Top Restaurants";
    self.cityGuideTable.hidden = YES;
    self.mapView.hidden = YES;
    self.filterButton.hidden = YES;
    self.errorLabel.hidden = NO;
    
    if(cityService){
        cityService.cityGuideDelegate = nil;
        [cityService release];  
        cityService = nil;
    }
}


-(void) serviceResponse:(NSMutableArray *)responseArray
{
    [self.cityGuideScrollView setScrollEnabled:YES];
    for (id <MKAnnotation> annotation in mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    [self.filterButton setTitle:[TDMDataStore sharedStore].guideType forState:UIControlStateNormal];
    int tableHeight =(71*[responseArray count]);
    int scrollHeight = 400+tableHeight;
    
    [self.cityGuideTable setFrame:CGRectMake(0, 200, 320, tableHeight)];
    [self.cityGuideScrollView setContentSize:CGSizeMake(320,scrollHeight)];
    self.cityGuideTable.hidden = NO;
    self.mapView.hidden = NO;
    self.filterButton.hidden = NO;
    self.errorLabel.hidden = YES;
    for (id <MKAnnotation> annotation in mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    if([responseArray count]==0)
    {
        self.cityGuideTable.hidden = YES;
        self.mapView.hidden = YES;
        self.errorLabel.hidden = NO;
//        [TDMDataStore sharedStore].guideType = @"Top Restaurants";
        [self.cityGuideScrollView setScrollEnabled:NO];
    }
    [self removeOverlayView];
    [self.cityGuideHeadersArray removeAllObjects];
    self.cityGuideHeadersArray = responseArray;
    [imageCache removeAllObjects];
    [self.cityGuideTable reloadData];
    [self addMapLatitudeAndLogitude];
    [self mapAllLocationsInOneView];
    [[TDMBusinessDetails sharedBusinessDetails] initializeCityGuideHeaders:self.cityGuideHeadersArray];
    
    
    if(cityService){
        cityService.cityGuideDelegate = nil;
        [cityService release];    
        cityService = nil;
    }
}

-(void) bussinessServiceFailed {

    [self removeOverlayView];
    if(self.businessService){
        self.businessService.serviceDelegate = self;
        [self.businessService release]; 
        self.businessService = nil;
    }
}


-(void) networkError
{
    [self removeOverlayView];
  
    [self.filterButton setTitle:[TDMDataStore sharedStore].guideType forState:UIControlStateNormal]; 
    if(self.businessService){
        self.businessService.serviceDelegate = self;
        [self.businessService release];    
        self.businessService = nil;
    }
}

-(void) requestTimeout
{
    self.errorLabel.text = @"Sorry, Server Error. Please try after some time.";
    self.errorLabel.frame=CGRectMake(1, 120,320, 80);
    self.errorLabel.numberOfLines=0;
    self.cityGuideTable.hidden = YES;
    self.errorLabel.hidden = NO;
    [self.cityGuideHeadersArray removeAllObjects];
    [self removeOverlayView];
}



#pragma <#arguments#>
- (IBAction)filterButtonClicked:(id)sender {
    
    if(!self.filter) {
        self.filter = [[TDMFilterViewController alloc]init];
    }
    if(![TDMDataStore sharedStore].guideType) {
        [TDMDataStore sharedStore].guideType = @"Top Restaurants";
    }
    if([FILTER_ARRAY indexOfObject:[TDMDataStore sharedStore].guideType] < [FILTER_ARRAY count]-1) {
        filter.lastIndex = [NSIndexPath indexPathForRow:[FILTER_ARRAY indexOfObject:[TDMDataStore sharedStore].guideType] inSection:0];
    }
    else if([CRITERIA_ARRAY indexOfObject:[TDMDataStore sharedStore].guideType]) {
        filter.lastIndex = [NSIndexPath indexPathForRow:[CRITERIA_ARRAY indexOfObject:[TDMDataStore sharedStore].guideType] inSection:1];
    }
    self.previousGuideType = [TDMDataStore sharedStore].guideType;
    self.previousCity = [TDMDataStore sharedStore].cityName;
    self.filter.lastIndexAfterDone = self.filter.lastIndex;
    [self.navigationController pushViewController:self.filter animated:YES];
    
}
-(IBAction)goButtonClick:(id)sender{


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

@end
