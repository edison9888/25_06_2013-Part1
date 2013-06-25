//
//  TDMLoadingOverlay.h
//  TheDailyMeal
//
//  Created by Nithin George on 13/01/2012.
//  Copyright 2010 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TDMLoadingOverlay : UIView {
		
	UIView *childView;
	UILabel *message;
	UILabel *stickyMessage;
	UIActivityIndicatorView *indicator;
	
	BOOL pendingAnimation;
}

@property (nonatomic, retain) IBOutlet UIView *childView;
@property (nonatomic, retain) IBOutlet UILabel *stickyMessage;
@property (nonatomic, retain) IBOutlet UILabel *message;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

+(TDMLoadingOverlay *)loadOverlayOnTopWithMessage:(NSString *)initialMessage animated:(BOOL)animated;
+(TDMLoadingOverlay *)loadOverlayOnTopWithMessage:(NSString *)initialMessage title:(NSString *)title animated:(BOOL)animated;
+(TDMLoadingOverlay *)loadOverView:(UIView *)baseView withMessage:(NSString *)initialMessage animated:(BOOL)animated;
+(TDMLoadingOverlay *)loadOverView:(UIView *)baseView withMessage:(NSString *)initialMessage title:(NSString*)title animated:(BOOL)animated;
+(TDMLoadingOverlay *)loadOverView:(UIView *)baseView 
					  withMessage:(NSString *)initialMessage 
							title:(NSString*)title 
						 animated:(BOOL)animated 
					centerMessage:(BOOL)centerMessage;
+(TDMLoadingOverlay *)loadOverReportView:(UIView *)baseView withMessage:(NSString *)initialMessage animated:(BOOL)animated;
-(void)removeFromSuperview:(BOOL)animated;
-(void)doRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
-(void)animateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;	
-(void)doRotation;
@end
