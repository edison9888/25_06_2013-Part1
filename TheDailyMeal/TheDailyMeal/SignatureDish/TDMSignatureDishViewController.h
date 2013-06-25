//
//  TDMSignatureDishViewController.h
//  TheDailyMeal
//
//  Created by Nibin V on 24/03/2012.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManager.h"
#import "TDMBestDishService.h"
#import "TDMOverlayView.h"
#import "SwipeController.h"
#import "TDMSignatureDishModel.h"
#import "TDMBestDishNameService.h"
#import <MapKit/MapKit.h>

@interface TDMSignatureDishViewController : SwipeController <LocationManagerDelegate, TDMBestDishServiceDelegate,TDMBestDishNameServiceDelegate,MKMapViewDelegate>
{
    NSMutableArray *signatureDataArray;
    TDMOverlayView *overlayView;
    UIImageView *dishImageview;
    BOOL isAlertAppeared;
}

@property (retain, nonatomic) UIView * mainView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (retain, nonatomic) IBOutlet UIImageView *contentBackgroundImageView;
@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (retain, nonatomic) NSMutableArray *signatureDataArray;
@property (retain, nonatomic) IBOutlet UILabel *noDishesLabel;
@property (retain, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic, assign) int currentPageIndex;
@property (retain, nonatomic) IBOutlet UIButton *previousButton;

@property (assign, nonatomic) double lastBestDishLocationLongitude;
@property (assign, nonatomic) double lastBestDishLocationLatitude;
@property (nonatomic, retain) NSMutableArray *pageViews;
@property (nonatomic, retain) NSMutableArray *arrayOfAddressID;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)segmentControlClicked:(id)sender;

@property (nonatomic)         NSInteger selectedSegmentIndex;

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) TDMBestDishNameService *bestDishName;



- (void) initialiseView;
- (BOOL)needToUpdateBestDishList;
- (IBAction)showNextBestDish:(id)sender;
- (IBAction)showPreviousBestDish:(id)sender;
- (void) addSegmentedControl;


@end
