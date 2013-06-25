//
//  ProjectWatchlistSummaryView.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProjectWatchlistSummaryView.h"
#import <QuartzCore/QuartzCore.h>
#import "AFE.h"

#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW CGRectMake(4,48,483,253)

@interface ProjectWatchlistSummaryView (){
    float width;
    float height;
    float xPos;
    float yPos;
    NSDate *startDate;
    NSDate *endDate;
        //  BOOL IsActualBtnClicked;
    
    UIActivityIndicatorView *activityIndicView;
    UIView *activityIndicContainerView;
    UIView *activityIndicBGView;
    UILabel *messageLabel;
    BOOL isCellAnimated;
    
}
@property (strong, nonatomic) IBOutlet UILabel *dateLbl;
@property (strong, nonatomic) IBOutlet UIButton *feldEstmtButton;
@property (strong, nonatomic) IBOutlet UIButton *actualsButton;
@property (strong, nonatomic) IBOutlet UIButton *detailButton;
@property (strong, nonatomic) IBOutlet UILabel *headerTitleLbl;
@property(nonatomic, strong) NSMutableArray *treeMapValues;
@property(nonatomic, strong) NSMutableArray *top5Details;
@property (nonatomic,assign)    BOOL IsActualBtnClicked;
@property (strong, nonatomic)  UIButton *backGrndBtn;
 

-(IBAction)detailedBtnClicked;

@end

@implementation ProjectWatchlistSummaryView
@synthesize dateLbl;
@synthesize actualSizeTRemember,treeMapValues;
@synthesize treeMapV,treeMapAnmtnCell,backgroundView;
@synthesize feldEstmtButton,actualsButton,detailButton;
@synthesize headerTitleLbl;
@synthesize delegate;
@synthesize afeArray;
@synthesize top5Details;
@synthesize IsActualBtnClicked;
@synthesize backGrndBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = (ProjectWatchlistSummaryView*) [[[NSBundle mainBundle] loadNibNamed:@"ProjectWatchlistSummaryView" owner:self options:nil] lastObject];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
       
    }
    return self;
}

-(void) awakeFromNib
{
    
    self.dateLbl.font = FONT_SUMMARY_DATE;
    self.dateLbl.textColor = COLOR_DASHBORD_DATE;
    self.headerTitleLbl.font = FONT_SUMMARY_HEADER_TITLE;
    self.headerTitleLbl.textColor = COLOR_SUMMARY_HEADER_TITLE;
    self.feldEstmtButton.titleLabel.font = FONT_DASHBOARD_BUTTON_DEFAULT_LABEL;
    [self.feldEstmtButton setTitleColor:COLOR_DASHBOARD_BUTTON_SELECTED_LABEL forState:UIControlStateNormal];
    [self.feldEstmtButton setTitleColor:COLOR_FONT_DASHBOARD_BUTTON_DEFAULT_LABEL forState:UIControlStateHighlighted];
        // [self setCustomFontForButton:self.feldEstmtButton];
    self.actualsButton.titleLabel.font = FONT_DASHBOARD_BUTTON_DEFAULT_LABEL;
    [self.actualsButton setTitleColor:COLOR_DASHBOARD_BUTTON_SELECTED_LABEL forState:UIControlStateNormal];
    [self.actualsButton setTitleColor:COLOR_FONT_DASHBOARD_BUTTON_DEFAULT_LABEL forState:UIControlStateHighlighted];
    
    [self setCustomFontForButton:self.actualsButton];
    [self setCustomFontForButton:self.feldEstmtButton];
    [self setCustomFontForButton:self.actualsButton];
        //  [self.feldEstmtButton setSelected:YES];
    [self.actualsButton setTitle:@"Actuals" forState:UIControlStateSelected];
    
    
    feldEstmtButton.hidden = YES;
    actualsButton.hidden = YES;
    self.treeMapValues = [[NSMutableArray alloc] init];
}


/*
 -(void)refreshDataWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*)end
{
    startDate = start;
    endDate = end;
    self.afeArray = (NSMutableArray *)afeArrayToUse;
 
    [[NSUserDefaults standardUserDefaults] setInteger:427 forKey:@"TREEMAP_WIDTH"];
    [[NSUserDefaults standardUserDefaults] setInteger:209 forKey:@"TREEMAP_HEIGHT"];
    dateLbl.text = [NSString stringWithFormat:@"%@ - %@",[Utility getStringFromDate:start],[Utility getStringFromDate:endDate]];
    [self sortArray];
    [self drawTreeGraph];

}
*/

-(void) refreshHeatMapWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end
{
    startDate = start;
    endDate = end;
    self.afeArray = (NSMutableArray *)afeArrayToUse;
    isCellAnimated = NO;
    [[NSUserDefaults standardUserDefaults] setInteger:427 forKey:@"TREEMAP_WIDTH"];
    [[NSUserDefaults standardUserDefaults] setInteger:209 forKey:@"TREEMAP_HEIGHT"];
    dateLbl.text = (startDate && endDate)? [NSString stringWithFormat:@"%@ - %@",[Utility getStringFromDate:start],[Utility getStringFromDate:endDate]]:@"";
    if(self.backGrndBtn)
        [self.backGrndBtn removeFromSuperview];
    if(self.backgroundView)
        [self.backgroundView removeFromSuperview];
    if(self.treeMapAnmtnCell)
        [self.treeMapAnmtnCell removeFromSuperview];
    [self drawTreeGraph];
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




-(void)sortArray{
    //(@"%@",self.afeArray);
    NSString *sortDescrptr = @"percntgConsmptn";
    //if(IsActualBtnClicked)
      //   sortDescrptr = @"actual";
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortDescrptr ascending:NO];
    self.afeArray = (NSMutableArray *) [self.afeArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    //(@"%@",self.afeArray);



}

-(void)drawTreeGraph{
    [self setData];
    //(@"%@",self.treeMapValues);
    treeMapV.delegate = self;
    treeMapV.dataSource = self;
    for (UIView *view in treeMapV.subviews){
        [view performSelector:@selector(removeFromSuperview)];
    }
    [self.treeMapV reloadData];
}
-(void)setData{
    
//    if(!self.treeMapValues && [self.treeMapValues isKindOfClass:[NSMutableArray class]])
//        self.treeMapValues = [[NSMutableArray alloc] init];
//    else if([self.treeMapValues isKindOfClass:[NSMutableArray class]])
        [self.treeMapValues removeAllObjects];
    
    AFE *tempAFE = [[AFE alloc] init];
    if([self.afeArray count]){
        
        int count = [self.afeArray count];
        if(4 < count)
            count = 5;
        for(int i = 0; i< count; i++){
            tempAFE = (AFE*)[self.afeArray objectAtIndex:i];
            NSNumber *num;
                // if(IsActualBtnClicked)
                //   num = [NSNumber numberWithFloat:tempAFE.actual];
                //else
            num = [NSNumber numberWithFloat:tempAFE.percntgConsmptn];
            //(@"%@",num);
            
            if(num == NULL || [num isKindOfClass:[NSNull class]])
                {
                NSLog(@"Is NUll");
                }
            if([num intValue])
                [self.treeMapValues addObject:num];
        }
    }
    
          
}

#pragma mark -

- (void)updateCell:(TreemapViewCell *)cell forIndex:(NSInteger)index {

    switch (index) {
        case 0:
            cell.backgroundColor =  [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1];            break;            
        case 1:
            cell.backgroundColor =  [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1];            break;  
        case 2:
            cell.backgroundColor =  [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1];            break;  
        case 3:
            cell.backgroundColor =  [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1];            break;  
        case 4:
            cell.backgroundColor =  [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1];            break;  
        default:
            cell.backgroundColor =  [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1];              break;
            
    }
    
}
#pragma mark -
#pragma mark TreemapView delegate

- (void)treemapView:(TreemapView *)treemapView tapped:(NSInteger)index {
    if(!isCellAnimated){
        isCellAnimated = YES;
        UIView *tmpView = (UIView*) [self.treeMapV.subviews objectAtIndex:index];
        self.actualSizeTRemember = CGRectMake(tmpView.frame.origin.x+treemapView.frame.origin.x, tmpView.frame.origin.y+treemapView.frame.origin.y, tmpView.frame.size.width, tmpView.frame.size.height);
        width = self.actualSizeTRemember.size.width;
        height = self.actualSizeTRemember.size.height;
        xPos = self.actualSizeTRemember.origin.x;
        yPos = self.actualSizeTRemember.origin.y;
        self.backGrndBtn = [[UIButton alloc] initWithFrame:CGRectMake(treemapView.frame.origin.x, treemapView.frame.origin.y, self.treeMapV.frame.size.width , self.treeMapV.frame.size.height)];
        backGrndBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:backGrndBtn];
        self.backgroundView =[[UIView alloc] initWithFrame:CGRectMake(treemapView.frame.origin.x, treemapView.frame.origin.y, self.treeMapV.frame.size.width , self.treeMapV.frame.size.height)];
        
        self.backgroundView.backgroundColor = [UIColor blackColor];
        self.backgroundView.alpha = 0.6;
        [self addSubview:self.backgroundView];
        
        self.treeMapAnmtnCell = [[TreeMapAnimationCell alloc] initWithFrame:actualSizeTRemember];
        self.treeMapAnmtnCell.backgroundColor = tmpView.backgroundColor;
            //self.treeMapAnmtnCell.frame =tmpView.frame;
        self.treeMapAnmtnCell.delegate = self;
            //self.treeMapAnmtnCell.frame = actualSizeTRemember;
        self.treeMapAnmtnCell.layer.borderColor = [UIColor whiteColor].CGColor;
        self.treeMapAnmtnCell.layer.borderWidth = 2.0;
        [self addSubview:self.treeMapAnmtnCell];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.treeMapAnmtnCell.frame = CGRectMake(treemapView.frame.origin.x+10,treemapView.frame.origin.y+10,self.treeMapV.frame.size.width -20,self.treeMapV.frame.size.height-20);
        }completion:^(BOOL finished){
            [self setLabels:index];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self 
                       action:@selector(btnTouched)
             forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor clearColor];
            button.titleLabel.text = @"Click";
            button.frame =CGRectMake(0,0,self.treeMapV.frame.size.width -20,self.treeMapV.frame.size.height-20);
            [self.treeMapAnmtnCell addSubview:button]; 
            
        }];

    }
        
}
- (void)btnTouched {
    [self removeAnimatedCell];
}
-(void)setLabels:(NSInteger)index{
    AFE *tempAFE = [[AFE alloc] init];
    tempAFE = (AFE*)[self.afeArray objectAtIndex:index];
        //[NSString stringWithFormat:@"%@",tempAFE.afeNumber];

    UIView *containerView = [[ UIView alloc ] init];
    containerView.tag = 12345;
    containerView.frame = CGRectMake((self.treeMapV.frame.size.width/2)-115,(self.treeMapV.frame.size.height/2)-53,200,100);
    containerView.backgroundColor = [UIColor clearColor];
    
    float Xcor = containerView.frame.origin.x-40-50;
    float Ycor = containerView.frame.origin.y-90;
    
    UILabel *afeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0+Xcor, 20+Ycor, 120, 20)];
    afeLbl.text = @"AFE                      ";
    [afeLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    afeLbl.backgroundColor = [UIColor clearColor];
    afeLbl.textColor = [UIColor whiteColor];
    afeLbl.textAlignment = UITextAlignmentLeft;
    afeLbl.font = FONT_DETAIL_PAGE_TAB;
    afeLbl.textColor = COLOR_PIECHART_VALUE_LABEL;

    [containerView addSubview:afeLbl];
    
    UILabel *afeNumLbl = [[UILabel alloc] initWithFrame:CGRectMake(120+Xcor, 20+Ycor, 120, 20)];
    afeNumLbl.text = [NSString stringWithFormat:@":  %@",tempAFE.afeNumber];
    [afeNumLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    afeNumLbl.backgroundColor = [UIColor clearColor];
    afeNumLbl.textColor = [UIColor whiteColor];
    afeNumLbl.textAlignment = UITextAlignmentLeft;
    afeNumLbl.font = FONT_DETAIL_PAGE_TAB;
    afeNumLbl.textColor = COLOR_PIECHART_VALUE_LABEL;

    [containerView addSubview:afeNumLbl];
    
    UILabel *afeEstimateLbl = [[UILabel alloc] initWithFrame:CGRectMake(0+Xcor, 40+Ycor, 120, 20)];
    afeEstimateLbl.text = @"AFE Estimate       ";
    [afeEstimateLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    afeEstimateLbl.backgroundColor = [UIColor clearColor];
    afeEstimateLbl.textColor = [UIColor whiteColor];
    afeEstimateLbl.textAlignment = UITextAlignmentLeft;
    afeEstimateLbl.autoresizingMask = NO;
    afeEstimateLbl.font = FONT_DETAIL_PAGE_TAB;
    afeEstimateLbl.textColor = COLOR_PIECHART_VALUE_LABEL;

    [containerView addSubview:afeEstimateLbl];
    
    UILabel *afeEstmtDataLbl = [[UILabel alloc] initWithFrame:CGRectMake(120+Xcor, 40+Ycor, 120, 20)];
    afeEstmtDataLbl.text = [NSString stringWithFormat:@":  %@",tempAFE.budgetAsStr];//tempAFE.budgetAsStr? tempAFE.budgetAsStr:@""; //[Utility formatNumber:[NSString stringWithFormat:@"%.f",tempAFE.budget]];//[NSString stringWithFormat:@"%.f",tempAFE.budget];
    [afeEstmtDataLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    afeEstmtDataLbl.backgroundColor = [UIColor clearColor];
    afeEstmtDataLbl.textColor = [UIColor whiteColor];
    afeEstmtDataLbl.textAlignment = UITextAlignmentLeft;
    afeEstmtDataLbl.font = FONT_DETAIL_PAGE_TAB;
    afeEstmtDataLbl.textColor = COLOR_PIECHART_VALUE_LABEL;

    [containerView addSubview:afeEstmtDataLbl];
    
    UILabel *accrualsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0+Xcor, 60+Ycor, 120, 20)];
    accrualsLbl.text = @"Accruals             ";
    [accrualsLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    accrualsLbl.backgroundColor = [UIColor clearColor];
    accrualsLbl.textColor = [UIColor whiteColor];
    accrualsLbl.textAlignment = UITextAlignmentLeft;
    accrualsLbl.font = FONT_DETAIL_PAGE_TAB;
    accrualsLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    
    [containerView addSubview:accrualsLbl];
    
    UILabel *accrualsDataLbl = [[UILabel alloc] initWithFrame:CGRectMake(120+Xcor, 60+Ycor, 100, 20)];
    accrualsDataLbl.text = [NSString stringWithFormat:@":  %@",[Utility formatNumber:tempAFE.fieldEstimateAsStr]];//[NSString stringWithFormat:@"%.f",tempAFE.percntgConsmptn];
    [accrualsDataLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    accrualsDataLbl.backgroundColor = [UIColor clearColor];
    accrualsDataLbl.textColor = [UIColor whiteColor];
    accrualsDataLbl.textAlignment = UITextAlignmentLeft;
    accrualsDataLbl.font = FONT_DETAIL_PAGE_TAB;
    accrualsDataLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    [containerView addSubview:accrualsDataLbl];

    
    
    UILabel *feldEstimateLbl = [[UILabel alloc] initWithFrame:CGRectMake(0+Xcor, 80+Ycor, 120, 20)];
    feldEstimateLbl.text = @"Actuals               ";
    [feldEstimateLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    feldEstimateLbl.backgroundColor = [UIColor clearColor];
    feldEstimateLbl.textColor = [UIColor whiteColor];
    feldEstimateLbl.textAlignment = UITextAlignmentLeft;
    feldEstimateLbl.font = FONT_DETAIL_PAGE_TAB;
    feldEstimateLbl.textColor = COLOR_PIECHART_VALUE_LABEL;

    [containerView addSubview:feldEstimateLbl];
    
    UILabel *fldEstmtDataLbl = [[UILabel alloc] initWithFrame:CGRectMake(120+Xcor, 80+Ycor, 120, 20)];
    fldEstmtDataLbl.text = [NSString stringWithFormat:@":  %@",tempAFE.actualsAsStr];//? tempAFE.actualsAsStr:@"";//[Utility formatNumber:[NSString stringWithFormat:@"%.f",tempAFE.fieldEstimate]];//[NSString stringWithFormat:@"%.f",tempAFE.fieldEstimate];
    [fldEstmtDataLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    fldEstmtDataLbl.backgroundColor = [UIColor clearColor];
    fldEstmtDataLbl.textColor = [UIColor whiteColor];
    fldEstmtDataLbl.textAlignment = UITextAlignmentLeft;
    fldEstmtDataLbl.font = FONT_DETAIL_PAGE_TAB;
    fldEstmtDataLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    [containerView addSubview:fldEstmtDataLbl];
    
    UILabel *totalLbl = [[UILabel alloc] initWithFrame:CGRectMake(0+Xcor, 100+Ycor, 120, 20)];
    totalLbl.text = @"Total                    ";
    [totalLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    totalLbl.backgroundColor = [UIColor clearColor];
    totalLbl.textColor = [UIColor whiteColor];
    totalLbl.textAlignment = UITextAlignmentLeft;
    totalLbl.font = FONT_DETAIL_PAGE_TAB;
    totalLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    [containerView addSubview:totalLbl];
    
    
    UILabel *totalDataLbl = [[UILabel alloc] initWithFrame:CGRectMake(120+Xcor, 100+Ycor, 150, 20)];
    totalDataLbl.text = [NSString stringWithFormat:@":  %@",tempAFE.actualPlusAccrualAsStr];
    [totalDataLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    totalDataLbl.backgroundColor = [UIColor clearColor];
    totalDataLbl.textColor = [UIColor whiteColor];
    totalDataLbl.textAlignment = UITextAlignmentLeft;
    totalDataLbl.font = FONT_DETAIL_PAGE_TAB;
    totalDataLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    [containerView addSubview:totalDataLbl];

    
    UILabel *consmpnLbl = [[UILabel alloc] initWithFrame:CGRectMake(0+Xcor, 120+Ycor, 120, 20)];
    consmpnLbl.text = @"%Consumption  ";
    [consmpnLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    consmpnLbl.backgroundColor = [UIColor clearColor];
    consmpnLbl.textColor = [UIColor whiteColor];
    consmpnLbl.textAlignment = UITextAlignmentLeft;
    consmpnLbl.font = FONT_DETAIL_PAGE_TAB;
    consmpnLbl.textColor = COLOR_PIECHART_VALUE_LABEL;

    [containerView addSubview:consmpnLbl];
    
    UILabel *consmpnDataLbl = [[UILabel alloc] initWithFrame:CGRectMake(120+Xcor, 120+Ycor, 100, 20)];
    consmpnDataLbl.text = [NSString stringWithFormat:@":  %@",[Utility formatNumber:[NSString stringWithFormat:@"%.2f\%%",tempAFE.percntgConsmptn]]];//[NSString stringWithFormat:@"%.f",tempAFE.percntgConsmptn];
    [fldEstmtDataLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    consmpnDataLbl.backgroundColor = [UIColor clearColor];
    consmpnDataLbl.textColor = [UIColor whiteColor];
    consmpnDataLbl.textAlignment = UITextAlignmentLeft;
    consmpnDataLbl.font = FONT_DETAIL_PAGE_TAB;
    consmpnDataLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    [containerView addSubview:consmpnDataLbl];
    
    
       
    
    [self.treeMapAnmtnCell addSubview:containerView];
    
}


#pragma mark -
#pragma mark TreeMapAnimationCell Delegate
-(void)removeAnimatedCell{
    [self.backgroundView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        // [self.backgroundView removeFromSuperview];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationCurveEaseInOut forView:self.treeMapAnmtnCell cache:YES];
    [self addSubview:treeMapAnmtnCell];
    self.treeMapAnmtnCell.frame = self.actualSizeTRemember;
    [UIView setAnimationDidStopSelector:@selector(myAnimationStopped)];
    
    [UIView commitAnimations];
    [self.treeMapAnmtnCell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *ViewTmp = [self.treeMapV viewWithTag:12345];
    if(ViewTmp){
        [ViewTmp removeFromSuperview];
    }
    isCellAnimated = NO;

}
-(void)myAnimationStopped {
    [self.treeMapAnmtnCell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.treeMapAnmtnCell removeFromSuperview];
    [self.backgroundView removeFromSuperview];
    [self.backGrndBtn removeFromSuperview];
    [self.treeMapV reloadData];
}

#pragma mark -
#pragma mark TreemapView data source

- (NSArray *)valuesForTreemapView:(TreemapView *)treemapView {
    return self.treeMapValues;
}

- (TreemapViewCell *)treemapView:(TreemapView *)treemapView cellForIndex:(NSInteger)index forRect:(CGRect)rect {
	TreemapViewCell *cell = [[TreemapViewCell alloc] initWithFrame:rect];
    UILabel *fldEstmtDataLbl = [[UILabel alloc] init];
    CGFloat widthLbl = rect.size.width;
    UIView *tmpV = [[UIView alloc] initWithFrame:CGRectMake((rect.size.width/2)-(widthLbl/2),(rect.size.height/2)-10 , widthLbl, 20)];
    tmpV.backgroundColor = [UIColor clearColor];
    [cell addSubview:tmpV];
    fldEstmtDataLbl.frame = CGRectMake(0, 0 , widthLbl, 20);
        // fldEstmtDataLbl.frame = CGRectMake((rect.size.width/2)-(widthLbl/2),(rect.size.height/2)-10 , widthLbl, 20);
        // fldEstmtDataLbl.frame = CGRectMake((rect.size.width/2)-40,(rect.size.height/2)-10 , 80, 20);
    if(rect.size.width < 50){
        fldEstmtDataLbl.frame = CGRectMake(rect.origin.x, (rect.size.height/2)-40,rect.size.width, 20); 
    }
    AFE *tempAFE = [[AFE alloc] init];
    tempAFE = (AFE*)[self.afeArray objectAtIndex:index];
    fldEstmtDataLbl.text = [NSString stringWithFormat:@"%@",tempAFE.afeNumber];
    fldEstmtDataLbl.backgroundColor = [UIColor clearColor];
    fldEstmtDataLbl.textAlignment = UITextAlignmentCenter;
    fldEstmtDataLbl.font = FONT_DETAIL_PAGE_TAB;
    fldEstmtDataLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    [tmpV addSubview:fldEstmtDataLbl];
    [cell bringSubviewToFront:tmpV];
    [self updateCell:cell forIndex:index];
    
	return cell;
}

- (void)treemapView:(TreemapView *)treemapView updateCell:(TreemapViewCell *)cell forIndex:(NSInteger)index forRect:(CGRect)rect {
	[self updateCell:cell forIndex:index];
}

-(IBAction)feldEstmtBtnTouched:(id) sender{
    
    self.IsActualBtnClicked = NO;
    [self.actualsButton setSelected:self.feldEstmtButton.selected];
    [self.feldEstmtButton setSelected:!self.feldEstmtButton.selected];
    [self.feldEstmtButton setUserInteractionEnabled:NO];
    [self.actualsButton setUserInteractionEnabled:YES];
    [self sortArray];
    [self drawTreeGraph];

}

-(IBAction)actualsBtnTouched
{

    [self.feldEstmtButton setSelected:self.actualsButton.selected];
    [self.actualsButton setSelected:!self.actualsButton.selected];
    [self.actualsButton setUserInteractionEnabled:NO];
    [self.feldEstmtButton setUserInteractionEnabled:YES];
    self.IsActualBtnClicked= YES;
    [self sortArray];
    [self drawTreeGraph];

}
-(IBAction)detailedBtnClicked{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(showDetailedViewOfProjectWatchlistSummaryView:)]){
        [self.delegate showDetailedViewOfProjectWatchlistSummaryView:self];
    }

}

-(void) setCustomFontForButton:(UIButton *)button
{
    button.titleLabel.font = FONT_DASHBOARD_BUTTON_DEFAULT_LABEL;
    [button setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateSelected];
    [button setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    [button setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateSelected];
    [button setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    
    [button setTitleColor:[Utility getUIColorWithHexString:@"192835"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"buttonDark"] forState:UIControlStateSelected];
    [button.titleLabel setShadowColor:[UIColor whiteColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    
}

-(void) dealloc
{
    self.delegate = nil;
    startDate = nil;
    endDate = nil;
    self.afeArray = nil;
    self.backgroundView = nil;
    self.treeMapAnmtnCell = nil;
}


@end
