//
//  TDMReviewRestaurant.m
//  TheDailyMeal
//
//  Created by Apple on 17/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "TDMNavigationController.h"
#import "TDMReviewRestaurant.h"
#import "TDMAddBusinessReviewService.h"
#import "TDMReviewRestaurantAddPhoto.h"
#import "TDMRestaurantReviewList.h"
#import "DatabaseManager.h"
#import "TDMPlaceHolderTextView.h"

@implementation TDMReviewRestaurant
@synthesize restaurantReviewImage;
@synthesize restaurantReviewTextView;
@synthesize restaurantReviewSubmitButton;
@synthesize placeholderLabel;
@synthesize restaurantName;
@synthesize userName;
@synthesize restaurantID;
@synthesize businessId;
@synthesize businessType;
@synthesize reviewTitle;
@synthesize reviewScrollView;
@synthesize isFromLogin;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
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
    [self createAdView];
    if (self.isFromLogin) 
    {
       // self.navigationItem.hidesBackButton = YES;
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
    }
    else
    {
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES  forKey:@"isReview"];
    [self registerKeyboardNotifications];
    [self addReviewTitleView];
    [self addReviewDescriptionView];
    self.reviewTitle.returnKeyType = UIReturnKeyNext;
    self.restaurantReviewTextView.returnKeyType = UIReturnKeyDefault;
    [self.navigationItem setTDMIconImage];
    NSDictionary *userDetails  =[[DatabaseManager sharedManager] getUserDetailsFromDataBase];
    NSString *usernameText = [userDetails objectForKey:@"username"];
    [self createReviewListButtonOnNavBar];
    [self.userName setText:[NSString stringWithFormat:@"Review by %@",usernameText]];
    // Do any additional setup after loading the view from its nib.
}

- (void)registerKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardDidShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

- (void)unregisterKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)addReviewTitleView
{
    CGRect rect=CGRectMake(90, 80, 210, 62);
    self.reviewTitle=[[[TDMPlaceHolderTextView alloc]init]autorelease];
    [self.reviewTitle setFrame:rect];
    self.reviewTitle.tag=12;
    self.reviewTitle.font=[UIFont fontWithName:@"Trebuchet MS" size:13];
    self.reviewTitle.delegate = self;    
    [self.reviewTitle.layer setCornerRadius:10.0];
    self.reviewTitle.textColor=[UIColor blackColor];
    self.reviewTitle.placeHolder = @"Enter Review Title Here";
    [self.reviewScrollView addSubview:self.reviewTitle];
    
}

- (void)addReviewDescriptionView
{
    CGRect rect = CGRectMake(90,160,210,100);
    
    self.restaurantReviewTextView = [[[TDMPlaceHolderTextView alloc] init] autorelease];
    [self.restaurantReviewTextView setFrame:rect];
    self.restaurantReviewTextView.textColor=[UIColor blackColor];
    self.restaurantReviewTextView.font=[UIFont fontWithName:@"Trebuchet MS" size:13];
    self.restaurantReviewTextView.tag = 11;
    self.restaurantReviewTextView.delegate = self;
    [self.restaurantReviewTextView.layer setCornerRadius:10.0];
    self.restaurantReviewTextView.placeHolder = @"Enter Review Description Here";
    //self.restaurantReviewTextView.font=[UIFont fontWithName:@"Trebuchet MS" size:12.0];
    
    [self.reviewScrollView addSubview:self.restaurantReviewTextView];
 
}

- (void)viewDidUnload
{
    [self setRestaurantReviewImage:nil];
    [self setRestaurantReviewTextView:nil];
    [self setRestaurantReviewSubmitButton:nil];
    [self setPlaceholderLabel:nil];
    [self setRestaurantName:nil];
    [self setUserName:nil];
    [self setRestaurantID:nil];
    [self unregisterKeyboardNotifications];
    [self setReviewTitle:nil];
    [self setReviewScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) viewWillAppear:(BOOL)animated
{
    restaurantReviewTextView.autocorrectionType=UITextAutocorrectionTypeNo;
    reviewTitle.autocorrectionType=UITextAutocorrectionTypeNo;
        [self createReviewListButtonOnNavBar];
}

- (void)dealloc {
    
    [self unregisterKeyboardNotifications];
    [restaurantReviewImage release];
    [restaurantReviewTextView release];
    [restaurantReviewSubmitButton release];
    [placeholderLabel release];
    [restaurantName release];
    [userName release];
    [restaurantID release];
    
    [reviewTitle release];
    [reviewScrollView release];
    [super dealloc];
}

-(void) keyboardWillShow:(NSNotification *)note
{
    self.reviewScrollView.contentSize = CGSizeMake(320, 600) ;
}
-(void) keyboardWillHide:(NSNotification *)note
{
     self.reviewScrollView.contentSize = CGSizeMake(320, 460) ;
}
#pragma mark - button Click

- (void)reviewBarButtonClicked:(id)sender{
    
    TDMRestaurantReviewList *review = [[TDMRestaurantReviewList alloc]init];
    review.restaurantNameTitle = self.restaurantName;
    review.busibessType = businessType;
    [self.navigationController pushViewController:review animated:YES];
    [review release];
    
}

#pragma mark -  TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView == reviewTitle) 
    {
        if([text isEqualToString:@"\n"])
        {
            [restaurantReviewTextView becomeFirstResponder];
            [self.reviewScrollView setContentOffset:CGPointMake(0, 60) animated:YES];
            return NO; 
        }
    }
    if (textView == restaurantReviewTextView) {
        [self.reviewScrollView setContentOffset:CGPointMake(0, 60) animated:YES];
        if([text isEqualToString:@"\n"])
        {
            [restaurantReviewTextView resignFirstResponder];
            [self.reviewScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
        }
    }
    
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
  
	if (textView == restaurantReviewTextView) {
        [self.reviewScrollView setContentOffset:CGPointMake(0,70) animated:YES];
    }
    if(textView==reviewTitle){
        [self.reviewScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
       return YES;
}

- (BOOL)isNonEmptyString:(NSString*)string 
{
    BOOL isValid = NO;
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string length]>0) {
        isValid = YES;
    }
    return isValid;    
}

- (IBAction)restaurantReviewSubmitButtonClicked:(id)sender {
    
    if (reviewTitle.text.length == 0) 
    {
        kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Please Enter your Review Title") 
    }
    else if (![self isNonEmptyString:self.reviewTitle.text])
    {
        kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Please Enter your Review Title")    
    }
    else if(restaurantReviewTextView.text.length ==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meal" message:@"Please Enter your Review" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if(![self isNonEmptyString:self.restaurantReviewTextView.text])
    {
        kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Please Enter your Review")  
    }
    else
    {
        //[self showOverlayView];
        TDMReviewRestaurantAddPhoto *tDMReviewRestaurantAddPhoto = [[TDMReviewRestaurantAddPhoto alloc] initWithNibName:@"TDMReviewRestaurantAddPhoto" bundle:nil];
        [tDMReviewRestaurantAddPhoto setRestaurantName:restaurantName];
        [tDMReviewRestaurantAddPhoto setReviewText:[NSString stringWithFormat:@"%@  -  %@",[restaurantReviewTextView text],[reviewTitle text]]];
        NSLog(@"desc : %@",self.restaurantReviewTextView.text);
        tDMReviewRestaurantAddPhoto.reviewDescription = self.restaurantReviewTextView.text;
        tDMReviewRestaurantAddPhoto.reviewTitle = self.reviewTitle.text;
        tDMReviewRestaurantAddPhoto.businessId = self.businessId;
        [self.navigationController pushViewController:tDMReviewRestaurantAddPhoto 
                                             animated:YES];
        [tDMReviewRestaurantAddPhoto release];
        tDMReviewRestaurantAddPhoto = nil;


    }
}

#pragma mark    Overlay View Management


- (void)removeOverlayView
{
    if (overlayView)
    {
        [overlayView removeFromSuperview];
        [overlayView release];
        overlayView = nil;
    }
}
- (void)showOverlayView
{
    [self removeOverlayView];
    
    overlayView = [[TDMOverlayView alloc] initWithSyncStyleAndTitle:@"Adding Review..."];
}

-(void) textViewDidBeginEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden=YES;
    edit=YES;
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(![textView hasText])
    {
         self.placeholderLabel.hidden=NO;
    }    
}
- (void)textViewDidChange:(UITextView *)textView
{
    
        if (![textView hasText]) {
        
        self.placeholderLabel.hidden=NO;
    }
    else if([[textView subviews]containsObject:self.placeholderLabel])
    {
        
        self.placeholderLabel.hidden=YES;
    } 
       
   	
}

-(void) businessReviewAddedSuccessfully
{

    [self removeOverlayView];
}

-(void) businessReviewFailed {
    
    [self removeOverlayView];
    
}

-(void) networkErrorInAddinBusinessReview 
{
    [self removeOverlayView];
}

@end
