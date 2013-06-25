//
//  OrgSearchController.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OrganizationSearchController.h"
#import "AFEListViewModel.h"

#import "OrganizationType.h"
#import "Organization.h"

enum ButtonTouched {
    
    ButtonTouchedNone,
    ButtonTouchedOrganizationType,
    ButtonTouchedOrganizationName,
    ButtonTouchedOrganizationStatus
}buttonSelection;

#define Begin_Date_Picker_Tag 0
#define End_Date_Picker_Tag 1

@interface OrganizationSearchController ()
{
    NSMutableArray *organisationTypeArray;
    NSMutableArray *organisationsArray;    
    NSMutableDictionary *organisationsDictionary;
    
    BOOL isAutoSearchRunning;
}

@property (strong, nonatomic) IBOutlet UILabel *organizationLabel;
@property (strong, nonatomic) IBOutlet UILabel *organizationNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *organizationStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *organizationBeginDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *organizationEndDateLabel;


@property(nonatomic, strong) NSString *currentlySelectedOrgType;
@property(nonatomic, strong) NSString *currentlySelectedOrgID;
@property(nonatomic, strong) NSString *currentlySelectedStatus;
@property(nonatomic, strong) NSDate *currentlySelectedStartDate;
@property(nonatomic, strong) NSDate *currentlySelectedEndDate;
@property(nonatomic, strong) NSString *currentlySelectedOrgName;
//@property(nonatomic,strong)NSMutableArray *orgStatusSearchArray;
@property (nonatomic,strong) UIPopoverController *searchPopOver;
@property (nonatomic, retain) UIDatePicker *datePickr;
@property(nonatomic,strong)AFEListView *listView;
@property(nonatomic,strong)AFEListViewModel *listViewModel;
@property(nonatomic,strong) NSString *selectedString;

@property(nonatomic,strong)UIImageView *backgroungImage;
@property (nonatomic,strong) UIButton *datePickerDoneButton;

@property (nonatomic,strong) NSMutableArray *orgTypeArray;
@property (nonatomic,strong) NSMutableArray *orgNameArray;

@property(nonatomic, strong) OrganizationSearchAPIHandler *apiHandlerOrgSummary;
@property(nonatomic, strong) NSMutableArray *apiRequestInfoObjectArray;

- (IBAction)didPickerValueChanged:(id)sender;
- (IBAction)OrganizationButtonTouched:(id)sender;
- (IBAction)OrganizationNameButtonTouched:(id)sender;
- (IBAction)OrganizationSatusButtonTouched:(id)sender;
- (IBAction)OrganizationBeginDateButtonTouched:(id)sender;
- (IBAction)OrganizationEndDateButtonTouched:(id)sender;
- (IBAction)popOverViewTouched:(id)sender;
- (void)createDateTimePickerView:(CGRect)rect pickerTag:(int)tag;
- (void)loadListViewDatas;


- (NSString *)DateFormater:(NSDate *)date;
-(void) initializeOrgSummaryAPIHandlerAndRequestArray;
-(void) stopAllAPICalls;
-(void) getAllOrganisationTypesFromService;
-(void) removeRequestInfoObjectFromPool:(RVAPIRequestInfo*) requestinfoObj;
-(BOOL) checkIfAllOrganisationsRetrivedForAllOrgTypes;
-(void) getOrganisationForOrgTypeFromService:(NSString*) type;
-(void) loadSettingsFromNSUserDefaults;
-(void) saveSettingsToNSUserDefaults;
-(BOOL) checkIfAPIRequestTypeAlive:(RVAPIRequestType) requestType;
-(NSMutableArray*) getListViewModelArrayForOrgTypes;
-(NSMutableArray*) getListViewModelArrayForOrganisations;
-(NSMutableArray*) getListViewModelArrayForOrgStatus;

@end

@implementation OrganizationSearchController
@synthesize searchButton;
@synthesize searchPopOver;
@synthesize organizationLabel;
@synthesize organizationNameLabel;
@synthesize organizationStatusLabel;
@synthesize organizationBeginDateLabel;
@synthesize organizationEndDateLabel;
//@synthesize orgStatusSearchArray;
@synthesize listView;
@synthesize datePickr;
@synthesize listViewModel;
@synthesize selectedString;
@synthesize backgroungImage;
@synthesize delegate;
@synthesize organizationButton;
@synthesize organizationNameButton;
@synthesize statusButton;
@synthesize beginDateButton;
@synthesize endDateButton;

@synthesize currentlySelectedOrgID;
@synthesize currentlySelectedOrgType;
@synthesize currentlySelectedStatus;
@synthesize currentlySelectedStartDate;
@synthesize currentlySelectedOrgName;
@synthesize currentlySelectedEndDate;
@synthesize orgNameArray;
@synthesize orgTypeArray;
@synthesize datePickerDoneButton;
@synthesize apiHandlerOrgSummary, apiRequestInfoObjectArray;
@synthesize isAutoSearchRunning = isAutoSearchRunning;

NSMutableArray *organizationStatusListArray;

NSDate *beginDate;
NSDate *EndDate;

#pragma mark- Memory Management
- (void)viewDidUnload
{

    [self setOrganizationLabel:nil];
    [self setOrganizationNameLabel:nil];
    [self setOrganizationStatusLabel:nil];
    [self setOrganizationBeginDateLabel:nil];
    [self setOrganizationEndDateLabel:nil];
    [self setSearchButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark- Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
    }
    return self;
}

#pragma  mark- Life Cycle

-(void) setFonts
{
    [staticOrgType setFont:FONT_SEARCH_STATIC_LABEL_BOLD];
    [staticOrgType setTextColor:[Utility getUIColorWithHexString:@"28374C"]];
    [staticOrgName setFont:FONT_SEARCH_STATIC_LABEL_BOLD];
    [staticOrgName setTextColor:[Utility getUIColorWithHexString:@"28374C"]];
    [staticOrgStatus setFont:FONT_SEARCH_STATIC_LABEL_BOLD];
    [staticOrgStatus setTextColor:[Utility getUIColorWithHexString:@"28374C"]];
    [staticOrgBeginDate setFont:FONT_SEARCH_STATIC_LABEL_BOLD];
    [staticOrgBeginDate setTextColor:[Utility getUIColorWithHexString:@"28374C"]];
    [staticOrgEndDate setFont:FONT_SEARCH_STATIC_LABEL_BOLD];
    [staticOrgEndDate setTextColor:[Utility getUIColorWithHexString:@"28374C"]];
    
    [self.organizationLabel setFont:FONT_SEARCH_VALUE_LABEL];
    [self.organizationLabel  setTextColor:[Utility getUIColorWithHexString:@"28374C"]];
    [self.organizationNameLabel setFont:FONT_SEARCH_VALUE_LABEL];
    [self.organizationNameLabel setTextColor:[Utility getUIColorWithHexString:@"28374C"]];
    [self.organizationStatusLabel setFont:FONT_SEARCH_VALUE_LABEL];
    [self.organizationStatusLabel setTextColor:[Utility getUIColorWithHexString:@"28374C"]];
    [self.organizationBeginDateLabel setFont:FONT_SEARCH_VALUE_LABEL];
    [self.organizationBeginDateLabel setTextColor:[Utility getUIColorWithHexString:@"28374C"]];
    [self.organizationEndDateLabel setFont:FONT_SEARCH_VALUE_LABEL];
    [self.organizationEndDateLabel setTextColor:[Utility getUIColorWithHexString:@"28374C"]];
    
    [self.searchButton.titleLabel setFont:FONT_SEARCH_STATIC_LABEL_BOLD];
    [self.searchButton.titleLabel setTextColor:[Utility getUIColorWithHexString:@"402C09"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setFonts];
//    [self loadListViewDatas];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    buttonSelection = ButtonTouchedNone;

    if(!isAutoSearchRunning)
    {
        [self loadSettingsFromNSUserDefaults];    
        [self getAllOrganisationTypesFromService];
    }
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self popOverViewTouched:nil];
    
}

- (void)loadListViewDatas
{
    
//    if (!orgStatusSearchArray) {
//        
//        orgStatusSearchArray = [[NSMutableArray alloc]init];
//    }
    
    
    organizationStatusListArray = [[NSMutableArray alloc]init];
    [organizationStatusListArray addObject:@"ALL"];
    [organizationStatusListArray addObject:@"Active"];
    [organizationStatusListArray addObject:@"Close"];
    
    
    //Dates Display
    beginDate = [NSDate date];
    EndDate   = [NSDate date];
    NSString *beginDate = [self DateFormater:[NSDate date]];
    self.organizationBeginDateLabel.text = beginDate;

    self.organizationEndDateLabel.text = beginDate;
    
}

//- (void)createListView:(CGRect)rect ArrayForListViewDisplay:(NSMutableArray *)listArray
//{
//    [self popOverViewTouched:nil];
//    if (!listView) {
//        
//        listView = [[AFEListView alloc]initWithFrame:CGRectMake(8, 85, 340, 236)];
//        listView.delegate = self;
//    }
//
//    [self.view addSubview:listView];
//}

- (void)createDateTimePickerView:(CGRect)rect pickerTag:(int)tag
{
    [self popOverViewTouched:nil];
    backgroungImage = [[UIImageView alloc]initWithFrame:rect];
    backgroungImage.image = [UIImage imageNamed:@"innerPopupDatePicker.png"];
    [backgroungImage setUserInteractionEnabled:YES];
    if (!datePickr) {
        
        datePickr = [[UIDatePicker alloc] init];
        datePickr.alpha=0.75;
        datePickr.datePickerMode = UIDatePickerModeDate;
        [datePickr addTarget:self action:@selector(didPickerValueChanged:)forControlEvents:UIControlEventValueChanged];
    }
    datePickr.tag = tag;
    datePickr.frame = CGRectMake(11.5, 63,rect.size.width-25,rect.size.height-26);
    [self.view addSubview:backgroungImage];
    [backgroungImage addSubview:datePickr];
    
    datePickerDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    datePickerDoneButton.frame = CGRectMake(205, 15, 100, 33);
    [datePickerDoneButton setBackgroundImage:[UIImage imageNamed:@"buttonDark"] forState:UIControlStateNormal];
    [[datePickerDoneButton imageView] setContentMode: UIViewContentModeScaleToFill];
    [datePickerDoneButton addTarget:self action:@selector(popOverViewTouched:) forControlEvents:UIControlEventTouchUpInside];
    [datePickerDoneButton setTitle:@"Done" forState:UIControlStateNormal];
    [backgroungImage addSubview:datePickerDoneButton];
 
}


- (NSString *)DateFormater:(NSDate *)date
{
    NSLog(@"DATE %@",date);
    NSString *result;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    result = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    NSLog(@"Date %@",result);
    return result;
    

}

#pragma mark- Button Events
- (IBAction)OrganizationButtonTouched:(id)sender
{
    [self popOverViewTouched:nil];
    [self.organizationButton setSelected:YES];

    listView = [[AFEListView alloc]initWithFrame:CGRectMake(13, 91, 320, 236)];
    listView.delegate = self;
    
    if(!organisationTypeArray || organisationTypeArray.count <= 0)
    {
        listView.searchData = [[NSMutableArray alloc] init];
        
        [self getAllOrganisationTypesFromService];
        
    }
    else
    {
        self.listView.searchData = [self getListViewModelArrayForOrgTypes];
    }
    
    if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetOrganizationTypes])
    {
        [self.listView showActivityIndicatorOverlayView];
    }
    
    
    buttonSelection = ButtonTouchedOrganizationType;
    [self.view addSubview:listView];
    
    
}

- (IBAction)OrganizationNameButtonTouched:(id)sender 
{
   // Organization *tempOrg;
    
    [self popOverViewTouched:nil];
    [self.organizationNameButton setSelected:YES];
    listView = [[AFEListView alloc]initWithFrame:CGRectMake(13, 189.5, 320, 236)];
    listView.delegate = self;
    
    if(!organisationsArray || organisationTypeArray.count <= 0)
    {
        organisationsArray = [[NSMutableArray alloc] init];
        
       /* tempOrg = [[Organization alloc] init];
        tempOrg.orgName = @"ALL";
        tempOrg.orgID = @"ALL";
        [organisationsArray addObject:tempOrg];
        */
        
        listView.searchData = [self getListViewModelArrayForOrganisations];
        
        if(self.currentlySelectedOrgType)
            [self getOrganisationForOrgTypeFromService:self.currentlySelectedOrgType];
        
    }
    else
    {   
        self.listView.searchData = [self getListViewModelArrayForOrganisations];
    }
    
    if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetOrganizations])
    {
        [self.listView showActivityIndicatorOverlayView];
    }

    
    buttonSelection = ButtonTouchedOrganizationName;
    [self.view addSubview:listView];
}

- (IBAction)OrganizationSatusButtonTouched:(id)sender
{
    [self popOverViewTouched:nil];
    [self.statusButton setSelected:YES];
    
    listView = [[AFEListView alloc]initWithFrame:CGRectMake(13, 289.5, 320, 236)];
    listView.delegate = self;
    listView.searchData = [self getListViewModelArrayForOrgStatus];
    buttonSelection = ButtonTouchedOrganizationStatus;
    [self.view addSubview:listView];

}


-(NSMutableArray*) getListViewModelArrayForOrgTypes
{
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    AFEListViewModel *tempListModel;
    
    if(organisationTypeArray)
    {
        for(OrganizationType *tempOrgType in organisationTypeArray)
        {
            tempListModel = [[AFEListViewModel alloc] init];
            
            tempListModel.ID = tempOrgType.type;
            tempListModel.name = tempOrgType.displayName;
            
            if(self.currentlySelectedOrgType && [tempOrgType.type caseInsensitiveCompare:self.currentlySelectedOrgType] == NSOrderedSame)
                tempListModel.isSelected = YES;
            else
                tempListModel.isSelected = NO;
            
            [tempArray addObject:tempListModel];
        }
    }
    
    return tempArray;
}

-(NSMutableArray*) getListViewModelArrayForOrganisations
{
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    AFEListViewModel *tempListModel;
    
    if(organisationsArray)
    {
        if(organisationsArray)
            for(Organization *tempOrg in organisationsArray)
            {
                tempListModel = [[AFEListViewModel alloc] init];
                
                tempListModel.ID = tempOrg.orgID;
                tempListModel.name = tempOrg.orgName;
                
                if(self.currentlySelectedOrgID && [tempOrg.orgID caseInsensitiveCompare:self.currentlySelectedOrgID] == NSOrderedSame)
                    tempListModel.isSelected  = YES;
                else
                    tempListModel.isSelected = NO;
                
                [tempArray addObject:tempListModel];
                
            }
    }
    
    return tempArray;
}

-(NSMutableArray*) getListViewModelArrayForOrgStatus
{
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    AFEListViewModel *tempListModel;
    
    if(organizationStatusListArray)
    {
        int i = 0;
        for(NSString *tempStatus in organizationStatusListArray)
        {
            i++;
            tempListModel = [[AFEListViewModel alloc] init];
            
            tempListModel.ID = [NSString stringWithFormat:@"%d",i];
            tempListModel.name = tempStatus;
            
            if(self.currentlySelectedStatus && [tempStatus caseInsensitiveCompare:self.currentlySelectedStatus] == NSOrderedSame)
                tempListModel.isSelected = YES;
            else
                tempListModel.isSelected = NO;
            
            [tempArray addObject:tempListModel];
        }
    }
    
    return tempArray;
}

-(void) setCurrentlySelectedOrgType:(NSString*) type
{
    if(!type || [self.currentlySelectedOrgType caseInsensitiveCompare:type] != NSOrderedSame)
    {
        self.currentlySelectedOrgID = NULL;
    }
    
    currentlySelectedOrgType = type;
    
    if(self.currentlySelectedOrgType != NULL && organisationTypeArray)
    {
        OrganizationType *tempOrgType;
        
        for(tempOrgType in organisationTypeArray)
        {
            if([tempOrgType.type caseInsensitiveCompare:self.currentlySelectedOrgType] == NSOrderedSame)
            {
                organizationLabel.text = tempOrgType.displayName;
                break;
            }
            else
                organizationLabel.text = @"";
        }
    }
    else
        organizationLabel.text = @"";
    
    
    
}

-(void) setCurrentlySelectedOrgID:(NSString*) orgID
{
    currentlySelectedOrgID = orgID;
    
    if(self.currentlySelectedOrgID == NULL)
    {
        organizationNameLabel.text = @"";
    }
    else if(self.currentlySelectedOrgID != NULL && organisationsArray)
    {
        Organization *tempOrg;
        
        for(tempOrg in organisationsArray)
        {
            if([tempOrg.orgID caseInsensitiveCompare:orgID] == NSOrderedSame)
            {
                organizationNameLabel.text = tempOrg.orgName;
                currentlySelectedOrgName = tempOrg.orgName;
                break;
            }
            else
            {
                currentlySelectedOrgName = @"";
                organizationNameLabel.text = @"";
            }

        }
    }
    else
    {
        currentlySelectedOrgName = @"";
        organizationNameLabel.text = @"";
    }
    
}

-(void) setCurrentlySelectedStatus:(NSString *)currentlySelectedStatusNew
{
    currentlySelectedStatus = currentlySelectedStatusNew;
    
    if(self.currentlySelectedStatus == NULL)
    {
        currentlySelectedStatus = @"Active";
        organizationStatusLabel.text = @"";
    }
    else if(self.currentlySelectedStatus != NULL)
    {
        NSString *tempStatus;
        
        for(tempStatus in organizationStatusListArray)
        {
            if([tempStatus caseInsensitiveCompare:self.currentlySelectedStatus] == NSOrderedSame)
            {
                organizationStatusLabel.text = tempStatus;
                break;
            }
            else
                organizationStatusLabel.text = @"";
        }
    }
    else
        organizationStatusLabel.text = @"";
}

-(void) setCurrentlySelectedStartDate:(NSDate *)currentlySelectedStartDateNew
{
    
    currentlySelectedStartDate = currentlySelectedStartDateNew;
    
    if(currentlySelectedStartDate == NULL)
    {
        currentlySelectedStartDate = [NSDate dateWithTimeInterval:-3600*24 sinceDate:[NSDate date]];
        currentlySelectedEndDate = [NSDate date];
    
    }
    
    organizationBeginDateLabel.text = [self DateFormater:currentlySelectedStartDate];
    
}

-(void) setCurrentlySelectedEndDate:(NSDate *)currentlySelectedEndDateNew
{
    currentlySelectedEndDate = currentlySelectedEndDateNew;
    
    if(currentlySelectedEndDate == NULL)
    {
        currentlySelectedEndDate = [NSDate date];
        currentlySelectedStartDate = [NSDate dateWithTimeInterval:-3600*24 sinceDate:[NSDate date]];
        
    }
    
    organizationEndDateLabel.text = [self DateFormater:currentlySelectedEndDate];
    
}


- (IBAction)OrganizationBeginDateButtonTouched:(id)sender 
{
    CGRect rect = CGRectMake(14, 50, 318, 303);
    [self createDateTimePickerView:rect pickerTag:Begin_Date_Picker_Tag];
    [datePickr setDate:self.currentlySelectedStartDate animated:NO]; 
    [self.beginDateButton setSelected:YES];
}

- (IBAction)OrganizationEndDateButtonTouched:(id)sender
{
    CGRect rect = CGRectMake(14, 150, 318, 303);
    [self createDateTimePickerView:rect pickerTag:End_Date_Picker_Tag];
    [datePickr setDate:self.currentlySelectedEndDate animated:NO];
    [self.endDateButton setSelected:YES];
}

- (IBAction)popOverViewTouched:(id)sender 
{
    if (listView)
    {
        [self.listView removeFromSuperview];
        [self.organizationButton setSelected:NO];
        [self.organizationNameButton setSelected:NO];
        [self.statusButton setSelected:NO];
    }
    if  (datePickr)
    {
        [self.datePickr removeFromSuperview];
        [self.beginDateButton setSelected:NO];
        [self.endDateButton setSelected:NO];
    }
    if(backgroungImage)
        [self.backgroungImage removeFromSuperview];
    
    buttonSelection = ButtonTouchedNone;

}

#pragma mark - Loading form NSUserdefaults
-(void) loadSettingsFromNSUserDefaults
{
    if(!organizationStatusListArray)
        organizationStatusListArray = [[NSMutableArray alloc]init];
    else
        [organizationStatusListArray removeAllObjects];
    
    [organizationStatusListArray addObject:@"ALL"];
    [organizationStatusListArray addObject:@"Active"];
    [organizationStatusListArray addObject:@"Close"];
    
    self.currentlySelectedOrgType = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaultsKeyOrganisationSearchCurrentOrgTypeSelected];
    self.currentlySelectedOrgID = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaultsKeyOrganisationSearchCurrentOrgIDSelected];
    
    self.currentlySelectedStatus = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaultsKeyOrganisationSearchCurrentStatusSelected];
    
    self.currentlySelectedStartDate = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaultsKeyOrganisationSearchCurrentStartDateSelected];
    
    self.currentlySelectedEndDate = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaultsKeyOrganisationSearchCurrentEndDateSelected];
    
    
}

-(void) saveSettingsToNSUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:self.currentlySelectedOrgType forKey:NSUserDefaultsKeyOrganisationSearchCurrentOrgTypeSelected];
    [[NSUserDefaults standardUserDefaults] setObject:self.currentlySelectedOrgID forKey:NSUserDefaultsKeyOrganisationSearchCurrentOrgIDSelected];
    [[NSUserDefaults standardUserDefaults] setObject:self.currentlySelectedStatus forKey:NSUserDefaultsKeyOrganisationSearchCurrentStatusSelected];
    [[NSUserDefaults standardUserDefaults] setObject:self.currentlySelectedStartDate forKey:NSUserDefaultsKeyOrganisationSearchCurrentStartDateSelected];
    [[NSUserDefaults standardUserDefaults] setObject:self.currentlySelectedEndDate forKey:NSUserDefaultsKeyOrganisationSearchCurrentEndDateSelected];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentlySelectedOrgName forKey:NSUserDefaultsKeyOrganisationSearchCurrentOrgNameSelected];
    
}


#pragma mark - PICKER
- (IBAction)didPickerValueChanged:(id)sender 
{
    NSLog(@"Date %@",[datePickr date]);
//    [self popOverViewTouched:nil];
    
    switch (datePickr.tag) {
        case Begin_Date_Picker_Tag:{
            self.currentlySelectedStartDate = [datePickr date];
        }
            break;
        case End_Date_Picker_Tag:{
            self.currentlySelectedEndDate = [datePickr date];
        }
            break;
            
        default:
            break;
    }
 
    
}
#pragma mark- List View Delegate
- (void)didSelectdropDownList:(NSMutableArray *)result
{
    if (!selectedString) 
        selectedString =[[NSString alloc]init];
    
    switch (buttonSelection) 
    {
        case ButtonTouchedOrganizationType:
        {
            AFEListViewModel *tempListModel;
            OrganizationType *tempOrgType;
            BOOL isFound = NO;
            
            for (tempListModel in result)
            {
                if (tempListModel.isSelected)
                {
                    break;
                }
                else
                    tempListModel = nil;
            }
            
            if(tempListModel && organisationTypeArray)
            {
                    for(tempOrgType  in organisationTypeArray)
                    {
                        if([tempOrgType.type caseInsensitiveCompare:tempListModel.ID] == NSOrderedSame)
                        {
                            isFound = YES;
                            break;
                        }
                            
                    }
            }

            // here make the api call to get the organization names for selected organization type
            if(isFound)
            {
                //self.organizationLabel.text = tempOrgType.displayName;
                self.currentlySelectedOrgType = tempOrgType.type;
                
                [self getOrganisationForOrgTypeFromService:currentlySelectedOrgType];
                
            }
            else
                self.currentlySelectedOrgType = NULL;
            
            
            [self.organizationButton setSelected:NO];
            break;
        }
        case ButtonTouchedOrganizationName:
        {
            AFEListViewModel *tempListModel;
            Organization *tempOrg;
            BOOL isFound = NO;
            
            for (tempListModel in result)
            {
                if (tempListModel.isSelected)
                {
                    break;
                }
                else
                    tempListModel = nil;
            }
            
            if(tempListModel && organisationsArray)
            {
                    for(tempOrg  in organisationsArray)
                    {
                        if([tempOrg.orgID caseInsensitiveCompare:tempListModel.ID] == NSOrderedSame)
                        {
                            isFound = YES;
                            break;
                        }
                        
                    }
            }
                    
            if(isFound)
            {
                self.currentlySelectedOrgID = tempOrg.orgID;
                
            }
            else
                 self.currentlySelectedOrgID = NULL;
            
            
            [self.organizationButton setSelected:NO];
            break;
        }
        case ButtonTouchedOrganizationStatus:
        {
            AFEListViewModel *tempListModel;
            NSString *tempStatus;
            BOOL isFound = NO;

            for (tempListModel in result)
            {
                if (tempListModel.isSelected)
                {
                    break;
                }
                else
                    tempListModel = nil;
            }
            
            if(tempListModel && organizationStatusListArray)
            {
                for(tempStatus  in organizationStatusListArray)
                {
                    if([tempStatus caseInsensitiveCompare:tempListModel.name] == NSOrderedSame)
                    {
                        isFound = YES;
                        break;
                    }
                    
                }
            }
            
            if(isFound)
                self.currentlySelectedStatus = tempStatus;
        
            [self.statusButton setSelected:NO];
            break;
        }
        default:
            break;
    }
    
    [self popOverViewTouched:nil];
}


- (IBAction)searchButtonClicked:(id)sender 
{
    if(!isAutoSearchRunning)
    {
        [self popOverViewTouched:nil];
    }
    
    [self saveSettingsToNSUserDefaults];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(searchWithDataOrganizationType:organizationID:status:begingDate:endDate:)])
    {
//        [[NSUserDefaults standardUserDefaults] setObject:organizationLabel.text forKey:@"organizationType"];
        
//        [[NSUserDefaults standardUserDefaults] setObject:organizationBeginDateLabel.text forKey:@"organizationBeginDate"];
//        [[NSUserDefaults standardUserDefaults] setObject:organizationEndDateLabel.text forKey:@"organizationEndDate"];
        
        [self.delegate searchWithDataOrganizationType:organizationLabel.text organizationID:organizationNameLabel.text status:organizationStatusLabel.text begingDate:organizationBeginDateLabel.text endDate:organizationEndDateLabel.text];
    }
   
    isAutoSearchRunning = NO;
}


#pragma mark - After receiving Response from Service

-(void) didReceiveAllOrganisationTypeFromService
{
    if(isAutoSearchRunning)
    {
        if(organisationTypeArray && organisationTypeArray.count > 0)
        {
            OrganizationType *tempOrgType = [organisationTypeArray objectAtIndex:0];
           
            if(tempOrgType)
            {
                self.currentlySelectedOrgType = tempOrgType.type;
                
                [self getOrganisationForOrgTypeFromService:self.currentlySelectedOrgType];
            }
                
        }
    }
    else if(buttonSelection == ButtonTouchedOrganizationType)
    {
        if(self.listView)
        {
            [self.listView removeActivityIndicatorOverlayView];
            self.listView.searchData = [self getListViewModelArrayForOrgTypes];
            [self.listView reloadData];
            
            if(!organisationTypeArray || organisationTypeArray.count == 0)
            {
                [self.listView showMessageOnView:@"No data available now!"];
            }
            else
            {
                [self.listView hideMessageOnView];
            }

        }
    }
}

-(void) didReceiveOrganisationForCurrentOrgType
{
    if(isAutoSearchRunning)
    {
        if(organisationsArray && organisationsArray.count > 0)
        {
            Organization *tempOrganisation = [organisationsArray objectAtIndex:0];
            
            if(tempOrganisation)
            {
                self.currentlySelectedOrgID = tempOrganisation.orgID;
                
                self.currentlySelectedStatus = (organizationStatusListArray && organizationStatusListArray.count > 0)? [organizationStatusListArray objectAtIndex:1]:@"Active";
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"MM/dd/yyyy"];
           
                self.currentlySelectedStartDate = [df dateFromString:[Utility getStartDate]];
                self.currentlySelectedEndDate = [NSDate date];
                
                [self searchButtonClicked:searchButton];
                
                isAutoSearchRunning = NO;
            }
            
        }
    }
    else if(buttonSelection == ButtonTouchedOrganizationName)
    {
        if(self.listView)
        {
            [self.listView removeActivityIndicatorOverlayView];
            self.listView.searchData = [self getListViewModelArrayForOrganisations];
            [self.listView reloadData];
            
            if(!organisationsArray || organisationsArray.count == 0)
            {
                [self.listView showMessageOnView:@"No data available now!"];
            }
            else
            {
                [self.listView hideMessageOnView];
            }
            
        }
    }
}


#pragma mark - API Handler mehtods

-(void) initializeOrgSummaryAPIHandlerAndRequestArray
{
    if (!self.apiHandlerOrgSummary) {
        self.apiHandlerOrgSummary = [[OrganizationSearchAPIHandler alloc] init];
        apiHandlerOrgSummary.delegate = self;    
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
                [tempRequestInfo cancelAPIRequest];
        }
    }
}

-(void) getAllOrganisationTypesFromService
{
    
    [self initializeOrgSummaryAPIHandlerAndRequestArray];
    
    if(self.apiHandlerOrgSummary)
    {
        RVAPIRequestInfo *tempRequestInfo = [self.apiHandlerOrgSummary getOrganisationTypes];
        
        if(!self.apiRequestInfoObjectArray)
            self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
        
        [self.apiRequestInfoObjectArray addObject:tempRequestInfo];
        
    }
    
}

-(void) getAllOrganisationsForAllOrgTypesFromService
{
    [self initializeOrgSummaryAPIHandlerAndRequestArray];
    
    if(organisationTypeArray)
    {
        
        for(OrganizationType *tempOrgType in organisationTypeArray)
        {
            [organisationsDictionary removeAllObjects];
            
            [self getOrganisationForOrgTypeFromService:tempOrgType.type];
            
        }
    }
}

-(void) getOrganisationForOrgTypeFromService:(NSString*) type
{
    if(!type || [type isEqualToString:@""])
        return;
    
    RVAPIRequestInfo *tempRequestInfo = [self.apiHandlerOrgSummary getOrganisationsForOrgType:type];
    
    tempRequestInfo.tag = type;
    
    if(!self.apiRequestInfoObjectArray)
        self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
    
    [self.apiRequestInfoObjectArray addObject:tempRequestInfo];
}

-(BOOL) checkIfAllOrganisationsRetrivedForAllOrgTypes
{
    BOOL result = NO;
    
    OrganizationType *tempOrgType;
    if(organisationTypeArray && organisationsDictionary)
    {
        for(tempOrgType in organisationTypeArray)
        {
            if([organisationsDictionary objectForKey:tempOrgType.type])
                result = YES;
            else
            {
                result = NO;
                break;
            }
        }
    }
    
    return result;
    
}

-(void) removeRequestInfoObjectFromPool:(RVAPIRequestInfo*) requestinfoObj
{
    if(apiRequestInfoObjectArray)
    {
        [apiRequestInfoObjectArray removeObject:requestinfoObj];
    }
}
       
 
-(BOOL) checkIfAPIRequestTypeAlive:(RVAPIRequestType) requestType
{
    BOOL result = NO;
    
    if(self.apiRequestInfoObjectArray)
    {
        for(RVAPIRequestInfo *tempReqInfo in self.apiRequestInfoObjectArray)
        {
            if(tempReqInfo.requestType == requestType)
            {
                result = YES;
                break;                
            }

        }
    }
    
    return result;
}
       

#pragma mark - OrganisationSearchAPIHandler delegate methods
-(void) rvAPIRequestCompletedSuccessfullyForRequest:(RVAPIRequestInfo *)requestInfoObj
{
    [self removeRequestInfoObjectFromPool:requestInfoObj];
    
    switch (requestInfoObj.requestType) {
        case RVAPIRequestTypeGetOrganizationTypes:
            organisationTypeArray = requestInfoObj.resultObject;
            if(organisationTypeArray)
            {
                [self didReceiveAllOrganisationTypeFromService];
            }
            break;
        case RVAPIRequestTypeGetOrganizations:
            
            if(requestInfoObj.resultObject)
            {
                
                organisationsArray = requestInfoObj.resultObject;
                
                //Addtional code written. Can be removed after integrating everything
                {
                    if(!organisationsDictionary)
                        organisationsDictionary = [[NSMutableDictionary alloc] init];
                    
                    BOOL addToDictionary = NO;
                    OrganizationType *tempOrgType;
                    if(organisationTypeArray)
                    {
                        for(tempOrgType in organisationTypeArray)
                        {
                            if([tempOrgType.type isEqualToString:requestInfoObj.tag])
                            {
                                addToDictionary = YES;
                                break;
                            }
                        }
                    }
                    
                    if(addToDictionary)
                    {
                        [organisationsDictionary setObject:requestInfoObj.resultObject forKey:requestInfoObj.tag];
                        
                    }
                
                }
                
                [self didReceiveOrganisationForCurrentOrgType];
    
            }
            
        default:
            break;
    }
    
    
}

-(void) rvAPIRequestCompletedWithErrorForRequest:(RVAPIRequestInfo *)requestInfoObj
{
    [self removeRequestInfoObjectFromPool:requestInfoObj];
    
    NSLog(@"Failure Reason: %@", requestInfoObj.statusMessage);
    
    switch (requestInfoObj.requestType) {
        case RVAPIRequestTypeGetOrganizationTypes:
            organisationTypeArray = nil;
            break;
            
        case RVAPIRequestTypeGetOrganizations:
            organisationsArray = nil;
            break;
            
        default:
            break;
       
    }
    
    if(listView)
    {
        if(requestInfoObj.statusCode == RVAPIResponseStatusCodeNoConnectivityError)
            [listView showMessageOnView:@"No Internet connectivity!"];
        else if(requestInfoObj.statusCode == RVAPIResponseStatusCodeServerUnReachableError)
            [listView showMessageOnView:@"Cannot reach server!"];
    }

    if(isAutoSearchRunning)
    {
        isAutoSearchRunning = NO;
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(didFailAutoSearchOnSearchController:)])
        {
            [self.delegate didFailAutoSearchOnSearchController:self];
        }
    }
    
    
        
}


-(void) autoSearchWithDefaultValues
{
    isAutoSearchRunning = YES;
    
    [self loadSettingsFromNSUserDefaults];
    
    self.currentlySelectedStatus = @"Active";
    
    [self getAllOrganisationTypesFromService];
    
}


@end
