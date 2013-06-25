//
//  TDMRestaurantsViewController.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 15/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BussinessModel.h"
#import "TDMOverlayView.h"
#import "TDMBusinessImageService.h"
#import "TDMBusinessService.h"
#import "TDMFoursquareSearchService.h"
#import "LocationManager.h"
#import "AppDelegate.h"

@interface TDMRestaurantsViewController : TDMBaseViewController<MKMapViewDelegate,TDMBusinessServiceDelegate,TDMBusinessImageServiceDelegate,TDMFoursquareSearchServiceDelegate,LocationManagerDelegate,UITextFieldDelegate>
{
    NSMutableArray *restaurantsHeadersArray;
    NSMutableArray *arrayOfAddressID;
    UILabel *emptySearchResult;
    NSMutableArray *fullData;
    TDMOverlayView *overlayView;
    NSMutableDictionary *imageCache;
}
@property (retain, nonatomic) NSMutableArray *arrayOfAddressID;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UILabel *statusOfRestaurants;
@property (retain, nonatomic) IBOutlet UITableView *restaurantsTableView;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic)         NSInteger selectedSegmentIndex;
@property (retain, nonatomic) NSMutableArray *restaurantsHeadersArray;
@property (retain, nonatomic) UIButton *searchAddressButton;

@property (nonatomic, assign) int isFromFavorites;

@property (retain, nonatomic) IBOutlet UIView *searchView;
@property (assign, nonatomic) double lastRestaurantLocationLongitude;
@property (assign, nonatomic) double lastRestaurantLocationLatitude;
@property (retain, nonatomic) IBOutlet UIButton *searchCancelButton;
- (IBAction)searchCancelButtonTapped:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *searchRestaurant;
@property (retain, nonatomic) IBOutlet UITextField *searchAddress;
@property (retain,nonatomic)IBOutlet UIButton *advancedButton;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;



- (void)initialiseView;
- (void)addMapLatitudeAndLogitude;
- (void)mapAllLocationsInOneView;
- (void)makeMapViewRectInCaseOfMutlipleAnnotations;
- (NSArray*)filterSearchText:(NSString*)searchText;
- (void)addBusinessToWishList:(int)index;
- (BOOL)needToUpdateRestaurantList;
-(void) changeUISegmentFont:(UIView*) myView ;
- (IBAction)searchViewDoneButtonClicked:(id)sender;
- (IBAction)adVancedSearchButtonClicked:(id)sender;
- (IBAction)searchViewCancelButtonTouched:(id)sender;
- (IBAction)searchBarCancelButtonTouched:(id)sender;
@end
