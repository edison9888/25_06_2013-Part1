//
//  SearchViewController_WellSearch.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 14/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController_WellSearch.h"
#import "AFEListViewModel.h"
#import "WellName.h"
#define Begin_Date_Picker_Tag 111
#define To_Date_Picker_Tag 222

enum ButtonTouched {
    isWellComptnButtonTouched,
    isStatusButtonTouched
}buttonSelection;


@interface SearchViewController_WellSearch (){
    
    UIImageView *backgroungImage;
    UIButton *datePickerDoneButton;
    NSDate *beginDate;
    NSDate *EndDate;
    NSString *selectedString;
    BOOL isWellSearchListView;
    BOOL isSearchEnd;
    NSString *tmpPropertyId;
}
@property (strong, nonatomic) IBOutlet UILabel *statusStaticLbl;
@property (strong, nonatomic) IBOutlet UILabel *wellCompltnNamStatcLbl;
@property (strong, nonatomic) IBOutlet UITextField *wellCompnNamTextView;
@property (strong, nonatomic) IBOutlet UILabel *afeDateFromStaticLbl;
@property (strong, nonatomic) IBOutlet UILabel *afeDateFromLbl;
@property (strong, nonatomic) IBOutlet UILabel *afeDateToStaticLbl;
@property (strong, nonatomic) IBOutlet UILabel *afeDateToLbl;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *statusButton;
@property (strong, nonatomic) IBOutlet UIButton *wellNamCompltnButton;
@property (strong, nonatomic) IBOutlet UIButton *afeDateFromButton;
@property (strong, nonatomic) IBOutlet UIButton *afeDateToButton;
@property (nonatomic, retain) UIDatePicker *datePickr;
@property (nonatomic, strong) UIImageView *backgroungImage;
@property(nonatomic,strong)AFEListView *listView;
@property(nonatomic,strong)AFEListView *statusListView;
@property(nonatomic,strong)AFEListViewModel *listViewModel;
@property(nonatomic,strong)NSMutableArray *statusArray;
@property(nonatomic,strong)NSMutableArray *listValueArray;
@property (strong, nonatomic) IBOutlet UILabel *statusDynamicLbl;
@property (strong, nonatomic) IBOutlet UILabel *wellCompltnNamDynamicLbl;
@property (nonatomic,strong) WellSearchAPIHandler *wellSearchAPIHandlerObj;
@property(nonatomic, strong) NSMutableArray *apiRequestInfoObjectArray;
@property(nonatomic, strong) NSString *propertyId;
@property(nonatomic, strong) NSMutableArray *resultArray;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property(nonatomic, strong) NSMutableArray *statusValueArray;
@property(nonatomic, strong) NSDate *currentlySelectedStartDate;
@property(nonatomic, strong) NSDate *currentlySelectedEndDate;




@end 

@implementation SearchViewController_WellSearch
@synthesize wellSearchAPIHandlerObj;
@synthesize apiRequestInfoObjectArray;
@synthesize delegate;
@synthesize datePickr;
@synthesize statusStaticLbl;
@synthesize wellCompltnNamStatcLbl;
@synthesize wellCompnNamTextView;
@synthesize statusButton;
@synthesize wellNamCompltnButton;
@synthesize afeDateFromButton;
@synthesize afeDateToButton;
@synthesize afeDateFromStaticLbl;
@synthesize afeDateFromLbl;
@synthesize afeDateToStaticLbl;
@synthesize afeDateToLbl;
@synthesize searchButton;
@synthesize backgroungImage;
@synthesize listView;
@synthesize statusListView;
@synthesize listViewModel;
@synthesize statusArray;
@synthesize listValueArray;
@synthesize statusDynamicLbl;
@synthesize wellCompltnNamDynamicLbl;
@synthesize propertyId;
@synthesize resultArray;
@synthesize scrollViewContainer;
@synthesize statusValueArray;
@synthesize currentlySelectedStartDate;
@synthesize currentlySelectedEndDate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    statusArray = [[NSMutableArray alloc]init];
    [statusArray addObject:@"All"];
    [statusArray addObject:@"Active"];
    [statusArray addObject:@"Close"];
    self.listValueArray = [[NSMutableArray alloc] init];
    self.statusValueArray = [[NSMutableArray alloc] init];
    [self setFonts];
    propertyId = @"";
    tmpPropertyId =@"";
    [self.scrollViewContainer setContentSize:CGSizeMake(350, 570)];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    self.currentlySelectedStartDate = [df dateFromString:[Utility getStartDate]];
    self.currentlySelectedEndDate = [NSDate date];
    NSDate *now = [NSDate date];
    NSString *today = [Utility getStringFromDate:now];
    afeDateToLbl.text = today;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"wellCompltnName"])
        wellCompnNamTextView.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"wellCompltnName"];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"StatusOfWellSearchPopOver"])
        statusDynamicLbl.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"StatusOfWellSearchPopOver"];
    else {
        [[NSUserDefaults standardUserDefaults] setValue:statusDynamicLbl.text forKey:@"StatusOfWellSearchPopOver"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"startDateWellSearchPopOver"]){
        afeDateFromLbl.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"startDateWellSearchPopOver"];
        self.currentlySelectedStartDate = [Utility getDateFromString:afeDateFromLbl.text];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"endDateWellSearchPopOver"]){
        afeDateToLbl.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"endDateWellSearchPopOver"];
        self.currentlySelectedEndDate = [Utility getDateFromString:afeDateToLbl.text];

    }
     if([[NSUserDefaults standardUserDefaults] objectForKey:@"propertyIdWellAFE"])
         propertyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"propertyIdWellAFE"];
    //scrollViewContainer.scrollEnabled= NO;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self initializeWellSearchAPIHandlerAndRequestArray];
    
    [wellSearchAPIHandlerObj getStatusTypes];
    
}
-(void)setFonts{
    [self.wellCompltnNamStatcLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    self.wellCompltnNamStatcLbl.font = FONT_SEARCH_STATIC_LABEL_BOLD;
    [self.wellCompltnNamDynamicLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    self.wellCompltnNamDynamicLbl.font = FONT_SUMMARY_DATE;
    [self.statusStaticLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    self.statusStaticLbl.font = FONT_SEARCH_STATIC_LABEL_BOLD;
    [self.statusDynamicLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    self.statusDynamicLbl.font = FONT_SUMMARY_DATE;
    [self.afeDateFromStaticLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    self.afeDateFromStaticLbl.font = FONT_SEARCH_STATIC_LABEL_BOLD;
    [self.afeDateFromLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    self.afeDateFromLbl.font = FONT_SUMMARY_DATE;
    [self.afeDateToStaticLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    self.afeDateToStaticLbl.font = FONT_SEARCH_STATIC_LABEL_BOLD;
    [self.afeDateToLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    self.afeDateToLbl.font = FONT_SUMMARY_DATE;
}
- (void)viewDidUnload
{
    [self setWellCompltnNamStatcLbl:nil];
    [self setWellCompnNamTextView:nil];
    [self setStatusStaticLbl:nil];
    [self setStatusButton:nil];
    [self setAfeDateFromStaticLbl:nil];
    [self setAfeDateFromLbl:nil];
    [self setAfeDateToStaticLbl:nil];
    [self setAfeDateToLbl:nil];
    [self setSearchButton:nil];
    [self setAfeDateFromButton:nil];
    [self setAfeDateToButton:nil];
    [self setScrollViewContainer:nil];
   

    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(IBAction)afeDateFromBtnTouched{
    [self resignResponder];
    [self popOverViewTouched:nil];
    [self.afeDateFromButton setSelected:YES];
    CGRect rect = CGRectMake(20, 1, 318, 294);
    [self createDateTimePickerView:rect pickerTag:Begin_Date_Picker_Tag];
//    NSDate *now = [NSDate date];
//    NSString *startDate = [NSString stringWithFormat:@"01/01/%@",[Utility getYearFromDate:now]];
//[datePickr setDate:self.currentlySelectedStartDate animated:NO]; 

        //   [datePickr setDate:[Utility getDateFromString:[Utility getStartDate]]];
    
//    if([[NSUserDefaults standardUserDefaults] objectForKey:@"startDateWellSearchPopOver"]){        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
//        NSDate *defaultStartdate = [[NSDate alloc] init];
//        defaultStartdate = [dateFormatter dateFromString:[Utility getStartDate]];
//        [datePickr setDate:defaultStartdate];
//    }
    [datePickr setDate:self.currentlySelectedStartDate];
    [datePickr setMaximumDate:[NSDate date]];

}
-(IBAction)afeDateToBtnTouched{
    [self resignResponder];
    [self popOverViewTouched:nil];
    [self.afeDateToButton setSelected:YES];
    CGRect rect = CGRectMake(20, 112, 318, 303);
    [self createDateTimePickerView:rect pickerTag:To_Date_Picker_Tag];
    [datePickr setDate:self.currentlySelectedEndDate animated:NO];
    [datePickr setMaximumDate:[NSDate date]];
//    if([[NSUserDefaults standardUserDefaults] objectForKey:@"endDateWellSearchPopOver"]){        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
//        NSDate *defaultStartdate = [[NSDate alloc] init];
//        defaultStartdate = [dateFormatter dateFromString:afeDateToLbl.text];
//        [datePickr setDate:defaultStartdate];
//    }

}

-(IBAction)statusBtnTouched{
    [self resignResponder];
    isWellSearchListView =NO;
    buttonSelection = isStatusButtonTouched;
    [self popOverViewTouched:nil];
    [self.view addSubview:listView];
    [self popOverViewTouched:nil];
    [self.statusButton setSelected:YES];

    if ([statusArray count]){
        [listValueArray removeAllObjects];
        [self.statusValueArray removeAllObjects];
        for (int i = 0; i < [statusArray count]; i++) {
            listViewModel = [[AFEListViewModel alloc]init];
            listViewModel.name = [statusArray objectAtIndex:i];
            listViewModel.ID = [NSString stringWithFormat:@"%d",i];
            //NSString *tempName = [[NSUserDefaults standardUserDefaults] objectForKey:@"StatusOfWellSearchPopOver"];
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"StatusOfWellSearchPopOver"]){
                NSString *prevsValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"StatusOfWellSearchPopOver"];
                if([listViewModel.name isEqualToString:prevsValue]){
                    listViewModel.isSelected  = YES;
                }
            }
            [self.statusValueArray addObject:listViewModel];
        }
    }
    
    statusListView = [[AFEListView alloc]initWithFrame:CGRectMake(19, 206, 320, 236)];
    statusListView.delegate = self;
    statusListView.searchData = self.statusValueArray;
        // buttonSelection = isOrganizationStatusButtonTouched;
    [self.scrollViewContainer addSubview:statusListView];

}
-(IBAction)welCompltnNamBtnTouched{
    buttonSelection = isWellComptnButtonTouched;
    
    [self.wellNamCompltnButton setSelected:YES];
    
    [self popOverViewTouched:nil];
    
    if ([statusArray count]){
        
        for (int i = 0; i < [statusArray count]; i++) {
            
            listViewModel = [[AFEListViewModel alloc]init];
            
            listViewModel.name = [statusArray objectAtIndex:i];
            
            listViewModel.ID = [NSString stringWithFormat:@"%d",i];
            
            [listValueArray addObject:listViewModel];
        }
    }
    listView = [[AFEListView alloc]initWithFrame:CGRectMake(19, 100, 320, 236)];
    
    listView.delegate = self;
    
    listView.searchData = self.listValueArray;
    
    if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetWellNames]){
        
        [self.listView showActivityIndicatorOverlayView];
    }
    
    [self.view addSubview:listView];
    
    
}
-(BOOL) checkIfAPIRequestTypeAlive:(RVAPIRequestType) requestType
{
    BOOL result = NO;
    
    if(self.apiRequestInfoObjectArray){
        
        for(RVAPIRequestInfo *tempReqInfo in self.apiRequestInfoObjectArray){
            
            if(tempReqInfo.requestType == requestType){
                
                result = YES;
                
                break;                
            }
            
        }
    }
    
    return result;
}

-(IBAction)searchBtnTouched{
    [self popOverViewTouched:nil];
    [self resignResponder];
    [[NSUserDefaults standardUserDefaults] setObject:wellCompnNamTextView.text forKey:@"wellCompltnName"];
    
    [[NSUserDefaults standardUserDefaults] setObject:statusDynamicLbl.text forKey:@"StatusOfWellSearchPopOver"];
    
    [[NSUserDefaults standardUserDefaults] setObject:afeDateToLbl.text forKey:@"endDateWellSearchPopOver"];
    
    [[NSUserDefaults standardUserDefaults] setObject:afeDateFromLbl.text forKey:@"startDateWellSearchPopOver"];
    
    [[NSUserDefaults standardUserDefaults] setObject:propertyId forKey:@"propertyIdWellAFE"];
    if([wellCompnNamTextView.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Fields Empty" message:@"Please Enter a Valid Well Completion Name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else {
        if(self.delegate && [self.delegate respondsToSelector:@selector(searchWithDataWellCompltnName:withStatus:withfromDate:withTodate:withPropertyID:)]){
            
            [self.delegate searchWithDataWellCompltnName:self.wellCompltnNamDynamicLbl.text withStatus:self.statusDynamicLbl.text withfromDate:afeDateFromLbl.text withTodate:afeDateToLbl.text withPropertyID:propertyId];
            
        }
    }
    
    
    
}
- (void)createDateTimePickerView:(CGRect)rect pickerTag:(int)tag
{
    backgroungImage = [[UIImageView alloc]initWithFrame:rect];
    
    backgroungImage.image = [UIImage imageNamed:@"innerPopupDatePicker.png"];
    
    [backgroungImage setUserInteractionEnabled:YES];
    if (!datePickr){
        
        datePickr = [[UIDatePicker alloc] init];
        
        datePickr.alpha=0.75;
        
        datePickr.datePickerMode = UIDatePickerModeDate;
        
        [datePickr addTarget:self action:@selector(didPickerValueChanged:)forControlEvents:UIControlEventValueChanged];
    
    }
    datePickr.tag = tag;
    
    datePickr.frame = CGRectMake(11.5, 63,rect.size.width-25,rect.size.height-26);
    
    [datePickr setAutoresizingMask:UIViewAutoresizingNone];
    
    [scrollViewContainer addSubview:backgroungImage];
    
    [backgroungImage addSubview:datePickr];
    
    
    
    datePickerDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    datePickerDoneButton.frame = CGRectMake(205, 15, 100, 33);
    
    [datePickerDoneButton setAutoresizingMask:UIViewAutoresizingNone];

    [datePickerDoneButton setBackgroundImage:[UIImage imageNamed:@"buttonDark"] forState:UIControlStateNormal];
    
    [[datePickerDoneButton imageView] setContentMode: UIViewContentModeScaleToFill];
    
    [datePickerDoneButton addTarget:self action:@selector(popOverViewTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [datePickerDoneButton setTitle:@"Done" forState:UIControlStateNormal];
    
    [backgroungImage addSubview:datePickerDoneButton];
    
}
- (IBAction)popOverViewTouched:(id)sender 
{
    [self resignResponder];
    if (listView)
        
        [self.listView removeFromSuperview];
    
    if (statusListView)
        
        [self.statusListView removeFromSuperview];  
    
    if  (datePickr)
        
        [self.datePickr removeFromSuperview];
    
    if(backgroungImage)
        
        [self.backgroungImage removeFromSuperview];
    
    statusButton.selected = NO;
    
    afeDateToButton.selected = NO;
    
    afeDateFromButton.selected = NO;
    
}
#pragma mark - PICKER
- (IBAction)didPickerValueChanged:(id)sender 
{
    switch (datePickr.tag) {
            
        case Begin_Date_Picker_Tag:{
            
            beginDate = [datePickr date];
            self.currentlySelectedStartDate = [datePickr date];

            NSString *tempBeginDate = [self DateFormater:[datePickr date]];
            
            self.afeDateFromLbl.text = tempBeginDate;
            
            [[NSUserDefaults standardUserDefaults] setObject:afeDateFromLbl.text forKey:@"startDateWellSearchPopOver"];
        }
            break;
        case To_Date_Picker_Tag:{
            
            EndDate   = [datePickr date];
            self.currentlySelectedEndDate = [datePickr date];

            NSString *endDateStr = [self DateFormater:[datePickr date]];
            
            self.afeDateToLbl.text = endDateStr;

            
            [[NSUserDefaults standardUserDefaults] setObject:afeDateToLbl.text forKey:@"endDateWellSearchPopOver"];
        }
            break;
        default:
            break;
    }
    
    
}

- (NSString *)DateFormater:(NSDate *)date
{
    NSString *result;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    result = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    return result;
    
}

#pragma mark - 
#pragma mark AFEListView delegate


- (void)didSelectdropDownList:(NSMutableArray *)result{

    isSearchEnd = YES;
    
    if (!selectedString) 
        
        selectedString =[[NSString alloc]init];
    
    switch (buttonSelection) 
        {
            case isStatusButtonTouched:{
                
                                        for (listViewModel in statusValueArray){
                                            
                                            if (listViewModel.isSelected)
                                                
                                                selectedString = listViewModel.name;
                                        }
                                            // here make the api call to get the afe names for selected organization type
                                        self.statusDynamicLbl.text = selectedString;
                                        
                                        [[NSUserDefaults standardUserDefaults] setObject:statusDynamicLbl.text forKey:@"StatusOfWellSearchPopOver"];
                                        
                                        [self.statusButton setSelected:NO];
                                        
                                        [self popOverViewTouched:nil];
                                    }
                                    break;
            
            case isWellComptnButtonTouched:{
            
                    for (listViewModel in listValueArray) {
                        
                        if (listViewModel.isSelected){
                                //selectedString = listViewModel.name;
                            if(isWellSearchListView){
                               // WellName *tempWellName = (WellName *)[resultArray objectAtIndex:listViewModel.ID];
                                
                                WellName *tempWellName;
                                
                                for(tempWellName in resultArray){
                                    if([tempWellName.propertyID caseInsensitiveCompare:listViewModel.ID] == NSOrderedSame)
                                        break;
                                    else
                                        tempWellName = nil;
                                }
                                
                                self.propertyId = [NSString stringWithFormat:@"%@",tempWellName? tempWellName.propertyID:@""];
                                
                                tmpPropertyId = [NSString stringWithFormat:@"%@",tempWellName? tempWellName.propertyID:@""];
                                
                                wellCompnNamTextView.text = tempWellName? tempWellName.propertyName:@"";
                                
                                [wellCompnNamTextView resignFirstResponder];
                                
                            }
                        }
                    }
                    self.wellCompltnNamDynamicLbl.text = selectedString;
                        
                    [self.wellNamCompltnButton setSelected:NO];
                        
                    [self.wellCompnNamTextView resignFirstResponder];
            }
            break;
            
            default:
            break;
        }
    
    [self popOverViewTouched:nil];
    }
    
#pragma mark -
#pragma mark textfield delagte


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //scrollViewContainer.scrollEnabled= YES;
    return YES;

}
-(void) getAFENamesForAFEType:(int)afeTypeID
{
    
} 
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    isSearchEnd = YES;
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    isSearchEnd = NO;
    if (statusListView)
        
        [self.statusListView removeFromSuperview];  
    
    if(![textField.text isEqualToString:@""])
        
        [self textFieldValueChanged:nil];
    
} 
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    isSearchEnd = NO;
    return YES;
}
-(IBAction)textFieldValueChanged:(UITextField *)sender{

    if(isSearchEnd == NO){
        
        if(![sender.text isEqualToString:@""]){
            [self showListView:self.listValueArray];
            [self.listView showActivityIndicatorOverlayView];
            buttonSelection = isWellComptnButtonTouched;
            isWellSearchListView = YES;
            [self stopAllAPICalls];
            [self initializeWellSearchAPIHandlerAndRequestArray];
            [self.listView showActivityIndicatorOverlayView];
            RVAPIRequestInfo *tempRequestInfo=[wellSearchAPIHandlerObj  getWellNames:wellCompnNamTextView.text numbrOfRecod:10 status:@"ALL"];
            if(!self.apiRequestInfoObjectArray)
                self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
            [self.apiRequestInfoObjectArray removeAllObjects];
            [self.apiRequestInfoObjectArray addObject:tempRequestInfo];
              
        }
        else{
            [self stopAllAPICalls];
            [self.listValueArray removeAllObjects];
            [self popOverViewTouched:nil];
            [sender becomeFirstResponder];
            
       }
    }
      isSearchEnd = NO;   
} 
-(void) initializeWellSearchAPIHandlerAndRequestArray
{
    if (!self.wellSearchAPIHandlerObj) {
        self.wellSearchAPIHandlerObj = [[WellSearchAPIHandler alloc] init];
        wellSearchAPIHandlerObj.delegate = self;    
    }
    
    if(!self.apiRequestInfoObjectArray)
        {
        self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
        }
}

-(void) stopAllAPICalls
{
    NSMutableArray *tempRequestInfoArray;
    
    if(apiRequestInfoObjectArray)
    {
        tempRequestInfoArray = [apiRequestInfoObjectArray copy];
        
        for(RVAPIRequestInfo *tempRequestInfo in tempRequestInfoArray)
        {
            if(tempRequestInfo)
            {
                [tempRequestInfo cancelAPIRequest];
                [self removeRequestInfoObjectFromPool:tempRequestInfo];
            }
        }
    }
}

-(void) stopAPICallOfType:(RVAPIRequestType) requestType withTag:(id) tag
{
    BOOL shouldCancel = NO;
    NSMutableArray *tempRequestInfoArray;
    
    if(apiRequestInfoObjectArray)
    {
        tempRequestInfoArray = [apiRequestInfoObjectArray copy];
        
        for(RVAPIRequestInfo *tempRequestInfo in tempRequestInfoArray)
        {
            shouldCancel = NO;
            
            if(tempRequestInfo && tempRequestInfo.requestType == requestType)
            {
                if(!tempRequestInfo.tag || !tag)
                {
                    shouldCancel = YES;
                }
                else if([tag isKindOfClass:[NSString class]] && [tempRequestInfo.tag isKindOfClass:[NSString class]])
                {
                    NSString *orginalTag = (NSString*) tempRequestInfo.tag;
                    NSString *tagToCompare = (NSString*) tag;
                    
                    if([orginalTag caseInsensitiveCompare:tagToCompare] == NSOrderedSame)
                        shouldCancel = YES;
                }
                else if(tag == tempRequestInfo.tag)
                {
                    shouldCancel = YES;
                }
                
                if(shouldCancel)
                {
                    [tempRequestInfo cancelAPIRequest];
                    [self removeRequestInfoObjectFromPool:tempRequestInfo];
                }
                
            }
        }
    }
    
}

-(void) removeRequestInfoObjectFromPool:(RVAPIRequestInfo*) requestinfoObj
{
    if(apiRequestInfoObjectArray){
        [apiRequestInfoObjectArray removeObject:requestinfoObj];
    }
}
-(void) rvAPIRequestCompletedWithErrorForRequest:(RVAPIRequestInfo *)requestInfoObj
{
        //self.propertyId =@"";
    [self.listView removeActivityIndicatorOverlayView];
        //[self.listView showMessageOnView:@"No data available now!"];
    [self removeRequestInfoObjectFromPool:requestInfoObj];
    
}
-(void) rvAPIRequestCompletedSuccessfullyForRequest:(RVAPIRequestInfo *)requestInfoObj{
    
    [self removeRequestInfoObjectFromPool:requestInfoObj];
    
    self.propertyId =@"";
    switch (requestInfoObj.requestType) {
        case RVAPIRequestTypeGetWellNames:{
            [self.listView removeActivityIndicatorOverlayView];
            resultArray = (NSMutableArray *)requestInfoObj.resultObject;
            [self.listValueArray removeAllObjects];
            [listValueArray removeAllObjects];
            for (int i= 0; i<[resultArray count]; i++){
                WellName *tempWellName = (WellName*)[resultArray objectAtIndex:i];
                listViewModel = [[AFEListViewModel alloc]init];
                listViewModel.name = [NSString stringWithFormat:@"%@",tempWellName.propertyName];
                listViewModel.ID = [NSString stringWithFormat:@"%@",tempWellName.propertyID];
                [self.listValueArray addObject:listViewModel];
                if([[NSUserDefaults standardUserDefaults] objectForKey:@"wellCompltnName"]){
                    NSString *prevusValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"wellCompltnName"];
                    if([listViewModel.name isEqualToString:prevusValue])
                        listViewModel.isSelected = YES;
                }
            }
            if(!listView)
                listView = [[AFEListView alloc]initWithFrame:CGRectMake(19, 84, 320, self.view.frame.size.height-102)];
            listView.delegate = self;
            [self.scrollViewContainer addSubview:listView];
            listView.searchData = self.listValueArray;
            [listView.tableViewForList reloadData];
            break;
        }
        case RVAPIRequestTypeGetStatusTypes:{
            [self.listView removeActivityIndicatorOverlayView];
            resultArray = (NSMutableArray *)requestInfoObj.resultObject;
                //[self showListView:resultArray];
        } 
       
        default:
        break;
    }
    
    
}
-(void)showListView:(NSMutableArray*)listValues{
    if(!listView)
        listView = [[AFEListView alloc]initWithFrame:CGRectMake(19, 84, 320, self.view.frame.size.height-102)];
    listView.delegate = self;
    listView.searchData = listValues;
    [self.scrollViewContainer addSubview:listView];
    
        //listView.searchData = self.listValueArray;
    [listView.tableViewForList reloadData];

}

    //method for scrolling the container
-(void)resignResponder{
    //scrollViewContainer.scrollEnabled= NO;
    if(wellCompnNamTextView)
        [wellCompnNamTextView resignFirstResponder];
}
-(IBAction)touchedBkrnd{
    [self popOverViewTouched:nil];
    
}
-(void) setCurrentlySelectedStartDate:(NSDate *)currentlySelectedStartDateNew
{
    
    currentlySelectedStartDate = currentlySelectedStartDateNew;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyy"];
    
    if(currentlySelectedStartDate == NULL)
        {
        currentlySelectedStartDate = [NSDate dateWithTimeInterval:-3600*24*1 sinceDate:[NSDate date]];
        self.currentlySelectedEndDate = [NSDate date];
        
        }
    else
        {
        
        
        if([Utility getNumberOfEpochDaysBetweenStartDate:[Utility currentDateByIgnoringTime:YES] andEndDate:currentlySelectedStartDate shouldIgnoreTime:YES] > 0)
            currentlySelectedStartDate = [NSDate date];
        
        currentlySelectedStartDate = [df dateFromString:[df stringFromDate:self.currentlySelectedStartDate]];
        
        if([Utility getNumberOfEpochDaysBetweenStartDate:currentlySelectedStartDate andEndDate:currentlySelectedEndDate shouldIgnoreTime:YES] < 0)
            {
            self.currentlySelectedEndDate = [NSDate dateWithTimeInterval:3600*24*0 sinceDate:self.currentlySelectedStartDate];
            }
        
        }
    
    afeDateFromLbl.text = [self DateFormater:currentlySelectedStartDate];
    
}
-(void) setCurrentlySelectedEndDate:(NSDate *)currentlySelectedEndDateNew
{
    currentlySelectedEndDate = currentlySelectedEndDateNew;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyy"];
    
    if(currentlySelectedEndDate == NULL)
        {
        currentlySelectedEndDate = [NSDate date];
        self.currentlySelectedStartDate = [NSDate dateWithTimeInterval:-3600*24 sinceDate:[NSDate date]];
        
        }
    else
        {
        currentlySelectedEndDate = [df dateFromString:[df stringFromDate:self.currentlySelectedEndDate]];
        
        if([Utility getNumberOfEpochDaysBetweenStartDate:[Utility currentDateByIgnoringTime:YES] andEndDate:currentlySelectedEndDate shouldIgnoreTime:YES] > 0)
            currentlySelectedEndDate = [NSDate date];
        
        if([Utility getNumberOfEpochDaysBetweenStartDate:currentlySelectedStartDate andEndDate:currentlySelectedEndDate shouldIgnoreTime:YES] < 0)
            {
            self.currentlySelectedStartDate = [NSDate dateWithTimeInterval:-3600*24*0 sinceDate:self.currentlySelectedEndDate];
            
            }
        
        }
    
    afeDateToLbl.text = [self DateFormater:currentlySelectedEndDate];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
- (void)dealloc
{
    
}

@end
