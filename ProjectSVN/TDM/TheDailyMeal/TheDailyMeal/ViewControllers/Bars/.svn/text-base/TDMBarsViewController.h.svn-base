//
//  TDMBarsViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/3/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TDMAppDelegate.h"
#import "TDMBusinessDetailsProviderAndHandler.h"
#import "TDMFoursquareBrowse.h"
@interface TDMBarsViewController : TDMBaseViewController<MKMapViewDelegate,UITextFieldDelegate,UISearchDisplayDelegate, UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,TDMLocationDelegate,TDMBusinessDetailsProviderAndHandlerDelegate,TDMFoursquareBrowseDelegate>{
    
    
    NSMutableArray *fullData;
    UILabel *emptySearchResult;
    NSMutableArray *barHeadersArray;

}

@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UITableView *barTableView;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (retain, nonatomic) IBOutlet UIImageView *contentBackgroundImageView;
@property (retain, nonatomic) IBOutlet UIImageView *searchBarBackGroundImage;
@property (retain, nonatomic) IBOutlet UIImageView *viewTitleImageView;
@property (retain, nonatomic) IBOutlet UIImageView *fourSquareLogoImage;
@property (retain, nonatomic) IBOutlet UILabel *viewImageTitleLabel;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic)         NSInteger selectedSegmentIndex;
@property (retain, nonatomic) NSMutableArray *barHeadersArray;
@property (retain, nonatomic) IBOutlet UILabel *noBarsFoundLabel;

@property (retain, nonatomic) IBOutlet UITapGestureRecognizer *tableGesture;


- (IBAction)segmentControllClicked:(id)sender;

- (IBAction)gestureClicled:(id)sender;
//search
- (void)initializeView;
- (NSArray*)filterSearchText:(NSString*)searchText;

//- (void)refreshData;

@end
