//
//  WellSearchTableView.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 12/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WellSearchTableView.h"
#import "ReloadInTableView.h"

#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW CGRectMake(0,50,950,300)

@interface WellSearchTableView ()
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
@property (nonatomic,strong)IBOutlet UITableView* wellTableView;
@property (nonatomic,strong) NSArray* wellDetailArray;

@property (nonatomic,strong) IBOutlet UILabel *afeHeaderLbl;
@property (nonatomic,strong) IBOutlet UILabel *startDateHeaderLbl;
@property (nonatomic,strong) IBOutlet UILabel *statusHeaderLbl;
@property (nonatomic,strong) IBOutlet UILabel *budgetHeaderLbl;
@property (nonatomic,strong) IBOutlet UILabel *fieldEstmtHeaderLbl;
@property (nonatomic,strong) IBOutlet UILabel *feldEstmtBudgtHeaderLbl;
@property (nonatomic,strong) IBOutlet UILabel *actualHeaderLbl;
@property (nonatomic,strong) IBOutlet UILabel *actualBudgtHeaderLbl;


@end

@implementation WellSearchTableView

@synthesize delegate;
@synthesize wellTableView;
@synthesize wellDetailArray;
@synthesize afeHeaderLbl,startDateHeaderLbl,statusHeaderLbl,budgetHeaderLbl,fieldEstmtHeaderLbl,feldEstmtBudgtHeaderLbl,actualHeaderLbl,actualBudgtHeaderLbl;


-(id) initWithFrame:(CGRect)frame
{
    self = (WellSearchTableView*) [[[NSBundle mainBundle] loadNibNamed:@"WellSearchTableView" owner:self options:nil] lastObject];
    if (self) {
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
    }
    return self;
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
    activityIndicBGView.layer.cornerRadius = 1;
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



-(void) refreshDataWithWellArray:(NSArray*)wellArrayToUse forPage:(int) page ofTotalPages:(int) totalPages
{
    
    currentPageShown = page;
    totalNoPagesAvailable = totalPages;
    self.wellDetailArray = wellArrayToUse;
    [afeHeaderLbl setFont:FONT_TABLEVIEWCELL_HEADER];
    [startDateHeaderLbl setFont:FONT_TABLEVIEWCELL_HEADER];
    [statusHeaderLbl setFont:FONT_TABLEVIEWCELL_HEADER];
    [budgetHeaderLbl setFont:FONT_TABLEVIEWCELL_HEADER];
    [fieldEstmtHeaderLbl setFont:FONT_TABLEVIEWCELL_HEADER];
    [feldEstmtBudgtHeaderLbl setFont:FONT_TABLEVIEWCELL_HEADER];
    [actualHeaderLbl setFont:FONT_TABLEVIEWCELL_HEADER];
    [actualBudgtHeaderLbl setFont:FONT_TABLEVIEWCELL];
    sortingParameterTypeArrays = [[NSArray  alloc]initWithObjects:SORTFIELD_AFENumber,SORTFIELD_AFEStartDate,SORTFIELD_AFEStatus,SORTFIELD_AFEEstimate,SORTFIELD_Actual,SORTFIELD_Accrual,SORTFIELD_Total,SORTFIELD_PercentageConsumption, nil];
    parameterType = [[NSArray alloc]initWithObjects:@"castString",@"castString",@"castString",@"castInt",@"castInt",@"castInt",@"castInt",@"castInt", nil];
    [wellTableView reloadData];
    [self initializePaginationViewsInTable:wellTableView];
    
        //deciding if next page view needs to be shown when pulling.
    if(currentPageShown < totalNoPagesAvailable)
        {
        [reloadInTableViewForNextPage removeFromSuperview];
        [wellTableView addSubview:reloadInTableViewForNextPage];
        }
    else
        [reloadInTableViewForNextPage removeFromSuperview];
    
    
        //deciding if previous page view needs to be shown when pulling.
    if(currentPageShown > 1 )
        {
        [reloadInTableViewForPreviousPage removeFromSuperview];
        [wellTableView addSubview:reloadInTableViewForPreviousPage];
        }
    else
        [reloadInTableViewForPreviousPage removeFromSuperview];


    
}

#pragma mark - table view datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count =  self.wellDetailArray? self.wellDetailArray.count:0;
    return (count<=6)?6:count; 
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WellSearchCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WellSearchCustomCell"];
    if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"WellSearchCustomCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    if(indexPath.row < [self.wellDetailArray count]){
        AFE *tempAFEClass = (AFE*)[self.wellDetailArray objectAtIndex:indexPath.row];
        if(tempAFEClass){
            [cell.jumpButton setHidden:NO];
            [cell.indicatorImage setHidden:NO];
            cell.afeLbl.text = tempAFEClass.afeNumber;
            NSString *dateStr = [NSString stringWithFormat:@"%@",tempAFEClass.fromDate];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
            NSDate *date = [[NSDate alloc] init];
            date = [dateFormatter dateFromString:dateStr];
            cell.startDateLbl.text = [NSString stringWithFormat:@"%@",[Utility getStringFromDateFormatter1:date]];
            cell.statusLbl.text = tempAFEClass.status;
            cell.budgetLbl.text = tempAFEClass.budget? tempAFEClass.budgetAsStr:@"";
            cell.fieldEstmtLbl.text =tempAFEClass.actualsAsStr? tempAFEClass.actualsAsStr:@"";//[NSString stringWithFormat:@"$%.f",tempAFEClass.actual]; 
            cell.feldEstmtBudgtLbl.text = tempAFEClass.fieldEstimateAsStr? tempAFEClass.fieldEstimateAsStr:@"";//[NSString stringWithFormat:@"$%.f %",tempAFEClass.fieldEstimatePercent];
            cell.actualLbl.text = tempAFEClass.actualPlusAccrualAsStr? tempAFEClass.actualPlusAccrualAsStr:@"";//[NSString stringWithFormat:@"$%.f",tempAFEClass.actual];
            cell.actualBudgtLbl.text = [NSString stringWithFormat:@"%@",[Utility formatNumber:[NSString stringWithFormat:@"%.2f",tempAFEClass.percntgConsmptn]]];//[NSString stringWithFormat:@"%.f %%",tempAFEClass.actualPercent];
            cell.indicatorImage.image = [UIImage imageNamed:@"redCircle.png"];
            if(tempAFEClass.percntgConsmptn < 80)
                cell.indicatorImage.image = [UIImage imageNamed:@"greenCircle.png"];
            if((tempAFEClass.percntgConsmptn >= 80) && (tempAFEClass.percntgConsmptn <=100))
                cell.indicatorImage.image = [UIImage imageNamed:@"yellowCircle.png"];
            cell.delegate = self;
            cell.afeObject = tempAFEClass;
            }
    }
    else {
        cell.afeLbl.text=@"";
        cell.startDateLbl.text=@"";
        cell.statusLbl.text =@"";
        cell.budgetLbl.text = @"";
        cell.fieldEstmtLbl.text =@"";
        cell.feldEstmtBudgtLbl.text =@"";
        cell.actualLbl.text =@"";
        cell.actualBudgtLbl.text=@"";
    }

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(wellDetailArray && (indexPath.row < wellDetailArray.count) && self.delegate && [self.delegate respondsToSelector:@selector(didSelectAFEObjectForMoreDetais:OnAFEsTableView:)]){
        [self.delegate  didSelectAFEObjectForMoreDetais:(AFE *)[self.wellDetailArray objectAtIndex:indexPath.row] OnAFEsTableView:self];
    }
}

#pragma mark -
#pragma mark CustomWellSeachCell Delegate

-(void) didSelectAFE:(AFE*) afeSelected onCell:(WellSearchCustomCell*) cell{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectAFEObjectForMoreDetais:OnAFEsTableView:)]){
        [self.delegate  didSelectAFEObjectForMoreDetais:afeSelected OnAFEsTableView:self];
    }

}
//Drop Down Button Action
-(IBAction)dropDownButtonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    typeOfParameter = [parameterType objectAtIndex:button.tag-12];
    
    if ([typeOfParameter isEqualToString:@"castInt"]) 
    {
        [self showPopOverWithXAxis:button.frame.origin.x withWidth:button.frame.size.width withSortingParameter:[sortingParameterTypeArrays objectAtIndex:button.tag-12] withType:castInt];
    }
    else if([typeOfParameter isEqualToString:@"castString"])
    {
        [self showPopOverWithXAxis:button.frame.origin.x withWidth:button.frame.size.width withSortingParameter:[sortingParameterTypeArrays objectAtIndex:button.tag-12] withType:castString];
    }
    else if([typeOfParameter isEqualToString:@"castDate"])
    {
        [self showPopOverWithXAxis:button.frame.origin.x withWidth:button.frame.size.width withSortingParameter:[sortingParameterTypeArrays objectAtIndex:button.tag-12] withType:castDate];
    }
}

-(void)showPopOverWithXAxis:(int)xAxis withWidth:(int)width withSortingParameter:(NSString *)parameter withType:(typeCastType)type
{   
    if(popover){
        [popover dismissPopoverAnimated:YES];
        popover = nil;
    }
    SortingView * sortView = [[SortingView alloc] initWithNibName:@"SortingView" bundle:nil];
    popover = [[UIPopoverController alloc] initWithContentViewController:sortView];    
    popover.popoverContentSize =CGSizeMake(165.0, 106.0);
    [popover setDelegate:self];    
    sortView.delegate = self;
    sortView.sortingParameter =parameter;
    sortView.sortType = type;
    [popover presentPopoverFromRect:CGRectMake(xAxis, 9, width, 32) inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES]; 
}

-(void)sortClicked:(BOOL)descending withSortingParameter:(NSString *)parameter withType:(AFESortDirection)type{
    
    currentSortDirection = type;
    currentSortParamater = parameter;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(getWellAFETableSort:forPage:sortByField:andSortOrder:withRecordLimit:)]){
            // [self.delegate getWellAFETableSort:self sortByField:parameter andSortOrder:descending withRecordLimit:50];
        [self.delegate getWellAFETableSort:self forPage:1 sortByField:currentSortParamater andSortOrder:currentSortDirection withRecordLimit:50];
    }
  [popover dismissPopoverAnimated:YES];
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
    
    
    if (scrollView.contentOffset.y > (scrollView.contentSize.height + REFRESH_HEADER_HEIGHT)-wellTableView.frame.size.width ) {
        
        [self setRefreshLoadingBottom:RefreshStop];
        
        [self getNextPageFromService];
        
    } 
    
}


-(void)setRefreshLoading:(RefreshState)refreshState{
    
    if(RefreshLoading== refreshState){
        
        isLoading=YES;
        
        wellTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        
    }
    
    else if(refreshState == RefreshStop){
        
        isLoading=NO;
        
        wellTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
    
    [reloadInTableViewForPreviousPage setState:refreshState];
    
}


-(void)setRefreshLoadingBottom:(RefreshState)refreshState{
    
    if(RefreshLoading== refreshState){
        
        isLoading=YES;
        
        wellTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        
    }
    
    else if(refreshState == RefreshStop){
        
        isLoading=NO;
        
        wellTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
    
    [reloadInTableViewForNextPage setState:refreshState];
    
}



-(void) getPreviousPageFromService
{
    if(currentPageShown > 1)
        {
        if(self.delegate && [self.delegate respondsToSelector:@selector(getWellAFETableSort:forPage:sortByField:andSortOrder:withRecordLimit:)])
            {
            [self.delegate getWellAFETableSort:self forPage:currentPageShown+1 sortByField:currentSortParamater andSortOrder:currentSortDirection withRecordLimit:50];
            
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
        if(self.delegate && [self.delegate respondsToSelector:@selector(getWellAFETableSort:forPage:sortByField:andSortOrder:withRecordLimit:)])
            {
            [self.delegate getWellAFETableSort:self forPage:currentPageShown+1 sortByField:currentSortParamater andSortOrder:currentSortDirection withRecordLimit:50];
            
            }  
        }
    else
        {
        NSLog(@"You are on last Page.");
        }
}


-(void) dealloc
{
    self.wellTableView = nil;
    self.wellDetailArray = nil;
}



@end
