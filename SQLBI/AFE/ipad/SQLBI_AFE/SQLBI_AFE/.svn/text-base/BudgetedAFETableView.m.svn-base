//
//  BudgetedAFETableView.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BudgetedAFETableView.h"
#import "BudgetedAFECustomCell.h"
#import "AFE.h"

#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW CGRectMake(0,46,530,413)

@interface BudgetedAFETableView ()
{
    UIView *popOverView;
    UIPopoverController *popover;
    NSArray *sortingParameterTypeArrays;
    NSArray *parameterType;
    NSString *typeOfParameter;
    
    int currentPageShown;
    int totalNoPagesAvailable;
    
    NSString *currentSortParamater;
    AFESortDirection currentSortDirection;
    
    BOOL isLoading;
    BOOL isDragging;
    ReloadInTableView *reloadInTableViewForPreviousPage;
    ReloadInTableView *reloadInTableViewForNextPage;
    
    UIActivityIndicatorView *activityIndicView;
    UIView *activityIndicContainerView;
    UIView *activityIndicBGView;
    UILabel *messageLabel;

}

@end

@implementation BudgetedAFETableView

@synthesize afeArray;
@synthesize delegate;

-(id) initWithFrame:(CGRect)frame
{
    self = (BudgetedAFETableView*) [[[NSBundle mainBundle] loadNibNamed:@"BudgetedAFETableView" owner:self options:nil] lastObject];
    if (self) {
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
        
        currentSortParamater = SORTFIELD_AFEEstimate;
        currentSortDirection = AFESortDirectionDescending;

    }
    return self;
}


-(void) refreshTableWithAFEArray:(NSArray*) afeArrayToUse forPage:(int) page ofTotalPages:(int) totalPages
{
    currentPageShown = page;
    totalNoPagesAvailable = totalPages;
    self.afeArray = afeArrayToUse;
    
    sortingParameterTypeArrays = [[NSArray  alloc]initWithObjects:SORTFIELD_AFEName,
                                  SORTFIELD_AFEEstimate,
                                  SORTFIELD_Accrual,
                                  SORTFIELD_Actual,
                                  SORTFIELD_Total,nil];
    parameterType = [[NSArray alloc]initWithObjects:@"castString",@"castInt",@"castInt",@"castInt",@"castInt",nil];
    
    [afeNameHeaderLabel setFont:FONT_BOLD_HEADLINE_METRICS_PERCENTAGE_VALUE];
    [afeClassHeaderLabel setFont:FONT_BOLD_HEADLINE_METRICS_PERCENTAGE_VALUE];
    [afeBudgetHeaderLabel setFont:FONT_BOLD_HEADLINE_METRICS_PERCENTAGE_VALUE];
    [afeFieldEstimateHeaderLabel setFont:FONT_BOLD_HEADLINE_METRICS_PERCENTAGE_VALUE];
    [afeActualsHeaderLabel setFont:FONT_BOLD_HEADLINE_METRICS_PERCENTAGE_VALUE];
    
    [afeTableView reloadData];
    
    [self initializePaginationViewsInTable:afeTableView];
    
    //deciding if next page view needs to be shown when pulling.
    if(currentPageShown < totalNoPagesAvailable)
    {
        [reloadInTableViewForNextPage removeFromSuperview];
        [afeTableView addSubview:reloadInTableViewForNextPage];
    }
    else
        [reloadInTableViewForNextPage removeFromSuperview];
    
    
    //deciding if previous page view needs to be shown when pulling.
    if(currentPageShown > 1 )
    {
        [reloadInTableViewForPreviousPage removeFromSuperview];
        [afeTableView addSubview:reloadInTableViewForPreviousPage];
    }
    else
        [reloadInTableViewForPreviousPage removeFromSuperview];

}



-(void) showActivityIndicatorOverlayView
{
    [self removeActivityIndicatorOverlayView];
    
    if(!activityIndicView)
    {
        activityIndicView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    else
        [activityIndicView removeFromSuperview];
    
    if(!activityIndicContainerView)
        activityIndicContainerView = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW];
    else
    {
        [activityIndicContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [activityIndicContainerView removeFromSuperview];
        
    }
    
    if(!activityIndicBGView)
        activityIndicBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, activityIndicContainerView.frame.size.width, activityIndicContainerView.frame.size.height)];
    else
        [activityIndicBGView removeFromSuperview];
    
    //Set Styling for all Views
    activityIndicContainerView.backgroundColor = [UIColor clearColor];
    activityIndicBGView.backgroundColor = [UIColor blackColor];
    activityIndicBGView.alpha = 0.1;
    activityIndicBGView.layer.cornerRadius = 5;
    activityIndicView.frame = CGRectMake((activityIndicContainerView.frame.size.width-50)/2, (activityIndicContainerView.frame.size.height-50)/2, 50, 50);
    activityIndicView.color = [UIColor darkGrayColor];
    
    [activityIndicContainerView addSubview:activityIndicBGView];
    [activityIndicContainerView addSubview:activityIndicView];
    [self addSubview:activityIndicContainerView];
    
    [activityIndicView startAnimating];
    
}

-(void) removeActivityIndicatorOverlayView
{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(activityIndicView)
        [activityIndicView stopAnimating];
    
}

-(void) showMessageOnView:(NSString*) message
{
    if(!activityIndicContainerView)
        activityIndicContainerView = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW];
    else
    {
        [activityIndicContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [activityIndicContainerView removeFromSuperview];
        
    }
    
    if(!messageLabel)
    {
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (activityIndicContainerView.frame.size.height-15)/2, activityIndicContainerView.frame.size.width, 15)];
    }
    
    if(!activityIndicBGView)
        activityIndicBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, activityIndicContainerView.frame.size.width, activityIndicContainerView.frame.size.height)];
    else
        [activityIndicBGView removeFromSuperview];
    
    //Set Styling for all Views
    activityIndicContainerView.backgroundColor = [UIColor clearColor];
    activityIndicBGView.backgroundColor = [UIColor blackColor];
    activityIndicBGView.alpha = 0.1;
    activityIndicBGView.layer.cornerRadius = 5;
    
    messageLabel.font = [UIFont fontWithName:COMMON_FONTNAME_BOLD size:15];
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.backgroundColor= [UIColor clearColor];
    messageLabel.text = message? message:@"";
    messageLabel.textAlignment = UITextAlignmentCenter;
    
    [activityIndicContainerView addSubview:activityIndicBGView];
    [activityIndicContainerView addSubview:messageLabel];
    [self addSubview:activityIndicContainerView];
    
}

-(void) hideMessageOnView
{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(messageLabel)
        messageLabel.text = @"";
}



#pragma mark - table view datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = self.afeArray? self.afeArray.count:0;
    
    return (count<=8)? 8: count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BudgetedAFECustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BudgetedAFECustomCell"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BudgetedAFECustomCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    if(indexPath.row < self.afeArray.count)
    {
        AFE *tempAFE = [self.afeArray objectAtIndex:indexPath.row];
        
        if(tempAFE)
        {
            cell.afeNameLabel.text = tempAFE.afeNumber;
            cell.afeBudgetLabel.text = [NSString stringWithFormat:@"%@",tempAFE.budgetAsStr];
            cell.afeFieldEstimateLabel.text = [NSString stringWithFormat:@"%@",tempAFE.fieldEstimateAsStr];
            cell.afeActualsLabel.text = [NSString stringWithFormat:@"%@",tempAFE.actualsAsStr];
            cell.afeTotalLabel.text = [NSString stringWithFormat:@"%@",tempAFE.actualPlusAccrualAsStr];
            cell.delegate = self;
            cell.afeObject = tempAFE;
            cell.afeDetailButton.hidden = NO;
        }

    }
    else
    {
        cell.afeNameLabel.text = @"";
        cell.afeBudgetLabel.text = @"";
        cell.afeFieldEstimateLabel.text = @"";
        cell.afeActualsLabel.text = @"";
        cell.afeTotalLabel.text = @"";
        cell.delegate = self;
        cell.afeObject = nil;
        cell.afeDetailButton.hidden = YES;
                
    }
        
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(afeArray && (indexPath.row < afeArray.count) && self.delegate && [self.delegate respondsToSelector:@selector(didSelectAFEObjectForMoreDetais:OnBudgetedAFETableView:)])
    {
        [self.delegate didSelectAFEObjectForMoreDetais:(AFE*)[self.afeArray objectAtIndex:indexPath.row] OnBudgetedAFETableView:self];
    }
}
    
//Drop Down Button Action
-(IBAction)dropDownButtonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    typeOfParameter = [parameterType objectAtIndex:button.tag-12];
    
    if ([typeOfParameter isEqualToString:@"castInt"]) 
    {
        [self showPopOverWithXAxis:button.frame.origin.x withSortingParameter:[sortingParameterTypeArrays objectAtIndex:button.tag-12] withType:castInt];
    }
    else if([typeOfParameter isEqualToString:@"castString"])
    {
        [self showPopOverWithXAxis:button.frame.origin.x withSortingParameter:[sortingParameterTypeArrays objectAtIndex:button.tag-12] withType:castString];
    }
}

-(void)showPopOverWithXAxis:(int)xAxis withSortingParameter:(NSString *)parameter withType:(typeCastType)type
{   
    SortingView * sortView = [[SortingView alloc] initWithNibName:@"SortingView" bundle:nil];
    popover = [[UIPopoverController alloc] initWithContentViewController:sortView];    
    popover.popoverContentSize =CGSizeMake(165.0, 106.0);
    [popover setDelegate:self];    
    sortView.delegate = self;
    sortView.sortingParameter =parameter;
    sortView.sortType = type;
    [popover presentPopoverFromRect:CGRectMake(xAxis, 5, 75, 32) inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES]; 
}


-(void)sortClicked:(BOOL)descending withSortingParameter:(NSString *)parameter withType:(AFESortDirection)type
{
    currentSortParamater = parameter;
    currentSortDirection = type;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(getAFEsForBudgetedAFETableView:forPage:sortByField:andSortOrder:withRecordLimit:)])
    {
        [self.delegate getAFEsForBudgetedAFETableView:self forPage:1 sortByField:parameter andSortOrder:type withRecordLimit:50];
    }

    
    [popover dismissPopoverAnimated:YES];
}

#pragma mark - Delegate

-(void) didSelectAFE:(AFE*) afeSelected onCell:(BudgetedAFECustomCell*) cell
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectAFEObjectForMoreDetais:OnBudgetedAFETableView:)])
    {
        [self.delegate didSelectAFEObjectForMoreDetais:afeSelected OnBudgetedAFETableView:self];
    }
    
    NSLog(@"Delegate from BudgetedAFECustomCell");  
}




#pragma mark - Table Pagination methods

-(void) initializePaginationViewsInTable:(UITableView*) tableView
{
    if(!reloadInTableViewForPreviousPage)
        reloadInTableViewForPreviousPage = [[ReloadInTableView alloc] init];
    else
        [reloadInTableViewForPreviousPage removeFromSuperview];
    
    if(!reloadInTableViewForNextPage)
        reloadInTableViewForNextPage = [[ReloadInTableView alloc] init];
    else
        [reloadInTableViewForNextPage removeFromSuperview];
    
    reloadInTableViewForNextPage.textPull = @"Pull to refresh..";
    reloadInTableViewForNextPage.textRelease = @"Release to load next page...";
    
    reloadInTableViewForPreviousPage.textPull = @"Pull to refresh..";
    reloadInTableViewForPreviousPage.textRelease = @"Release to load previous page...";
    
    [tableView addSubview:reloadInTableViewForPreviousPage];
    [tableView addSubview:reloadInTableViewForNextPage];
    reloadInTableViewForNextPage.frame = CGRectMake(0, tableView.contentSize.height, tableView.frame.size.width, 50);
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (isLoading) return;
    
    isDragging = YES;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"test %@",NSStringFromCGPoint(scrollView.contentOffset));
    
    NSLog(@"SIDE %@",NSStringFromCGSize(scrollView.contentSize));
    
    if (isLoading) {
        
        
    } else if (isDragging ) {
        
        [UIView beginAnimations:nil context:NULL];
        
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            
            
            
            //[reloadInTableView setState:RefreshPulling];
            
            [self setRefreshLoading:RefreshPulling];
            
            
            
        } else {
            
            //[reloadInTableView setState:RefreshNormal];
            
            [self setRefreshLoading:RefreshNormal];
            
        }
        
        
        if (scrollView.contentOffset.y > REFRESH_HEADER_HEIGHT+75) {
            
            
            [self setRefreshLoadingBottom:RefreshPulling];
            
            
            
        } else {
            
            [self setRefreshLoadingBottom:RefreshNormal];
            
        }
        
        [UIView commitAnimations];
        
    }
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
    if (isLoading) return;
    
    isDragging = NO;
    
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {        
        
        [self setRefreshLoading:RefreshStop];
        
        [self getPreviousPageFromService];
        
    }
    
    
    if (scrollView.contentOffset.y > (scrollView.contentSize.height + REFRESH_HEADER_HEIGHT)-afeTableView.frame.size.width ) {
        
        [self setRefreshLoadingBottom:RefreshStop];
        
        [self getNextPageFromService];
        
    } 
    
}


-(void)setRefreshLoading:(RefreshState)refreshState{
    
    if(RefreshLoading== refreshState){
        
        isLoading=YES;
        
        afeTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        
    }
    
    else if(refreshState == RefreshStop){
        
        isLoading=NO;
        
        afeTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
    
    [reloadInTableViewForPreviousPage setState:refreshState];
    
}


-(void)setRefreshLoadingBottom:(RefreshState)refreshState{
    
    if(RefreshLoading== refreshState){
        
        isLoading=YES;
        
        afeTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        
    }
    
    else if(refreshState == RefreshStop){
        
        isLoading=NO;
        
        afeTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
    
    [reloadInTableViewForNextPage setState:refreshState];
    
}



-(void) getPreviousPageFromService
{
    if(currentPageShown > 1)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(getAFEsForBudgetedAFETableView:forPage:sortByField:andSortOrder:withRecordLimit:)])
        {
            [self.delegate getAFEsForBudgetedAFETableView:self forPage:currentPageShown-1 sortByField:currentSortParamater andSortOrder:currentSortDirection withRecordLimit:50];
        }
        
    }
    else
    {
        NSLog(@"You are on first page");
    }
    
}

-(void) getNextPageFromService
{
    if(currentPageShown < totalNoPagesAvailable)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(getAFEsForBudgetedAFETableView:forPage:sortByField:andSortOrder:withRecordLimit:)])
        {
            [self.delegate getAFEsForBudgetedAFETableView:self forPage:currentPageShown+1 sortByField:currentSortParamater andSortOrder:currentSortDirection withRecordLimit:50];
        }     
    }
    else
    {
        NSLog(@"You are on last Page.");
    }
}






-(void) dealloc
{
    self.afeArray = nil;
    self.delegate = nil;
}

@end
