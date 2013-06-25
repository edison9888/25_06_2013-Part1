//
//  TopAFEClassesSummaryView.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopAFEClassesSummaryView.h"
#import "AFEClass.h"
#import "ScrubberView.h"

#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW CGRectMake(4,48,483,253)

@interface TopAFEClassesSummaryView (){
    NSDate *startDate;
    NSDate *endDate;
    ScrubberView *scrubberView;
    UILabel *classNameLabel;
    
    UIActivityIndicatorView *activityIndicView;
    UIView *activityIndicContainerView;
    UIView *activityIndicBGView;
    UILabel *messageLabel;
    
}
@property (strong, nonatomic) IBOutlet UIButton *detailButton;
@property (strong, nonatomic) IBOutlet UIButton *budgetButton;
@property (strong, nonatomic) IBOutlet UIButton *noOFAFEsButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel *dateLbl;
@property(nonatomic, strong) NSArray        *sliceColors;
@property (nonatomic, strong) IBOutlet XYPieChart *pieChart;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSMutableArray *afeClassesArray;
@property(nonatomic, assign) BOOL IsNoOfAFesButtonClicked;

@property (strong, nonatomic) IBOutlet UIImageView *iconOrange;
@property (strong, nonatomic) IBOutlet UIImageView *iconGreen;
@property (strong, nonatomic) IBOutlet UIImageView *iconBlue;
@property (strong, nonatomic) IBOutlet UIImageView *iconRed;
@property (strong, nonatomic) IBOutlet UIImageView *iconGray;

- (IBAction)budgetButtonTouched:(id)sender;
- (IBAction)noOfAFEsButtonTouched:(id)sender;
-(void)drawPieChart;

@end


@implementation TopAFEClassesSummaryView
@synthesize delegate;
@synthesize pieChart,slices,sliceColors;
@synthesize detailButton;
@synthesize budgetButton;
@synthesize noOFAFEsButton;
@synthesize titleLbl;
@synthesize dateLbl;
@synthesize afeClassesArray;
@synthesize IsNoOfAFesButtonClicked;
@synthesize iconOrange;
@synthesize iconGreen;
@synthesize iconBlue;
@synthesize iconRed;
@synthesize iconGray;

- (id)initWithFrame:(CGRect)frame
{
    self = (TopAFEClassesSummaryView*) [[[NSBundle mainBundle] loadNibNamed:@"TopAFEClassesSummaryView" owner:self options:nil] lastObject];
    if (self) {
            // Initialization code
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
        
    }
    return self;
}

-(void) awakeFromNib
{
    [self.titleLbl setFont:FONT_SUMMARY_HEADER_TITLE];
    [self.titleLbl setTextColor:COLOR_HEADER_TITLE];
    [self.dateLbl setFont:FONT_SUMMARY_DATE];
    [self.dateLbl setTextColor:COLOR_DASHBORD_DATE];
    [self setCustomFontForButton:self.budgetButton];
    [self setCustomFontForButton:self.noOFAFEsButton];
    
    [self.budgetButton setSelected:YES];
    [self.budgetButton setUserInteractionEnabled:NO];
    
}

-(void) refreshPieChartWithAFEClassesArray:(NSArray*) afeClassesArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end
{
    self.slices = [[NSMutableArray alloc] init];
    startDate = start;
    endDate = end;
    self.afeClassesArray = (NSMutableArray*) afeClassesArrayToUse;
    dateLbl.text = [NSString stringWithFormat:@"%@ - %@",[Utility getStringFromDate:start],[Utility getStringFromDate:endDate]];
    [self hideIcons];
    [self drawPieChart];
}
-(void)hideIcons{
    iconOrange.hidden = YES;
    iconGreen.hidden = YES;
    iconBlue.hidden = YES;
    iconRed.hidden = YES;
    iconGray.hidden = YES;
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
    messageLabel.textColor = [UIColor redColor];
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
- (void)removeLabelsFromView
{
    for (UILabel *label in self.subviews) {
        if([label isKindOfClass:[UILabel class]])
        {
            if([label respondsToSelector:@selector(removeFromSuperview)])
            {
            switch (label.tag) {
                case 777:
                    
                    break;
                case 666:
                    
                    break;
                default:{
                    [label removeFromSuperview];
                    break;}
            }
                    
            }
        }
    }
}

-(void)setData{

    [self removeLabelsFromView];
    if([self.slices count])
        [self.slices removeAllObjects];
    NSSortDescriptor *sortDescriptor; 
    if(IsNoOfAFesButtonClicked){
        
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"afeCount" ascending:NO];
    }
    else {
        
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"budget" ascending:NO];
         
    }
    self.afeClassesArray = (NSMutableArray*)[self.afeClassesArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];   
    NSMutableDictionary *piechartValue = [[NSMutableDictionary alloc] init];
    NSString *piechartKey;
    
    AFEClass *tempAFE = [[AFEClass alloc] init];
    NSNumberFormatter* number_formatter = [[NSNumberFormatter alloc]
                                           init] ;
    NSString* my_string = @"";
    if([self.afeClassesArray count]){
        
        int count = [self.afeClassesArray count];
        if(4 < count)
            count = 5;
        for(int i = 0; i< count; i++){
            tempAFE = (AFEClass*)[self.afeClassesArray objectAtIndex:i];
            NSNumber *num;
            if(IsNoOfAFesButtonClicked){
                my_string = [NSString stringWithFormat:@"%d",tempAFE.afeCount];
                num =  [number_formatter numberFromString:my_string]; 
                piechartKey = [NSString stringWithFormat:@"%@",num];
                    //[piechartValue setObject:tempAFE.budgetAsStr forKey:piechartKey];
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
                NSLog(@"Less than 4 perctg");
            }
                    // [self.slices removeObjectAtIndex:j];
            
            
        }
        self.slices = tmpSliceArray;
            //NSNumber *tmpvalue  = [self.slices objectAtIndex:j];
        
        

            
            
    }
   
    [[NSUserDefaults standardUserDefaults] setObject:piechartValue forKey:@"pieChartValue"];
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
//    self.slices = (NSMutableArray *) [self.slices sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
//    if([self.slices count]){
//        int limit;
//        if([self.slices count] > 4){
//            limit = 5;
//        }
//        else
//            limit = [self.slices count];
//        for(int i =  0 ;i < limit;i++)
//            [tmpArray addObject:[self.slices objectAtIndex:i]];
//        self.slices = tmpArray;
//    }
    if(classNameLabel)
        [classNameLabel removeFromSuperview];
    int yOffSet = 0;
    AFEClass *tempAfe = [[AFEClass alloc] init];
    for (int i = 0; i< [self.slices count]; i++) 
    {
        if(!classNameLabel)
            classNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(402, 128+yOffSet, 100, 15)];
        else
            [classNameLabel removeFromSuperview];
        [classNameLabel setBackgroundColor:[UIColor clearColor]];
        tempAfe = (AFEClass*)[self.afeClassesArray objectAtIndex:i];
        [classNameLabel setText:tempAfe.afeClassName];
        [classNameLabel setFont:FONT_TOP_AFE_SUMMARY_VIEW_LEGEND_BARCHART];
        yOffSet+=18;
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

-(void)drawPieChart{
    [self setData];
    [self  setPieChartValue];

    
//    for (UIView *view in pieChart.subviews) 
//        {
//        [view performSelector:@selector(removeFromSuperview)];
//        }
    
    
    
    
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
    [self addSubview:self.pieChart];
    [self.pieChart setShowPercentage:NO];
    self.pieChart.labelFont = [UIFont fontWithName:COMMON_FONTNAME_BOLD size:11];
    [self.pieChart reloadData];
    
    
}
#pragma mark -
#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    NSLog(@"%d", [[self.slices objectAtIndex:index] intValue]);
    return [[self.slices objectAtIndex:index] floatValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

-(void) createScrubberView
{
    
    if(!scrubberView)
    {
        scrubberView = [[ScrubberView alloc] initWithFrame:CGRectMake(18, 273, 457, 13)];
    }
    else
        [scrubberView removeFromSuperview];
    
    [[NSUserDefaults standardUserDefaults] setObject:startDate?startDate:[NSDate dateWithTimeInterval:-3600*24*20 sinceDate:[NSDate date]] forKey:@"AFEStartDate"];
    [[NSUserDefaults standardUserDefaults] setObject:endDate?endDate:[NSDate dateWithTimeInterval:-3600*24*10 sinceDate:[NSDate date]] forKey:@"AFEEndDate"];
    
    [scrubberView reloadScrubberFromStartDateKey:@"AFEStartDate" andEndDateKey:@"AFEEndDate" forMaximumEndDateOfAvailableRange:[NSDate date] andMaximumDaysAllowedInGraphDateRange:30];
    
    [self addSubview:scrubberView];
    
}


#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %d",index);
}
#pragma - mark
#pragma mark Button Actions
- (IBAction)budgetButtonTouched:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"SET_DOLAR"];
    [self.noOFAFEsButton setSelected:NO];
    [self.budgetButton setSelected:YES];
    [self.budgetButton setUserInteractionEnabled:NO];
    [self.noOFAFEsButton setUserInteractionEnabled:YES];
    IsNoOfAFesButtonClicked  = NO;
    
    if([self.delegate respondsToSelector:@selector(getAFEClassesForPieChartInTopAFEClassesSummaryView:sortByField:andSortOrder:withRecordLimit:)])
    {
        [self.delegate getAFEClassesForPieChartInTopAFEClassesSummaryView:self sortByField:SORTFIELD_AFEEstimate andSortOrder:AFESortDirectionDescending withRecordLimit:5];
    }

}

- (IBAction)noOfAFEsButtonTouched:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"SET_DOLAR"];
    
    [self.noOFAFEsButton setSelected:YES];
    [self.budgetButton setSelected:NO];
    [self.noOFAFEsButton setUserInteractionEnabled:NO];
    [self.budgetButton setUserInteractionEnabled:YES];
    IsNoOfAFesButtonClicked  = YES;
   // [self drawPieChart];
    
    if([self.delegate respondsToSelector:@selector(getAFEClassesForPieChartInTopAFEClassesSummaryView:sortByField:andSortOrder:withRecordLimit:)])
    {
        [self.delegate getAFEClassesForPieChartInTopAFEClassesSummaryView:self sortByField:SORTFIELD_NumberOfAFES andSortOrder:AFESortDirectionDescending withRecordLimit:5];
    }

}


-(IBAction)detailBtnTouched{
    if(self.delegate && [self.delegate respondsToSelector:@selector(showDetailedViewOfTopAFEClassSummaryView:)]){
        [self.delegate showDetailedViewOfTopAFEClassSummaryView:self];
    }
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
    
    [button.titleLabel setShadowColor:[UIColor whiteColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    
}


-(void) dealloc
{
    self.delegate = nil;
    startDate = nil;
    endDate = nil;
    scrubberView = nil;
}

@end
