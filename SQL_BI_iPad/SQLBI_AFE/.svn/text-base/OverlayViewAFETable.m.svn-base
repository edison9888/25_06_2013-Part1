//
//  OverlayViewAFETable.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 10/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OverlayViewAFETable.h"
#import "AppDelegate.h"


#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW CGRectMake(140,180,730,520)

@interface OverlayViewAFETable ()
{
    NSArray *afeArray;
    AFEsTableView *afeTableView;
    
    UIActivityIndicatorView *activityIndicView;
    UIView *activityIndicContainerView;
    UIView *activityIndicBGView;
    UILabel *messageLabel;
    
    int currentPageShown;
    int totalNoPagesAvailable;
    int totalRecordsAvailable;
    int currentRecordCount;
}

-(void) createAFETableView;
-(IBAction)buttoncloseClicked:(id)sender;

@end

@implementation OverlayViewAFETable
@synthesize delegate, afeClass;
@synthesize displayLbl;

- (id)initWithFrame:(CGRect)frame
{
    self = (OverlayViewAFETable*) [[[NSBundle mainBundle] loadNibNamed:@"OverlayViewAFETable" owner:self options:nil] lastObject];
    if (self) {
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
        
        [self refreshDataWithAFEArray:[[NSArray alloc]init]];
    }
    return self;
}


-(void) refreshDataWithAFEArray:(NSArray*) afeArrayToUse
{
    afeArray = afeArrayToUse;
    btnClose.titleLabel.font = FONT_DASHBOARD_BUTTON_DEFAULT_LABEL;
    [btnClose setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateSelected];
    [btnClose setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    self.displayLbl.text = @"dispalying";
    self.displayLbl.font = [UIFont fontWithName:COMMON_FONTNAME_NORMAL size:11.5];

    [self createAFETableView];
}


-(void) refreshTableWithAFEArray:(NSArray*) afeArrayToUse forPage:(int) page ofTotalPages:(int) totalPages andTotalRecords:(int) totalRecords  andStartDate:(NSDate*) start andEndDate:(NSDate*) end
{
    currentPageShown = page;
    totalNoPagesAvailable = totalPages;
    afeArray = afeArrayToUse;
    totalRecordsAvailable = totalRecords;
    btnClose.titleLabel.font = FONT_DASHBOARD_BUTTON_DEFAULT_LABEL;
    [btnClose setExclusiveTouch:YES];
    [btnClose setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateSelected];
    [btnClose setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    
    for(AFE *tempAFE in afeArray)
    {
        tempAFE.afeClassName = self.afeClass.afeClassName;
    }
    
    [self createAFETableView];

}

-(void) createAFETableView
{
    if(!afeTableView)
        afeTableView = [[AFEsTableView alloc]initWithFrame:CGRectMake(10, -10, containerView.frame.size.width+150, containerView.frame.size.height)];
    
    else
        [afeTableView removeFromSuperview];
    
    afeTableView.delegate = self;
    [containerView addSubview:afeTableView];
    [afeTableView refreshTableWithAFEArray:afeArray forPage:currentPageShown ofTotalPages:totalNoPagesAvailable andTotalRecords:totalRecordsAvailable];
}


-(void) showActivityIndicatorOverlayView
{
    if(afeTableView)
        [afeTableView showActivityIndicatorOverlayView];
    
}

-(void) removeActivityIndicatorOverlayView
{
    if(afeTableView)
        [afeTableView removeActivityIndicatorOverlayView];
    
}

-(void) showMessageOnView:(NSString*) message
{
   if(afeTableView)
       [afeTableView showMessageOnView:message];
    
}

-(void) hideMessageOnView
{
    if(afeTableView)
        [afeTableView hideMessageOnView];
}



#pragma mark - Button

-(IBAction)buttoncloseClicked:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(didCloseOverlayViewAFETable:)])
        {
            [self.delegate didCloseOverlayViewAFETable:self];
        }
        
    }];

}


#pragma mark - AFEsTableView Delegate method
-(void) didSelectAFEObjectForMoreDetais:(AFE *)afeObj OnAFEsTableView:(AFEsTableView *)tableView
{
    AppDelegate *tempAppDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    if(tempAppDelegate)
    {
        [tempAppDelegate jumpToAFESearchAndSearchAFEWithObject:afeObj];
    }
}

-(void) getAFEsForAFEsTableView:(AFEsTableView*) tableView forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(getAFEsForTableInOverlayViewAFETable:withAFEClass:forPage:sortByField:andSortOrder:withRecordLimit:)])
    {
        [self.delegate getAFEsForTableInOverlayViewAFETable:self withAFEClass:self.afeClass forPage:page sortByField:sortField andSortOrder:sortDirection withRecordLimit:limit];
    }
}


-(void) dealloc
{
    afeArray = nil;
    self.delegate = nil;
}

@end
