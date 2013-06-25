//
//  TDMAddSignatureDishViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/13/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMAddSignatureDishViewController.h"
#import "TDMSuccessPageViewController.h"
#import "TDMReviewConfirmationViewController.h"
#import "TDMAddSignatureDishThanks.h"
#import "TDMAddSignatureDishFindRestaurant.h"

#import "MBProgressHUD.h"

#define NAV_TITLE @"Add Dish"

@interface TDMAddSignatureDishViewController (Private)
- (void)customiseCurrentView;
- (void)addViewsToScrollView;
- (void)addReviewTitleTextView;
- (void)addReviewDecriptionTextView;
- (void)startNotifications;
- (void)addThumbImage:(NSString *)imageName imageRect:(CGRect)rect;
- (void)addReviewDescriptionImage;

- (void)adjustScrollView;
- (void)RestoreScrollview;
- (void)startAnimateScrollview:(int)iVal;
- (void)customiseCurrentView;

@end

@implementation TDMAddSignatureDishViewController
@synthesize addDishScrollView;
@synthesize reviewTitleTextView;
@synthesize reviewDescriptionTextView;

@synthesize backgroungImageView;
@synthesize findRestaurantBtn;
@synthesize submitBtn;

@synthesize  titleViewImage;
@synthesize viewTitleImageTitle;

@synthesize submitButton;
@synthesize reviewDescriptionLabel;
@synthesize adButton;
@synthesize businessType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self createCustomisedNavigationTitleWithString:NAV_TITLE];
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
}
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    addDishScrollView.contentSize = CGSizeMake(320, 480);
    [self customiseCurrentView];
    [self addViewsToScrollView];
    [self.navigationItem setRBIconImage];
    if (businessType == kBARS_TABBAR_INDEX) 
    {
        findRestaurantBtn.titleLabel.text = @"Find The Bar";
    }
    else if(businessType == kRESTAURANTS_TABBAR_INDEX)
    {
        findRestaurantBtn.titleLabel.text = @"Find The Restaurant";
    }
   
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self customiseCurrentView];

}

#pragma mark - View Creations
- (void)customiseCurrentView{
    
    //this will show the Tabbat
    [self showTabbar];
    NSString *restuarantId = [ClassFinder getRestaurantId];
    if (restuarantId != nil) 
    {
        findRestaurantBtn.hidden = YES;
        CGRect findRect = findRestaurantBtn.frame;
        submitBtn.frame = findRect; 
    }
    //creates Accountbar on Navigation Bar
    [self createAccountButtonOnNavBar];
    [self startNotifications];
    
}

- (void)viewDidUnload
{
    [self setAddDishScrollView:nil];
    [self setFindRestaurantBtn:nil];
    [self setSubmitBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [addDishScrollView release];
    [findRestaurantBtn release];
    [submitBtn release];
    [super dealloc];
}

- (void)addViewsToScrollView
{
    //add review images
    CGRect rect = CGRectMake(15, 10, 62, 62);
    [self addThumbImage:@"dish1.jpg" imageRect:rect];
    
    //    //add review description image
    //    CGRect rect = CGRectMake(15, 10, 62, 62);
    //    [self addThumbImage:@"dish1.jpg" imageRect:rect];
    
    [self addReviewDescriptionImage];
    
    [self addReviewTitleTextView];
    [self addReviewDecriptionTextView];
    
    reviewDescriptionLabel.frame = CGRectMake(90, 98, 210, 15);
    reviewDescriptionLabel.font = kGET_BOLD_FONT_WITH_SIZE(12);
    reviewDescriptionLabel.textColor = [UIColor blackColor];
    reviewDescriptionLabel.backgroundColor  = [UIColor clearColor];
    reviewDescriptionLabel.textAlignment=UITextAlignmentLeft;
    reviewDescriptionLabel.text= [NSString stringWithFormat:@"Review by User"];
    
    self.submitButton.frame = CGRectMake(90, 230, 210, 35);
}

- (void)addThumbImage:(NSString *)imageName imageRect:(CGRect)rect
{
    
    UIButton *addReviewTitleImageButton = [[UIButton alloc]initWithFrame:rect];
    [addReviewTitleImageButton.layer setCornerRadius:5.0];
    [addReviewTitleImageButton setUserInteractionEnabled:NO];
    [addReviewTitleImageButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    addReviewTitleImageButton.layer.masksToBounds = YES;
    [self.addDishScrollView addSubview:addReviewTitleImageButton];
    REMOVE_FROM_MEMORY(addReviewTitleImageButton); 
    
    //set border of the image 
    CGRect borderRect = rect;
    borderRect.origin.x = borderRect.origin.x - 2;
    borderRect.origin.y = borderRect.origin.y - 2;
    borderRect.size.width = borderRect.size.width + 4;
    borderRect.size.height = borderRect.size.height + 4;
    
    UIButton *borderButton = [[UIButton alloc]initWithFrame:borderRect];
    borderButton.userInteractionEnabled = NO;
    [borderButton.layer setBorderWidth:1.0];
    [borderButton.layer setCornerRadius:10.0];
    [borderButton.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor]];
    [self.addDishScrollView addSubview:borderButton];
    REMOVE_FROM_MEMORY(borderButton);
}

- (void)addReviewDescriptionImage
{
    UIButton *addDescriptionImageButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 100, 62, 62)];
    // [addDescriptionImageButton.layer setCornerRadius:5.0];
    [addDescriptionImageButton setUserInteractionEnabled:NO];
    [addDescriptionImageButton setBackgroundImage:[UIImage imageNamed:@"dish1.jpg"] forState:UIControlStateNormal];
    //addDescriptionImageButton.layer.masksToBounds = YES;
    [self.addDishScrollView addSubview:addDescriptionImageButton];
    REMOVE_FROM_MEMORY(addDescriptionImageButton); 
    
    //set border of the image 
    UIButton *borderButton = [[UIButton alloc]initWithFrame:CGRectMake(13, 98, 66, 66)];
    borderButton.userInteractionEnabled = NO;
    [borderButton.layer setBorderWidth:1.0];
    [borderButton.layer setCornerRadius:10.0];
    [borderButton.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor]];
    [self.addDishScrollView addSubview:borderButton];
    REMOVE_FROM_MEMORY(borderButton);
}
- (void)addReviewTitleTextView
{
    CGRect rect = CGRectMake(90,10,210,62);
    
    self.reviewTitleTextView = [[[TDMPlaceHolderTextView alloc] init] autorelease];
    [self.reviewTitleTextView setFrame:rect];
    self.reviewTitleTextView.tag  = 1;
    self.reviewTitleTextView.delegate = self;
    [self.reviewTitleTextView.layer setCornerRadius:7.0];
    self.reviewTitleTextView.placeHolder = @"Enter Dish Name Here";
    [self.addDishScrollView addSubview:self.reviewTitleTextView];
    [reviewTitleTextView release];
}
- (void)addReviewDecriptionTextView
{
    CGRect rect = CGRectMake(90,100,210,100);
    
    self.reviewDescriptionTextView = [[[TDMPlaceHolderTextView alloc] init] autorelease];
    [self.reviewDescriptionTextView setFrame:rect];
    self.reviewDescriptionTextView.tag = 2;
    self.reviewDescriptionTextView.delegate = self;
    [self.reviewDescriptionTextView.layer setCornerRadius:7.0];
    self.reviewDescriptionTextView.placeHolder = @"Enter Dish Description Here";
    [self.addDishScrollView addSubview:self.reviewDescriptionTextView];
    [reviewDescriptionTextView release];
}
-(void)startNotifications {
    
    // register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification 
											   object:self.view.window];
	// register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillHide:) 
												 name:UIKeyboardWillHideNotification 
											   object:self.view.window];
}

#pragma mark - scrolling handling

- (void)keyboardWillHide:(NSNotification *)obj_notification{
	if(bcontentflag)
	{
		icontentsize    = 460;
		self.addDishScrollView.contentSize= CGSizeMake(0, icontentsize);
		bcontentflag    = NO;
	}
	[self RestoreScrollview];
}

- (void)keyboardWillShow:(NSNotification *)obj_notification{
	[self adjustScrollView];
}


-(void)RestoreScrollview{
    CGPoint pt;
    pt.x = 0;
    pt.y = 50 ;
    [self.addDishScrollView setContentOffset:pt animated:YES];
}

-(void)adjustScrollView{		
	if(!bcontentflag)
	{
		icontentsize=270;
		self.addDishScrollView.contentSize= CGSizeMake(0, icontentsize);
		bcontentflag=YES;
	}
	
}

-(void)startAnimateScrollview:(int)iVal{
    CGRect rc   = [self.addDishScrollView bounds];
    rc          = [self.addDishScrollView convertRect:rc toView:self.view];
    CGPoint pt  = rc.origin ;
    pt.x        = 0 ;
    pt.y -= iVal*(-1) ;
    [self.addDishScrollView setContentOffset:pt animated:YES];
}


#pragma mark TextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self adjustScrollView];
	float fval;
	
	if(textView.tag == 2 ) {
		CGRect m_objtextrect=[self.view frame];		
		fval=m_objtextrect.origin.y;
		m_objtextrect=[textView frame];
		fval=fval+m_objtextrect.origin.y;
		if(fval > 55){
            [self startAnimateScrollview:(int)((fval-120))];//120 value is the scrollable Y Position
            
		}
	}
    
    return YES;
}

#pragma mark - Validation Methods Add Review

- (BOOL)isNonEmptyString:(NSString*)string {
    BOOL isValid = NO;
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string length]>0) {
        isValid = YES;
    }
    return isValid;    
}

- (BOOL)isValReviewTitle {
    BOOL isValid =  NO;
    if ([self isNonEmptyString:self.reviewTitleTextView.text]) {
        isValid = YES;
    }
    return isValid;
}

- (BOOL)isValidReviewDescription {
    BOOL isValid = NO;
    if ([self isNonEmptyString:self.reviewDescriptionTextView.text]) {
        isValid = YES;
    }
    return isValid;
}
//returns TRUE if all fields are valid else FALSE
- (BOOL)isValidAddReviewDatas {
    
#define AS_ADD_REVIEW_WITH_NO_TITLE_DATA @"Review title is empty"
#define AS_ADD_REVIEW_WITH_NO_DESCRIPTION_DATA @"Review description is empty"
    
    BOOL isValid = YES;
    NSString * alertMessage;
    do {
        if (![self isNonEmptyString:self.reviewTitleTextView.text]) {
            alertMessage = AS_ADD_REVIEW_WITH_NO_TITLE_DATA;
            isValid = NO;
            break;
        }
        
        if (![self isNonEmptyString:self.reviewDescriptionTextView.text]) {
            alertMessage = AS_ADD_REVIEW_WITH_NO_DESCRIPTION_DATA;
            isValid = NO;
        }
        //add for more checking here
        //...
        //...
        
    } while (FALSE);
    
    if (!isValid) {
        
        kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, alertMessage);
        
    }
    return isValid;    
}



#pragma mark - Button Actions
//- (IBAction)submitButtonClicked:(id)sender {
//    
//    TDMSuccessPageViewController *successPageViewController = (TDMSuccessPageViewController *)[self getClass:kSUCCESSPAGE_CLASS];
//    [self.navigationController pushViewController:successPageViewController animated:YES];
//}
//
//- (IBAction)submitReviewButtonClicked:(id)sender {
//    
//    
//    if ([self isValidAddReviewDatas]) 
//    {
//        NSLog(@"Call API 4 Add Review");
//        
//        TDMReviewConfirmationViewController *confirmReviewController = (TDMReviewConfirmationViewController *)[self getClass:kADDREVIEW_CONFIRMATION_CLASS];
//        [self.navigationController pushViewController:confirmReviewController animated:YES];
//    }
//}
//

- (IBAction)addDishFindRestaurantClicked:(id)sender {
    TDMAddSignatureDishFindRestaurant *find = [[TDMAddSignatureDishFindRestaurant alloc]init];
    find.typeOfBusiness = businessType;
    NSLog(@"%d",businessType);
    [self.navigationController pushViewController:find animated:YES];
    [find release];
}

- (IBAction)addDishSubmitClicked:(id)sender {
    
    addSignatureDish = [[TDMAddSignatureDishHandlerAndProvider alloc] init];
    addSignatureDish.signatureDishDelegate = self;
    addSignatureDish.requestType = kTDMAddSignatureDish;
    [addSignatureDish addSignatureDishWithBody:@"Awesome Dish" andTitle:@"Signature Dish through REST" forVenue:@"20838" withPhotoFID:@""];
    [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];

}

-(void)signatureDishAddedSuccessFully {
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    
    [reviewTitleTextView setText:@""];
    self.reviewTitleTextView.placeHolder = @"Enter Dish Name Here";
    [reviewDescriptionTextView setText:@""];
    self.reviewDescriptionTextView.placeHolder = @"Enter Dish Description Here";
    
    TDMAddSignatureDishThanks *thanksObject = [[TDMAddSignatureDishThanks alloc]init];
    [self.navigationController pushViewController:thanksObject animated:YES];
    [thanksObject release];
    
    addSignatureDish.signatureDishDelegate = nil;
    [addSignatureDish release];
}

-(void)failedToAddSignatureDish {
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"Failed To Add Signature dish. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
    
    addSignatureDish.signatureDishDelegate = nil;
    [addSignatureDish release];
}
@end
