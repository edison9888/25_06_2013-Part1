//
//  AFEClassesTableView.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFEClassesTableView.h"
#import "AFEClassesCustomCell.h"

#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW CGRectMake(0,46,599,444)

@interface AFEClassesTableView ()
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
    NSIndexPath *myIP;
    NSIndexPath *myIPUP;

}
-(IBAction)dropDownButtonClick:(UIButton*)sender;
@property(nonatomic, strong) NSArray *afeClassesArray;

@end

@implementation AFEClassesTableView
@synthesize afeClassesArray,delegate,afeClassesTableView;
@synthesize highlightedRow;

-(id) initWithFrame:(CGRect)frame{
    self = (AFEClassesTableView*) [[[NSBundle mainBundle] loadNibNamed:@"AFEClassesTableView" owner:self options:nil] lastObject];
    if (self) {
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
        
        currentSortParamater = SORTFIELD_AFEEstimate;
        currentSortDirection = AFESortDirectionDescending;
    
        [self initializePaginationViewsInTable:afeClassesTableView];
    }
    return self;
}

-(void) refreshTableWithAFEClassesArray:(NSArray*) afeClassesArrayToUse forPage:(int) page ofTotalPages:(int) totalPages andTotalRecords:(int) totalRecords{
    
    
    currentPageShown = page;
    totalNoPagesAvailable = totalPages;
    self.afeClassesArray = afeClassesArrayToUse;
    
    sortingParameterTypeArrays = [[NSArray  alloc]initWithObjects:SORTFIELD_Class,SORTFIELD_NumberOfAFES,SORTFIELD_AFEEstimate,SORTFIELD_Actual,SORTFIELD_Accrual,SORTFIELD_Total, nil];
    parameterType = [[NSArray alloc]initWithObjects:@"castString",@"castString",@"castInt",@"castInt",@"castInt",@"castInt", nil];
    
    [classHeaderLabel setFont:FONT_TABLEVIEWCELL];
    [noOfAFEsHeaderLabel setFont:FONT_TABLEVIEWCELL];
    [afeBudgetHeaderLabel setFont:FONT_TABLEVIEWCELL];
    [afeFieldEstimateHeaderLabel setFont:FONT_TABLEVIEWCELL];
    [afeActualsHeaderLabel setFont:FONT_TABLEVIEWCELL];
    [afeTotalLabel setFont:FONT_TABLEVIEWCELL];
    
    [afeClassesTableView reloadData];
    self.afeClassesTableView.allowsMultipleSelection = NO;
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = self.afeClassesArray? self.afeClassesArray.count:0;
    
    return (count<=8)? 8: count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AFEClassesCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AFEClassesCustomCell"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AFEClassesCustomCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        if([topLevelObjects count])
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    if(indexPath.row < self.afeClassesArray.count)
    {
        AFEClass *tempAFEClass = [self.afeClassesArray objectAtIndex:indexPath.row];
        
        if(tempAFEClass)
        {
            cell.afeClassObject = tempAFEClass;
            cell.classLbl.text = tempAFEClass.afeClassName;
            cell.noOfAFELbl.text = [NSString stringWithFormat:@"%@",[Utility formatNumber:[NSString stringWithFormat:@"%d",tempAFEClass.afeCount]]];
            cell.budgetLbl.text = [NSString stringWithFormat:@"%@",tempAFEClass.budgetAsStr];
            cell.actualLbl.text = [NSString stringWithFormat:@"%@",tempAFEClass.totalActualsAsStr];
            cell.fieldEstmtLbl.text = [NSString stringWithFormat:@"%@",tempAFEClass.fieldEstimateAsStr];
            cell.totalLbl.text = [NSString stringWithFormat:@"%@",tempAFEClass.actualsPlusAccrualsASsStr];
            cell.fieldEstmtLbl.text = [NSString stringWithFormat:@"%@",tempAFEClass.fieldEstimateAsStr];  
            cell.delegate = self;
            cell.afeButton.hidden = NO;
            if([tempAFEClass.afeClassID isEqualToString:highlightedRow]){
                    cell.cellBKgrndImage.image =[UIImage imageNamed:@"topBarSelected.png"];
                    //[afeClassesTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                myIPUP = indexPath;
                NSLog(@"high row : %@",highlightedRow);
                NSLog(@"high row indexath :%d",indexPath.row);
            }
            
        }
    }
    else
    {
        cell.afeClassObject = nil;
        cell.classLbl.text = @"";
        cell.noOfAFELbl.text = @"";
        cell.budgetLbl.text = @"";
        cell.actualLbl.text = @"";
        cell.fieldEstmtLbl.text = @"";
        cell.totalLbl.text = @"";
        cell.fieldEstmtLbl.text = @"";  
        cell.delegate = self;
        cell.afeButton.hidden = YES;
    }
    if(indexPath.row == [self.afeClassesArray count])
        myIP = indexPath;
       
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
-(void)tableviewScrollup{
   
        // NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndex:[self.afeClassesArray count]];
        //if(myIPUP.row > 7)
//        AFEClassesCustomCell *tmpCell = (AFEClassesCustomCell*)[afeClassesTableView cellForRowAtIndexPath:myIPUP];
//       NSIndexPath *tempPath = [afeClassesTableView indexPathForCell:tmpCell];
        // if(!tempPath)
        // if (![self.afeClassesTableView.indexPathsForVisibleRows containsObject:myIPUP]) {
    
//    CGRect cellRect = [afeClassesTableView rectForRowAtIndexPath:myIPUP];
//    cellRect = [afeClassesTableView convertRect:cellRect toView:afeClassesTableView.superview];
//    BOOL completelyVisible = CGRectContainsRect(afeClassesTableView.frame, cellRect);
//    if(!completelyVisible)
    [afeClassesTableView scrollToRowAtIndexPath:myIPUP atScrollPosition:UITableViewScrollPositionTop animated:YES];//}

//    AFEClassesCustomCell *tmpCell = (AFEClassesCustomCell*)[afeClassesTableView cellForRowAtIndexPath:myIPUP];
//    tmpCell.cellBKgrndImage.image =[UIImage imageNamed:@"LegendRedBar2.png"];
//    
        // cell.cellBKgrndImage.image =[UIImage imageNamed:@"LegendRedBar2.png"];
        // NSArray *indexPathArray = [[NSArray alloc] initWithObjects:myIPUP,nil];
        // [afeClassesTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void)tableviewScrollDown{
        // NSIndexPath *myIP = [[NSIndexPath alloc] indexPathForRow:0 inSection:0];

        // NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndex:[self.afeClassesArray count]];
    [afeClassesTableView scrollToRowAtIndexPath:myIP atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
#pragma mark - table view delegate methods
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(afeClassesArray && (indexPath.row < afeClassesArray.count) && self.delegate && [self.delegate respondsToSelector:@selector(didSelectAFEClassObjectForMoreDetais:OnAFEClassesTableView:)])
    {
        [self.delegate didSelectAFEClassObjectForMoreDetais:(AFEClass*)[self.afeClassesArray objectAtIndex:indexPath.row] OnAFEClassesTableView:self];
    }
}

//Drop Down Button Action
-(IBAction)dropDownButtonClick:(UIButton*)sender{
        //UIButton *button = (UIButton *)sender;
    if([self.afeClassesArray count]){typeOfParameter = [parameterType objectAtIndex:sender.tag-12];
        
        if ([typeOfParameter isEqualToString:@"castInt"]) 
            {
            [self showPopOverWithXAxis:sender.frame.origin.x withSortingParameter:[sortingParameterTypeArrays objectAtIndex:sender.tag-12] withType:castInt];
            }
        else if([typeOfParameter isEqualToString:@"castString"])
            {
            [self showPopOverWithXAxis:sender.frame.origin.x withSortingParameter:[sortingParameterTypeArrays objectAtIndex:sender.tag-12] withType:castString];
            }
    }
}

-(void)showPopOverWithXAxis:(int)xAxis withSortingParameter:(NSString *)parameter withType:(typeCastType)type{
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
    [popover presentPopoverFromRect:CGRectMake(xAxis, 5, 75, 32) inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES]; 
}

-(void)sortClicked:(BOOL)descending withSortingParameter:(NSString *)parameter withType:(AFESortDirection)type{
    currentSortParamater = parameter;
    currentSortDirection = type;
        // self.highlightedRow =@"";
    if(self.delegate && [self.delegate respondsToSelector:@selector(getAFEClassesForAFEClassesTableView:forPage:sortByField:andSortOrder:withRecordLimit:)])
    {
        [self.delegate getAFEClassesForAFEClassesTableView:self forPage:1 sortByField:parameter andSortOrder:type withRecordLimit:50];
    }

    [popover dismissPopoverAnimated:YES];
}

#pragma mark -  CustomCell Delegate
-(void) didSelectAFEClass:(AFEClass*) afeClassSelected onCell:(AFEClassesCustomCell*) cell{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectAFEClassObjectForMoreDetais:OnAFEClassesTableView:)])
    {
        [self.delegate didSelectAFEClassObjectForMoreDetais:afeClassSelected OnAFEClassesTableView:self];
    }
    //NSLog(@"Delegate from AFEClassesCustomCell");
}

#pragma mark - Table Pagination methods
-(void) initializePaginationViewsInTable:(UITableView*) tableView{
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

-(void) getPreviousPageFromService{
    if(currentPageShown > 1)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(getAFEClassesForAFEClassesTableView:forPage:sortByField:andSortOrder:withRecordLimit:)])
        {
            [self.delegate getAFEClassesForAFEClassesTableView:self forPage:currentPageShown-1 sortByField:currentSortParamater andSortOrder:currentSortDirection withRecordLimit:50];
        }
        
    }
      
}

-(void) getNextPageFromService{
    if(currentPageShown < totalNoPagesAvailable)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(getAFEClassesForAFEClassesTableView:forPage:sortByField:andSortOrder:withRecordLimit:)])
        {
            [self.delegate getAFEClassesForAFEClassesTableView:self forPage:currentPageShown+1 sortByField:currentSortParamater andSortOrder:currentSortDirection withRecordLimit:50];
        }
        
    }
    
}

#pragma mark - Previous Button Clicked

-(void) dealloc{
    self.afeClassesArray = nil;
    self.delegate = nil;
}

@end
