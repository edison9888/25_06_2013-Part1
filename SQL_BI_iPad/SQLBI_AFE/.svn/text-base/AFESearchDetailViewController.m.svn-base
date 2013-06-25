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
#import "AFEBurnDownGraphDetailedView.h"

@implementation UIPageControl (Custom)

- (void)setCurrentPage:(NSInteger)page {
    
    NSString* imgActive = [[NSBundle mainBundle] pathForResource:@"roundSelected" ofType:@"png"];
    NSString* imgInactive = [[NSBundle mainBundle] pathForResource:@"roundSelected" ofType:@"png"];
    
    for (int subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        subview.layer.cornerRadius=8.0;
        subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y, 7, 7);
        if (subviewIndex == page)
            [subview setImage:[UIImage imageWithContentsOfFile:imgActive]];
        else 
            [subview setImage:[UIImage imageWithContentsOfFile:imgInactive]];
    }
}
@end

@interface AFESearchDetailViewController ()
{
    NSArray *afeBillingDetailArray;
    NSArray *afeBurnDownArray;
    
    int totalPageCount_BillingCategoryTable;
    int totalPageCount_InvoiceTable;
    
    int totalRecordCount_BillingCategoryTable;
    int totalRecordCount_InvoiceTable;
       
    int newPageNumber_BillingCategoryTable;
    int newPageNumber_InvoiceTable;
    
    UISwipeGestureRecognizer *leftSwipeRecognizer;
    UISwipeGestureRecognizer *rightSwipeRecognizer;
    IBOutlet UIPageControl *pageCntlr;
    
    AFEBurnDownGraphDetailedView *burnDownGraphDetailedView;
    
    BOOL invoiceSelected;
}

@property(nonatomic,strong)IBOutlet UIButton *byBillingcategoryButton;
@property(nonatomic,strong)IBOutlet UIButton *byInvoiceButton;
@property(nonatomic,strong)IBOutlet UIButton *showBurnDownButton;
@property(nonatomic,strong)IBOutlet UIButton *showBurnDownTableButton;

@property(nonatomic,strong)AFESearchAPIHandler *afeSearchAPIHandlerObj;
@property(nonatomic,strong)NSMutableArray *apiRequestInfoObjectArray;
@property(nonatomic,strong)NSArray *nilArray;
-(IBAction)pageChangedOnControl:(id)sender;
-(IBAction) expandButtonClick:(id)sender;
@end

@implementation AFESearchDetailViewController

@synthesize afeDetailsButton;
@synthesize afeInvoiceButton;
@synthesize afeDetailsLeftView;
@synthesize afeBurnDownGraphView;
@synthesize afeInvoiceView;
@synthesize afeSearchAPIHandlerObj;
@synthesize apiRequestInfoObjectArray;
@synthesize afeBillingView;
@synthesize byInvoiceButton;
@synthesize byBillingcategoryButton;
@synthesize nilArray;
@synthesize afeBurnDownButton;
@synthesize showBurnDownButton, showBurnDownTableButton;
@synthesize afeBurnDownTableView;
@synthesize delegate;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidLoad{
    [super viewDidLoad];
    pageCntlr.currentPage = 0;
    UIFont *font = FONT_HEADLINE_TITLE;
    font = [font fontWithSize:font.pointSize+2];
    UIFont *font1 = FONT_HEADLINE_TITLE;
    font1 = [font1 fontWithSize:font1.pointSize];
    [self.afeDetailsButton.titleLabel setFont:font];
    [self.afeInvoiceButton.titleLabel setFont:font];
    [self.afeBurnDownButton.titleLabel setFont:font];
    
    [self.byBillingcategoryButton.titleLabel setFont:font1];
    [self.byInvoiceButton.titleLabel setFont:font1];
    [self.showBurnDownButton.titleLabel setFont:font1];
    [self.showBurnDownTableButton.titleLabel setFont:font1];
    
    [self.byBillingcategoryButton setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.byBillingcategoryButton setTitleColor:[Utility getUIColorWithHexString:@"192835"] forState:UIControlStateSelected];
    [self.byInvoiceButton setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.byInvoiceButton setTitleColor:[Utility getUIColorWithHexString:@"192835"] forState:UIControlStateSelected]; 
    
    [self.showBurnDownButton setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.showBurnDownButton setTitleColor:[Utility getUIColorWithHexString:@"192835"] forState:UIControlStateSelected];
    [self.showBurnDownTableButton setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.showBurnDownTableButton setTitleColor:[Utility getUIColorWithHexString:@"192835"] forState:UIControlStateSelected]; 
    
    [self.view addSubview:self.afeDetailsLeftView];
    [self.view addSubview:afeBurnDownTableView];
    [self.view addSubview:self.afeInvoiceView];
    [self.view addSubview:self.afeBillingView];
    
    self.afeBillingView.delegate = self;
    self.afeInvoiceView.delegate = self;
    self.afeDetailsLeftView.delegate = self;
    self.afeBurnDownTableView.delegate = self;
    
    self.afeDetailsLeftView.frame = CGRectMake(17,80,432,538);
    self.afeBurnDownGraphView.frame = CGRectMake(17,88, self.afeBurnDownGraphView.frame.size.width, self.afeBurnDownGraphView.frame.size.height);
    [self.view addSubview:self.afeBurnDownGraphView];

    self.afeBurnDownTableView.frame = CGRectMake(460, 90, self.afeBurnDownTableView.frame.size.width, self.afeBurnDownTableView.frame.size.height);
    self.afeInvoiceView.frame = CGRectMake(17,87,950,505);
    self.afeBillingView.frame = CGRectMake(17,90,950,505);
    
    [self AFEDetailsButtonClick:self.afeDetailsButton];
    
    leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeMethod:)];
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft; 
    [self.view addGestureRecognizer:leftSwipeRecognizer];
    
    rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeMethod:)];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight; 
    [self.view addGestureRecognizer:rightSwipeRecognizer];
    
    self.afeBurnDownGraphView.delegate = self;
}

//Swipe function
-(void) swipeMethod: (UISwipeGestureRecognizer *) sender{
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if ([self.afeDetailsButton isSelected]){   
            pageCntlr.currentPage = 1;
            self.afeBurnDownGraphView.frame = CGRectMake(1024,88,self.afeBurnDownGraphView.frame.size.width,self.afeBurnDownGraphView.frame.size.height);
            self.afeBurnDownTableView.frame = CGRectMake(1024,self.afeBurnDownTableView.frame.origin.y,self.afeBurnDownTableView.frame.size.width,self.afeBurnDownTableView.frame.size.height);
            self.showBurnDownButton.frame= CGRectMake(self.byBillingcategoryButton.frame.origin.x+1024,59, 135, 27);
            self.showBurnDownTableButton.frame= CGRectMake(self.byInvoiceButton.frame.origin.x+1024,59, 100, 27);
            [self.afeBurnDownGraphView getAfeBurnDownDetailArray:afeBurnDownArray];
            
            self.showBurnDownButton.hidden = YES;
            self.showBurnDownTableButton.hidden = YES;
            self.afeBurnDownGraphView.hidden = NO;
            self.afeBurnDownTableView.hidden = NO;
            self.afeDetailsButton.selected = NO;
            self.afeBurnDownButton.selected = YES;
            self.afeInvoiceButton.selected = NO;
            
            [UIView animateWithDuration:0.5 
                             animations:^
            {
                self.afeDetailsLeftView.frame = CGRectMake(-1007,80,432,538);
                self.afeBurnDownGraphView.frame = CGRectMake(17,88,self.afeBurnDownGraphView.frame.size.width,self.afeBurnDownGraphView.frame.size.height);
                   self.afeBurnDownTableView.frame = CGRectMake(510,self.afeBurnDownTableView.frame.origin.y,self.afeBurnDownTableView.frame.size.width,self.afeBurnDownTableView.frame.size.height);
                self.showBurnDownButton.frame = CGRectMake(698,59,135,27);
                self.showBurnDownTableButton.frame = CGRectMake(851,59,100,27);
            }
                             completion:^(BOOL finished)
            {
                
                
                self.afeDetailsLeftView.hidden=YES;
                [self showBurnDownGraphClicked];
            }];
        }
        else if ([self.afeBurnDownButton isSelected])
        {
            pageCntlr.currentPage = 2;
            self.afeBillingView.frame = CGRectMake(1024,90,950,505);
            self.byBillingcategoryButton.frame= CGRectMake(self.byBillingcategoryButton.frame.origin.x+1024,59, 135, 27);
            self.byInvoiceButton.frame= CGRectMake(self.byInvoiceButton.frame.origin.x+1024,59, 100, 27);
            
            self.afeDetailsButton.selected = NO;
            self.afeBurnDownButton.selected = NO;
            self.afeInvoiceButton.selected = YES;
            
            self.afeBillingView.hidden = NO;
            self.afeInvoiceView.hidden = YES;

            [UIView animateWithDuration:0.5 
                             animations:^
             {
                 self.afeDetailsLeftView.frame = CGRectMake(-1007,80,432,538);
                 self.afeBurnDownGraphView.frame = CGRectMake(-561,self.afeBurnDownGraphView.frame.origin.y,self.afeBurnDownGraphView.frame.size.width,self.afeBurnDownGraphView.frame.size.height);
                self.afeBurnDownTableView.frame = CGRectMake(-561,self.afeBurnDownTableView.frame.origin.y,self.afeBurnDownTableView.frame.size.width,self.afeBurnDownTableView.frame.size.height);
                 self.showBurnDownButton.frame = CGRectMake(-561,self.showBurnDownButton.frame.origin.y,self.showBurnDownButton.frame.size.width,self.showBurnDownButton.frame.size.height);
                  self.showBurnDownTableButton.frame = CGRectMake(-561,self.showBurnDownTableButton.frame.origin.y,self.showBurnDownTableButton.frame.size.width,self.showBurnDownTableButton.frame.size.height);
                 
                 self.afeBillingView.frame = CGRectMake(17,90,950,505);
                 self.byBillingcategoryButton.frame = CGRectMake(698,59,135,27);
                 self.byInvoiceButton.frame = CGRectMake(851,59,100,27);
                 
             }
                             completion:^(BOOL finished)
             {
                 self.afeBurnDownGraphView.hidden=YES;
                 self.afeBurnDownTableView.hidden = YES;
                 self.showBurnDownButton.hidden = YES;
                 self.showBurnDownTableButton.hidden = YES;
                 self.afeDetailsLeftView.hidden=YES;
                 self.byBillingcategoryButton.hidden = NO;
                 self.byInvoiceButton.hidden = NO;
                 self.afeBillingView.hidden = NO;
                 self.afeInvoiceView.hidden = YES;
                 
                 [self selectionType:self.byBillingcategoryButton];
             }];
        }
    }
    
    else if (sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if ([self.afeInvoiceButton isSelected]) 
        {
            pageCntlr.currentPage = 1;
            self.afeDetailsLeftView.frame = CGRectMake(-1007,80,432,538);
            self.afeDetailsLeftView.hidden = YES;
            self.afeBurnDownGraphView.frame = CGRectMake(-561,self.afeBurnDownGraphView.frame.origin.y,self.afeBurnDownGraphView.frame.size.width,self.afeBurnDownGraphView.frame.size.height);
             self.afeBurnDownTableView.frame = CGRectMake(-561,self.afeBurnDownTableView.frame.origin.y,self.afeBurnDownTableView.frame.size.width,self.afeBurnDownTableView.frame.size.height);
            self.showBurnDownButton.frame = CGRectMake(-561,self.showBurnDownButton.frame.origin.y,self.showBurnDownButton.frame.size.width,self.showBurnDownButton.frame.size.height);
             self.showBurnDownTableButton.frame = CGRectMake(-561,self.showBurnDownTableButton.frame.origin.y,self.showBurnDownTableButton.frame.size.width,self.showBurnDownTableButton.frame.size.height);
            
            self.afeDetailsLeftView.hidden = YES;

            //self.afeBillingView.hidden=YES;
            self.afeBurnDownButton.selected = YES;
            self.afeDetailsButton.selected = NO;
            self.afeInvoiceButton.selected = NO;
            self.showBurnDownButton.hidden = YES;
            self.showBurnDownTableButton.hidden = YES;
            self.afeBurnDownTableView.hidden =NO;
            
            [self showBurnDownGraphClicked];
            
            [UIView animateWithDuration:0.5 
                             animations:^
             {
                 self.afeInvoiceView.frame = CGRectMake(1024,87,950,505);
                self.afeBillingView.frame = CGRectMake(1024,87,950,505);
                 self.byBillingcategoryButton.frame= CGRectMake(self.byBillingcategoryButton.frame.origin.x+1024,59, 135, 27);
                 self.byInvoiceButton.frame= CGRectMake(self.byInvoiceButton.frame.origin.x+1024,59, 100, 27);
                 //self.afeDetailsLeftView.frame = CGRectMake(17,80,432,538);
                 self.afeBurnDownGraphView.frame = CGRectMake(17,88,self.afeBurnDownGraphView.frame.size.width,self.afeBurnDownGraphView.frame.size.height);
                  
                   self.afeBurnDownTableView.frame = CGRectMake(510,self.afeBurnDownTableView.frame.origin.y,self.afeBurnDownTableView.frame.size.width,self.afeBurnDownTableView.frame.size.height);
                 
                 self.showBurnDownButton.frame = CGRectMake(698,self.showBurnDownButton.frame.origin.y,self.showBurnDownButton.frame.size.width,self.showBurnDownButton.frame.size.height);
                 
                 self.showBurnDownTableButton.frame = CGRectMake(851,self.showBurnDownTableButton.frame.origin.y,self.showBurnDownTableButton.frame.size.width,self.showBurnDownTableButton.frame.size.height);

             }
                             completion:^(BOOL finished)
             {
                 self.afeInvoiceView.hidden=YES;
                 self.byBillingcategoryButton.hidden=YES;
                 self.byInvoiceButton.hidden=YES;
                 self.showBurnDownButton.hidden = YES;
                 self.showBurnDownTableButton.hidden = YES;
                 
                 [self showBurnDownGraphClicked];

             }];
        }
        else if ([self.afeBurnDownButton isSelected]) 
        {
            pageCntlr.currentPage = 0;
            self.afeDetailsLeftView.frame = CGRectMake(-1007,80,432,538);
        
            self.afeDetailsButton.selected = YES;
            self.afeBurnDownButton.selected = NO;
            self.afeInvoiceButton.selected = NO;
            self.afeInvoiceButton.selected = NO;
            self.byBillingcategoryButton.hidden = YES;
            self.byInvoiceButton.hidden = YES;
            self.showBurnDownButton.hidden = YES;
            self.showBurnDownTableButton.hidden = YES;
            self.afeDetailsLeftView.hidden = NO;
            
            [UIView animateWithDuration:0.5 
                             animations:^
             {
                 //self.afeInvoiceView.frame = CGRectMake(1024,87,950,505);
                 //self.afeBillingView.frame = CGRectMake(1024,87,950,505);
                 
                 self.afeBurnDownGraphView.frame = CGRectMake(1024, self.afeBurnDownGraphView.frame.origin.y, self.afeBurnDownGraphView.frame.size.width, self.afeBurnDownGraphView.frame.size.height);
                 
                     self.afeBurnDownTableView.frame = CGRectMake(1024, self.afeBurnDownTableView.frame.origin.y, self.afeBurnDownTableView.frame.size.width, self.afeBurnDownTableView.frame.size.height);
                 
                 self.afeDetailsLeftView.frame = CGRectMake(17, self.afeDetailsLeftView.frame.origin.y, self.afeDetailsLeftView.frame.size.width, self.afeDetailsLeftView.frame.size.height);
                 
                 self.showBurnDownButton.frame = CGRectMake(1024, self.showBurnDownButton.frame.origin.y, self.showBurnDownButton.frame.size.width, self.showBurnDownButton.frame.size.height);
                 
                 self.showBurnDownTableButton.frame = CGRectMake(1024, self.showBurnDownTableButton.frame.origin.y, self.showBurnDownTableButton.frame.size.width, self.showBurnDownTableButton.frame.size.height);
                 
                 
                 
             }
                             completion:^(BOOL finished)
             {
                 self.afeInvoiceView.hidden=YES;
                 self.byBillingcategoryButton.hidden=YES;
                 self.byInvoiceButton.hidden=YES;
                 self.showBurnDownButton.hidden = YES;
                 self.showBurnDownTableButton.hidden = YES;
                 
                 [self AFEDetailsButtonClick:self.afeDetailsButton];
                 
             }];
        }
    }           
}

/*
-(void)leftSwipe{
    [self.afeDetailsButton setSelected:NO];
    [self.afeInvoiceButton setSelected:NO];
    self.afeBillingView.hidden=NO;
    self.byBillingcategoryButton.hidden=NO;
    self.byInvoiceButton.hidden=NO;
    [self byBillingCategoryButtonTouched];
}

-(void)rightSwipe{
    [self.afeInvoiceButton setSelected:NO];
    [self.afeDetailsButton setSelected:YES];
    self.afeDetailsLeftView.hidden=NO;
    self.afeBurnDownGraphView.hidden=NO;
}
*/

-(IBAction)pageChangedOnControl:(UIPageControl*)sender{
    if(sender.currentPage){
        [self AFEDetailsButtonClick:nil];
            //  pageCntlr.currentPage=1;
    }
    else{
        [self AFEInvoiceButtonClick:nil];
            // pageCntlr.currentPage=0;

    }

}

-(void) viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight)) ;
}

#pragma - mark Button Actions

-(IBAction) AFEDetailsButtonClick:(id)sender{
    
    pageCntlr.currentPage = 0;
    self.afeDetailsLeftView.frame = CGRectMake(17,80,432,538);
    [self.afeDetailsButton setTitle:@"AFE Details" forState:UIControlStateSelected];

    [self.afeInvoiceButton setSelected:NO];
    [self.afeBurnDownButton setSelected:NO];
    
    [self.afeDetailsButton setSelected:YES];
    
    
    self.afeDetailsLeftView.hidden=NO;
    self.afeBurnDownGraphView.hidden=YES;
    self.afeBurnDownTableView.hidden = YES;
    self.afeInvoiceView.hidden=YES;
    self.afeBillingView.hidden=YES;
    self.showBurnDownButton.hidden = YES;
    self.showBurnDownTableButton.hidden = YES;
    
    self.byInvoiceButton.hidden=YES;
    self.byBillingcategoryButton.hidden=YES;
    
}

-(IBAction) AFEBurnDownButtonClick:(id)sender{
    [self.showBurnDownTableButton setSelected:YES];

    pageCntlr.currentPage = 1;
    self.showBurnDownButton.frame = CGRectMake(698,59,135,27);
    self.showBurnDownTableButton.frame = CGRectMake(851,59,100,27);
    [self.afeBurnDownGraphView setAutoresizingMask:UIViewAutoresizingNone];
    self.afeBurnDownGraphView.frame =  CGRectMake(20,88,self.afeBurnDownGraphView.frame.size.width,self.afeBurnDownGraphView.frame.size.height);
        // self.afeBurnDownTableView.frame = CGRectMake(17,self.afeBurnDownTableView.frame.origin.y,self.afeBurnDownTableView.frame.size.width,self.afeBurnDownTableView.frame.size.height);
    
    [self.afeInvoiceButton setSelected:NO];
    [self.afeDetailsButton setSelected:NO];
    [self.afeBurnDownButton setSelected:YES];
    
    self.afeDetailsLeftView.hidden=YES;
    self.afeBurnDownGraphView.hidden=NO;
    self.afeBurnDownTableView.hidden = YES;
    self.afeInvoiceView.hidden=YES;
    self.afeBillingView.hidden=YES;
    
    self.byInvoiceButton.hidden=YES;
    self.byBillingcategoryButton.hidden=YES;
    
    self.showBurnDownButton.hidden = YES;
        //self.showBurnDownTableButton.hidden = NO;
    
    [self showBurnDownGraphClicked];
    
    [self.view bringSubviewToFront:pageCntlr];
    
}


-(IBAction) AFEInvoiceButtonClick:(id)sender{
    
    pageCntlr.currentPage = 2;
    self.afeBillingView.frame = CGRectMake(17,90,950,505); 
    self.byBillingcategoryButton.frame = CGRectMake(698,59,135,27);
    self.byInvoiceButton.frame = CGRectMake(851,59,100,27);
    [self.afeDetailsButton setSelected:NO];
    [self.afeInvoiceButton setSelected:YES];
    [self.afeBurnDownButton setSelected:NO];
    
    [self.afeDetailsButton setTitle:@"AFE Details" forState:UIControlStateSelected];

    self.afeDetailsLeftView.hidden=YES;
    self.afeBurnDownGraphView.hidden=YES;
    self.afeBurnDownTableView.hidden = YES;
    self.afeInvoiceView.hidden=YES;
    self.afeBillingView.hidden=NO;
    
    self.byInvoiceButton.hidden=NO;
    self.byBillingcategoryButton.hidden=NO;
    self.showBurnDownButton.hidden = YES;
    self.showBurnDownTableButton.hidden = YES;
    
    [self selectionType:self.byBillingcategoryButton];
    [self.view bringSubviewToFront:pageCntlr];
    
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
    
    self.afeInvoiceView.frame = CGRectMake(17,87,950,505);
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

-(IBAction) showBurnDownGraphClicked
{
    [self.showBurnDownButton setSelected:YES];
    self.afeBurnDownTableView.hidden = NO;
        //  [self.showBurnDownTableButton setSelected:NO];
    self.afeBurnDownGraphView.hidden=NO;
        //  self.afeBurnDownTableView.hidden = YES;
    self.afeBurnDownTableView.frame = CGRectMake(510,90,afeBurnDownTableView.frame.size.width,afeBurnDownTableView.frame.size.height);
    
    self.showBurnDownButton.userInteractionEnabled = NO;
    self.showBurnDownTableButton.userInteractionEnabled = YES;
    
}


-(IBAction) showBurnDownTableClicked
{
    
    [self.showBurnDownButton setSelected:NO];
    [self.showBurnDownTableButton setSelected:YES];
    self.afeBurnDownGraphView.hidden=YES;
    self.afeBurnDownTableView.hidden = NO;
    
    self.showBurnDownButton.userInteractionEnabled = YES;
    self.showBurnDownTableButton.userInteractionEnabled = NO;
}


#pragma mark - API Call on Search Button Click
- (void) callAPIforAFEDetailWithAfeID:(NSString *)afeID{
    if (afeID == NULL||[afeID isEqualToString:@""]) {
        [self.afeDetailsButton setTitle:@"AFE Details" forState:UIControlStateNormal];
        [self.afeDetailsButton setTitle:@"AFE Details" forState:UIControlStateSelected];
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Fields Empty" message:@"Please Enter a Valid AFE Number or AFE Name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alertView show];
        [self.afeDetailsLeftView getAfeSearchSummaryArray:nilArray];
        [self.afeBurnDownGraphView getAfeBurnDownDetailArray:nilArray];
        [self.afeInvoiceView getAfeSearchInvoiceArray:nilArray forPage:newPageNumber_InvoiceTable ofTotalPages:totalPageCount_InvoiceTable];
        [self.afeBillingView getAfeSearchBillingCategoryArray:nilArray forPage:newPageNumber_BillingCategoryTable ofTotalPages:totalPageCount_BillingCategoryTable];
    }
    else {
        [self initializeAfeSearchAPIHandlerAndRequestArray];
        
        [afeSearchAPIHandlerObj getAFEDetailsWithID:afeID]; 
        [self.afeDetailsLeftView showActivityIndicatorOverlayView];
        
        [afeSearchAPIHandlerObj getAFEBurnDownWithID:afeID];
        [self.afeBurnDownGraphView showActivityIndicatorOverlayView];
        [self.afeBurnDownTableView showActivityIndicatorOverlayView];
        
        if(burnDownGraphDetailedView)
            [burnDownGraphDetailedView showActivityIndicatorOverlayView];
        
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
            afeBurnDownArray = requestInfoObj.resultObject;
            
            [self.afeBurnDownGraphView getAfeBurnDownDetailArray:requestInfoObj.resultObject];
            [self.afeBurnDownGraphView removeActivityIndicatorOverlayView];
            
            [self.afeBurnDownTableView refreshWithAfeBurnDownItemArray:requestInfoObj.resultObject forPage:1 ofTotalPages:1 andTotalRecordCount:(requestInfoObj.resultObject? ((NSArray*) requestInfoObj.resultObject).count:0)];
            [self.afeBurnDownTableView removeActivityIndicatorOverlayView];
            
            if(burnDownGraphDetailedView)
            {
                [burnDownGraphDetailedView removeActivityIndicatorOverlayView];
                [burnDownGraphDetailedView refreshDataWithAFEArray:requestInfoObj.resultObject andStartDate:[NSDate date] andEndDate:[NSDate date]];
            }
            
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
            self.afeInvoiceView.totalRecords = recordCount;
            
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
            self.afeBillingView.totalRecordCount_InvoiceDetailTable=recordCount;
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


-(void) showExpandedBurndownGraphWithBurnDownItemArray:(NSArray *)burnDownItemArrayToUse andStartDate:(NSDate *)start andEndDate:(NSDate *)end
{
    burnDownGraphDetailedView = [[AFEBurnDownGraphDetailedView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];  
    burnDownGraphDetailedView.alpha = 0;
    burnDownGraphDetailedView.delegate = self;
    
    UIViewController *tempAFESearchCtrlr = (UIViewController*) self.delegate;
    [tempAFESearchCtrlr.navigationController.view addSubview:burnDownGraphDetailedView];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        burnDownGraphDetailedView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [burnDownGraphDetailedView refreshDataWithAFEArray:burnDownItemArrayToUse andStartDate:start andEndDate:end];
        
    }];
    

}

-(void) didCloseAFEBurnDownGraphDetailedView:(AFEBurnDownGraphDetailedView *)view
{
    if(burnDownGraphDetailedView && view == burnDownGraphDetailedView)
    {
        [burnDownGraphDetailedView removeFromSuperview];
        burnDownGraphDetailedView = nil;
    }
}

@end
