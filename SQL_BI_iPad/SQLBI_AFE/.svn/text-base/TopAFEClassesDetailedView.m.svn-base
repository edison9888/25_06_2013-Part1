//
//  TopAFEClassesDetailedView.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopAFEClassesDetailedView.h"
#import "AFEClass.h"
#import "ScrubberView.h"
#import "AFEClassesTableView.h"

#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW_PieChart CGRectMake(18,122,310,313)

@interface TopAFEClassesDetailedView (){
    NSDate *startDate;
    NSDate *endDate;
    ScrubberView *scrubberView;
    AFEClassesTableView *afeClassesTableView;
    UIView *scrubberContainerView;
    UILabel *classNameLabel;
    
    UIActivityIndicatorView *activityIndicView;
    UIView *activityIndicContainerView;
    UIView *activityIndicBGView;
    UILabel *messageLabel;
    
    
    int currentPageShown;
    int totalNoPagesAvailable;
    int totalRecordsAvailable;
    int currentRecordCount;
    NSMutableArray *pieChartIds;

}

@property (strong, nonatomic) IBOutlet UILabel *recordCountLabel;
@property (strong, nonatomic) IBOutlet UIButton *budgetButton;
@property (strong, nonatomic) IBOutlet UIButton *noOFAFEsButton;
@property (nonatomic,strong) IBOutlet XYPieChart *pieChart;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;
@property(nonatomic, strong) NSMutableArray *afeClassesArray_Table;
@property(nonatomic, strong) NSMutableArray *afeClassesArray_PieChart;
@property(nonatomic, assign) BOOL IsNoOfAFesButtonClicked;
@property (strong, nonatomic) IBOutlet UIImageView *iconOrange;
@property (strong, nonatomic) IBOutlet UIImageView *iconGreen;
@property (strong, nonatomic) IBOutlet UIImageView *iconBlue;
@property (strong, nonatomic) IBOutlet UIImageView *iconRed;
@property (strong, nonatomic) IBOutlet UIImageView *iconGray;


-(void)drawPieChart;
- (IBAction)budgetButtonTouched:(id)sender;
- (IBAction)noOfAFEsButtonTouched:(id)sender;

@end

@implementation TopAFEClassesDetailedView
@synthesize iconOrange;
@synthesize iconGreen;
@synthesize iconBlue;
@synthesize iconRed;
@synthesize iconGray;

@synthesize swipeDelegate;
@synthesize pieChart,slices,sliceColors;
@synthesize budgetButton;
@synthesize noOFAFEsButton;
@synthesize afeClassesArray_Table, afeClassesArray_PieChart;
@synthesize IsNoOfAFesButtonClicked, delegate;
@synthesize recordCountLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = (TopAFEClassesDetailedView *) [[[NSBundle mainBundle] loadNibNamed:@"TopAFEClassesDetailedView" owner:self options:nil] lastObject];
    if (self) {
            // Initialization code
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
        [self createAFEClassesTableView];
            //  [self.budgetButton setSelected:YES];
            //  [self.budgetButton setUserInteractionEnabled:NO];
        
    }
    return self;
}


-(void) awakeFromNib
{
    self.recordCountLabel.text = @"";
    self.recordCountLabel.font = [UIFont fontWithName:COMMON_FONTNAME_NORMAL size:11.5];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"SET_DOLAR"];
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"SET_DOLAR"]){
        IsNoOfAFesButtonClicked =YES;
        [self.noOFAFEsButton setSelected:YES];
        [self.budgetButton setSelected:NO];
        [self.noOFAFEsButton setUserInteractionEnabled:NO];
        [self.budgetButton setUserInteractionEnabled:YES];


    }
    else {
        IsNoOfAFesButtonClicked = NO;
        [self.budgetButton setSelected:YES];
        [self.noOFAFEsButton setSelected:NO];
        [self.noOFAFEsButton setUserInteractionEnabled:YES];
        [self.budgetButton setUserInteractionEnabled:NO];


    }
    
}

-(void) refreshDataWithAFEClassesArray:(NSArray*) afeClassesArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end{
    
    self.slices = [[NSMutableArray alloc] init];
    startDate = start;
    endDate = end;
    self.afeClassesArray_Table = (NSMutableArray*) afeClassesArrayToUse;

    [self createAFEClassesTableView];
    [self setCustomFontForButton:self.budgetButton];
    [self setCustomFontForButton:self.noOFAFEsButton];
        // [self.budgetButton setSelected:YES];
    
    
        //IsNoOfAFesButtonClicked = NO;
        //[self budgetButtonTouched:self.budgetButton];
    
        // [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"SET_DOLAR"];
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"SET_DOLAR"]){
        IsNoOfAFesButtonClicked =YES;
        [self.noOFAFEsButton setSelected:YES];
        [self.budgetButton setSelected:NO];
        [self.noOFAFEsButton setUserInteractionEnabled:NO];
        [self.budgetButton setUserInteractionEnabled:YES];
    }
    else {
        IsNoOfAFesButtonClicked = NO;
        [self.budgetButton setSelected:YES];
        [self.noOFAFEsButton setSelected:NO];
        [self.noOFAFEsButton setUserInteractionEnabled:YES];
        [self.budgetButton setUserInteractionEnabled:NO];
    }

    
    [Utility removeLeftSwipeGestureFromViewsRecursively:self];
    [Utility removeRightSwipeGestureFromViewsRecursively:self];
    [Utility addLeftSwipeGestureToViewsRecursively:self targetDelegate:self handleSelector:@selector(handleSwipeFrom:)];
    [Utility addRightSwipeGestureToViewsRecursively:self targetDelegate:self handleSelector:@selector(handleSwipeFrom:)];
    [Utility removeLeftSwipeGestureFromViewsRecursively:scrubberContainerView];
    [Utility removeRightSwipeGestureFromViewsRecursively:scrubberContainerView];
    
}

-(void) refreshTableWithAFEClassesArray:(NSArray*) afeClassesArrayToUse forPage:(int) page ofTotalPages:(int) totalPages andTotalRecords:(int) totalRecords andStartDate:(NSDate*) start andEndDate:(NSDate*) end
{
    if(page <= currentPageShown)
        currentRecordCount = currentRecordCount - (50 + self.afeClassesArray_Table.count);
    
    startDate = start;
    endDate = end;
    self.afeClassesArray_Table = (NSMutableArray*) afeClassesArrayToUse;
    currentPageShown = page;
    totalNoPagesAvailable = totalPages;
    totalRecordsAvailable = totalRecords;
    
    if(currentPageShown <= 1)
        currentRecordCount = 0;
    
    if(self.afeClassesArray_Table && self.afeClassesArray_Table.count > 0)
    {
        self.recordCountLabel.text = [NSString stringWithFormat:@"Displaying %d - %d of %d",currentRecordCount + 1, currentRecordCount + [self.afeClassesArray_Table count],totalRecords];
    }
    else
        self.recordCountLabel.text = @"";
    
    currentRecordCount += self.afeClassesArray_Table.count;
    
    [self createAFEClassesTableView];
    [self setCustomFontForButton:self.budgetButton];
    [self setCustomFontForButton:self.noOFAFEsButton];
    
    
    if(self.recordCountLabel)
    {
        [self.recordCountLabel removeFromSuperview];
        [self addSubview:self.recordCountLabel];
        self.recordCountLabel.hidden = NO;
    }
    
    [Utility removeLeftSwipeGestureFromViewsRecursively:self];
    [Utility removeRightSwipeGestureFromViewsRecursively:self];
    [Utility addLeftSwipeGestureToViewsRecursively:self targetDelegate:self handleSelector:@selector(handleSwipeFrom:)];
    [Utility addRightSwipeGestureToViewsRecursively:self targetDelegate:self handleSelector:@selector(handleSwipeFrom:)];
    [Utility removeLeftSwipeGestureFromViewsRecursively:scrubberContainerView];
    [Utility removeRightSwipeGestureFromViewsRecursively:scrubberContainerView];

}

-(void) refreshPieChartWithAFEClassesArray:(NSArray*) afeClassesArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end
{
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"SET_DOLAR"]){
        IsNoOfAFesButtonClicked =YES;
        [self.noOFAFEsButton setSelected:YES];
        [self.budgetButton setSelected:NO];
        [self.noOFAFEsButton setUserInteractionEnabled:NO];
        [self.budgetButton setUserInteractionEnabled:YES];
    }
    else {
        IsNoOfAFesButtonClicked = NO;
        [self.budgetButton setSelected:YES];
        [self.noOFAFEsButton setSelected:NO];
        [self.noOFAFEsButton setUserInteractionEnabled:YES];
        [self.budgetButton setUserInteractionEnabled:NO];
    }

    self.slices = [[NSMutableArray alloc] init];
    startDate = start;
    endDate = end;
    pieChartIds = [[NSMutableArray alloc] init];
    self.afeClassesArray_PieChart = (NSMutableArray*) afeClassesArrayToUse;
    [self drawPieChart];
    [self setCustomFontForButton:self.budgetButton];
    [self setCustomFontForButton:self.noOFAFEsButton];

    [Utility removeLeftSwipeGestureFromViewsRecursively:self];
    [Utility removeRightSwipeGestureFromViewsRecursively:self];
    [Utility addLeftSwipeGestureToViewsRecursively:self targetDelegate:self handleSelector:@selector(handleSwipeFrom:)];
    [Utility addRightSwipeGestureToViewsRecursively:self targetDelegate:self handleSelector:@selector(handleSwipeFrom:)];
    [Utility removeLeftSwipeGestureFromViewsRecursively:scrubberContainerView];
    [Utility removeRightSwipeGestureFromViewsRecursively:scrubberContainerView];
    
}

-(void)hideIcons{
    iconOrange.hidden = YES;
    iconGreen.hidden = YES;
    iconBlue.hidden = YES;
    iconRed.hidden = YES;
    iconGray.hidden = YES;
}


-(void) showActivityIndicatorOverlayViewOnPieChart
{
    [self removeActivityIndicatorOverlayViewOnPieChart];
    
    if(!activityIndicView)
    {
        activityIndicView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    else
        [activityIndicView removeFromSuperview];
    
    if(!activityIndicContainerView)
        activityIndicContainerView = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW_PieChart];
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
    activityIndicBGView.layer.cornerRadius = 155;
    activityIndicView.frame = CGRectMake((activityIndicContainerView.frame.size.width-50)/2, (activityIndicContainerView.frame.size.height-50)/2, 50, 50);
    activityIndicView.color = [UIColor darkGrayColor];
    
    [activityIndicContainerView addSubview:activityIndicBGView];
    [activityIndicContainerView addSubview:activityIndicView];
    [self addSubview:activityIndicContainerView];
    
    [activityIndicView startAnimating];
    
}

-(void) removeActivityIndicatorOverlayViewOnPieChart
{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(activityIndicView)
        [activityIndicView stopAnimating];
    
}

-(void) showMessageOnPieChart:(NSString*) message
{
    if(!activityIndicContainerView)
        activityIndicContainerView = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW_PieChart];
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

-(void) hideMessageOnPieChart
{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(messageLabel)
        messageLabel.text = @"";
}


-(void) showActivityIndicatorOverlayViewOnTable
{
    if(afeClassesTableView)
        [afeClassesTableView showActivityIndicatorOverlayView];
}

-(void) removeActivityIndicatorOverlayViewOnTable
{
    if(afeClassesTableView)
        [afeClassesTableView removeActivityIndicatorOverlayView];
}

-(void) showMessageOnTable:(NSString*) message
{
    if(afeClassesTableView)
        [afeClassesTableView showMessageOnView:message];
}

-(void) hideMessageOnTable
{
    if(afeClassesTableView)
        [afeClassesTableView hideMessageOnView];
}


-(void) createAFEClassesTableView
{
    if(!afeClassesTableView)
        afeClassesTableView = [[AFEClassesTableView alloc]initWithFrame:CGRectMake(350, 30, 570, 497)];
    else
        [afeClassesTableView removeFromSuperview];
    
    [self addSubview:afeClassesTableView];
    afeClassesTableView.delegate = self;
    
    [afeClassesTableView refreshTableWithAFEClassesArray:afeClassesArray_Table forPage:currentPageShown ofTotalPages:totalNoPagesAvailable andTotalRecords:totalRecordsAvailable];
}

-(void)drawPieChart{
    afeClassesTableView.highlightedRow = @"";
    [self hideIcons];
    [self setData];
    [self  setPieChartValue];
}

- (void)removeLabelsFromView
{
    for (UILabel *label in self.subviews) {
        if([label isKindOfClass:[UILabel class]])
        {
            if([label respondsToSelector:@selector(removeFromSuperview)])
            {
                [label removeFromSuperview];
            }
        }
    }
}

-(void)setData
{
    if([self.slices count])
        [self.slices removeAllObjects];
    NSSortDescriptor *sortDescriptor; 
    if(IsNoOfAFesButtonClicked){
        
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"afeCount" ascending:NO];
    }
    else {
        
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"budget" ascending:NO];
        
    }
    self.afeClassesArray_PieChart = (NSMutableArray*)[self.afeClassesArray_PieChart sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];   

    NSMutableDictionary *piechartValue = [[NSMutableDictionary alloc] init];
    NSString *piechartKey;
    
    AFEClass *tempAFE = [[AFEClass alloc] init];
    NSNumberFormatter* number_formatter = [[NSNumberFormatter alloc]
                                           init] ;
    NSString* my_string = @"";
    if([self.afeClassesArray_PieChart count]){
        
        int count = [self.afeClassesArray_PieChart count];
        if(4 < count)
            count = 5;
        for(int i = 0; i< count; i++){
            tempAFE = (AFEClass*)[self.afeClassesArray_PieChart objectAtIndex:i];
            NSNumber *num;
            if(IsNoOfAFesButtonClicked){
                my_string = [NSString stringWithFormat:@"%d",tempAFE.afeCount];
                num =  [number_formatter numberFromString:my_string]; 
                piechartKey = [NSString stringWithFormat:@"%@",num];
            }
            else{
                my_string = [NSString stringWithFormat:@"%.7f",tempAFE.budget];
                num =  [number_formatter numberFromString:my_string];
                double tmpVal;
                tmpVal= [num floatValue];
                num = [NSString stringWithFormat:@"%.7f",tmpVal];
                piechartKey = [NSString stringWithFormat:@"%@",num];
                [piechartValue setObject:tempAFE.budgetAsStr forKey:piechartKey];
            }
            [self.slices addObject:num];
            [pieChartIds addObject:tempAFE.afeClassID];
        }
    }
    if([self.slices count]){
        int totalSlice = [self.slices count];
        float total= 0.0;
        for(int i = 0; i< totalSlice; i++){
            NSNumber *value = [self.slices objectAtIndex:i];
            total = total + [value floatValue];
        }
        NSString *totalStr = [NSString stringWithFormat:@"%.7f",total];
        NSNumber *totalValue = [number_formatter numberFromString:totalStr];
        NSMutableArray *tmpSliceArray = [[NSMutableArray alloc] init];
        for(int j = 0; j< totalSlice; j++){
            NSNumber *tmpvalue = [self.slices objectAtIndex:j];
            double tmpVal;
            tmpVal= [tmpvalue floatValue];
            tmpvalue = [NSString stringWithFormat:@"%.7f",tmpVal];
            float percentge = (([tmpvalue floatValue]*100)/[totalValue floatValue]);
            if(percentge > 4){

                [tmpSliceArray addObject:tmpvalue];
              
            }
            else {
                
                if(j < pieChartIds.count)
                    [pieChartIds removeObjectAtIndex:j];
            }
                // [self.slices removeObjectAtIndex:j];
            
            
        }
        self.slices = tmpSliceArray;
            //NSNumber *tmpvalue  = [self.slices objectAtIndex:j];
        
        
        
        
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:piechartValue forKey:@"pieChartValue"];    
    [self removeLabelsFromView];
    if(classNameLabel)
        [classNameLabel removeFromSuperview];
    int xOffSet =  10;
    BOOL shouldCreateSecondLine = NO;
    AFEClass *tempAfe = [[AFEClass alloc] init];
    for (int i = 0; i<[self.slices count]; i++) 
    {
        if(!(xOffSet<=220))
        {
            if(xOffSet == 220+105)
                xOffSet =10;
            shouldCreateSecondLine = YES;
        }
        if(shouldCreateSecondLine)
        {
            classNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(35+xOffSet, 486, 82, 15)];
        }
        else 
        {
            classNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(35+xOffSet, 463, 82, 15)];
        }
        [classNameLabel setBackgroundColor:[UIColor clearColor]];
        classNameLabel.lineBreakMode = UILineBreakModeTailTruncation;
        tempAfe = (AFEClass*)[self.afeClassesArray_PieChart objectAtIndex:i];
        [classNameLabel setText:tempAfe.afeClassName? tempAfe.afeClassName:@""];
        [classNameLabel setFont:FONT_TOP_AFE_SUMMARY_VIEW_LEGEND_BARCHART];
        xOffSet+=105;
        [self addSubview:classNameLabel];
        classNameLabel = nil;
        switch (i) {
            case 0:iconOrange.hidden = NO;
                break;
            case 1:iconGreen.hidden = NO;
                break;
            case 2:iconBlue.hidden = NO;
                break;
            case 3:iconRed.hidden = NO;
                break;
            case 4:iconGray.hidden = NO;
                break;
                
            default:
                break;
        }
        
    }
}

-(void)setPieChartValue{
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1], 
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    self.pieChart.labelFont = [UIFont fontWithName:COMMON_FONTNAME_BOLD size:10];
    [self.pieChart setShowPercentage:NO];
    [self.pieChart reloadData];
    
    
}

-(void) createScrubberView
{
    
    if(!scrubberContainerView)
    {
        scrubberContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 495, 420, 68)];
    }
    else
    {
        [scrubberContainerView removeFromSuperview];
        [scrubberContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    scrubberContainerView.backgroundColor = [UIColor clearColor];
    [self addSubview:scrubberContainerView];
    
    if(!scrubberView)
    {
        scrubberView = [[ScrubberView alloc] initWithFrame:CGRectMake(20, 30, 315, 13)];
    }
    else
        [scrubberView removeFromSuperview];
    
    [[NSUserDefaults standardUserDefaults] setObject:startDate?startDate:[NSDate dateWithTimeInterval:-3600*24*20 sinceDate:[NSDate date]] forKey:@"AFEStartDate"];
    [[NSUserDefaults standardUserDefaults] setObject:endDate?endDate:[NSDate dateWithTimeInterval:-3600*24*10 sinceDate:[NSDate date]] forKey:@"AFEEndDate"];
    
    [scrubberView reloadScrubberFromStartDateKey:@"AFEStartDate" andEndDateKey:@"AFEEndDate" forMaximumEndDateOfAvailableRange:[NSDate date] andMaximumDaysAllowedInGraphDateRange:30];
    
    [scrubberContainerView addSubview:scrubberView];
    
}

#pragma mark -
#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] floatValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
        // if(pieChart == self.pieChartRight) return nil;
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index{
    
    NSString *afeId=[pieChartIds objectAtIndex:index];
    NSLog(@"%@",afeId);
    afeClassesTableView.highlightedRow = [pieChartIds objectAtIndex:index];
    [afeClassesTableView.afeClassesTableView reloadData];
    [afeClassesTableView performSelector:@selector(tableviewScrollup) withObject:nil afterDelay:0];
    

}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index{
    afeClassesTableView.highlightedRow =@"";
    [afeClassesTableView.afeClassesTableView reloadData];
    [afeClassesTableView tableviewScrollDown];
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index{
//    afeClassesTableView.highlightedRow =@"";
//    [afeClassesTableView.afeClassesTableView reloadData];
}

- (IBAction)budgetButtonTouched:(id)sender
{
    afeClassesTableView.highlightedRow = @"";
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"SET_DOLAR"];
    [self.noOFAFEsButton setSelected:NO];
    [self.budgetButton setSelected:YES];
    [self.budgetButton setUserInteractionEnabled:NO];
    [self.noOFAFEsButton setUserInteractionEnabled:YES];
    
        
    IsNoOfAFesButtonClicked = NO;

    if(self.delegate && [self.delegate respondsToSelector:@selector(getAFEClassesForPieChartInTopAFEClassesDetailView:sortByField:andSortOrder:withRecordLimit:)])
    {
        [self.delegate getAFEClassesForPieChartInTopAFEClassesDetailView:self sortByField:SORTFIELD_AFEEstimate andSortOrder:AFESortDirectionDescending withRecordLimit:5];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(getAFEClassesForTableInTopAFEClassesDetailView:forPage:sortByField:andSortOrder:withRecordLimit:)])
    {
        [self.delegate getAFEClassesForTableInTopAFEClassesDetailView:self forPage:1 sortByField:SORTFIELD_AFEEstimate andSortOrder:AFESortDirectionDescending withRecordLimit:50];
    }

}

- (IBAction)noOfAFEsButtonTouched:(id)sender
{
    afeClassesTableView.highlightedRow = @"";
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"SET_DOLAR"];
    [self.budgetButton setSelected:NO];
    [self.noOFAFEsButton setSelected:YES];
    [self.noOFAFEsButton setUserInteractionEnabled:NO];
    [self.budgetButton setUserInteractionEnabled:YES];
    
    IsNoOfAFesButtonClicked = YES;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(getAFEClassesForPieChartInTopAFEClassesDetailView:sortByField:andSortOrder:withRecordLimit:)])
    {
        [self.delegate getAFEClassesForPieChartInTopAFEClassesDetailView:self sortByField:SORTFIELD_NumberOfAFES andSortOrder:AFESortDirectionDescending withRecordLimit:5];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(getAFEClassesForTableInTopAFEClassesDetailView:forPage:sortByField:andSortOrder:withRecordLimit:)])
    {
        [self.delegate getAFEClassesForTableInTopAFEClassesDetailView:self forPage:1 sortByField:SORTFIELD_NumberOfAFES andSortOrder:AFESortDirectionDescending withRecordLimit:50];
    }    

}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
    //[self setUserInteractionEnabled:NO];
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if(self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(didSwipeLeftOnTopAFEClassesDetailedView:)])
        {
            
            if(recognizer.view !=scrubberContainerView)
            [self.swipeDelegate didSwipeLeftOnTopAFEClassesDetailedView:self];
        }
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if(self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(didSwipeRightOnTopAFEClassesDetailedView:)])
        {
            if(recognizer.view != scrubberContainerView)
            [self.swipeDelegate didSwipeRightOnTopAFEClassesDetailedView:self];
        }
    }
}

#pragma mark - AFE Classes Table View Delegate
-(void) didSelectAFEClassObjectForMoreDetais:(AFEClass *)afeClassObj OnAFEClassesTableView:(AFEClassesTableView *)tableView
{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectTheAFEClassToSeeListOfAFEs:)])
    {
        [self.delegate didSelectTheAFEClassToSeeListOfAFEs:afeClassObj];
    }
    
}


-(void) getAFEClassesForAFEClassesTableView:(AFEClassesTableView*) tableView forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(getAFEClassesForTableInTopAFEClassesDetailView:forPage:sortByField:andSortOrder:withRecordLimit:)])
    {
        [self.delegate getAFEClassesForTableInTopAFEClassesDetailView:self forPage:page sortByField:sortField andSortOrder:sortDirection withRecordLimit:limit];
    }
}

-(void) dealloc
{
    self.swipeDelegate = nil;
    startDate = nil;
    endDate = nil;
    scrubberView = nil;
    afeClassesTableView = nil;
    classNameLabel = nil;
}

-(void) setCustomFontForButton:(UIButton *)button
{
    button.titleLabel.font = FONT_DASHBOARD_BUTTON_DEFAULT_LABEL;
        
    [button setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"buttonDark"] forState:UIControlStateNormal];
    
    [button setTitleColor:[Utility getUIColorWithHexString:@"192835"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"buttonLight"] forState:UIControlStateHighlighted];
    
    [button setTitleColor:[Utility getUIColorWithHexString:@"192835"] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:@"buttonLight"] forState:UIControlStateSelected];
 
//    [button.titleLabel setShadowColor:[UIColor whiteColor]];
//    [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    
}


@end
