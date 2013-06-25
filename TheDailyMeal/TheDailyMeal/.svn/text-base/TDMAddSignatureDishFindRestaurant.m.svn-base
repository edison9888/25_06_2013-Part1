//
//  TDMAddSignatureDishFindRestaurant.m
//  TheDailyMeal
//
//  Created by Apple on 17/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMAddSignatureDishFindRestaurant.h"
#import "TDMRestaurantsViewController.h"
#import "TDMOverlayView.h"
#import "TDMAsyncImage.h"
#import "BussinessCellView.h"
#import "TDMAddSignatureDishViewController.h"
#import "TDMSignatureDishViewController.h"
#import "TDMCustomTabBar.h"

//#define kBARS_CELL_HEIGHT 71;
//#define kCELL_IMAGEVIEW_FRAME CGRectMake(10, 6, 67, 59)
//#define kBUSINESS_ADDRESS_LABEL_FRAME CGRectMake(85, 25, 182, 21)


@interface TDMAddSignatureDishFindRestaurant()
//private

- (void)cofigureCell:(UITableViewCell *)aCell withRow:(int)aRow;
- (void)deallocContentsInView;
- (void)removeOverlayView;
- (void)showOverlayView;

-(void)allNearSelectedState;
-(void)searchSelectedState;
@end

@implementation TDMAddSignatureDishFindRestaurant
@synthesize searchRestaurant;
@synthesize searchAddress;
@synthesize resultLabel;
@synthesize restaurantTable;
@synthesize segmentControl;
@synthesize restaurantsHeadersArray;
@synthesize typeOfBusiness;
@synthesize scrollView;
@synthesize bID;
@synthesize overlayTitle;

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setSegmentControl:nil];
    [self setSearchRestaurant:nil];
    [self setSearchAddress:nil];
    [self setRestaurantTable:nil];
    [self deallocContentsInView];
    [self setResultLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    self.restaurantTable.delegate = nil;
    self.restaurantTable.dataSource = nil;
    [self setRestaurantTable:nil];
    [segmentControl release];
    [searchRestaurant release];
    [searchAddress release];
    [businessCell release];
    [restaurantTable release];
    [restaurantDetails release];
    [resultLabel release];
    [super dealloc];
}

- (void)deallocContentsInView
{
    REMOVE_FROM_MEMORY(restaurantTable)
    
}
#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self createCustomisedNavigationTitleWithString:kNAVBAR_TITLE_BEST_DISHES];
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
        [self.navigationItem setTDMIconImage];
    }
    return self;
}

- (void)initializeThView {
    
    number = [arrayRestaurants count];
    restaurantTable.delegate=self;
    restaurantTable.dataSource = self;
    searchRestaurant.delegate=self;
    searchAddress.delegate=self;
    self.scrollView.contentSize= CGSizeMake(0, 200);
    [segmentControl setSelectedSegmentIndex:0];
    searchAddress.hidden = YES;
    searchRestaurant.hidden = YES;
    searchRestaurant.autocorrectionType=UITextAutocorrectionTypeNo;
    searchAddress.autocorrectionType=UITextAutocorrectionTypeNo;
    
    self.overlayTitle = @"Searching Restaurants...";
    restaurantTable.frame = CGRectMake(0, 140, 320, 320);
    /*if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 5)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:kGET_REGULAR_FONT_WITH_SIZE(13)
                                                               forKey:UITextAttributeFont];
        
        [segmentControl setTitleTextAttributes:attributes 
                                      forState:UIControlStateNormal];
        attributes = nil;
    }*/
    [TDMUtilities setRestaurantId:@" "];
    [TDMUtilities setRestaurantName:@""];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageCache = [[NSMutableDictionary alloc] init];
    [self addSegmentedControl];
    [self initializeThView];
    [self getBusinessDetails];
    [self createAdView];
    resultLabel.hidden=YES;
    selectedBusiness = [[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedBid"]integerValue];
    if(segmentControl.selectedSegmentIndex == 0){
        self.scrollView.scrollEnabled=FALSE;
    }

    //self.segmentControl.frame=CGRectMake(62, 10, 198, 30);
}
- (void) addSegmentedControl 
{
    NSArray * segmentItems = [NSArray arrayWithObjects: @"Show Near Me", @"Search", nil];
    self.segmentControl = [[[UISegmentedControl alloc] initWithItems: segmentItems] autorelease];
    self.segmentControl.segmentedControlStyle = UISegmentedControlStylePlain;
   
    //self.segmentControl.selectedSegmentIndex = SEGMENT_CONTROL_LIST_BUTTON;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5)
    {
        self.segmentControl.frame = CGRectMake(70, 15, 180, 32);
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:kGET_BOLD_FONT_WITH_SIZE(12)
                                                               forKey:UITextAttributeFont];
       // NSLog(@"Attribute%@",attributes);
        [self.segmentControl setTitleTextAttributes:attributes 
                                           forState:UIControlStateNormal];
        attributes = nil;
    }
    else
    {
        [self changeUISegmentFont:self.segmentControl];
         self.segmentControl.frame = CGRectMake(60, 15, 200, 30);
self.segmentControl.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    [self.segmentControl addTarget: self action: @selector(segmentClick:) 
                  forControlEvents: UIControlEventValueChanged];
    [self.scrollView addSubview:self.segmentControl];
    [self.segmentControl setSelectedSegmentIndex:0];
    
}

-(void) changeUISegmentFont:(UIView*) myView 
{
    if ([myView isKindOfClass:[UILabel class]]) {  // Getting the label subview of the passed view
           UILabel* label = (UILabel*)myView;
        [label setTextAlignment:UITextAlignmentCenter];
        [label setFont:kGET_BOLD_FONT_WITH_SIZE(12)]; // Set the font size you want to change to
            
           }
   
     NSArray* subViewArray = [myView subviews]; // Getting the subview array
   
     NSEnumerator* iterator = [subViewArray objectEnumerator]; // For enumeration
      
     UIView* subView;
      
     while (subView = [iterator nextObject]) { // Iterating through the subviews of the view passed
            
           [self changeUISegmentFont:subView]; // Recursion
            
           }
      
}

#pragma mark - Handle Orientations

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)allNearSelectedState {
    
    searchAddress.hidden = YES;
    searchRestaurant.hidden = YES;
    searchResultLabel.hidden=YES;
    restaurantTable.frame = CGRectMake(0, 150, 320, 220);
}

-(void)searchSelectedState {
    
    searchAddress.hidden = NO;
    searchRestaurant.hidden = NO;
    restaurantTable.frame = CGRectMake(0, 250, 320, 120);
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


#pragma mark - Segment Actions

- (IBAction)segmentClick:(id)sender 
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 5)
        [self changeUISegmentFont:self.segmentControl];

   [searchRestaurant resignFirstResponder];
   [searchAddress resignFirstResponder];
    if(segmentControl.selectedSegmentIndex == 0)
    {
        [self allNearSelectedState];
        restaurantTable.hidden=NO;
//        if(!self.restaurantsHeadersArray)
            [self getBusinessDetails];
        //self.scrollView.scrollEnabled=NO;
    }
    else
    {
        [searchRestaurant becomeFirstResponder];
        self.resultLabel.hidden=YES;
        restaurantTable.hidden=YES;
        [self searchSelectedState];
    }
    [restaurantTable reloadData];
}


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
                        if([searchAddress.text length]>0){
                            TDMFoursquareSearchService *service = [[TDMFoursquareSearchService alloc] init];
                            service.searchDelegate = self;
                            [service searchForName:searchRestaurant.text withAddress:searchAddress.text withSearchType:SearchTypeRestaurant];
                        }
                        else{
                            
                            TDMFoursquareSearchService *service = [[TDMFoursquareSearchService alloc] init];
                            service.searchDelegate = self;
                            [service searchForName:searchRestaurant.text withSearchType:SearchTypeRestaurant];
                        }
                        
                    }
                }
                else
                {
                    kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Please fill empty fields")
                    self.restaurantTable.hidden=YES;
                }
            }

            
        }
              

    return retValue; 
}

-(void) searchSuccessfullWithResults:(NSMutableArray *)searchedItems{
    
    [self removeOverlayView];
    self.resultLabel.hidden = YES;
    if([searchedItems count]>0){
        self.restaurantsHeadersArray = searchedItems;
        self.resultLabel.hidden=YES;    
        [restaurantTable reloadData];    
        self.restaurantTable.hidden=NO;
        
    }
    else{
        self.resultLabel.text = @"Sorry, No Results Found.";
        self.resultLabel.hidden=NO;
        self.restaurantTable.hidden=YES;
    }
        
}

-(void) failedToSearch {
    
    [self removeOverlayView];
    self.resultLabel.text = @"Sorry, No Results Found.";

    self.resultLabel.hidden=NO;
    self.restaurantTable.hidden=YES;

}

#pragma mark - BusinessId delegates

-(void) getBusinessVenueIDFofBusiness
{
    [self showOverlayView];
    serviceID = [[TDMBusinessIDService alloc] init];
    serviceID.businessIDdelegate= self;
    serviceID.delegate= self;
    [serviceID getBusinessVenueIDFofBusiness:tempResturantsModel];
    
}

-(void) businessIDFetchedWithVenueID:(int)venueID
{
    [self removeOverlayView];
    if(serviceID){
        serviceID.businessIDdelegate = nil;
        serviceID.delegate= nil;
        [serviceID release];
        serviceID = nil;
    }
    self.bID = venueID;
    tempResturantsModel.venueId = [NSString stringWithFormat:@"%d",self.bID];
    if(self.bID > 0){
        
          [TDMUtilities setRestaurantId:[NSString stringWithFormat:@"%d",self.bID]];
        [TDMUtilities setRestaurantName:[NSString stringWithFormat:@"%@",tempResturantsModel.name]];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) failedTOFetchBusinessID
{
    [self removeOverlayView];
    if(serviceID){
        serviceID.businessIDdelegate = nil;
        serviceID.delegate= nil;
        [serviceID release];
        serviceID = nil;
    }
   
    kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"This business has not been added to TDM and hence we can't add a dish")
      [TDMUtilities setRestaurantId:@" "];
    [TDMUtilities setRestaurantName:@""];
}

#pragma  mark -  TableView datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kBARS_CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [restaurantsHeadersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    [self cofigureCell:cell withRow:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.font=[UIFont fontWithName:@"Trebuchet MS" size:1];
    //cell.selectionStyle=UITableViewCellSelectionStyleGray;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    tempResturantsModel  = [self.restaurantsHeadersArray objectAtIndex:indexPath.row];
    self.overlayTitle = @"Loading...";
    [self getBusinessVenueIDFofBusiness];
       
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedBusiness) 
    {
        if (indexPath.row == selectedBusiness) 
        {
            [cell setBackgroundColor:[UIColor grayColor]];
            [cell setSelected:YES];
        }
    }
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
    if (self.restaurantTable) {
        [self.restaurantTable reloadData];
    }
    
}
-(void) failedToFecthPhoto
{
    [self removeOverlayView];
}

#pragma mark - Configure Cell

- (void)cofigureCell:(UITableViewCell *)aCell withRow:(int)aRow
{
    if (self.restaurantsHeadersArray) {
        
   
    BussinessModel *tempResturantModel  = [self.restaurantsHeadersArray objectAtIndex:aRow];
    
    BussinessCellView *businessCustomCellView = (BussinessCellView *)[aCell.contentView viewWithTag:8989];
    if(businessCustomCellView){
        [businessCustomCellView setvaluesToTheContents:tempResturantModel];
    }else{
        businessCustomCellView = [[BussinessCellView alloc] initWithFrame:CGRectMake(0, 0, aCell.frame.size.width, aCell.frame.size.height)];
        businessCustomCellView.tag = 8989;
        [aCell.contentView addSubview:businessCustomCellView];
        [businessCustomCellView setvaluesToTheContents:tempResturantModel];
        [businessCustomCellView.detailLabel setHidden:YES];
        [businessCustomCellView.disclosureButton setHidden:YES];
        [businessCustomCellView release];
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

#pragma mark - Location Delegates
-(void)currentLocationDidSaved:(CLLocation *)location 
{
  
}

-(void)failedToFetchRestaurantDetails
{
    self.restaurantTable.hidden = YES;
    [self removeOverlayView];
}

#pragma mark  -  Overlay View Management
- (void)showOverlayView
{
    [self removeOverlayView];
    overlayView = [[TDMOverlayView alloc] initWithSyncStyleAndTitle:overlayTitle];
    self.overlayTitle = @"Searching Restaurants...";
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

#pragma mark - Gets Business Details

- (void)getBusinessDetails
{
    [self showOverlayView];
    businessHandler = [[TDMBusinessService alloc] init];

    businessHandler.serviceDelegate = self;
    if (typeOfBusiness == 0) 
         [businessHandler getRestauarnts];
    else
        [businessHandler getBars];
    

}

- (void)navBarButtonClicked:(id)sender
{
    if (kBACK_BAR_BUTTON_TYPE)
    {

        restaurantTable.delegate=nil;
        restaurantTable.dataSource = nil;
        searchRestaurant.delegate=nil;
        searchAddress.delegate=nil;
        if(businessHandler){
            [businessHandler clearDelegate];
            [businessHandler release];
            businessHandler = nil;
        }
        
    }
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - Gets Restaurant Details delegate
-(void) serviceResponse:(NSMutableArray *)responseArray
{

    self.resultLabel.text = @"Sorry, No Results Found";
    if(businessHandler)
    {
        [businessHandler clearDelegate];
    }
    self.restaurantTable.hidden = NO;
    self.restaurantsHeadersArray = responseArray;
    if([responseArray count]>0) 
    {
        [self.restaurantTable reloadData];
    }
    else
    {
        self.restaurantTable.hidden = YES;
        self.resultLabel.hidden =NO;
        
    }
    [self removeOverlayView];
}

-(void) bussinessServiceFailed {
    
    [self removeOverlayView];
    self.resultLabel.hidden = NO;
    self.resultLabel.text = @"Sorry, No Results Found";
    self.restaurantTable.hidden = YES;
    if(businessHandler){
        businessHandler.delegate = nil;
        [businessHandler release];
        businessHandler = nil;
    }
}

-(void) networkError
{
    self.restaurantTable.hidden = YES;
    self.resultLabel.hidden = NO;
    self.resultLabel.text = @"Sorry, Network Error. Please try again later";
    [self removeOverlayView];
}

-(void) requestTimeout
{
    self.resultLabel.text = @"Sorry, Server Error. Please try again later";
    self.restaurantTable.hidden = YES;
    [self removeOverlayView];
}


@end
