    //
    //  SearchViewController_AFE.m
    //  SQLBI_AFE
    //
    //  Created by Anilkumar Pillai on 09/08/12.
    //  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
    //

#import "SearchViewController_AFE.h"
#import "AFEListViewModel.h"
#import "AFE.h"
#import "AllAFEs.h"

enum typeOfSearch{
    isNameSearch,
    isNumberSearch
    
}searchType;

@interface SearchViewController_AFE ()
{
    BOOL isSearchEnd;
}

@property(strong, nonatomic) IBOutlet UILabel   *afeNumberLabel;
@property(strong, nonatomic) IBOutlet UILabel   *afeNameLabel;

@property(nonatomic,strong) NSMutableArray      *afeNumberSearchArray;
@property(nonatomic,strong) NSMutableArray      *afeNameSearchArray;

@property(nonatomic,strong) UIPopoverController *searchPopOver;
@property(nonatomic,strong) AFEListView         *listView;
@property(nonatomic,strong) AFEListViewModel    *listViewModel;
@property(nonatomic,strong) NSString            *selectedString;
@property(nonatomic,strong) NSString            *selectedID;
@property(nonatomic,strong) UIImageView         *backgroungImage;
@property(nonatomic,strong) NSMutableArray      *afeNumberArray;
@property(nonatomic,strong) NSMutableArray      *afeNameArray;
@property(strong, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property(strong,nonatomic) AFESearchAPIHandler *afeSearchAPIHandlerObj;
@property(strong,nonatomic) NSMutableArray *apiRequestInfoObjectArray;
@property(strong,nonatomic) NSMutableArray *resultArray;
@property(strong,nonatomic) NSMutableArray *listValueArray;

    //Button Actions

- (IBAction)popOverViewTouched:(id)sender;

    //Functions
- (void)createListView:(CGRect)rect ArrayForListViewDisplay:(NSMutableArray *)listArray;
- (void)loadListViewDatas;
- (void)getAFENumbers;
- (void)populateAFENumbersArrayFromJSONString:(NSString *)jsonResponse;

@end

@implementation SearchViewController_AFE

@synthesize searchButton;
@synthesize afeNumberLabel;
@synthesize afeNameLabel;
@synthesize afeNumberSearchArray;
@synthesize afeNameSearchArray;
@synthesize searchPopOver;
@synthesize listView;
@synthesize listViewModel;
@synthesize selectedString;
@synthesize backgroungImage;
@synthesize afeNumberArray;
@synthesize afeNameArray;
@synthesize scrollViewContainer;
@synthesize delegate;
@synthesize afenumberField;
@synthesize afenameField;
@synthesize orLabel;
@synthesize afeSearchAPIHandlerObj;
@synthesize apiRequestInfoObjectArray;
@synthesize resultArray;
@synthesize listValueArray;
@synthesize selectedID;

NSMutableArray *afeMutableListArray;
NSMutableArray *afeNamesMutableListArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
        UIFont *font = FONT_TABLEVIEWCELL;
        font = [font fontWithSize:font.pointSize];
        [self.orLabel setFont:font];
        [self.orLabel setTextColor:[UIColor redColor]];//[Utility getUIColorWithHexString:@"22313f"]];
    }
    return self;
}

- (void)viewDidLoad
{
        //    [self getAFENumbers];
    
    [self loadListViewDatas];
    self.scrollViewContainer.contentSize = CGSizeMake(350, 350);
    self.resultArray =  [[NSMutableArray alloc] init];
    self.listValueArray =  [[NSMutableArray alloc] init];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"afeNumberAFESearch"])
        afenumberField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"afeNumberAFESearch"];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"afeNameAFESearch"])
        afenameField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"afeNameAFESearch"];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"AFESearchAFEID"])
        self.selectedID = [[NSUserDefaults standardUserDefaults]objectForKey:@"AFESearchAFEID"];
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"AFESearchType"])
        searchType = isNumberSearch;
    else
        searchType = isNameSearch;
    
    
    
    
        //  [self createListView:CGRectMake(19, 70, 312, 236) ArrayForListViewDisplay:afeMutableListArray];
        // [self createListView:CGRectMake(29, 57, 340, 236) ArrayForListViewDisplay:afeMutableListArray];
    
}

- (void)loadListViewDatas
{
    if (!afeNumberSearchArray) 
        {
        
        afeNumberSearchArray = [[NSMutableArray alloc]init];
        }
    
    if (!afeNameSearchArray) 
        {
        
        afeNameSearchArray = [[NSMutableArray alloc]init];
        }
    
    
    afeMutableListArray = [[NSMutableArray alloc]init];
    [afeMutableListArray addObject:@"All"];
    [afeMutableListArray addObject:@"101"];
    [afeMutableListArray addObject:@"102"];
    [afeMutableListArray addObject:@"103"];
    [afeMutableListArray addObject:@"104"]; 
    
    afeNamesMutableListArray = [[NSMutableArray alloc]init];
    [afeNamesMutableListArray addObject:@"All"];
    [afeNamesMutableListArray addObject:@"name1"];
    [afeNamesMutableListArray addObject:@"name2"];
    [afeNamesMutableListArray addObject:@"name3"]; 
    
}

- (void)createListView:(CGRect)rect ArrayForListViewDisplay:(NSMutableArray *)listArray
{
    if (!listView) {
        listView = [[AFEListView alloc]initWithFrame:rect];
        listView.delegate = self;
        [self.scrollViewContainer addSubview:listView];
    }
    listView.frame= rect;
    listView.searchData = listArray;
    [listView.tableViewForList reloadData];
    [self.listView setHidden:NO];
}


#pragma mark- Button Events
    //- (IBAction)AFENumberButtonTouched:(id)sender
    //{
    //    [self popOverViewTouched:nil];
    //    [afenumberButton setSelected:YES];
    //       if ([afeNumberSearchArray count] == 0) 
    //       {
    //           for (int i = 0; i < [afeMutableListArray count]; i++) {
    //               
    //               listViewModel = [[AFEListViewModel alloc]init];
    //               listViewModel.name = [afeMutableListArray objectAtIndex:i];
    //               listViewModel.ID = i;
    //               [afeNumberSearchArray addObject:listViewModel];
    //           }
    //       }
    //    
    //    listView = [[AFEListView alloc]initWithFrame:CGRectMake(13, 109, 320, 236)];
    //    listView.delegate = self;
    //    listView.searchData = self.afeNumberSearchArray;
    //    buttonSelection = isAFENumberButtonTouched;  
    //    [self.view addSubview:listView];
    //}

    //- (IBAction)AFENameButtonTouched:(id)sender 
    //{
    //    [self popOverViewTouched:nil];
    //    [afenameButton setSelected:YES];
    //    if ([afeNameSearchArray count] == 0) 
    //    {
    //        for (int i = 0; i < [afeNamesMutableListArray count]; i++) {
    //            
    //            listViewModel = [[AFEListViewModel alloc]init];
    //            listViewModel.name = [afeNamesMutableListArray objectAtIndex:i];
    //            listViewModel.ID = i;
    //            [afeNameSearchArray addObject:listViewModel];
    //        }
    //    }
    //    
    //    listView = [[AFEListView alloc]initWithFrame:CGRectMake(13, 17, 320, 236)];//y=230
    //    listView.delegate = self;
    //    listView.searchData = self.afeNameSearchArray;
    //    buttonSelection = isAFENameButtonTouched;
    //    [self.view addSubview:listView];
    //}

- (IBAction)popOverViewTouched:(id)sender 
{   
    
    if (listView)
        {
        [self.listView setHidden:YES]; 
        }
    if(backgroungImage)
        [self.backgroungImage removeFromSuperview];
    [afenumberField resignFirstResponder];
    [afenameField resignFirstResponder];
    
}

    //#pragma mark- List View Delegate
- (void)didSelectdropDownList:(NSMutableArray *)result
{
    isSearchEnd = YES;
    
    switch (searchType) 
    {
        case isNumberSearch:
        {
        for (listViewModel in result)
            {
            if (listViewModel.isSelected)
                {
                afenumberField.text = listViewModel.name;
                NSLog(@"%@",listViewModel.name);
                self.selectedID = listViewModel.ID;
                }
                //selectedString = listViewModel.name;
            }
        [afenumberField resignFirstResponder];
            // here make the api call to get the afe names for selected organization type
        
        }
        break;
        case isNameSearch:
        {
        for (listViewModel in result) {
            if (listViewModel.isSelected)
                {
                self.afenameField.text = listViewModel.name;
                self.selectedID = listViewModel.ID;
                
                }
        }
        
        [afenameField resignFirstResponder];
        
        }
        break;
        
        default:
        break;
    }
    
    [self popOverViewTouched:nil];
}


- (IBAction)searchButtonClicked:(id)sender 
{
    [self popOverViewTouched:nil];
    if(searchType == isNumberSearch){
        afenameField.text=@"";
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"AFESearchType"];
        [[NSUserDefaults standardUserDefaults] setObject:afenumberField.text forKey:@"afeNumberAFESearch"];
        [[NSUserDefaults standardUserDefaults] setObject:afenameField.text forKey:@"afeNameAFESearch"];
    }
    else {
        afenumberField.text=@"";
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"AFESearchType"];
        [[NSUserDefaults standardUserDefaults] setObject:afenumberField.text forKey:@"afeNumberAFESearch"];
        [[NSUserDefaults standardUserDefaults] setObject:afenameField.text forKey:@"afeNameAFESearch"];
    }
    NSLog(@"%@",self.selectedID);
    [[NSUserDefaults standardUserDefaults] setObject:self.selectedID forKey:@"AFESearchAFEID"];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(searchWithDataAFEID:)])
        {
            //        [[NSUserDefaults standardUserDefaults] setObject:afeNumberLabel.text forKey:@"afeNumber"];
            //        [[NSUserDefaults standardUserDefaults] setObject:afeNameLabel.text forKey:@"afeName"];
//        [[NSUserDefaults standardUserDefaults] setObject:self.selectedID forKey:@"afeID"];
        
        [self.delegate searchWithDataAFEID:self.selectedID];
        }    
}

-(void) getOrganizationTypes
{
        //Actual API call here
        // call returns to the class as a delegate with JSON response as a string
    
        // here the delegate method is assumed to be 
        //populateOrganizationTypesArrayFromJSONString:(NSString *)jsonResponse
        // hence it is called
    [self populateAFENumbersArray:[self getDummyAFENumbers]];
        // the delegate with response will be automatically fired with valide responseString
}

-(NSArray *) getDummyAFENumbers
{
    NSMutableArray *jsonArray =[[NSMutableArray alloc]init];
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
    [dic1 setValue:@"Division" forKey:@"DisplayName"];
    [dic1 setValue:@"Division" forKey:@"OrgType"];
    [jsonArray addObject:dic1];
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc]init];
    [dic2 setValue:@"Region" forKey:@"DisplayName"];
    [dic2 setValue:@"Region" forKey:@"OrgType"];
    [jsonArray addObject:dic2];
    NSMutableDictionary *dic3 = [[NSMutableDictionary alloc]init];
    [dic3 setValue:@"Business Unit" forKey:@"DisplayName"];
    [dic3 setValue:@"BusinessUnit" forKey:@"OrgType"];
    [jsonArray addObject:dic3];
    NSMutableDictionary *dic4 = [[NSMutableDictionary alloc]init];
    [dic4 setValue:@"District" forKey:@"DisplayName"];
    [dic4 setValue:@"District" forKey:@"OrgType"];
    [jsonArray addObject:dic4];
    NSMutableDictionary *dic5 = [[NSMutableDictionary alloc]init];
    [dic5 setValue:@"Area" forKey:@"DisplayName"];
    [dic5 setValue:@"Area" forKey:@"OrgType"];
    [jsonArray addObject:dic5];
    
    NSLog(@"json array %@",jsonArray);
    return (NSArray *)jsonArray;
}

-(void) populateAFENumbersArray:(NSArray *)jsonResponseArray
{
    if(!afeNumberSearchArray)
        afeNumberSearchArray = [[NSMutableArray alloc]init];
    else
        [afeNumberSearchArray removeAllObjects];
    int ID =0;
    for(NSMutableDictionary *dictionary in jsonResponseArray)
        {
        if([dictionary isKindOfClass:[NSMutableDictionary class]] && [dictionary count])
            {
            listViewModel = [[AFEListViewModel alloc]init];
            listViewModel.name = [dictionary objectForKey:@"DisplayName"];
            listViewModel.ID = [NSString stringWithFormat:@"%d",ID++];
            [afeNumberSearchArray addObject:listViewModel];
            
            }
        }
}

#pragma mark Methods to get Organization Names

-(void) getAFENamesForAFEType:(int)afeTypeID
{
    
} 
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.tag)
        afenumberField.text= @"";
    else
        afenameField.text= @"";
    
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    isSearchEnd = YES;
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    isSearchEnd = NO;
    if(![textField.text isEqualToString:@""])
        [self textFieldValueChanged:textField];
    
} 
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    isSearchEnd = NO;
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
    
}

-(IBAction)textFieldValueChanged :(UITextField *)sender {
    
    if(isSearchEnd == NO){
        NSLog(@"%d",sender.tag);
        if(![sender.text isEqualToString:@""]){
                //if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAllAFEs]){
            [self.listView showActivityIndicatorOverlayView];
                //}
            if(sender.tag){
                searchType = isNameSearch;
                [self stopAllAPICalls];
                [self initializeWellSearchAPIHandlerAndRequestArray];
                [afeSearchAPIHandlerObj getAllAFEs:afenameField.text withSearchField:@"Name" withTopNumberOfRows:10];
                [self createListView:CGRectMake(19, 0, 312, 236) ArrayForListViewDisplay:self.listValueArray];

            }
            else {
                searchType = isNumberSearch;
                [self stopAllAPICalls];
                [self initializeWellSearchAPIHandlerAndRequestArray];
                [afeSearchAPIHandlerObj getAllAFEs:afenumberField.text withSearchField:@"Number" withTopNumberOfRows:10];
                [self createListView:CGRectMake(19, 70, 312, 236) ArrayForListViewDisplay:self.listValueArray];

            }
        }
            //        else{
            //            listView.hidden = YES;
            //        }
        
    }
    isSearchEnd = NO;     
} 
-(void) initializeWellSearchAPIHandlerAndRequestArray
{
    if (!self.afeSearchAPIHandlerObj) {
        self.afeSearchAPIHandlerObj = [[AFESearchAPIHandler alloc] init];
        afeSearchAPIHandlerObj.delegate = self;    
    }
    
    if(!self.apiRequestInfoObjectArray){
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
-(void) removeRequestInfoObjectFromPool:(RVAPIRequestInfo*) requestinfoObj
{
    [self.listView removeActivityIndicatorOverlayView];
    if(apiRequestInfoObjectArray){
        [apiRequestInfoObjectArray removeObject:requestinfoObj];
    }
}
-(void) rvAPIRequestCompletedSuccessfullyForRequest:(RVAPIRequestInfo *)requestInfoObj{
    
    [self removeRequestInfoObjectFromPool:requestInfoObj];
    
    self.selectedID = @"";
    switch (requestInfoObj.requestType) {
        case RVAPIRequestTypeGetAllAFEs:{
            [self.listView removeActivityIndicatorOverlayView];
            resultArray = (NSMutableArray *)requestInfoObj.resultObject;
            [self.listValueArray removeAllObjects];
            [listValueArray removeAllObjects];
            for (int i= 0; i<[resultArray count]; i++) {
                AllAFEs *tempAllAFE = (AllAFEs *)[resultArray objectAtIndex:i];
                listViewModel = [[AFEListViewModel alloc]init];
                if(searchType == isNumberSearch)
                    listViewModel.name = [NSString stringWithFormat:@"%@",tempAllAFE.afeNumber];
                else {
                    listViewModel.name = [NSString stringWithFormat:@"%@",tempAllAFE.afeName];
                }
                    // listViewModel.name = [NSString stringWithFormat:@"%d",tempAllAFE.afeID];
                listViewModel.ID = [NSString stringWithFormat:@"%@",tempAllAFE.afeID];
                NSLog(@"%@",listViewModel.name);
                [self.listValueArray addObject:listViewModel];
            }
                //self.listValueArray 
                //            if([resultArray count])
                //                listView.hidden = NO;
                //            else {
                //                listView.hidden = YES;
                //            }
            [self createListView:CGRectMake(19, 70, 312, 236) ArrayForListViewDisplay:self.listValueArray];
            if(searchType == isNameSearch)
                [self createListView:CGRectMake(19, 0, 312, 236) ArrayForListViewDisplay:self.listValueArray];
            break;
        }
            
        default:
            break;
    }
    
    
}

-(void) rvAPIRequestCompletedWithErrorForRequest:(RVAPIRequestInfo *)requestInfoObj
{
    [self.listView removeActivityIndicatorOverlayView];
    self.selectedID = @"";
    NSLog(@"Failure Reason: %@", requestInfoObj.statusMessage);
    [self removeRequestInfoObjectFromPool:requestInfoObj];
    
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

-(IBAction)touchedBkrgnd{
    [self popOverViewTouched:nil];
}

- (void)viewDidUnload
{
    [self setScrollViewContainer:nil];
    [super viewDidUnload];
        // Release any retained subviews of the main view.
        // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
- (void)dealloc
{
    
    
}

@end
