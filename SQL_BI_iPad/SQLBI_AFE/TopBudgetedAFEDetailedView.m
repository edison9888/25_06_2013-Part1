//
//  TopBudgetedAFEDetailesView.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopBudgetedAFEDetailedView.h"
#import "AFE.h"
#import "ScrubberView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

#define NUMBER_OF_GRAPHS_TO_BE_SHOWN 5
#define STATIC_LEGEND_OFFSET 435
#define BAR_GRAPH_IMAGE_VIEW_TAG_OFFSET 100;

#define LEGAND_SIZE sizeThatFits:CGSizeMake(16, 16)

#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW_BarChart CGRectMake(15,79,387,357)

@interface TopBudgetedAFEDetailedView()
{
    float scalefactor;
    //NSArray *afeArray;
    NSArray *afeArray_BarChart;
    NSArray *afeArray_Table;
    NSDate *startDate;
    NSDate *endDate;
    ScrubberView *scrubberView;
    NSMutableArray *barImageArray;
    UIImageView *staticBudget;
    UILabel *staticBudgetLabel;
    UIImageView *staticActual;
    UILabel *staticActualsLabel;
    UIView *tempContainerView;
    UIImageView *budgetBarImageView;
    UIImageView *actualbarImageView;
    BudgetedAFETableView *afeTableView;
    UIView *scrubberContainerView;
    //UISwipeGestureRecognizer *gestureR;
    UISwipeGestureRecognizer *gestureL;
    UIImageView *accuralsLegand;
    UILabel *accuralsLabel;
    UIImageView *accrualsbarImageView;
    UILabel *statusLabel;
    UILabel *budgetLabel;
    UILabel *actualsAccuralsLabel;
    UIPopoverController* aPopover;
    
    UIActivityIndicatorView *activityIndicView;
    UIView *activityIndicContainerView;
    UIView *activityIndicBGView;
    UILabel *messageLabel;
    
    int currentPageShown;
    int totalNoPagesAvailable;
    
    int totalRecordsAvailable;
    int currentRecordCount;
}

@property (strong, nonatomic) IBOutlet UILabel *recordCountLabel;
@property(strong, nonatomic) IBOutlet UIView *barchartContainer;
@property (strong, nonatomic) NSMutableArray *graphData;

-(void)drawBarChartWithAFEArray:(NSMutableArray *)modelArray;

@end

@implementation TopBudgetedAFEDetailedView
@synthesize barchartContainer;
@synthesize swipeDelegate;
@synthesize graphData, delegate;
@synthesize recordCountLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = (TopBudgetedAFEDetailedView*) [[[NSBundle mainBundle] loadNibNamed:@"TopBudgetedAFEDetailedView" owner:self options:nil] lastObject];
    if (self) {
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
        
        [self createAFETableView];
        
    }
    return self;
}

-(void) awakeFromNib
{
    self.recordCountLabel.text = @"";
    self.recordCountLabel.font = [UIFont fontWithName:COMMON_FONTNAME_NORMAL size:11.5];
}

-(void) createAFETableView
{
    if(!afeTableView)
        afeTableView = [[BudgetedAFETableView alloc]initWithFrame:CGRectMake(425, 30, 526, 497)];
    else
        [afeTableView removeFromSuperview];
    
    afeTableView.delegate = self;
    [self addSubview:afeTableView];
    [afeTableView refreshTableWithAFEArray:afeArray_Table forPage:currentPageShown ofTotalPages:totalNoPagesAvailable andTotalRecords:totalRecordsAvailable];
}

-(void)drawBarChartWithAFEArray:(NSMutableArray *)modelArray{
    
    for (UIView *view in barchartContainer.subviews) 
        {
        [view performSelector:@selector(removeFromSuperview)];
        }
    if(barImageArray && [barImageArray count])
        {
        for (UIImageView *imgV in barImageArray) {
            [imgV removeFromSuperview];
        }
        }
    if(modelArray)
        self.graphData = modelArray;
    else 
    {
        return;
    }
    
    scalefactor = 1;
    scalefactor = [self getScalingFactor];
    if(!scalefactor)
        scalefactor = 1.0;
    
    int legandXCor = 35;
    int legandYCor = 370;

    if(!staticBudget)
        staticBudget = [[UIImageView alloc]initWithFrame:CGRectMake(legandXCor, legandYCor, 16, 16)];
    else 
        [staticBudget removeFromSuperview];
    [staticBudget setImage:[UIImage imageNamed:@"bluebar"]];
    [staticBudget LEGAND_SIZE];
    [barchartContainer addSubview:staticBudget];
    staticBudget = nil;
    
    legandXCor+=20;
    
    if(!staticBudgetLabel)
        staticBudgetLabel = [[UILabel alloc]initWithFrame:CGRectMake(legandXCor, legandYCor, 100, 16)];
    else
        [staticBudgetLabel removeFromSuperview];
    [staticBudgetLabel setText:@"AFE Estimate"];
    [staticBudgetLabel setFont:FONT_SUMMARY_VIEW_BARCHART];
    [staticBudgetLabel setBackgroundColor:[UIColor clearColor]];
    [staticBudgetLabel setTextColor:[Utility getUIColorWithHexString:@"1b2b40"]];
    [barchartContainer addSubview:staticBudgetLabel];
    legandXCor+=110;
    
    staticBudgetLabel = nil;
    if(!staticActual)
        staticActual = [[UIImageView alloc]initWithFrame:CGRectMake(legandXCor, legandYCor, 16, 16)];
    else
        [staticActual removeFromSuperview];
    [staticActual LEGAND_SIZE];
    [staticActual setImage:[UIImage imageNamed:@"yellowbar"]];
    [barchartContainer addSubview:staticActual];
    
    staticActual = nil;
    
    legandXCor+=20;
    
    if(!accuralsLabel)
        accuralsLabel = [[UILabel alloc]initWithFrame:CGRectMake(legandXCor, legandYCor, 100, 16)];
    else
        [accuralsLabel removeFromSuperview];
    [accuralsLabel setText:@"Accruals"];
    [accuralsLabel setTextColor:[Utility getUIColorWithHexString:@"1b2b40"]];
    [accuralsLabel setFont:FONT_SUMMARY_VIEW_BARCHART];
    [accuralsLabel setBackgroundColor:[UIColor clearColor]];
    [barchartContainer addSubview:accuralsLabel];
    accuralsLabel = nil;

    legandXCor+=80;
    
    if(!accuralsLegand)
        accuralsLegand = [[UIImageView alloc]initWithFrame:CGRectMake(legandXCor, legandYCor, 16, 16)];
    else
        [accuralsLegand removeFromSuperview];
    legandXCor+=20;
    [accuralsLegand LEGAND_SIZE];
    [accuralsLegand setImage:[UIImage imageNamed:@"redbar"]];
    [barchartContainer addSubview:accuralsLegand];
    accuralsLegand = nil;
    
    if(!staticActualsLabel)
        staticActualsLabel = [[UILabel alloc]initWithFrame:CGRectMake(legandXCor, legandYCor, 100, 16)];
    else
        [staticActualsLabel removeFromSuperview];
    [staticActualsLabel setText:@"Actuals"];
    [staticActualsLabel setTextColor:[Utility getUIColorWithHexString:@"1b2b40"]];
    [staticActualsLabel setFont:FONT_SUMMARY_VIEW_BARCHART];
    [staticActualsLabel setBackgroundColor:[UIColor clearColor]];
    [barchartContainer addSubview:staticActualsLabel];
    staticActualsLabel = nil;
       int frameOffSet = 5;
    int tag =0;
    int i =0;
    if(!barImageArray)
        barImageArray = [[NSMutableArray alloc]init];    
    else
        [barImageArray removeAllObjects];
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"budget" ascending:NO] ;
    NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor]; 
    self.graphData = (NSMutableArray *)[self.graphData sortedArrayUsingDescriptors:descriptors];
    for(i = 0; i < 5; i++)
    {  
        CGRect mainFrame = CGRectMake(0, 16+frameOffSet, 0, 20);
        if(!budgetBarImageView)
            budgetBarImageView = [[UIImageView alloc]initWithFrame:mainFrame];
        else
            [budgetBarImageView removeFromSuperview];
        
        AFE *afeObj;
        if(i < [self.graphData count])
            afeObj = [self.graphData objectAtIndex:i];
        else
            afeObj = [[AFE alloc] init];

        
        budgetBarImageView.image = [UIImage imageNamed:@"bluebar"];
        budgetBarImageView.tag = tag+BAR_GRAPH_IMAGE_VIEW_TAG_OFFSET;
            //    tag+=1;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                     action:@selector(handleTap:)];
        recognizer.numberOfTapsRequired = 1;
        recognizer.delegate = self;
        budgetBarImageView.userInteractionEnabled = YES;
        budgetBarImageView.image = [UIImage imageNamed:@"bluebar"];
        budgetBarImageView.tag = tag+BAR_GRAPH_IMAGE_VIEW_TAG_OFFSET;
        
        tag+=1;
        [budgetBarImageView addGestureRecognizer:recognizer];
        [barchartContainer addSubview:budgetBarImageView];
        [barchartContainer bringSubviewToFront:budgetBarImageView];
        [barImageArray addObject:budgetBarImageView];
        budgetBarImageView = nil;
        
        
        if(!accrualsbarImageView)
            accrualsbarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 36+frameOffSet, 0, 13)];
        else
            [accrualsbarImageView removeFromSuperview];
        
        accrualsbarImageView.image = [UIImage imageNamed:@"yellowbar"];
        [barchartContainer addSubview:accrualsbarImageView];
        accrualsbarImageView.tag = tag+BAR_GRAPH_IMAGE_VIEW_TAG_OFFSET;
        CGRect tempFrame = accrualsbarImageView.frame;
        tempFrame.size.width = afeObj.fieldEstimate*scalefactor;
        accrualsbarImageView.frame = tempFrame;
        tag+=1;
        UITapGestureRecognizer *recognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleTap:)];
        recognizer.numberOfTapsRequired = 1;
        recognizer.delegate = self;
        accrualsbarImageView.userInteractionEnabled = YES;
        [accrualsbarImageView addGestureRecognizer:recognizer3];
        
        [barImageArray addObject:accrualsbarImageView];
        budgetBarImageView = nil;
        

        CGRect subFrame = CGRectMake(accrualsbarImageView.frame.origin.x+accrualsbarImageView.frame.size.width, 36+frameOffSet, 0, 13);
        if(!actualbarImageView)
            actualbarImageView = [[UIImageView alloc]initWithFrame:subFrame];
        else
            [actualbarImageView removeFromSuperview];
        actualbarImageView.image = [UIImage imageNamed:@"redbar"];
        actualbarImageView.tag = tag+BAR_GRAPH_IMAGE_VIEW_TAG_OFFSET;
        tag+=1;
        UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                      action:@selector(handleTap:)];
        recognizer.numberOfTapsRequired = 1;
        recognizer.delegate = self;
        [actualbarImageView addGestureRecognizer:recognizer2];
        actualbarImageView.userInteractionEnabled = YES;
        [barchartContainer addSubview:actualbarImageView];
        [barImageArray addObject:actualbarImageView];
        
       
        accrualsbarImageView = nil;
        actualbarImageView = nil;
        frameOffSet+=68;

    }
    
    [self addSubview:barchartContainer];
    [UIView animateWithDuration:1
                     animations:^{
                         
                         int j = 0;
                         for (int i =0; i< [barImageArray count]; i+=3) 
                         {
                             //  if(i<=9)
                             AFE *afeObj = [[AFE alloc]init];
                             @try 
                             { 
                                 if(j < [self.graphData count])
                                     afeObj = [self.graphData objectAtIndex:j];
                                 else
                                     afeObj = [[AFE alloc] init];
                             }
                             @catch (NSException *exception)
                             {NSLog(@"Exception");}
                             
                             UIImageView *imgV = [barImageArray objectAtIndex:i];
                             CGRect tempFrame = imgV.frame;
                             tempFrame.size.width = afeObj.budget*scalefactor;
                             if(2 >= tempFrame.size.width)
                                 tempFrame.size.width = 2;
                            // NSLog(@"%f Applay scaling %f   Act %f ",scalefactor ,afeObj.budget*scalefactor,afeObj.budget);
                             imgV.frame = tempFrame;
                             
                            j++;
                         }
                         
                         j = 0;
                         for (int i = 1; i< [barImageArray count]; i+=3)
                         {
                             
                             UIImageView *tmp;
                             AFE *afeObj = [[AFE alloc]init];
                             @try
                             {
                                 if(j < [self.graphData count])
                                     afeObj = [self.graphData objectAtIndex:j];
                                 else
                                     afeObj = [[AFE alloc] init];
                                 
                                 tmp = [barImageArray objectAtIndex:i-1];
                             }
                             @catch (NSException *exception)
                             {NSLog(@"Exception");}
                             UIImageView *imgV = [barImageArray objectAtIndex:i];
                             CGRect tempFrame = imgV.frame;
                             
                             
                             
                             //tempFrame.origin.x = tmp.frame.origin.x+tmp.frame.size.width+0;
                             tempFrame.size.width = afeObj.fieldEstimate*scalefactor;
                             if(2 >= tempFrame.size.width)
                                 tempFrame.size.width = 2;
                             //NSLog(@"%f Applay scaling %f   Act %f ",scalefactor ,afeObj.fieldEstimate*scalefactor,afeObj.fieldEstimate);
                             imgV.frame = tempFrame;
                             
                             j++;
                             
                         }

                         
                         j = 0;
                         for (int i =2; i< [barImageArray count]; i+=3)
                         {
                             AFE *afeObj = [[AFE alloc]init];
                             @try 
                             { 
                                 if(j < [self.graphData count])
                                     afeObj = [self.graphData objectAtIndex:j];
                                 else
                                     afeObj = [[AFE alloc] init];
                             }
                             @catch (NSException *exception) 
                             {NSLog(@"Exception");}
                             
                             UIImageView *imgV = [barImageArray objectAtIndex:i];
                             CGRect tempFrame = imgV.frame;
                             tempFrame.size.width = afeObj.actual*scalefactor;
                             if(2 >= tempFrame.size.width)
                                 tempFrame.size.width = 2;
                            // NSLog(@"%f Applay Orange scaling %f   Act %f ",scalefactor ,afeObj.actual*scalefactor,afeObj.actual);
                             
                             imgV.frame = tempFrame;
                             
                             j++;
                         }
                         
                         
                         
                     }
                     completion:^(BOOL finished)
                     {
                         
                         int j = 0 ;
                     AFE *afeObj;
                     for (UIImageView *barImgeView in barImageArray) 
                         {
                         if(barImgeView.tag >=100)
                             {
                             barImgeView.tag = barImgeView.tag - BAR_GRAPH_IMAGE_VIEW_TAG_OFFSET;
                             @try 
                                 {
                                     if(barImgeView.tag != 0 && barImgeView.tag%3 == 0)
                                     {
                                         j++;
                                     }
                                     
                                     if(j < [self.graphData count]) 
                                         afeObj = [self.graphData objectAtIndex:j];
                                     else
                                         afeObj = [[AFE alloc] init];
                                 }
                             @catch (NSException *exception) 
                                 {
                                 NSLog(@"Exception");
                                 }
                             int yOffSet = 18;
                             if(barImgeView.tag%3 == 0)
                                 {
                                 if(!statusLabel)
                                     statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, barImgeView.frame.origin.y-yOffSet, 300, 20)];
                                 else
                                     [statusLabel removeFromSuperview];
                                 statusLabel.text = afeObj.afeNumber;
                                 statusLabel.textColor = [UIColor blackColor];
                                 [statusLabel setFont:FONT_SUMMARY_DETAIL_VIEW_BARCHART];
                                 statusLabel.backgroundColor = [UIColor clearColor];
                                 statusLabel.textAlignment = UITextAlignmentLeft;
                                 [barchartContainer addSubview:statusLabel];
                                 
                                 CGRect tempFrame = barImgeView.frame;
                                 tempFrame.origin.x = barImgeView.frame.size.width+15;
                                 tempFrame.origin.y -=2;
                                 if(!budgetLabel)
                                     budgetLabel = [[UILabel alloc]initWithFrame:tempFrame];
                                 else
                                     [budgetLabel removeFromSuperview];
                                 if(2 <= budgetLabel.frame.size.width)
                                     budgetLabel.frame = CGRectMake(budgetLabel.frame.origin.x, budgetLabel.frame.origin.y, budgetLabel.frame.size.width+50, budgetLabel.frame.size.height);
                                 budgetLabel.text =[NSString stringWithFormat:@"%@",afeObj.budgetAsStr];
                                 [budgetLabel setTextColor:[Utility getUIColorWithHexString:@"1b2b40"]];
                                 //[budgetLabel setTextColor:[UIColor redColor]];

                                 [budgetLabel setFont:FONT_SUMMARY_DETAIL_VIEW_BARCHART];
                                 [budgetLabel setBackgroundColor:[UIColor clearColor]];
                                 if(barchartContainer.frame.size.width - barImgeView.frame.size.width+10<[budgetLabel.text sizeWithFont:budgetLabel.font].width)
                                     {
                                     budgetLabel.lineBreakMode = UILineBreakModeTailTruncation;
                                     }
                                 budgetLabel.textAlignment = UITextAlignmentLeft;
                                 [barchartContainer addSubview:budgetLabel];
                                 statusLabel = nil;
                                 budgetLabel = nil;
                                 }
                             if(barImgeView.tag %3 ==2)
                                 {
                                 CGRect tempFrame = CGRectMake(barImgeView.frame.origin.x + barImgeView.frame.size.width+5, barImgeView.frame.origin.y-8, 250, 30);
                                 
                                 
                                 if(!actualsAccuralsLabel)
                                     actualsAccuralsLabel = [[UILabel alloc]initWithFrame:tempFrame];
                                 else
                                     [actualsAccuralsLabel removeFromSuperview];
                                 if(2 <= actualsAccuralsLabel.frame.size.width)
                                     actualsAccuralsLabel.frame = CGRectMake(actualsAccuralsLabel.frame.origin.x+15, actualsAccuralsLabel.frame.origin.y, actualsAccuralsLabel.frame.size.width, actualsAccuralsLabel.frame.size.height);
                                 actualsAccuralsLabel.text =[NSString stringWithFormat:@"%@",afeObj.actualPlusAccrualAsStr];
                                 
                                 [actualsAccuralsLabel setTextColor:[Utility getUIColorWithHexString:@"1b2b40"]];
                                 [actualsAccuralsLabel setFont:FONT_SUMMARY_DETAIL_VIEW_BARCHART];
                                 [actualsAccuralsLabel setBackgroundColor:[UIColor clearColor]];
                                 if(barchartContainer.frame.size.width - barImgeView.frame.size.width+10<[actualsAccuralsLabel.text sizeWithFont:actualsAccuralsLabel.font].width)
                                     {
                                     actualsAccuralsLabel.lineBreakMode = UILineBreakModeTailTruncation;
                                     }
                                 
                                 actualsAccuralsLabel.textAlignment = UITextAlignmentLeft;
                                 [barchartContainer addSubview:actualsAccuralsLabel];
                                 statusLabel = nil;
                                 actualsAccuralsLabel = nil;
                                 
                                 }
                             
                             }
                         }
                     }];
    
}


-(float) getScalingFactor
{
    NSMutableArray *budgetActualArray = [[NSMutableArray alloc]init];
    //int i =0;
    for (AFE *afeObj in self.graphData) 
        {
            //if(i++<4)
            {
            if([afeObj isKindOfClass:[AFE class]])
                {
                [budgetActualArray addObject:[NSNumber numberWithFloat:afeObj.budget]];
                [budgetActualArray addObject:[NSNumber numberWithFloat:afeObj.actual]];
                [budgetActualArray addObject:[NSNumber numberWithFloat:afeObj.actualPlusAccrual]];
                }
            }
        }    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    budgetActualArray = (NSMutableArray *) [budgetActualArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    if(budgetActualArray && [budgetActualArray count])
        {
        
        if([[budgetActualArray objectAtIndex:0] doubleValue] > 170)
            {
            return 275.00/[[budgetActualArray objectAtIndex:0] doubleValue];
            }
        else if([[budgetActualArray objectAtIndex:0] floatValue]<=20.0)
            return 15;
        
        }
    budgetActualArray = nil;
    sortDescriptor = nil;
    return 0.0;
    
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
        scrubberView = [[ScrubberView alloc] initWithFrame:CGRectMake(20, 30, 383, 13)];
    }
    else
        [scrubberView removeFromSuperview];
    
    [[NSUserDefaults standardUserDefaults] setObject:startDate?startDate:[NSDate dateWithTimeInterval:-3600*24*20 sinceDate:[NSDate date]] forKey:@"AFEStartDate"];
    [[NSUserDefaults standardUserDefaults] setObject:endDate?endDate:[NSDate dateWithTimeInterval:-3600*24*10 sinceDate:[NSDate date]] forKey:@"AFEEndDate"];
    
    [scrubberView reloadScrubberFromStartDateKey:@"AFEStartDate" andEndDateKey:@"AFEEndDate" forMaximumEndDateOfAvailableRange:[NSDate date] andMaximumDaysAllowedInGraphDateRange:30];
    
    [scrubberContainerView addSubview:scrubberView];
    
}


-(void) refreshTableWithAFEArray:(NSArray*) afeArrayToUse forPage:(int) page ofTotalPages:(int) totalPages andTotalRecords:(int) totalRecords  andStartDate:(NSDate*) start andEndDate:(NSDate*) end
{
    if(page <= currentPageShown)
        currentRecordCount = currentRecordCount - (50 + afeArray_Table.count);
    
    afeArray_Table = afeArrayToUse;
    currentPageShown = page;
    totalNoPagesAvailable = totalPages;
    startDate = start;
    endDate = end;
    
    totalRecordsAvailable = totalRecords;

    if(currentPageShown <= 1)
        currentRecordCount = 0;
    
    if(afeArray_Table && afeArray_Table.count > 0)
    {
     self.recordCountLabel.text = [NSString stringWithFormat:@"Displaying %d - %d of %d",K_LIST_COUNT *(page-1) + 1, K_LIST_COUNT *(page-1)+[afeArray_Table count],totalRecords];
//        self.recordCountLabel.text = [NSString stringWithFormat:@"Displaying %d - %d of %d",currentRecordCount + 1, currentRecordCount + [afeArray_Table count],totalRecords];
    }
    else
        self.recordCountLabel.text = @"";
    
    currentRecordCount += afeArray_Table.count;
    
    [self createAFETableView];
    
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

-(void) refreshBarChartWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end
{
    afeArray_BarChart = afeArrayToUse;
    startDate = start;
    endDate = end;
    
    [self drawBarChartWithAFEArray:(NSMutableArray*)afeArray_BarChart];
    
    [Utility removeLeftSwipeGestureFromViewsRecursively:self];
    [Utility removeRightSwipeGestureFromViewsRecursively:self];
    [Utility addLeftSwipeGestureToViewsRecursively:self targetDelegate:self handleSelector:@selector(handleSwipeFrom:)];
    [Utility addRightSwipeGestureToViewsRecursively:self targetDelegate:self handleSelector:@selector(handleSwipeFrom:)];
    [Utility removeLeftSwipeGestureFromViewsRecursively:scrubberContainerView];
    [Utility removeRightSwipeGestureFromViewsRecursively:scrubberContainerView];
    
}

-(void) showActivityIndicatorOverlayViewOnBarChart
{
    [self removeActivityIndicatorOverlayViewOnBarChart];
    
    if(!activityIndicView)
    {
        activityIndicView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    else
        [activityIndicView removeFromSuperview];
    
    if(!activityIndicContainerView)
        activityIndicContainerView = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW_BarChart];
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

-(void) removeActivityIndicatorOverlayViewOnBarChart
{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(activityIndicView)
        [activityIndicView stopAnimating];
    
}

-(void) showMessageOnBarChart:(NSString*) message
{
    if(!activityIndicContainerView)
        activityIndicContainerView = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW_BarChart];
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

-(void) hideMessageOnBarChart
{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(messageLabel)
        messageLabel.text = @"";
}


-(void) showActivityIndicatorOverlayViewOnTable
{
    if(afeTableView)
        [afeTableView showActivityIndicatorOverlayView];
}

-(void) removeActivityIndicatorOverlayViewOnTable
{
    if(afeTableView)
        [afeTableView removeActivityIndicatorOverlayView];
}

-(void) showMessageOnTable:(NSString*) message
{
    if(afeTableView)
        [afeTableView showMessageOnView:message];
}

-(void) hideMessageOnTable
{
    if(afeTableView)
        [afeTableView hideMessageOnView];
}



- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
    //[self setUserInteractionEnabled:NO];
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if(self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(didSwipeLeftOnTopBudgetedAFEDetailedView:)])
        {

            if(recognizer.view != scrubberContainerView)
                [self.swipeDelegate didSwipeLeftOnTopBudgetedAFEDetailedView:self];
        }
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if(self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(didSwipeRightOnTopBudgetedAFEDetailedView:)])
        {
            if(recognizer.view != scrubberContainerView)
                [self.swipeDelegate didSwipeRightOnTopBudgetedAFEDetailedView:self];
        }
    }
}

#pragma mark - ToBudgetedAFE Delegate Method

-(void) didSelectAFEObjectForMoreDetais:(AFE *)afeObj OnBudgetedAFETableView:(BudgetedAFETableView *)tableView
{
    AppDelegate *tempAppDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    if(tempAppDelegate)
    {
        [tempAppDelegate jumpToAFESearchAndSearchAFEWithObject:afeObj];
    }

}

-(void) getAFEsForBudgetedAFETableView:(BudgetedAFETableView*) tableView forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(getAFEsForTableInTopBudgetedAFEDetailedView:forPage:sortByField:andSortOrder:withRecordLimit:)])
    {
        [self.delegate getAFEsForTableInTopBudgetedAFEDetailedView:self forPage:page sortByField:sortField andSortOrder:sortDirection withRecordLimit:limit];
    }
}

-(void)handleTap:(UITapGestureRecognizer *)sender{
    NSLog(@"Handling tap on ImageView");
    CGPoint touchPoint = [sender locationInView:[sender view]];
    UIView* viewTouched = [[sender view] hitTest:touchPoint withEvent:nil];
    
    switch (viewTouched.tag) {
            
            
        case 0:
        case 1:
        case 2:{
            [self setPopOver:0 frame:viewTouched.frame arrowDir:0];
            break;
        }
        case 3:
        case 4:
        case 5:{
            [self setPopOver:1 frame:viewTouched.frame arrowDir:0];
            
            break;
        }
        case 6:
        case 7:
        case 8:{
            [self setPopOver:2 frame:viewTouched.frame arrowDir:0];
            
            break;
        }
        case 9:
        case 10:
        case 11:{
            [self setPopOver:3 frame:viewTouched.frame arrowDir:0];
            
            break;
        }
        case 12:
        case 13:
        case 14:{
            [self setPopOver:3 frame:viewTouched.frame arrowDir:1];
            
            break;
        }

            
        default:{
            break;
        }
            
    }
}

-(void)setPopOver : (int)Tag frame :(CGRect)rect arrowDir:(int)arrowDirection {
   
    if(self.graphData && (Tag < self.graphData.count))
    {
        AFE *tmpAfe = (AFE*)[self.graphData objectAtIndex:Tag];
        
        if(!tmpAfe)
            return;
        
        UIView *contianerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 50)];
        contianerV.backgroundColor = [UIColor whiteColor];
        
        UILabel *afeEstimateLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,0,100,20)];
        afeEstimateLbl.text = @"AFE Estimate  :";
        [afeEstimateLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        afeEstimateLbl.backgroundColor = [UIColor clearColor];
        afeEstimateLbl.textColor = [UIColor whiteColor];
        afeEstimateLbl.textAlignment = UITextAlignmentLeft;
        afeEstimateLbl.font = FONT_SUMMARY_DATE;
        afeEstimateLbl.textColor = [Utility getUIColorWithHexString:@"1b2128"];
        [contianerV addSubview:afeEstimateLbl];
        
        UILabel *afeEstimateValLbl = [[UILabel alloc] initWithFrame:CGRectMake(110,0,100,20)];
        afeEstimateValLbl.text = tmpAfe.budgetAsStr? tmpAfe.budgetAsStr:@"";
        afeEstimateValLbl.backgroundColor = [UIColor clearColor];
        afeEstimateValLbl.textAlignment = UITextAlignmentLeft;
        afeEstimateValLbl.font = FONT_SUMMARY_DATE;
        afeEstimateValLbl.textColor = [Utility getUIColorWithHexString:@"1b2128"];
        [contianerV addSubview:afeEstimateValLbl];
        
        
        UILabel *actualLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,20,100,20)];
        actualLbl.text = @"Actuals           :";
        [actualLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        actualLbl.backgroundColor = [UIColor clearColor];
        actualLbl.textColor = [UIColor whiteColor];
        actualLbl.textAlignment = UITextAlignmentLeft;
        actualLbl.font = FONT_SUMMARY_DATE;
        actualLbl.textColor = [Utility getUIColorWithHexString:@"1b2128"];
        [contianerV addSubview:actualLbl];
        
        UILabel *actualValLbl = [[UILabel alloc] initWithFrame:CGRectMake(110,20,100,20)];
        actualValLbl.text = tmpAfe.actualsAsStr? tmpAfe.actualsAsStr:@"";
        actualValLbl.backgroundColor = [UIColor clearColor];
        actualValLbl.textAlignment = UITextAlignmentLeft;
        actualValLbl.font = FONT_SUMMARY_DATE;
        actualValLbl.textColor = [Utility getUIColorWithHexString:@"1b2128"];
        [contianerV addSubview:actualValLbl];
        
        UILabel *accrualLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,40,100,20)];
        accrualLbl.text = @"Accruals         : ";
        [accrualLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        accrualLbl.backgroundColor = [UIColor clearColor];
        accrualLbl.textColor = [UIColor whiteColor];
        accrualLbl.textAlignment = UITextAlignmentLeft;
        accrualLbl.font = FONT_SUMMARY_DATE;
        accrualLbl.textColor = [Utility getUIColorWithHexString:@"1b2128"];
        [contianerV addSubview:accrualLbl];
        
        UILabel *accrualLblValLbl = [[UILabel alloc] initWithFrame:CGRectMake(110,40,100,20)];
        accrualLblValLbl.text = tmpAfe.fieldEstimateAsStr? tmpAfe.fieldEstimateAsStr:@"";
        accrualLblValLbl.backgroundColor = [UIColor clearColor];
        accrualLblValLbl.textAlignment = UITextAlignmentLeft;
        accrualLblValLbl.font = FONT_SUMMARY_DATE;
        accrualLblValLbl.textColor = [Utility getUIColorWithHexString:@"1b2128"];
        [contianerV addSubview:accrualLblValLbl];
        
        UILabel *totalLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,60,100,20)];
        totalLbl.text = @"Total                : ";
        [totalLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        totalLbl.backgroundColor = [UIColor clearColor];
        totalLbl.textColor = [UIColor whiteColor];
        totalLbl.textAlignment = UITextAlignmentLeft;
        totalLbl.font = FONT_SUMMARY_DATE;
        totalLbl.textColor = [Utility getUIColorWithHexString:@"1b2128"];
        [contianerV addSubview:totalLbl];
        
        UILabel *totalValLbl = [[UILabel alloc] initWithFrame:CGRectMake(110,60,100,20)];
        //double totalVal = tmpAfe.budget + tmpAfe.actual;
        totalValLbl.text = tmpAfe.actualPlusAccrualAsStr? tmpAfe.actualPlusAccrualAsStr:@"";
        totalValLbl.backgroundColor = [UIColor clearColor];
        totalValLbl.textAlignment = UITextAlignmentLeft;
        totalValLbl.font = FONT_SUMMARY_DATE;
        totalValLbl.textColor = [Utility getUIColorWithHexString:@"1b2128"];
        [contianerV addSubview:totalValLbl];
        
        UIViewController* controller = [[UIViewController alloc] init] ;
        controller.view = contianerV;
        aPopover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [aPopover setDelegate:self];
        [aPopover setPopoverContentSize:CGSizeMake(230, 80) animated:YES];
        
        if(arrowDirection)
            [aPopover presentPopoverFromRect:CGRectMake(rect.origin.x+150,rect.origin.y+99,100,100) inView:self permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        else {
            [aPopover presentPopoverFromRect:CGRectMake(rect.origin.x + 150,rect.origin.y - 5,100,100) inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
        

    }
    
}



- (void)dealloc{
    
    self.graphData = nil;
    //afeArray = nil;
    afeArray_BarChart = nil;
    afeArray_Table = nil;
    scrubberView = nil;
    startDate = nil;
    endDate = nil;
    self.swipeDelegate = nil;
    
}





@end
