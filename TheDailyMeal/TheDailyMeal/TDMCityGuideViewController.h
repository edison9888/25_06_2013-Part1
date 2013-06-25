//
//  TDMCityGuideViewController.h
//  TheDailyMeal
//
//  Created by Apple on 23/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TDMBaseViewController.h"
#import "TDMCityGuideService.h"
#import "TDMOverlayView.h"
#import "TDMBusinessService.h"
#import "TDMBusinessImageService.h"
#import "TDMAsyncImage.h"
#import "TDMFilterViewController.h"

@interface TDMCityGuideViewController : TDMBaseViewController<MKMapViewDelegate,MKAnnotation,TDMCityGuideServiceDelegate,TDMBusinessServiceDelegate,TDMBusinessImageServiceDelegate>
{
    NSMutableArray *arrayOfAddressID;
    NSMutableArray *cityGuideHeadersArray;
    TDMOverlayView *overlayView;
    NSMutableDictionary *imageCache;
    TDMCityGuideService *cityService;
    TDMBusinessService *businessService;
}

@property (retain, nonatomic) IBOutlet UIButton *goButton;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UITableView *cityGuideTable;
@property (retain, nonatomic) IBOutlet NSMutableArray *arrayOfAddressID;
@property (retain, nonatomic) NSMutableArray *cityGuideHeadersArray;
@property (retain, nonatomic) IBOutlet UIButton *filterButton;
@property (retain, nonatomic) IBOutlet UILabel *cityGuideLabel;
@property (retain, nonatomic) IBOutlet UILabel *errorLabel;
@property (retain, nonatomic) IBOutlet UIScrollView *cityGuideScrollView;
@property (retain, nonatomic) NSString *previousGuideType;
@property (retain, nonatomic) NSString *previousCity;
@property (retain, nonatomic) TDMFilterViewController *filter;
@property (assign,nonatomic)  TDMCityGuideService *cityService;
@property (assign,nonatomic)  TDMBusinessService *businessService;

- (IBAction)filterButtonClicked:(id)sender;
- (void)releaseFilterController;
- (void)dismissKeyBoardAndSetNavBar;
- (void)addMapLatitudeAndLogitude;
- (void)mapAllLocationsInOneView;
- (void)makeMapViewRectInCaseOfMutlipleAnnotations;
-(IBAction)goButtonClick:(id)sender;
-(void) getCityDetails;
- (void)cofigureCell:(UITableViewCell *)aCell withRow:(int)aRow;
@end
