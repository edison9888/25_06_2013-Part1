//
//  TDMCityGuidesViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/3/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DisplayMap.h"
#import "TDMCityGuideListOfRestaurantsHandler.h"
#import "TDMAppDelegate.h"
#import "TDMCityGuideListOfCitiesHandler.h"
#import "TDMCityGuideListOfBarsHandler.h"
#import "TDMFilterViewController.h"
#import "TDMAppDelegate.h"
#import "TDMFoursquareBrowse.h"
#import "TDMFilterShared.h"
typedef enum mapShowType{
    mapSingleLocationType = 1,
    mapAllLocationsType = 2
}mapType;


@interface TDMCityGuidesViewController : TDMBaseViewController<MKMapViewDelegate,TDMCityGuideListOfRestaurantsHandlerDelegate,UITableViewDelegate,UITableViewDataSource,TDMLocationDelegate,TDMCityGuideListOfCitiesHandlerDelegate,TDMCityGuideListOfBarsHandlerDelegate,TDMFilterDelegate,TDMLocationDelegate,TDMFoursquareBrowseDelegate,TDMFilterSharedDelegate>{
    
    NSString *name;
    NSMutableArray *fullData;
    NSMutableArray *arrayBars;
    NSMutableArray *arrayRestaurants;
    BOOL isFilterByRestaurant;
    NSMutableArray *cityRestaurantsHeaders;
    NSMutableArray *currentCityBusinessHeaders;
    NSMutableArray *cityBarsHeaders;
    NSMutableArray *criteriaHeaders;
    NSMutableArray *currentBusinessArray;
    double currentLatitude;
    double currentLongitude;
}

@property (retain, nonatomic) NSMutableArray *currentCityBusinessHeaders;
@property (retain, nonatomic) IBOutlet UIButton *filterButton;
@property (retain, nonatomic) NSMutableArray *cityRestaurantsHeaders;
@property (retain, nonatomic) NSMutableArray *cityBarsHeaders;
@property (retain, nonatomic) IBOutlet UIImageView *FilterImage;
@property (retain, nonatomic) NSMutableArray *arrayBars;
@property (retain, nonatomic) NSMutableArray *arrayRestaurants;
@property (nonatomic, retain) IBOutlet UITableView *displayNameTable;
@property (nonatomic, retain) IBOutlet UIImageView *backgroungImage;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UILabel *filterText;
@property (nonatomic) double currentLatitude;
@property (nonatomic) double currentLongitude;
- (IBAction)segmentButtonClicked:(id)sender;
- (IBAction)filterButtonClicked:(id)sender;
- (void) toGetFilterText;


@end
