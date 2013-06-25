//
//  TDMSignatureDishModel.h
//  TheDailyMeal
//
//  Created by Nibin Varghese on 24/03/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussinessModel.h"

@interface TDMSignatureDishModel : NSObject
{
    BussinessModel *businessModel;  
 
    NSString *staffFirstName;
    NSString *staffLastName;
    NSString *staffImagePath;  
    NSString *reviewDescription; 

    NSString *venuTitle;     
    NSString *venuImagePath;
    NSString *dishName;
    NSData *dishImageData; //Holds the image data so that we dont have to download it again in the details view.
}

@property (retain, nonatomic) BussinessModel *businessModel;
@property (retain, nonatomic) NSString *staffFirstName;
@property (retain, nonatomic) NSString *staffLastName;
@property (retain, nonatomic) NSString *staffImagePath;
@property (retain, nonatomic) NSString *dishName;
@property (retain, nonatomic) NSString *venuTitle;
@property (retain, nonatomic) NSString *reviewDescription;
@property (retain, nonatomic) NSString *dishImagePath;
@property (retain, nonatomic) NSString *venuImagePath;
@property (retain, nonatomic) NSData *dishImageData;

@end
