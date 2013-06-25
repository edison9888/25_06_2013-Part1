//
//  AFESearchBurnDownGraphView.h
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 12/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AFESearchBurnDownGraphViewDelegate <NSObject>

@optional

-(void) showExpandedBurndownGraphWithBurnDownItemArray:(NSArray*) burnDownItemArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end;

@end

@interface AFESearchBurnDownGraphView : UIView
{
    
}
@property(nonatomic,retain)IBOutlet UILabel *afeBurndownLabel;
@property(nonatomic, assign) __unsafe_unretained NSObject<AFESearchBurnDownGraphViewDelegate> *delegate;

-(void) refreshDataWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end;

-(void)getAfeBurnDownDetailArray:(NSArray *)afeBurnDownItemsArray;

-(void) showActivityIndicatorOverlayView;
-(void) removeActivityIndicatorOverlayView;
-(void) showMessageOnView:(NSString*) message;
-(void) hideMessageOnView;

@end

