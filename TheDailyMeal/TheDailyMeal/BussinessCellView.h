//
//  BussinessCellView.h
//  TheDailyMeal
//
//  Created by Jai Raj on 28/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussinessModel.h"
#import "TDMAsyncImage.h"

@interface BussinessCellView : UIView


//@property (nonatomic, retain) BussinessModel *bussinessModel;
@property (nonatomic, retain) TDMAsyncImage *asyncImageView;
@property (nonatomic, retain) UILabel *businessNameLabel;
@property (nonatomic, retain) UILabel *businessAddressLabel;
@property (nonatomic, retain) UILabel *staticCategoriesLabel;
@property (nonatomic, retain) UILabel *categoriesInputLabel;
@property (nonatomic, retain) UILabel *disatanceInputLabel;
@property (nonatomic, retain) UILabel * detailLabel;
@property (nonatomic, retain) UIImageView * disclosureButton;

- (void)setvaluesToTheContents:(BussinessModel *)bussinessModel;

@end
