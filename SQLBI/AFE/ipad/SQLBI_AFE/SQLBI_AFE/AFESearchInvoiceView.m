//
//  AFESearchInvoiceView.m
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 12/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFESearchInvoiceView.h"
#import "AFEInvoice.h"
#import "SortingView.h"

#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW CGRectMake(0,1,951,510)

@interface AFESearchInvoiceView()
{
    
    UIView *popOverView;
    UIPopoverController *popover;
    NSArray *sortingParameterTypeArrays;
    
    NSDate *startDate;
    NSDate *endDate;
    
    UIActivityIndicatorView *activityIndicView;
    UIView *activityIndicContainerView;
    UIView *activityIndicBGView;
    UILabel *messageLabel;
    
    int currentPageShown;
    int totalNoPagesAvailable;
    
    NSString *currentSortParamater;
    AFESortDirection currentSortDirection;
    
    BOOL isLoading;
    BOOL isDragging;
    ReloadInTableView *reloadInTableViewForPreviousPage;
    ReloadInTableView *reloadInTableViewForNextPage;
}

@property(nonatomic,strong)AFESearchAPIHandler *afeSearchAPIHandlerObj;
@property(nonatomic,strong)NSMutableArray *apiRequestInfoObjectArray;
@end

@implementation AFESearchInvoiceView
@synthesize afeInvoiceTableView;
@synthesize afeArray;
@synthesize afeInvoiceDetailArray;
@synthesize afeSearchAPIHandlerObj;
@synthesize apiRequestInfoObjectArray;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib{
    self.afeInvoiceTableView.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.75].CGColor;
    self.afeInvoiceTableView.layer.borderWidth = 1.0f;
    
    UIFont *font = FONT_HEADLINE_TITLE;
    font = [font fontWithSize:font.pointSize-1];//13
    [invoiceNoHeaderLabel setFont:font]; 
    [billingCategoryHeaderLabel setFont:font];
    [invoiceDateHeaderLabel setFont:font];
    [invoiceAmountHeaderLabel setFont:font];
    [propertyNameHeaderLabel setFont:font]; 
    [propertyTypeHeaderLabel setFont:font];
    [serviceDateHeaderLabel setFont:font];
    [acctlingDateHeaderLabel setFont:font]; 
    [vendorNameHeaderLabel setFont:font];
           
    [invoiceNoHeaderLabel setTextColor:COLOR_HEADER_TITLE]; 
    [billingCategoryHeaderLabel setTextColor:COLOR_HEADER_TITLE];
    [invoiceDateHeaderLabel setTextColor:COLOR_HEADER_TITLE];
    [invoiceAmountHeaderLabel setTextColor:COLOR_HEADER_TITLE];
    [propertyNameHeaderLabel setTextColor:COLOR_HEADER_TITLE]; 
    [propertyTypeHeaderLabel setTextColor:COLOR_HEADER_TITLE];
    [serviceDateHeaderLabel setTextColor:COLOR_HEADER_TITLE];
    [acctlingDateHeaderLabel setTextColor:COLOR_HEADER_TITLE]; 
    [vendorNameHeaderLabel setTextColor:COLOR_HEADER_TITLE];
    
    sortingParameterTypeArrays = [[NSArray  alloc]initWithObjects:SORTFIELD_InvoiceNumber,SORTFIELD_BillingCategoryName,SORTFIELD_InvoiceDate,SORTFIELD_AFEInvoiceAmount,SORTFIELD_PropertyName,SORTFIELD_PropertyType,SORTFIELD_ServiceDate,SORTFIELD_Accrual,SORTFIELD_AccountingDate,SORTFIELD_VendorName, nil];
    
    currentSortParamater = SORTFIELD_GrossExpense;
    currentPageShown = 1;
    currentSortDirection = AFESortDirectionAscending;
    
}

#pragma mark - Refresh Method
-(void)getAfeSearchInvoiceArray:(NSArray *)afeInvoiceArray forPage:(int) page ofTotalPages:(int) totalPages{
    
    currentPageShown = page;
    
    totalNoPagesAvailable = totalPages;
    self.afeInvoiceDetailArray = afeInvoiceArray;
    [self.afeInvoiceTableView reloadData];
    
    [self initializePaginationViewsInTable:afeInvoiceTableView];
    
    //deciding if next page view needs to be shown when pulling.
    if(currentPageShown < totalNoPagesAvailable)
    {
        [reloadInTableViewForNextPage removeFromSuperview];
        [afeInvoiceTableView addSubview:reloadInTableViewForNextPage];
    }
    else
        [reloadInTableViewForNextPage removeFromSuperview];
    
    
    //deciding if previous page view needs to be shown when pulling.
    if(currentPageShown > 1 )
    {
        [reloadInTableViewForPreviousPage removeFromSuperview];
        [afeInvoiceTableView addSubview:reloadInTableViewForPreviousPage];
    }
    else
        [reloadInTableViewForPreviousPage removeFromSuperview];

}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    return [afeInvoiceDetailArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    AFESearchCustomTableViewInvoiceCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[AFESearchCustomTableViewInvoiceCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    AFEInvoice *tempInvoiceObject = [afeInvoiceDetailArray objectAtIndex:indexPath.row];
    if (tempInvoiceObject) 
    {
        cell.invoiceNoLabel.text        = tempInvoiceObject.invoiceNumber;
        cell.billingCategoryLabel.text  = tempInvoiceObject.billingCategory;
        cell.invoiceDateLabel.text      = [NSString stringWithFormat:@"%@",tempInvoiceObject.invoiceDate];
        cell.invoiceAmountLabel.text    = tempInvoiceObject.invoiceAmountAsStr;
        cell.propertyNameLabel.text     = tempInvoiceObject.propertyName;
        cell.propertyTypeLabel.text     = tempInvoiceObject.propertyType;
        cell.serviceDateLabel.text      = [NSString stringWithFormat:@"%@",tempInvoiceObject.serviceDate];
        cell.acctlingDateLabel.text     = [NSString stringWithFormat:@"%@",tempInvoiceObject.accountingDate];
        cell.vendorNameLabel.text       = tempInvoiceObject.vendorName;
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Sort Popover View
-(IBAction)dropDownButtonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    [self showPopOverWithXAxis:button.frame.origin.x withSortingParameter:[sortingParameterTypeArrays objectAtIndex:button.tag-12] withType:castDate];
}

-(void)showPopOverWithXAxis:(int)xAxis withSortingParameter:(NSString *)parameter withType:(typeCastType)type{   
    SortingView * sortView = [[SortingView alloc] initWithNibName:@"SortingView" bundle:nil];
    popover = [[UIPopoverController alloc] initWithContentViewController:sortView];    
    popover.popoverContentSize =CGSizeMake(165.0, 106.0);
    sortView.sortingParameter =parameter;
    sortView.sortType = type;
    [popover setDelegate:self];    
    sortView.delegate = self;
     
    [popover presentPopoverFromRect:CGRectMake(xAxis, 9, 88, 32) inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES]; 
}

-(void)sortClicked:(BOOL)descending withSortingParameter:(NSString *)parameter withType:(AFESortDirection)type{
    currentSortDirection = type;
    currentSortParamater = parameter;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(getInvoiceTableSort:forPage:sortByField:andSortOrder:withRecordLimit:)])
    {
        [self.delegate getInvoiceTableSort:self forPage:1 sortByField:currentSortParamater andSortOrder:type withRecordLimit:50];
    }
    [popover dismissPopoverAnimated:YES];
}

#pragma mark - Activity Indicator
-(void)showActivityIndicatorOverlayView{
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

-(void)removeActivityIndicatorOverlayView{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(activityIndicView)
        [activityIndicView stopAnimating];
    
}

-(void)showMessageOnView:(NSString*) message{
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

-(void)hideMessageOnView{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(messageLabel)
        messageLabel.text = @"";
}

#pragma mark - Table Pagination methods
-(void)initializePaginationViewsInTable:(UITableView*) tableView{
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

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (isLoading) return;
    
    isDragging = YES;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
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

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
    if (isLoading) return;
    
    isDragging = NO;
    
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {        
        
        [self setRefreshLoading:RefreshStop];
        
        [self getPreviousPageFromService];
        
    }
    
    
    if (scrollView.contentOffset.y > (scrollView.contentSize.height - afeInvoiceTableView.frame.size.height)+ REFRESH_HEADER_HEIGHT) {
        
        [self setRefreshLoadingBottom:RefreshStop];
        
        [self getNextPageFromService];
        
    } 
    
}

-(void)setRefreshLoading:(RefreshState)refreshState{
    
    if(RefreshLoading== refreshState){
        
        isLoading=YES;
        
        afeInvoiceTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        
    }
    
    else if(refreshState == RefreshStop){
        
        isLoading=NO;
        
        afeInvoiceTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
    
    [reloadInTableViewForPreviousPage setState:refreshState];
    
}

-(void)setRefreshLoadingBottom:(RefreshState)refreshState{
    
    if(RefreshLoading== refreshState){
        
        isLoading=YES;
        
        afeInvoiceTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        
    }
    
    else if(refreshState == RefreshStop){
        
        isLoading=NO;
        
        afeInvoiceTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
    
    [reloadInTableViewForNextPage setState:refreshState];
    
}

-(void)getPreviousPageFromService{
    if(currentPageShown > 1)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(getInvoiceTableSort:forPage:sortByField:andSortOrder:withRecordLimit:)])
        {
            [self.delegate getInvoiceTableSort:self forPage:currentPageShown-1 sortByField:currentSortParamater andSortOrder:currentSortDirection withRecordLimit:50];
        }
        
    }
    else
    {
        NSLog(@"You are on first page");
    }
    
}

-(void)getNextPageFromService{
    if(currentPageShown < totalNoPagesAvailable)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(getInvoiceTableSort:forPage:sortByField:andSortOrder:withRecordLimit:)])
        {
            [self.delegate getInvoiceTableSort:self forPage:currentPageShown+1 sortByField:currentSortParamater andSortOrder:currentSortDirection withRecordLimit:50];
        } 
    }
    else
    {
        NSLog(@"You are on last Page.");
    }
}

@end
