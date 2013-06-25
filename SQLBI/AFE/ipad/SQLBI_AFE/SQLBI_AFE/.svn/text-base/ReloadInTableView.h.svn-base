//
//  ReloadInTableView.h
//  MedAmerica
//
//  Created by Elbin John on 01/03/12.
//  Copyright (c) 2012 RapidValue . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define REFRESH_HEADER_HEIGHT 52.0f
#define FLIP_ANIMATION_DURATION 0.18f

typedef enum{
	RefreshPulling = 0,
	RefreshNormal,
	RefreshLoading,
    RefreshStop,
	
} RefreshState;



@interface ReloadInTableView : UIView{
     
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
//    BOOL isDragging;
//    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    RefreshState prevState;
    
}

@property(nonatomic, strong) NSString *textPull;
@property(nonatomic, strong) NSString *textRelease;
@property(nonatomic, strong) NSString *textLoading;

- (void)initilizeView;
- (void)setState:(RefreshState)aState;
@end
