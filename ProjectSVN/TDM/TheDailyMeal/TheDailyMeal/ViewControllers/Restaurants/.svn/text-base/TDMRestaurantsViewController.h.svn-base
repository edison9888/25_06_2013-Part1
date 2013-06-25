//
//  TDMRestaurantsViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/3/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TDMAppDelegate.h"
#import "TDMBusinessDetailsProviderAndHandler.h"
#import "TDMBaseHttpHandler.h"
#import "TDMFoursquareBrowse.h"


@interface TDMRestaurantsViewController : TDMBaseViewController<MKMapViewDelegate,UITextFieldDelegate,
UISearchDisplayDelegate,
UIScrollViewDelegate,TDMBusinessDetailsProviderAndHandlerDelegate,TDMLocationDelegate,TDMBaseHttpHandlerDelegate,TDMFoursquareBrowseDelegate>{
    
    
    NSMutableArray *fullData;
    NSMutableArray *restaurantsHeadersArray;
    UILabel *emptySearchResult;

}

@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic,retain) IBOutlet UITableView *restaurantTableView;
@property (nonatomic,retain) IBOutlet UIImageView *backgroundImageView;
@property (retain, nonatomic) IBOutlet UIImageView *contentBackgroundImageView;
@property (retain, nonatomic) IBOutlet UIImageView *searchBarBackGroundImage;
@property (retain, nonatomic) IBOutlet UIImageView *viewTitleImageView;
@property (retain, nonatomic) IBOutlet UIImageView *fourSquareLogoImage;
@property (retain, nonatomic) IBOutlet UILabel *viewImageTitleLabel;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) NSInteger selectedSegmentIndex;
@property (retain, nonatomic) NSMutableArray *restaurantsHeadersArray;
@property (retain, nonatomic) IBOutlet UITapGestureRecognizer *tableGesture;


- (IBAction)segmentControllClicked:(id)sender;

- (IBAction)gestureClicled:(id)sender;
//search
- (void)initializeView;
- (NSArray*)filterSearchText:(NSString*)searchText;

//- (void)refreshData;

@end
