/**************************************************************************************
//  File Name      : SwipeController.h
//  Project Name   : <Generic Class>
//  Description    : N/A
//  Version        : 1.0
//  Created by     : NaveenShan
//  Created on     : 12/04/2011
//  Copyright (C) 2011 RapidValue IT Services Pvt Ltd. Ltd. All Rights Reserved.
***************************************************************************************/

#import <UIKit/UIKit.h>

#import "TDMBaseViewController.h"


@interface SwipeController : TDMBaseViewController {
    
    int initialPageToShow;
    int m_totalPages;
    
    float imageHorizontalSpacing;
    float imageVerticalSpacing;
    
    BOOL avoidScroll;
    
    @private
    //for sliding 
    int m_iCurrentPageIndex; 
	BOOL m_bRotationInProgress;
    NSMutableArray *m_pageViews;
	UIScrollView *m_scrollView;
    
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *subNavigationTitle;

@property (nonatomic, assign) int initialPageToShow;
@property (nonatomic, assign) int totalPages; 

@property (nonatomic, assign) float imageHorizontalSpacing;
@property (nonatomic, assign) float imageVerticalSpacing;

- (void)loadScrollView; 

- (CGSize)pageSize;
- (BOOL)isPageLoaded:(int)pageIndex;

- (void)layoutPages;
- (CGRect)alignView:(UIView *)view forPage:(int)pageIndex;

- (UIView *)viewForPage:(int)pageIndex;

-(void)willChangeToPageIndex:(int)pageIndex;
-(void)didChangePageIndex:(int)pageIndex;

-(void)gotoPageAtIndex:(int)pageIndex;
-(void)reloadCurrentPageView;
- (void)unloadPageViews;
- (void)reloadPageViews;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
