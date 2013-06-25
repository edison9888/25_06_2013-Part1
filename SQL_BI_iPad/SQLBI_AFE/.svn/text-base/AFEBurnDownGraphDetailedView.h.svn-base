//
//  AFEBurnDownGraphDetailedView.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 16/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFESearchBurnDownGraphView.h"

@class AFEBurnDownGraphDetailedView;

@protocol AFEBurnDownGraphDetailedViewDelegate <NSObject>
@optional

-(void) didCloseAFEBurnDownGraphDetailedView:(AFEBurnDownGraphDetailedView*) view;

@end

@interface AFEBurnDownGraphDetailedView : UIView
{
    IBOutlet UIView *chartContainerView;
    IBOutlet UIImageView *backgroundView;
}

@property(nonatomic, assign) __unsafe_unretained NSObject<AFEBurnDownGraphDetailedViewDelegate> *delegate;

-(void) refreshDataWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end;

-(void) showActivityIndicatorOverlayView;
-(void) removeActivityIndicatorOverlayView;
-(void) showMessageOnView:(NSString*) message;
-(void) hideMessageOnView;

@end
