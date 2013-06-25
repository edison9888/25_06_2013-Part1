//
//  AFESearchDetailViewController.m
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 10/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFESearchDetailViewController.h"
#import "AFE.h"
#import "AFEInvoice.h"


@interface AFESearchDetailViewController ()
{
    NSArray *afeBillingDetailArray;
    
    int totalPageCount_BillingCategoryTable;
    int totalPageCount_InvoiceTable;
    
    int totalRecordCount_BillingCategoryTable;
    int totalRecordCount_InvoiceTable;
       
    int newPageNumber_BillingCategoryTable;
    int newPageNumber_InvoiceTable;
    
    UISwipeGestureRecognizer *leftSwipeRecognizer;
    UISwipeGestureRecognizer *rightSwipeRecognizer;
    
    BOOL invoiceSelected;
}

@property(nonatomic,strong)IBOutlet UIButton *byBillingcategoryButton;
@property(nonatomic,strong)IBOutlet UIButton *byInvoiceButton;

@property(nonatomic,strong)AFESearchAPIHandler *afeSearchAPIHandlerObj;
@property(nonatomic,strong)NSMutableArray *apiRequestInfoObjectArray;
@property(nonatomic,strong)NSArray *nilArray;
@end

@implementation AFESearchDetailViewController

@synthesize afeDetailsButton;
@synthesize afeInvoiceButton;
@synthesize afeDetailsLeftView;
@synthesize afeDetailsRightView;
@synthesize afeInvoiceView;
@synthesize afeSearchAPIHandlerObj;
@synthesize apiRequestInfoObjectArray;
@synthesize afeBillingView;
@synthesize byInvoiceButton;
@synthesize byBillingcategoryButton;
@synthesize nilArray;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidLoad{
    [super viewDidLoad];
    UIFont *font = FONT_HEADLINE_TITLE;
    font = [font fontWithSize:font.pointSize+2];
    UIFont *font1 = FONT_HEADLINE_TITLE;
    font1 = [font1 fontWithSize:font1.pointSize];
    [self.afeDetailsButton.titleLabel setFont:font];
    [self.afeInvoiceButton.titleLabel setFont:font];
    [self.byBillingcategoryButton.titleLabel setFont:font1];
    [self.byInvoiceButton.titleLabel setFont:font1];
    [self.byBillingcategoryButton setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.byBillingcategoryButton setTitleColor:[Utility getUIColorWithHexString:@"192835"] forState:UIControlStateSelected];
    [self.byInvoiceButton setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.byInvoiceButton setTitleColor:[Utility getUIColorWithHexString:@"192835"] forState:UIControlStateSelected];     
    
    [self.view addSubview:self.afeDetailsLeftView];
    [self.view addSubview:self.afeDetailsRightView];
    [self.view addSubview:self.afeInvoiceView];
    [self.view addSubview:self.afeBillingView];
    
    self.afeBillingView.delegate = self;
    self.afeInvoiceView.delegate = self;
    self.afeDetailsLeftView.delegate = self;
    
    self.afeDetailsLeftView.frame = CGRectMake(17,63,432,538);
    self.afeDetailsRightView.frame = CGRectMake(463,63,505,531);
    self.afeInvoiceView.frame = CGRectMake(17,87,950,505);
    self.afeBillingView.frame = CGRectMake(17,90,950,505);
    
    [self AFEDetailsButtonClick:self.afeDetailsButton];
    
    leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeMethod:)];
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft; 
    [self.view addGestureRecognizer:leftSwipeRecognizer];
    
    rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeMethod:)];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight; 
    [self.view addGestureRecognizer:rightSwipeRecognizer];
}

//Swipe function
-(void) swipeMethod: (UISwipeGestureRecognizer *) sender{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if ([self.afeDetailsButton isSelected]) 
        {
            self.afeBillingView.frame = CGRectMake(1024,90,950,505);
            self.byBillingcategoryButton.frame= CGRectMake(self.byBillingcategoryButton.frame.origin.x+1024,59, 135, 27);
            self.byInvoiceButton.frame= CGRectMake(self.byInvoiceButton.frame.origin.x+1024,59, 100, 27);
            [self leftSwipe];
            [UIView animateWithDuration:0.8 
                             animations:^
            {
                self.afeDetailsLeftView.frame = CGRectMake(-1007,63,432,538);
                self.afeDetailsRightView.frame = CGRectMake(-561,63,505,531);
                self.afeBillingView.frame = CGRectMake(17,90,950,505);
                self.byBillingcategoryButton.frame = CGRectMake(698,59,135,27);
                self.byInvoiceButton.frame = CGRectMake(851,59,100,27);
            }
                             completion:^(BOOL finished)
            {
                self.afeDetailsRightView.hidden=YES;
                self.afeDetailsLeftView.hidden=YES;
            }];
        }
        NSLog(@"Left Swipe!");
    }
    
    else if (sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if ([self.afeInvoiceButton isSelected]) 
        {
            self.afeDetailsLeftView.frame = CGRectMake(-1007,63,432,538);
            self.afeDetailsRightView.frame = CGRectMake(-561,63,505,531);
            [self rightSwipe];
            [UIView animateWithDuration:0.8 
                             animations:^
             {
                 self.afeBillingView.frame = CGRectMake(1024,90,950,505);
                 self.byBillingcategoryButton.frame= CGRectMake(self.byBillingcategoryButton.frame.origin.x+1024,59, 135, 27);
                 self.byInvoiceButton.frame= CGRectMake(self.byInvoiceButton.frame.origin.x+1024,59, 100, 27);
                 self.afeDetailsLeftView.frame = CGRectMake(17,63,432,538);
                 self.afeDetailsRightView.frame = CGRectMake(463,63,505,531);
             }
                             completion:^(BOOL finished)
             {
                 self.afeBillingView.hidden=YES;
                 self.byBillingcategoryButton.hidden=YES;
                 self.byInvoiceButton.hidden=YES;
             }];
        }
        NSLog(@"Right Swipe!");
    }           
}

-(void)leftSwipe{
    [self.afeDetailsButton setSelected:NO];
    [self.afeInvoiceButton setSelected:YES];
    self.afeBillingView.hidden=NO;
    self.byBillingcategoryButton.hidden=NO;
    self.byInvoiceButton.hidden=NO;
    [self byBillingCategoryButtonTouched];
}

-(void)rightSwipe{
    [self.afeInvoiceButton setSelected:NO];
    [self.afeDetailsButton setSelected:YES];
    self.afeDetailsLeftView.hidden=NO;
    self.afeDetailsRightView.hidden=NO;
}

-(void) viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	return YES;
}

#pragma - mark Button Actions
-(IBAction) AFEDetailsButtonClick:(id)sender{
    
    self.afeDetailsLeftView.frame = CGRectMake(17,63,432,538);
    self.afeDetailsRightView.frame = CGRectMake(463,63,505,531);
    NSString *tempAfeNumber = [[NSUserDefaults standardUserDefaults]objectForKey:@"afeNumber"];
    if (tempAfeNumber==NULL) 
    {
        [self.afeDetailsButton setTitle:@"AFE Detail - " forState:UIControlStateSelected];
    }
    else 
    {
        [self.afeDetailsButton setTitle:[NSString stringWithFormat:@"AFE Detail - %@",tempAfeNumber] forState:UIControlStateSelected];
    }
    if ([self.afeInvoiceButton isSelected]) 
    {
        [self.afeInvoiceButton setSelected:NO];
    }
    [self.afeDetailsButton setSelected:YES];
    
    self.afeDetailsLeftView.hidden=NO;
    self.afeDetailsRightView.hidden=NO;
    self.afeInvoiceView.hidden=YES;
    self.afeBillingView.hidden=YES;
    
    self.byInvoiceButton.hidden=YES;
    self.byBillingcategoryButton.hidden=YES;
    
}

-(IBAction) AFEInvoiceButtonClick:(id)sender{
    self.afeBillingView.frame = CGRectMake(17,90,950,505); 
    [self.afeDetailsButton setSelected:NO];
    [self.afeInvoiceButton setSelected:YES];
    NSString *tempAfeNumber = [[NSUserDefaults standardUserDefaults]objectForKey:@"afeNumber"];
    if (tempAfeNumber==NULL) 
    {
        [self.afeDetailsButton setTitle:@"AFE Detail - " forState:UIControlStateNormal];
    }
    else 
    {
        [self.afeDetailsButton setTitle:[NSString stringWithFormat:@"AFE Detail - %@",tempAfeNumber] forState:UIControlStateNormal];
    }
    self.afeDetailsLeftView.hidden=YES;
    self.afeDetailsRightView.hidden=YES;
    self.afeInvoiceView.hidden=YES;
    
    self.afeBillingView.hidden=NO;
    self.byInvoiceButton.hidden=NO;
    self.byBillingcategoryButton.hidden=NO;
    
    [self selectionType:self.byBillingcategoryButton];
    
}

-(IBAction) selectionType:(id)sender{
    UIButton *button = (UIButton*)sender;
    switch (button.tag) {
        case 100:
        {
            [self byBillingCategoryButtonTouched];
        }
            break;
        case 200:
        {
            [self byInvoiceButtonTouched];
        }
            break;
            
        default:
            break;
    }     
}

-(void) byBillingCategoryButtonTouched{
    if ([self.byInvoiceButton isSelected]) 
    {
        [self.byInvoiceButton setSelected:NO];
        self.afeInvoiceView.hidden=YES;
    }
    
    [self.byBillingcategoryButton setSelected:YES];
    self.afeBillingView.hidden=NO;
    
    self.byBillingcategoryButton.userInteractionEnabled = NO;
    self.byInvoiceButton.userInteractionEnabled = YES;
}

-(void) byInvoiceButtonTouched{
    if ([self.byBillingcategoryButton isSelected]) 
    {
        [self.byBillingcategoryButton setSelected:NO];
        self.afeBillingView.hidden=YES;
    }
    
    [self.byInvoiceButton setSelected:YES];
    self.afeInvoiceView.hidden=NO;
    
    self.byBillingcategoryButton.userInteractionEnabled = YES;
    self.byInvoiceButton.userInteractionEnabled = NO;
}

#pragma mark - API Call on Search Button Click
- (void) callAPIforAFEDetailWithAfeID:(NSString *)afeID{
    if (afeID == NULL||[afeID isEqualToString:@""]) {
        [self.afeDetailsButton setTitle:@"AFE Detail - " forState:UIControlStateNormal];
        [self.afeDetailsButton setTitle:@"AFE Detail - " forState:UIControlStateSelected];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Fields Empty" message:@"Please Enter a Valid AFE Number or AFE Name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [self.afeDetailsLeftView getAfeSearchSummaryArray:nilArray];
        [self.afeDetailsRightView getAfeBurnDownDetailArray:nilArray];
        [self.afeInvoiceView getAfeSearchInvoiceArray:nilArray forPage:newPageNumber_InvoiceTable ofTotalPages:totalPageCount_InvoiceTable];
        [self.afeBillingView getAfeSearchBillingCategoryArray:nilArray forPage:newPageNumber_BillingCategoryTable ofTotalPages:totalPageCount_BillingCategoryTable];
    }
    else {
        [self initializeAfeSearchAPIHandlerAndRequestArray];
        
        [afeSearchAPIHandlerObj getAFEDetailsWithID:afeID]; 
        [self.afeDetailsLeftView showActivityIndicatorOverlayView];
        
        [afeSearchAPIHandlerObj getAFEBurnDownWithID:afeID];
        [self.afeDetailsRightView showActivityIndicatorOverlayView];
        
        newPageNumber_InvoiceTable = 1;
        totalPageCount_InvoiceTable = 1;
        totalRecordCount_InvoiceTable = 1;
        [afeSearchAPIHandlerObj getAFEInvoiceWithBillingCategoryID:@"ALL" andWithAFEID:afeID andSortBy:SORTFIELD_GrossExpense withSortOrder:@"DESC" withPageNumber:1 andLimit:50];
        [self.afeInvoiceView showActivityIndicatorOverlayView];
        
        newPageNumber_BillingCategoryTable = 1;
        totalPageCount_BillingCategoryTable = 1;
        totalRecordCount_BillingCategoryTable = 1;
        [afeSearchAPIHandlerObj getAFEBillingCategoryWithID:afeID andSortBy:SORTFIELD_Total withSortOrder:@"DESC" withPageNumber:1 andLimit:50];
        [self.afeBillingView showActivityIndicatorOverlayView];
    }
    
}

#pragma mark - Delegate Functions

//Setting AFE Number on tab
-(void) setAfeNumberToTabButton:(NSString *)afeNumber{
    [self.afeDetailsButton setTitle:[NSString stringWithFormat:@"AFE Detail - %@",afeNumber] forState:UIControlStateNormal];
    [self.afeDetailsButton setTitle:[NSString stringWithFormat:@"AFE Detail - %@",afeNumber] forState:UIControlStateSelected];
    [[NSUserDefaults standardUserDefaults] setObject:afeNumber forKey:@"afeNumber"];
}

//Billing Category Sorting
-(void) getBillingCategoryTableSort:(AFESearchBillingCategoryView *) billingCategoryView forPage:(int)page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit{
    
    newPageNumber_BillingCategoryTable = (page>0)? page:1;
    
    [self.afeBillingView showActivityIndicatorOverlayView]; 
    [self initializeAfeSearchAPIHandlerAndRequestArray];
    [self stopAPICallOfType:RVAPIRequestTypeGetBillingCategories withTag:nil];
    RVAPIRequestInfo *tempRequestInfo;
    if (sortDirection == 0) 
    {
        tempRequestInfo = [afeSearchAPIHandlerObj getAFEBillingCategoryWithID:[[NSUserDefaults standardUserDefaults]objectForKey:@"AFESearchAFEID"] andSortBy:sortField withSortOrder:@"ASC" withPageNumber:page andLimit:limit];
    }
    else 
    {
        tempRequestInfo = [afeSearchAPIHandlerObj getAFEBillingCategoryWithID:[[NSUserDefaults standardUserDefaults]objectForKey:@"AFESearchAFEID"] andSortBy:sortField withSortOrder:@"DESC" withPageNumber:page andLimit:limit];
    }
    [self.apiRequestInfoObjectArray addObject:tempRequestInfo];
}

//Invoice View Sorting
-(void) getInvoiceTableSort:(AFESearchInvoiceView *) invoiceView forPage:(int)page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit{
    
    newPageNumber_InvoiceTable = (page>0)? page:1;
    
    [self.afeInvoiceView showActivityIndicatorOverlayView]; 
    [self initializeAfeSearchAPIHandlerAndRequestArray];
    [self stopAPICallOfType:RVAPIRequestTypeGetAfeInvoice withTag:nil];
    RVAPIRequestInfo *tempRequestInfo;
    if (sortDirection == 0) 
    {
        tempRequestInfo = [afeSearchAPIHandlerObj getAFEInvoiceWithBillingCategoryID:@"ALL" andWithAFEID:[[NSUserDefaults standardUserDefaults]objectForKey:@"AFESearchAFEID"] andSortBy:sortField withSortOrder:@"ASC" withPageNumber:page andLimit:50];
    }
    else 
    {
        tempRequestInfo = [afeSearchAPIHandlerObj getAFEInvoiceWithBillingCategoryID:@"ALL" andWithAFEID:[[NSUserDefaults standardUserDefaults]objectForKey:@"AFESearchAFEID"] andSortBy:sortField withSortOrder:@"DESC" withPageNumber:page andLimit:50];
    }
    [self.apiRequestInfoObjectArray addObject:tempRequestInfo];
}

#pragma - mark API Handler
-(void) initializeAfeSearchAPIHandlerAndRequestArray{
    if (!self.afeSearchAPIHandlerObj) 
    {
        self.afeSearchAPIHandlerObj = [[AFESearchAPIHandler alloc] init];
        afeSearchAPIHandlerObj.delegate = self;    
    }
    
    if(!self.apiRequestInfoObjectArray)
    {
        self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
    }
}

-(void) stopAllAPICalls{
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

-(void) removeRequestInfoObjectFromPool:(RVAPIRequestInfo*) requestinfoObj{
    if(apiRequestInfoObjectArray){
        [apiRequestInfoObjectArray removeObject:requestinfoObj];
    }
}

-(void) rvAPIRequestCompletedSuccessfullyForRequest:(RVAPIRequestInfo *)requestInfoObj{
    
    [self removeRequestInfoObjectFromPool:requestInfoObj];
    
    switch (requestInfoObj.requestType) 
    {
        case RVAPIRequestTypeGetAfeDetails:
        {
            [self.afeDetailsLeftView getAfeSearchSummaryArray:requestInfoObj.resultObject];
            [self.afeDetailsLeftView removeActivityIndicatorOverlayView];
        }
            break;
            
        case RVAPIRequestTypeGetBurnDownItems:
        {
            [self.afeDetailsRightView getAfeBurnDownDetailArray:requestInfoObj.resultObject];
            [self.afeDetailsRightView removeActivityIndicatorOverlayView];
        }
            break;
            
        case RVAPIRequestTypeGetAfeInvoice:
        {            
            NSDictionary *resultDict = requestInfoObj.resultObject;
            NSArray *resultArray = [resultDict objectForKey:@"AFEInvoiceArray"]? [[NSMutableArray alloc] initWithArray:[resultDict objectForKey:@"AFEInvoiceArray"]]:[[NSMutableArray alloc] init];
            int recordCount = [resultDict objectForKey:@"totrcnt"]? [[resultDict objectForKey:@"totrcnt"] intValue]:[resultArray count];
            int pageCount = [resultDict objectForKey:@"totpgcnt"]?[[resultDict objectForKey:@"totpgcnt"] intValue]:1;
            
            totalPageCount_InvoiceTable = pageCount;
            totalRecordCount_InvoiceTable = recordCount;
            
            [self.afeInvoiceView getAfeSearchInvoiceArray:resultArray forPage:newPageNumber_InvoiceTable ofTotalPages:totalPageCount_InvoiceTable];
            [self.afeInvoiceView removeActivityIndicatorOverlayView];
        }
            break;
            
        case RVAPIRequestTypeGetBillingCategories:
        {
            NSDictionary *resultDict = requestInfoObj.resultObject;
            NSArray *resultArray = [resultDict objectForKey:@"AFEBillingCategoryArray"]? [[NSMutableArray alloc] initWithArray:[resultDict objectForKey:@"AFEBillingCategoryArray"]]:[[NSMutableArray alloc] init];
            int recordCount = [resultDict objectForKey:@"totrcnt"]? [[resultDict objectForKey:@"totrcnt"] intValue]:[resultArray count];
            int pageCount = [resultDict objectForKey:@"totpgcnt"]?[[resultDict objectForKey:@"totpgcnt"] intValue]:1;
            
            totalPageCount_BillingCategoryTable = pageCount;
            totalRecordCount_BillingCategoryTable = recordCount;
            
            [self.afeBillingView getAfeSearchBillingCategoryArray:resultArray forPage:newPageNumber_BillingCategoryTable ofTotalPages:totalPageCount_BillingCategoryTable];
            [self.afeBillingView removeActivityIndicatorOverlayView];
            
        }
            break;
                            
        default:
            break;
    }
    
    
    
}

-(void) rvAPIRequestCompletedWithErrorForRequest:(RVAPIRequestInfo *)requestInfoObj{
    
    NSLog(@"Failure Reason: %@", requestInfoObj.statusMessage);
    
    [self removeRequestInfoObjectFromPool:requestInfoObj];
    
}

-(void) stopAPICallOfType:(RVAPIRequestType) requestType withTag:(id) tag{
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
                    [tempRequestInfo cancelAPIRequest];
                
            }
        }
    }
    
}

-(BOOL) checkIfAPIRequestTypeAlive:(RVAPIRequestType) requestType withTag:(id) tag{
    BOOL result = NO;
    
    if(self.apiRequestInfoObjectArray)
    {
        for(RVAPIRequestInfo *tempRequestInfo in self.apiRequestInfoObjectArray)
        {
            if(tempRequestInfo.requestType == requestType)
            {
                if(!tempRequestInfo.tag || !tag)
                {
                    result = YES;
                }
                else if([tag isKindOfClass:[NSString class]] && [tempRequestInfo.tag isKindOfClass:[NSString class]])
                {
                    NSString *orginalTag = (NSString*) tempRequestInfo.tag;
                    NSString *tagToCompare = (NSString*) tag;
                    
                    if([orginalTag caseInsensitiveCompare:tagToCompare] == NSOrderedSame)
                        result = YES;
                }
                else if(tag == tempRequestInfo.tag)
                {
                    result = YES;
                }
                
                if(result)
                {
                    break;     
                }              
            }
            
        }
    }
    
    return result;
}

@end
