//
//  ProjectWatchListAFETableView.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProjectWatchListAFETableView.h"
#import "ProjectWatchListAFECustomCell.h"
#import "AFE.h"

#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW CGRectMake(0,46,599,413)

@interface ProjectWatchListAFETableView ()
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

@property(nonatomic, strong) NSArray *afeArray;

@end

@implementation ProjectWatchListAFETableView
@synthesize afeArray;
@synthesize delegate;

-(id) initWithFrame:(CGRect)frame
{
    self = (ProjectWatchListAFETableView*) [[[NSBundle mainBundle] loadNibNamed:@"ProjectWatchListAFETableView" owner:self options:nil] lastObject];
    if (self) {
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
        
        currentSortParamater = SORTFIELD_PercentageConsumption;
        currentSortDirection = AFESortDirectionDescending;
    }
    return self;
}

-(void) refreshTableWithAFEArray:(NSArray*) afeArrayToUse forPage:(int) page ofTotalPages:(int) totalPages
{
    currentPageShown = page;
    totalNoPagesAvailable = totalPages;
    self.afeArray = afeArrayToUse;
    
    sortingParameterTypeArrays = [[NSArray  alloc]initWithObjects:SORTFIELD_AFEName,SORTFIELD_AFEEstimate,SORTFIELD_Accrual,SORTFIELD_Actual,SORTFIELD_Total,SORTFIELD_PercentageConsumption, nil];
    parameterType = [[NSArray alloc]initWithObjects:@"castString",@"castInt",@"castInt",@"castInt",@"castInt",@"castInt", nil];
    
    UIFont *font = FONT_HEADLINE_TITLE;
    font = [font fontWithSize:font.pointSize-1];
    [classHeaderLabel setFont:font];
    [noOfAFEsHeaderLabel setFont:font];
    [afeBudgetHeaderLabel setFont:font];
    [afeFieldEstimateHeaderLabel setFont:font];
    [afeActualsHeaderLabel setFont:font];
    [consumptionLabel setFont:font];
    
    [afeClassesTableView reloadData];
    
    [self initializePaginationViewsInTable:afeClassesTableView];

    //deciding if next page view needs to be shown when pulling.
    if(currentPageShown < totalNoPagesAvailable)
    {
        [reloadInTableViewForNextPage removeFromSuperview];
        [afeClassesTableView addSubview:reloadInTableViewForNextPage];
    }
    else
        [reloadInTableViewForNextPage removeFromSuperview];
    
    
    //deciding if previous page view needs to be shown when pulling.
    if(currentPageShown > 1 )
    {
        [reloadInTableViewForPreviousPage removeFromSuperview];
        [afeClassesTableView addSubview:reloadInTableViewForPreviousPage];
    }
    else
        [reloadInTableViewForPreviousPage removeFromSuperview];

    
}

#pragma mark - table view datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = self.afeArray? self.afeArray.count:0;
    
    return (count<=8)? 8: count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectWatchListAFECustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectWatchListAFECustomCell"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProjectWatchListAFECustomCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    if(indexPath.row < self.afeArray.count)
    {
        AFE *tempAFE = [self.afeArray objectAtIndex:indexPath.row];
        
        if(tempAFE)
        {
            cell.afeNameLbl.text = tempAFE.afeNumber? tempAFE.afeNumber:@"";
            cell.budgetLbl.text = [NSString stringWithFormat:@"%@",tempAFE.budgetAsStr];
            cell.fieldEstmtLbl.text = [NSString stringWithFormat:@"%@",tempAFE.fieldEstimateAsStr];
            cell.actualLbl.text = [NSString stringWithFormat:@"%@",tempAFE.actualsAsStr];
            cell.totalLbl.text = [NSString stringWithFormat:@"%@",tempAFE.actualPlusAccrualAsStr];
            cell.consumptionLbl.text = [NSString stringWithFormat:@"%.2f\%%",tempAFE.percntgConsmptn];
            cell.afeObject = tempAFE;
            cell.delegate = self;
            cell.afeButton.hidden = NO;
            
        }
        
    }
    else
    {
        cell.afeNameLbl.text = @"";
        cell.budgetLbl.text = @"";
        cell.fieldEstmtLbl.text = @"";
        cell.actualLbl.text = @"";
        cell.totalLbl.text = @"";
        cell.consumptionLbl.text = @"";
        cell.afeObject = nil;
        cell.delegate = self;
        cell.afeButton.hidden = YES;
        
    }
       
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(afeArray && (indexPath.row < afeArray.count) && self.delegate && [self.delegate respondsToSelector:@selector(didSelectAFEObjectForMoreDetais:OnProjectWatchListAFETableView:)])
    {
        [self.delegate didSelectAFEObjectForMoreDetais:(AFE*)[self.afeArray objectAtIndex:indexPath.row] OnProjectWatchListAFETableView:self]; 
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
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(getAFEsForProjectWatchListAFETableView:forPage:sortByField:andSortOrder:withRecordLimit:)])
    {
        [self.delegate getAFEsForProjectWatchListAFETableView:self forPage:1 sortByField:parameter andSortOrder:type withRecordLimit:50];
    }
    
    [popover dismissPopoverAnimated:YES];
}

#pragma mark - Delegate

-(void) didSelectAFE:(AFE*) afeSelected onCell:(ProjectWatchListAFECustomCell*) cell
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectAFEObjectForMoreDetais:OnProjectWatchListAFETableView:)])
    {
        [self.delegate didSelectAFEObjectForMoreDetais:afeSelected OnProjectWatchListAFETableView:self]; 
    }

    
    NSLog(@"Delegate in ProjectWatchListAFECustomCell");
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
    
    
    if (scrollView.contentOffset.y > (scrollView.contentSize.height + REFRESH_HEADER_HEIGHT)-afeClassesTableView.frame.size.width ) {
        
        [self setRefreshLoadingBottom:RefreshStop];
        
        [self getNextPageFromService];
        
    } 
    
}


-(void)setRefreshLoading:(RefreshState)refreshState{
    
    if(RefreshLoading== refreshState){
        
        isLoading=YES;
        
        afeClassesTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        
    }
    
    else if(refreshState == RefreshStop){
        
        isLoading=NO;
        
        afeClassesTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
    
    [reloadInTableViewForPreviousPage setState:refreshState];
    
}


-(void)setRefreshLoadingBottom:(RefreshState)refreshState{
    
    if(RefreshLoading== refreshState){
        
        isLoading=YES;
        
        afeClassesTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        
    }
    
    else if(refreshState == RefreshStop){
        
        isLoading=NO;
        
        afeClassesTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
    
    [reloadInTableViewForNextPage setState:refreshState];
    
}


-(void) getPreviousPageFromService
{
    if(currentPageShown > 1)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(getAFEsForProjectWatchListAFETableView:forPage:sortByField:andSortOrder:withRecordLimit:)])
        {
            [self.delegate getAFEsForProjectWatchListAFETableView:self forPage:currentPageShown-1 sortByField:currentSortParamater andSortOrder:currentSortDirection withRecordLimit:50];
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
        if(self.delegate && [self.delegate respondsToSelector:@selector(getAFEsForProjectWatchListAFETableView:forPage:sortByField:andSortOrder:withRecordLimit:)])
        {
            [self.delegate getAFEsForProjectWatchListAFETableView:self forPage:currentPageShown+1 sortByField:currentSortParamater andSortOrder:currentSortDirection withRecordLimit:50];
        }        
    }
    else
    {
        NSLog(@"You are on last Page.");
    }
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




-(void) dealloc
{
    self.afeArray = nil;
    self.delegate = nil;
}

@end
