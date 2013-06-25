//
//  AFEBurndownTableView.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 21/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFEBurndownTableView.h"
#import "AFESearchBurnDownTableViewCell.h"
#import "AFEBurnDownItem.h"

#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW CGRectMake(0,0,450,505)

@interface AFEBurndownTableView ()
{
    UIView *popOverView;
    UIPopoverController *popover;
    NSArray *sortingParameterTypeArrays;
    NSString *typeOfParameter;
    
    UIActivityIndicatorView *activityIndicView;
    UIView *activityIndicContainerView;
    UIView *activityIndicBGView;
    UILabel *messageLabel;
    
    int currentPageShown;
    int totalNoPagesAvailable;
    int totalRecordsAvaialable;
    
    NSString *currentSortParamater;
    AFESortDirection currentSortDirection;
    
    BOOL isLoading;
    BOOL isDragging;
    ReloadInTableView *reloadInTableViewForPreviousPage;
    ReloadInTableView *reloadInTableViewForNextPage;
    
    int totalPageCount_InvoiceDetailTable;
    //    int totalRecordCount_InvoiceDetailTable;
    int newPageNumber_InvoiceDetailTable;
    int curntRecordNmbr;


}

@end

@implementation AFEBurndownTableView

@synthesize delegate, afeBurnDownTable, noOfPagesLabel, afeBurnDownItemArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) awakeFromNib{
    UIFont *font = FONT_HEADLINE_TITLE;
    font = [font fontWithSize:font.pointSize-1];
    
    self.afeBurnDownTable.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.75].CGColor;
    self.afeBurnDownTable.layer.borderWidth = 1.0f;
    self.afeBurnDownTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    sortingParameterTypeArrays = [[NSArray  alloc]initWithObjects:@"date",@"actual",@"fieldEstimate",@"actualPlusAccrual", nil];
    
    [serviceMonthHeaderLabel setFont:font];
    [actualsHeaderLabel setFont:font]; 
    [accrualsHeaderLabel setFont:font];
    [totalHeaderLabel setFont:font];

    [serviceMonthHeaderLabel setTextColor:COLOR_HEADER_TITLE];
    [actualsHeaderLabel setTextColor:COLOR_HEADER_TITLE]; 
    [accrualsHeaderLabel setTextColor:COLOR_HEADER_TITLE];
    [totalHeaderLabel setTextColor:COLOR_HEADER_TITLE];
    
    //Paging parameters
    currentSortParamater = SORTFIELD_Total;
    currentPageShown = 1;
    currentSortDirection = AFESortDirectionAscending;
    
    newPageNumber_InvoiceDetailTable = 1;
    totalPageCount_InvoiceDetailTable = 1;
    //    totalRecordCount_InvoiceDetailTable = 1;
    
    self.noOfPagesLabel.font = [UIFont fontWithName:COMMON_FONTNAME_NORMAL size:11.5];
}

-(void)refreshWithAfeBurnDownItemArray:(NSArray *)afeBurndownItemArray forPage:(int) page ofTotalPages:(int) totalPages andTotalRecordCount:(int) totalRecordCount
{
    currentPageShown = page;
    totalNoPagesAvailable = totalPages;
    
  /*  if(currentPageShown == 1)
        curntRecordNmbr = 0;
    
    self.noOfPagesLabel.text = [NSString stringWithFormat:@"Displaying %d - %d of %d",curntRecordNmbr + 1, curntRecordNmbr + [afeBurndownItemArray count],totalRecordCount_InvoiceDetailTable];
    
    curntRecordNmbr+=[afeBillingCategoryArray count];
    if(curntRecordNmbr >totalRecordCount_InvoiceDetailTable)
        curntRecordNmbr = [afeBillingCategoryArray count];
    
    self.afeBillingCategoryDetailArray = afeBillingCategoryArray;
    [self.afeBillingCategoryTableView reloadData];
    
    [self initializePaginationViewsInTable:afeBillingCategoryTableView];
    
    //deciding if next page view needs to be shown when pulling.
    if(currentPageShown < totalNoPagesAvailable)
    {
        [reloadInTableViewForNextPage removeFromSuperview];
        [afeBillingCategoryTableView addSubview:reloadInTableViewForNextPage];
    }
    else
        [reloadInTableViewForNextPage removeFromSuperview];
    
    
    //deciding if previous page view needs to be shown when pulling.
    if(currentPageShown > 1 )
    {
        [reloadInTableViewForPreviousPage removeFromSuperview];
        [afeBurnDownTable addSubview:reloadInTableViewForPreviousPage];
    }
    else
        [reloadInTableViewForPreviousPage removeFromSuperview];
    
    */
    
    self.afeBurnDownItemArray = afeBurndownItemArray;
    
    [self.afeBurnDownTable reloadData];

}

#pragma mark - Sorting View

-(IBAction) dropDownButtonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    [self showPopOverWithXAxis:button.frame.origin.x andWithWidth:button.frame.size.width withSortingParameter:[sortingParameterTypeArrays objectAtIndex:button.tag-12] withType:0];
    
}

-(void) showPopOverWithXAxis:(int)xAxis andWithWidth:(int)width withSortingParameter:(NSString *)parameter withType:(AFESortDirection)type{   
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

-(void) sortClicked:(BOOL)descending withSortingParameter:(NSString *)parameter withType:(AFESortDirection)type{
    currentSortDirection = type;
    currentSortParamater = parameter;
    
//    if(self.delegate && [self.delegate respondsToSelector:@selector(getBillingCategoryTableSort:forPage:sortByField:andSortOrder:withRecordLimit:)])
//    {
//        [self.delegate getBillingCategoryTableSort:self forPage:1 sortByField:currentSortParamater andSortOrder:type withRecordLimit:100];
//    }
    
    if(self.afeBurnDownItemArray && self.afeBurnDownItemArray.count > 0)
    {
        NSSortDescriptor *tempDescriptor = [[NSSortDescriptor alloc] initWithKey:parameter ascending:(type==AFESortDirectionAscending)? YES:NO];
        
        self.afeBurnDownItemArray = [self.afeBurnDownItemArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:tempDescriptor]];
        
        [self.afeBurnDownTable reloadData];
    }
    
    [popover dismissPopoverAnimated:YES];
}



#pragma mark - Activity Indicator View
-(void) showActivityIndicatorOverlayView{
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

-(void) removeActivityIndicatorOverlayView{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(activityIndicView)
        [activityIndicView stopAnimating];
    
}

-(void) showMessageOnView:(NSString*) message{
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
    messageLabel.textColor = [UIColor redColor];
    messageLabel.backgroundColor= [UIColor clearColor];
    messageLabel.text = message? message:@"";
    messageLabel.textAlignment = UITextAlignmentCenter;
    
    [activityIndicContainerView addSubview:activityIndicBGView];
    [activityIndicContainerView addSubview:messageLabel];
    [self addSubview:activityIndicContainerView];
    
}

-(void) hideMessageOnView{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(messageLabel)
        messageLabel.text = @"";
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.afeBurnDownItemArray? [self.afeBurnDownItemArray count]:0;
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AFESearchBurnDownTableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[AFESearchBurnDownTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    AFEBurnDownItem  *tempInvoiceObject = (AFEBurnDownItem *) [afeBurnDownItemArray objectAtIndex:indexPath.row];
    if (YES) 
    {       
        
        cell.serviceMonthLabel.text  = tempInvoiceObject.date? [NSString stringWithFormat:@"%@ %@",[Utility getMonthNameFromDate:tempInvoiceObject.date], [Utility getYearInShortFormatFromDate:tempInvoiceObject.date]]:@"";
        cell.actualsLabel.text  = tempInvoiceObject.actualsAsStr? tempInvoiceObject.actualsAsStr:@"";
        cell.accrualsLabel.text = tempInvoiceObject.fieldEstimateAsStr? tempInvoiceObject.fieldEstimateAsStr:@"";
        cell.totalsLabel.text = tempInvoiceObject.actualPlusAccrualAsString? tempInvoiceObject.actualPlusAccrualAsString:@"";
       
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
