//
//  BussinessCellView.m
//  TheDailyMeal
//
//  Created by Jai Raj on 28/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "BussinessCellView.h"

@implementation BussinessCellView

@synthesize asyncImageView;
@synthesize businessNameLabel;
@synthesize businessAddressLabel;
@synthesize staticCategoriesLabel;
@synthesize categoriesInputLabel;
@synthesize disatanceInputLabel;
@synthesize detailLabel;
@synthesize disclosureButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)setViewForCellWithBussiness {
    
    UILabel *businessNameLabel_ =  [[UILabel alloc]initWithFrame:kBUSINESS_NAME_LABEL_FRAME];
    
    businessNameLabel_.font = kGET_BOLD_FONT_WITH_SIZE(14.0f);
    [self addSubview:businessNameLabel_];
    self.businessNameLabel = businessNameLabel_;
    REMOVE_FROM_MEMORY(businessNameLabel_)
    
    UILabel *businessAddressLabel_ = [[UILabel alloc]initWithFrame:kBUSINESS_ADDRESS_LABEL_FRAME];
    
    businessAddressLabel_.font = kGET_REGULAR_FONT_WITH_SIZE(12.0f);
    [self addSubview:businessAddressLabel_];
    self.businessAddressLabel = businessAddressLabel_;
    REMOVE_FROM_MEMORY(businessAddressLabel_)
    
    UILabel *staticCategoriesLabel_ = [[UILabel alloc]initWithFrame:kBUSINESS_CATEGORIES_STATIC_LABEL_FRAME];
    staticCategoriesLabel_.font = kGET_BOLD_FONT_WITH_SIZE(11.0f);
    self.staticCategoriesLabel = staticCategoriesLabel_;
    [self addSubview:staticCategoriesLabel_];
    REMOVE_FROM_MEMORY(staticCategoriesLabel_) 
    
    UILabel *categoriesInputLabel_ = [[UILabel alloc]initWithFrame:kBUSINESS_CATERIES_INPUT_LABEL_FRAME];
    
    categoriesInputLabel_.font = kGET_REGULAR_FONT_WITH_SIZE(11.0f);
    [categoriesInputLabel_ setBackgroundColor:[UIColor clearColor]];    
    [self addSubview:categoriesInputLabel_];
    self.categoriesInputLabel = categoriesInputLabel_;
    REMOVE_FROM_MEMORY(categoriesInputLabel_)
    
    UILabel *disatanceInputLabel_ = [[UILabel alloc]initWithFrame:kBUSINESS_DISTANCE_LABEL_FRAME];
    disatanceInputLabel_.font = kGET_REGULAR_FONT_WITH_SIZE(11.0f);
    
    [self addSubview:disatanceInputLabel_];
    self.disatanceInputLabel = disatanceInputLabel_;
    disatanceInputLabel_.textColor=[UIColor grayColor];
    REMOVE_FROM_MEMORY(disatanceInputLabel_)
    
    CGRect detailRect;
    detailRect.origin.x = 250;
    detailRect.origin.y = 48;
    detailRect.size = CGSizeMake(46, 16);
    
    UILabel * detailLabel_ = [[UILabel alloc]initWithFrame:detailRect];
    detailLabel_.font = kGET_REGULAR_FONT_WITH_SIZE(11.0f);
    [detailLabel_ setTextAlignment:UITextAlignmentRight];
    detailLabel_.textColor=[UIColor grayColor];
    [detailLabel_ setBackgroundColor:[UIColor clearColor]];
    [self addSubview:detailLabel_];
    self.detailLabel = detailLabel_;
    REMOVE_FROM_MEMORY(detailLabel_)
    
    
    CGRect discloseRect;
    discloseRect.origin.y = 50;
    discloseRect.origin.x = 300;
    discloseRect.size = CGSizeMake(9, 13);
    UIImageView * disclosureButton_ = [[UIImageView alloc] initWithFrame:discloseRect];
    [disclosureButton_ setImage:[UIImage imageNamed:@"accessory"]];
    [self addSubview:disclosureButton_];
    self.disclosureButton = disclosureButton_;
    REMOVE_FROM_MEMORY(disclosureButton_)
}


- (void)setvaluesToTheContents:(BussinessModel *)bussinessModel {

    if(!businessNameLabel)
        [self setViewForCellWithBussiness];
    
    self.businessNameLabel.text =  bussinessModel.name;

    if (![bussinessModel.locationAddress isEqualToString:@""]) {
        
        self.businessAddressLabel. text = [NSString stringWithFormat:@"%@",bussinessModel.locationAddress];
        
        if (![bussinessModel.locationCity isEqualToString:@""])
        {

        self.businessAddressLabel.text = [NSString stringWithFormat:@"%@, %@",
                                          bussinessModel.locationAddress,
                                            bussinessModel.locationCity];
        }

    }
    else if (![bussinessModel.locationCity isEqualToString:@""])
    {
        self.businessAddressLabel.text = [NSString stringWithFormat:@"%@",
                                          bussinessModel.locationCity];
        
    }
    else if(![bussinessModel.locationState isEqualToString:@""])
    {
        self.businessAddressLabel.text = [NSString stringWithFormat:@"%@",
                                          bussinessModel.locationCity];
    }
    else if(![bussinessModel.locationCountry isEqualToString:@""])
    {
        self.businessAddressLabel.text = [NSString stringWithFormat:@"%@",
                                          bussinessModel.locationCountry];
    }
//    if (bussinessModel.locationAddress && 
//        ![bussinessModel.locationAddress isEqual:[NSNull null]] &&
//        bussinessModel.locationCity &&
//        ![bussinessModel.locationCity isEqual:[NSNull null]])
//    {
//        self.businessAddressLabel.text = [NSString stringWithFormat:@"%@, %@",
//                                      bussinessModel.locationAddress,
//                                      bussinessModel.locationCity];
//    }
    
    if(bussinessModel.categoryName.length>0)
    {
        self.staticCategoriesLabel.text = @"Category :";
        self.categoriesInputLabel.text = bussinessModel.categoryName;
    }
    
    if (bussinessModel.locationDistance && 
        ![bussinessModel.locationDistance isEqual:[NSNull null]]) {

        self.disatanceInputLabel.text = [NSString stringWithFormat:@"%0.2f miles",[bussinessModel.locationDistance floatValue]];

    }
    self.detailLabel.text = @"details";

}

@end
