//
//  TDMAddSignatureDishFindRestaurant.h
//  TheDailyMeal
//
//  Created by Apple on 17/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TDMOverlayView.h"
#import "TDMBusinessService.h"
#import "TDMBusinessImageService.h"
#import "TDMFoursquareSearchService.h"
#import "TDMBusinessIDService.h"
#import "BussinessModel.h"

@interface TDMAddSignatureDishFindRestaurant : TDMBaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,TDMBusinessServiceDelegate,TDMBusinessImageServiceDelegate,TDMFoursquareSearchServiceDelegate,TDMBusinessIDServiceDelegate>
{
    NSMutableArray *arrayRestaurants;
    NSInteger *numberOfCells;
    int number;
    NSMutableArray *restaurantsHeadersArray;
    NSMutableDictionary *restaurantDetails;
     TDMOverlayView *overlayView;
     NSMutableDictionary *imageCache;
    NSInteger selectedBusiness;    
    TDMBusinessService *businessHandler;
    BOOL valid;
    UILabel *searchResultLabel;
    BussinessModel *tempResturantsModel;
     TDMBusinessIDService *serviceID;
    UITableViewCell *businessCell;
}

@property (assign, nonatomic) int typeOfBusiness;
@property (assign, nonatomic) int bID;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (retain, nonatomic) IBOutlet UITextField *searchRestaurant;
@property (retain, nonatomic) IBOutlet UITextField *searchAddress;
@property (retain, nonatomic) IBOutlet UILabel *resultLabel;
@property (retain, nonatomic) IBOutlet UITableView *restaurantTable;
@property (retain, nonatomic) NSMutableArray *restaurantsHeadersArray;
@property (retain, nonatomic) NSString *overlayTitle;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)segmentClick:(id)sender;
- (void)getBusinessDetails;
-(BOOL)textFieldValidation;
- (void) addSegmentedControl ;
-(void)changeUISegmentFont:(UIView*)aView;
@end
