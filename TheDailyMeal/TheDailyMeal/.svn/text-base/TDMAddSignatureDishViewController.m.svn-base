//
//  TDMAddSignatureDishViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/13/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMAddSignatureDishViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TDMPhotoUploadService.h"
#import "DatabaseManager.h"
#import "TDMAddSignatureDishFindRestaurant.h"
#import "TDMLoginViewController.h"
#import "TDMCustomTabBar.h"

#define NAV_TITLE @"Add Dish"

@interface TDMAddSignatureDishViewController (Private)

- (void)customiseCurrentView;
- (void)customizeScrollView;
- (void)addDishTitleView;
- (void)addDishDescriptionView;
- (void)addThumbImage:(NSString *)imageName imageRect:(CGRect)rect;
- (void)removeOverlayView;
- (void)showOverlayView;

@end

@implementation TDMAddSignatureDishViewController
@synthesize addDishScrollView;
@synthesize dishName;
@synthesize dishDescription;
@synthesize backgroungImageView;
@synthesize findRestaurantBtn;
@synthesize submitBtn;
@synthesize  titleViewImage;
@synthesize viewTitleImageTitle;
@synthesize submitButton;
@synthesize reviewDescriptionLabel;
@synthesize adButton;
@synthesize businessType;
@synthesize venueId;
@synthesize isFromBusinessHome;
@synthesize imageName;
@synthesize isFromLogin,imageData;

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload
{
    [self unregisterKeyboardNotifications];
    [self setAddDishScrollView:nil];
    [self setFindRestaurantBtn:nil];
    [self setSubmitBtn:nil];
    [super viewDidUnload];
}

- (void)dealloc 
{
    [addDishScrollView release];
    [findRestaurantBtn release];
    [submitBtn release];
    [dishName release];
    [dishDescription release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self createCustomisedNavigationTitleWithString:NAV_TITLE];
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (isFromBusinessHome) 
    {
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
        findRestaurantBtn.hidden = YES;
    }
    else
    {
        self.navigationItem.hidesBackButton = YES;
    }
    NSUserDefaults *isReview=[NSUserDefaults standardUserDefaults];
    if([isReview boolForKey:@"isReview"])
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isReview"];
    }
    [self registerKeyboardNotifications];
    addDishScrollView.contentSize = CGSizeMake(320, 490);
    [self customiseCurrentView];
    [self customizeScrollView];
    [self createAdView];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    int selectedIndex =  appDelegate.tabBarController.selectedIndex;
   
    if (selectedIndex == 2) {
        if([TDMDataStore sharedStore].isLoggedIn && (!isPhotoPresent))
            if (!isActionSheetPresent) {
                [self performSelector:@selector(addNewImage:)];
            }
        
    }

    NSString *businesId  = [TDMUtilities getRestaurantId];
    if (!businesId || ([businesId isEqualToString:@" "])) {
        submitBtn.hidden = YES;
    }
    else
    {
        submitBtn.hidden = NO;
    }


}

- (void)viewWillAppear:(BOOL)animated
{
    
//    self.dishName.autocorrectionType=UITextAutocorrectionTypeNo;
//    self.dishDescription.autocorrectionType=UITextAutocorrectionTypeNo;
    if(animated)
    {
        if (isFromLogin) 
        {
             findRestaurantBtn.hidden = YES;
             self.submitBtn.frame = CGRectMake(90, 217, 210, 35);
        }
        else
        {
            findRestaurantBtn.hidden = NO;
        }
        if (isFromBusinessHome) 
        {
            [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
            findRestaurantBtn.hidden = YES;
        }
        else
        {
            self.navigationItem.hidesBackButton = YES;
        }
        if ([TDMDataStore sharedStore].isLoggedIn)
        {
            [self customiseCurrentView];
            if (!isPhotoPresent) 
            {
                if (!isActionSheetPresent) {
                    [self performSelector:@selector(addNewImage:)];
                }
            }
        }
//        else
//        {
//            [[NSUserDefaults standardUserDefaults]setObject:@" " forKey:kIS_TO_LOGIN];
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:TDM_TITLE message:@"You are not logged in .Do you want to login?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//            [alert show];
//            REMOVE_FROM_MEMORY(alert)
//           
//        }
    }
     AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
     TDMCustomTabBar *tab = (TDMCustomTabBar *) appDelegate.tabBarController;
    int selectedIndex =  [tab getSelectedTabIndex];
   
    if (selectedIndex == 2) {
        if([TDMDataStore sharedStore].isLoggedIn && (!isPhotoPresent))
            if (!isActionSheetPresent) {
                 [self performSelector:@selector(addNewImage:)];
            }
            
    }

    if ([TDMDataStore sharedStore].isLoggedIn)
    {
        [self customiseCurrentView];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:@" " forKey:kIS_TO_LOGIN];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:TDM_TITLE message:@"Please log in" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        alert.tag=100;
        [alert show];
        REMOVE_FROM_MEMORY(alert)
        
    }
    NSString *businesId  = [TDMUtilities getRestaurantId];
    if (!businesId || ([businesId isEqualToString:@" "])) {
       submitBtn.hidden = YES;
    }
    else
    {
        submitBtn.hidden = NO;
    }
}
#pragma mark - AlertView Delegates

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if(actionSheet.tag==100 ) {
       if (buttonIndex == 0) {
    
        TDMLoginViewController *loginVC = [[TDMLoginViewController alloc]initWithNibName:@"TDMLoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
        [loginVC release];
       }
    }
    if(actionSheet.tag==200){
        if(buttonIndex==0){
                   TDMLoginViewController *loginViewController = (TDMLoginViewController *)[self getClass:kLOGIN_SIGNUPCLASS];
                   [self.navigationController pushViewController:loginViewController animated:YES];

            }
   
        }
}
#pragma mark - View Customization

- (void)customiseCurrentView
{
    
    //this will show the Tabbar
    [self showTabbar];
    
    //creates Accountbar on Navigation Bar
    [self createAccountButtonOnNavBar];
    //[self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
    
    self.dishName.returnKeyType = UIReturnKeyNext;
    self.dishDescription.returnKeyType = UIReturnKeyNext;
    dishDescription.tag =  25;

    
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
-(void) keyboardWillShow:(NSNotification *)note
{
    self.addDishScrollView.contentSize = CGSizeMake(320, 700) ;
}
-(void) keyboardWillHide:(NSNotification *)note
{
    self.addDishScrollView.contentSize = CGSizeMake(320, 460) ;
}


#pragma mark - Handle Orientations
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Create views
- (void)customizeScrollView
{
    //add review images
    CGRect rect = CGRectMake(15, 10, 60, 60);
    [self addThumbImage:@"signupAddPhoto" imageRect:rect];
    [self addDishTitleView];
    [self addDishDescriptionView];
    
    if (isFromBusinessHome) 
    {
        self.submitBtn.frame = CGRectMake(90, 217, 210, 35);
    }
//    else
//    {
//        self.submitBtn.frame = CGRectMake(90, 290, 210, 35);
//    }
}

- (void)addDishTitleView
{
    CGRect rect = CGRectMake(88,10,210,62);
    
    self.dishName = [[TDMPlaceHolderTextView alloc] init] ;
    [self.dishName setFrame:rect];
    self.dishName.tag  = 1;
    self.dishName.delegate = self;
    [self.dishName.layer setCornerRadius:10.0];
    [self.dishName setFont:[UIFont fontWithName:@"Trebuchet MS" size:13.0]];
    self.dishName.placeHolder = @"Enter Dish Name Here";
    self.dishName.textColor=[UIColor blackColor];
    [self.addDishScrollView addSubview:self.dishName];
    
}

- (void)addDishDescriptionView
{
    CGRect rect = CGRectMake(90,100,210,100);
    
    self.dishDescription = [[TDMPlaceHolderTextView alloc] init] ;
    [self.dishDescription setFrame:rect];
    self.dishDescription.tag = 2;
    [self.dishDescription setFont:[UIFont fontWithName:@"Trebuchet MS" size:13.0]];
    self.dishDescription.delegate = self;
    self.dishDescription.textColor=[UIColor blackColor];
    [self.dishDescription.layer setCornerRadius:10.0];
    self.dishDescription.placeHolder = @"Enter Dish Description Here";
    [self.addDishScrollView addSubview:self.dishDescription];
   
}


- (void)addThumbImage:(NSString *)imagName imageRect:(CGRect)rect
{
    //set border of the image 
    CGRect borderRect = rect;
    borderRect.origin.x = borderRect.origin.x-2 ;
    borderRect.origin.y = borderRect.origin.y-1 ;
    borderRect.size.width = borderRect.size.width+3 ;
    borderRect.size.height = borderRect.size.height+1;
    
    
    if(!backgroundImage){
        
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signupAddPhoto"]];
        backgroundImage.frame = borderRect;
        backgroundImage.contentMode=UIViewContentModeScaleAspectFit;
        [self.addDishScrollView addSubview:backgroundImage];
    }
   
    UIButton *addReviewTitleImageButton = (UIButton *)[addDishScrollView viewWithTag:1000];
    if(!addReviewTitleImageButton){
    
        UIButton *addReviewTitleImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addReviewTitleImageButton.tag = 1000;
        addReviewTitleImageButton.frame = rect;
        [addReviewTitleImageButton addTarget:self action:@selector(addNewImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.addDishScrollView addSubview:addReviewTitleImageButton];
    }
   
    UIImage *image;
    if ([imagName isEqualToString:@"signupAddPhoto"]) {
        image = [UIImage imageNamed:@"signupAddPhoto"];
    }
    else
    {
        image = [UIImage imageWithContentsOfFile:imageName];
        
    }   
    [addReviewTitleImageButton setBackgroundImage:image forState:UIControlStateNormal];
    [addReviewTitleImageButton.layer setCornerRadius:4.0];
    [addReviewTitleImageButton.layer setMasksToBounds:YES];
}

#pragma mark - Add Image Button Action

- (IBAction)addNewImage:(id)sender
{
   isActionSheetPresent = YES;//to load only once 
//    @try {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:ACTIONSHEET_TITLE delegate:self cancelButtonTitle:ACTIONSHEET_CANCEL_BUTTON_TITLE destructiveButtonTitle:nil otherButtonTitles:ACTIONSHEET_ADD_PHOTO_BUTTON_TITLE,ACTIONSHEET_ADD_PHOTO_FROM_LIBRARY_BUTTON_TITLE,nil];
        
        [actionSheet showInView:self.tabBarController.view];
        REMOVE_FROM_MEMORY(actionSheet);
//    }
//    @catch (NSException *exception) {
//        
//    }
//    @finally {
//        
//    }
    

}

#pragma mark -  Action sheet delegates
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
   
    if ([TDMDataStore sharedStore].isLoggedIn) 
    {
    if (TAKE_PHOTO_BUTTON_INDEX == buttonIndex)
    {
       
        [self takePhoto];
    }
    else if(FROM_LIBRARY_BUTTON_INDEX == buttonIndex)
    {
        isActionSheetPresent = YES;
        [self addFromLibrary];
    }
    else {
        isActionSheetPresent = NO;
    }
    }
    else
    {
        if(buttonIndex==2){
            isActionSheetPresent = NO;
        }
        else{
        //kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Please login to add a dish")
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:TDM_TITLE message: @"Please login to add a dish" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag=200;
        [alert show];
        REMOVE_FROM_MEMORY(alert)               
        }
        
    }
}



#pragma mark - Camera Handler methods
- (void)takePhoto
{
     isPhotoPresent = NO; 
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        
        picker.sourceType = 
        UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = NO;
        picker.delegate = self;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        [[self navigationController] presentModalViewController:picker animated:YES];
        
    }
    else
    {
        
      kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, ERROR_MSG_DIVICE_WITH_NO_CAMERA);
    }
    [picker release];
   
        
    
}
- (void)addFromLibrary
{
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary]) 
    {
       
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [[self navigationController] presentModalViewController:picker animated:YES];
        [picker release];
    }
    else
    {
         
       kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Cannot find library!")
        
    }
    
}

- (BOOL)isDeviceHasCamera
{
    BOOL isAvailable = NO;
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] ||
        [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
    {
        isAvailable = YES;
    }
    
    return isAvailable;
}

#pragma mark - Saving Media details

- (void)saveMediaFromLibrary:(NSDictionary*)infos
{
    
    UIImage * shrinked =[infos objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *compressedImage = [self compressImage:shrinked];
    NSString *folderPath = [self getDirectoryPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:NULL]) 
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:
         folderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    
    NSString *savedDate = @"dishImage";
    NSString *imagePath=[NSString stringWithFormat:@"%@/%@.png",folderPath,savedDate];
    NSData *imageDatas = [NSData dataWithData:UIImagePNGRepresentation(compressedImage)];
    [[NSUserDefaults standardUserDefaults] setValue:imageDatas forKey:@"dishURL"];
    [imageDatas writeToFile:imagePath atomically:YES];
    self.imageName = imagePath;
}

#pragma mark - DELEGATE METHODS PickerView delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     [picker dismissModalViewControllerAnimated:YES];
    isPhotoPresent = NO;
    if ([TDMDataStore sharedStore].isLoggedIn) 
    {
        isPhotoUploaded = NO;
        [self saveMediaFromLibrary:info];
        [self addThumbImage:imageName imageRect:CGRectMake(15, 10, 62, 62)];
        
    }
    else
    {
        kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Please login to add a dish")
    }
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    isPhotoPresent = YES;
     isActionSheetPresent = NO;
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - Resize Image and Directory Path
- (UIImage *)compressImage:(UIImage *)imageToCompress
{
    CGSize size = {320, 316};
	UIGraphicsBeginImageContext(size);
	
	CGRect rect;
	rect.origin = CGPointZero;
	rect.size = size;
	[imageToCompress drawInRect:rect];
	
	UIImage *shrinked;
	shrinked = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return shrinked; 
}


- (NSString *)getDirectoryPath
{
    NSString *directoryPath = [NSString pathWithComponents:
                               [NSArray arrayWithObjects:[NSString stringWithString:
                                                          [[DOCUMENTS_FOLDER stringByAppendingString:@"/Pictures/"] 
                                                           stringByExpandingTildeInPath]], nil]];
    return directoryPath;
}

#pragma mark -  TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView == dishName) 
    {
        if([text isEqualToString:@"\n"])
        {
            [dishDescription becomeFirstResponder];
            [self.addDishScrollView setContentOffset:CGPointMake(0, 60) animated:YES];
            return NO;
        }
    }
    if (textView == dishDescription) {
        [self.addDishScrollView setContentOffset:CGPointMake(0, 60) animated:YES];
        if([text isEqualToString:@"\n"])
        {
            [dishDescription resignFirstResponder];
            
        }
    }
    
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	if (textView == dishDescription) {
         [self.addDishScrollView setContentOffset:CGPointMake(0,70) animated:YES];
    }
    if (textView == dishName) {
        [self.addDishScrollView setContentOffset:CGPointMake(0,0) animated:YES];
    }

    return YES;
}


#pragma mark - Validation Methods 

- (BOOL)isNonEmptyString:(NSString*)string 
{
    BOOL isValid = NO;
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string length]>0) {
        isValid = YES;
    }
    return isValid;    
}

- (BOOL)isValReviewTitle {
    BOOL isValid =  NO;
    if ([self isNonEmptyString:self.dishName.text]) {
        isValid = YES;
    }
    return isValid;
}

- (BOOL)isValidReviewDescription 
{
    BOOL isValid = NO;
    if ([self isNonEmptyString:self.dishDescription.text]) {
        isValid = YES;
    }
    return isValid;
}
//returns TRUE if all fields are valid else FALSE
- (BOOL)isValidAddReviewDatas {
    
#define AS_ADD_REVIEW_WITH_NO_TITLE_DATA @"Please enter the dish name "
#define AS_ADD_REVIEW_WITH_NO_DESCRIPTION_DATA @" Please enter the dish description"
    
    BOOL isValid = YES;
    NSString * alertMessage;
    do {
       if (![self isNonEmptyString:self.dishName.text]) {
            alertMessage = AS_ADD_REVIEW_WITH_NO_TITLE_DATA;
            isValid = NO;
            break;
        }
        
        if (![self isNonEmptyString:self.dishDescription.text]) {
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

- (IBAction)addDishFindRestaurantClicked:(id)sender 
{
    if ([TDMDataStore sharedStore].isLoggedIn) 
    {
  
        TDMAddSignatureDishFindRestaurant *find = [[TDMAddSignatureDishFindRestaurant alloc]init];
        find.typeOfBusiness = businessType;
        [self.navigationController pushViewController:find animated:YES];
        [find release];
        find = nil;
    }
    else
    {
         //kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Please login to add a dish")
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:TDM_TITLE message:@"Please log in" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alertView.tag=200;
        [alertView show];
        REMOVE_FROM_MEMORY(alertView)
        
    }
    
}

- (IBAction)addDishAndUploadImage:(id)sender 
{
    
   
    if ([self isValidAddReviewDatas]) 
    {
        NSString *businesId  = [TDMUtilities getRestaurantId];
        if (!businesId) 
        {
           
            kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Please associate a business")
        } 
        else
        {
            if (![businesId isEqualToString:@" "]) 
            {
                [self showOverlayView];
                if ([imageName isKindOfClass:[NSString class]]) 
                {
                    UIImage *newImage = [UIImage imageWithContentsOfFile:self.imageName];
                    imageData=UIImageJPEGRepresentation(newImage,1.0);
                    [imageData retain];
                    [self uploadImage:imageData]; 
                    
                }
                else
                {
                    [self submitAddDishDetails];
                }

            }
            else
            {
                kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Please associate a business")
            }
        }
       }
}

- (void)submitAddDishDetails
{
    [self showOverlayView];
    NSString *businesId  = [TDMUtilities getRestaurantId];
    if ([TDMDataStore sharedStore].isLoggedIn) 
    {
        if ([businesId isEqualToString:@" "]) 
        {
            [self removeOverlayView];
            kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Please associate a business")
        } 
        else
        {
        
            TDMAddDishService *addDishService = [[TDMAddDishService alloc]init];
            addDishService.addDishServicedelegate = self;
            
            NSString *fid = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
            [addDishService addSignatureDishWithBody:dishDescription.text andTitle:dishName.text forVenue:businesId withPhotoFID:fid]; 
            [[NSUserDefaults standardUserDefaults]setObject:@" " forKey:@"fid"];
            [TDMUtilities setRestaurantId:@" "];
            businesId = @" ";
        }
    }
    else
    {
        [self removeOverlayView];
        kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Please login to add a dish")
    }

}

#pragma mark - Signature Dish Delegates

-(void)signatureDishAddedSuccessFully 
{
    
    [self removeOverlayView];
    CGRect rect = CGRectMake(15, 10, 63, 63);
    [self addThumbImage:@"signupAddPhoto" imageRect:rect];
    isPhotoPresent = NO;
    isActionSheetPresent = NO;
    TDMAddSignatureDishThanks *addDishSuccessfully = [[TDMAddSignatureDishThanks alloc]initWithNibName:@"TDMAddSignatureDishThanks" bundle:nil];
    
    addDishSuccessfully.dishName = self.dishName.text;
    addDishSuccessfully.dishImage = @"";
    addDishSuccessfully.imageData = imageData;
    addDishSuccessfully.isFromBusinessHome = self.isFromBusinessHome;
    [self.navigationController pushViewController:addDishSuccessfully animated:YES];
    [addDishSuccessfully release];
    addDishSuccessfully = nil;
    [dishDescription setText:@""];
    [dishName setText:@""];
    [self customizeScrollView];

//    [dishName setText:@""];

}

-(void)failedToAddSignatureDish 
{
    [self removeOverlayView]; 
    kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Failed to upload dish")
   
}

-(void) networkErrorInAddingBusinessReview
{
    [self removeOverlayView];
}

#pragma mark  -  Overlay View Management

- (void)showOverlayView
{
    [self removeOverlayView];
    
    overlayView = [[TDMOverlayView alloc] initWithSyncStyleAndTitle:@"Adding Best Dish..."];
}

- (void)removeOverlayView
{
    if (overlayView)
    {
        [overlayView removeFromSuperview];
        [overlayView release];
        overlayView = nil;
    }
}

#pragma mark - upload Image Delegates

- (void)uploadImage:(NSData* )imageDatas 
{
    [self showOverlayView];
    if (imageDatas) 
    {
        TDMPhotoUploadService *addPhoto = [[TDMPhotoUploadService alloc]init];
        NSDictionary *userDetails  =[[DatabaseManager sharedManager]getUserDetailsFromDataBase];
        NSString *userId = [userDetails objectForKey:@"userid"];
        [addPhoto uploadPhotoToTheReviewWithUID:userId withData:imageDatas withFileName:@"1.jpg"];
        addPhoto.isFromAddDish = YES;
        addPhoto.photoUploadServicedelegate= self;
    
    }
    else
    {
        [self removeOverlayView];
         [self submitAddDishDetails];
    }

}

-(void) photoUploadedSuccessFully 
{
    isPhotoUploaded = YES;
     [self removeOverlayView];
    [self submitAddDishDetails];
}

-(void) photoUploadedFailed 
{
    isPhotoUploaded = NO;
    [self removeOverlayView];
    [self submitAddDishDetails];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meal" 
                                                   message:@"Error occured while photo upload" 
                                                  delegate:nil 
                                         cancelButtonTitle:@"OK" 
                                         otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void) networkErrorInAddinBusinessReview
{
    [self removeOverlayView];
}

-(void) noPhoto
{
    [self removeOverlayView];
    [self submitAddDishDetails];
}
@end
