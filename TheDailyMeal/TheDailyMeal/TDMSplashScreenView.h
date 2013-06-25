//
//  TDMSplashScreenView.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 02/04/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMOverlayView.h"
@interface TDMSplashScreenView : UIViewController
{
   TDMOverlayView *overlayView; 
}
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (void)showOverlayView;
- (void)removeOverlayView;
@end
