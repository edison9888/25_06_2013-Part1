//
//  TDMAddSignatureDishFindRestaurant.h
//  TheDailyMeal
//
//  Created by Apple on 17/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMAppDelegate.h"
#import "TDMBusinessDetailsProviderAndHandler.h"

@interface TDMAddSignatureDishFindRestaurant : TDMBaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,TDMLocationDelegate,TDMBusinessDetailsProviderAndHandlerDelegate>
{
    NSMutableArray *arrayRestaurants;
    NSInteger *numberOfCells;
    int number;
    NSMutableArray *restaurantsHeadersArray;
    NSMutableDictionary *restaurantDetails;
}

@property (assign, nonatomic) int typeOfBusiness;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (retain, nonatomic) IBOutlet UITextField *searchRestaurant;
@property (retain, nonatomic) IBOutlet UITextField *searchAddress;
@property (retain, nonatomic) IBOutlet UITableView *restaurantTable;
@property (retain, nonatomic) NSMutableArray *restaurantsHeadersArray;

- (IBAction)segmentClick:(id)sender;
@end
