//
//  TDMBarsViewController.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 13/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
///Users/apple/Desktop/TheDailyMeal

#import <UIKit/UIKit.h>
#import "LocationManager.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import "Reachability.h"
#import "DisplayMap.h"
#import "TDMBusinessImageService.h"
#import "TDMFoursquareSearchService.h"
#import "TDMOverlayView.h"

@interface TDMBarsViewController : TDMBaseViewController<LocationManagerDelegate,MKMapViewDelegate,TDMBusinessServiceDelegate,UISearchDisplayDelegate,TDMBusinessImageServiceDelegate,TDMFoursquareSearchServiceDelegate,UITextFieldDelegate>
{
    NSMutableArray *barHeadersArray;
    NSMutableArray *fullData;
    UILabel *emptySearchResult;
    TDMOverlayView *overlayView;
    NSMutableDictionary *imageCache;
    BOOL valid;
    double lastBarsLocationLongitude;
    double lastBarsLocationLatitude;
    
}
@property (retain, nonatomic) IBOutlet UILabel *stausOfBarLabel;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UITableView *barTableView;
@property (retain, nonatomic) NSMutableArray *barHeadersArray;
@property (nonatomic)            NSInteger selectedSegmentIndex;
@property (nonatomic, assign) int isFromFavorites;
@property (retain, nonatomic) IBOutlet UIView *searchView;
@property (assign, nonatomic) double lastBarsLocationLongitude;
@property (assign, nonatomic) double lastBarsLocationLatitude;
@property (retain, nonatomic) IBOutlet UITextField *searchRestaurant;
@property (retain, nonatomic) IBOutlet UITextField *searchAddress;
@property (retain,nonatomic)IBOutlet UIButton *advancedButton;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;


- (void)initialiseView;
- (void)addMapLatitudeAndLogitude;
- (void)mapAllLocationsInOneView;
- (void)makeMapViewRectInCaseOfMutlipleAnnotations;
- (IBAction)segmentControlClicked:(id)sender;
- (void)addBusinessToWishList:(int)index;
-(void) changeUISegmentFont:(UIView*) myView ;
- (IBAction)searchViewCancelButtonTouched:(id)sender;
- (IBAction)searchViewDoneButtonClicked:(id)sender;
- (IBAction)adVancedSearchButtonClicked:(id)sender;
- (IBAction)searchBarCancelButtonTouched:(id)sender;
@end
