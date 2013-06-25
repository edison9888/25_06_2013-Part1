//
//  TDMLoginViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/6/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMLoginViewController.h"
#import "TDMForgotPasswordViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ELCImagePickerController.h"
#import "TDMAssetsTablePicker.h"
#import "MBProgressHUD.h"
#import "TDMAppDelegate.h"
#import "TDMFaceBook.h"
#import "TDMUserLogin.h"
#import "MBProgressHUD.h"
#import "DatabaseManager.h"
#import "TDMUserThumbnailHandlerAndProvider.h"

#import "TDMBusinessReviewListHandlerAndProvider.h"

@interface TDMLoginViewController()
//private
- (void)customiseCurrentView;
- (BOOL)isValidLoginDatas;
@end

#define kNORMAL_CELL_HEIGHT 44
#define kCELL_PLACEHOLDER_USERNAME @"User Name"
#define kCELL_PLACEHOLDER_EMAIL @"Email"
#define kCELL_PLACEHOLDER_PASSWORD @"Password"
#define kCELL_PLACEHOLDER_CONFIRMPASSWORD @"Confirm Password"
#define kROW_USERNAME 0
#define kROW_EMAIL 1
#define kROW_PASSWORD 2
#define kROW_CONFIRMPASSWORD 3

#define LABEL_THANKS @"thanks!"
#define LABEL_SUCESS_ADD_REVIEW_TEXT @"Your review has been uploaded."
#define LABEL_SUCESS_ADD_REVIEW_PHOTO @"Your photo has been uploaded."

#define ACTIONSHEET_TITLE   @""
#define ACTIONSHEET_ADD_PHOTO_BUTTON_TITLE   @"Take Photo"
#define ACTIONSHEET_ADD_PHOTO_FROM_LIBRARY_BUTTON_TITLE   @"Choose From Library"
#define ACTIONSHEET_CANCEL_BUTTON_TITLE     @"Cancel"

#define TAKE_PHOTO_BUTTON_INDEX   0
#define FROM_LIBRARY_BUTTON_INDEX    1

#define kNUMBER_OF_ROWS 4
#define kCORNER_RADIUS 10.0f
#define kCELL_TEXT_COLOR [UIColor darkGrayColor]
#define kCELL_TEXTFIELD_FRAME CGRectMake(0, 0, 231, kNORMAL_CELL_HEIGHT)
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

NSString * const AS_LOGIN_USERNAME_EMPTY         = @"Username is empty";
NSString * const AS_LOGIN_PASSWORD_EMPTY         = @"Password is empty";

static NSString *CellIdentifier = @"Cell";
@interface TDMLoginViewController()
- (void)takePhoto;
- (void)addFromLibrary;
- (BOOL)isDeviceHasCamera;
@end
@implementation TDMLoginViewController
@synthesize userName;
@synthesize eMailId;
@synthesize password;
@synthesize confirmPassword;
@synthesize passwords;
@synthesize userImageAddButton;
@synthesize profileImage;
@synthesize loginView;
@synthesize signupView;
@synthesize signUpTableView;
@synthesize segment;
@synthesize loginScrollView;
@synthesize signUpScrollView;
@synthesize userNames;
@synthesize nameUser;
@synthesize email;
@synthesize userPassword;
@synthesize confirmPasswords;
@synthesize loginButton;
@synthesize forgotPassword;
@synthesize FBLoginButton;
@synthesize twitterLoginButton;
//@synthesize facebook;

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
    if (profileImage.image!= nil) 
    {
        userImageAddButton.titleLabel.text = @"Change Photo";
    }
    else
    {
        userImageAddButton.titleLabel.text = @"Add Photo";
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    
    [self setLoginView:nil];
    [self setSignupView:nil];
    [self setSignUpTableView:nil];
    [self setSegment:nil];
    [self setLoginScrollView:nil];
    [self setSignUpScrollView:nil];
    [self setUserName:nil];
    [self setPassword:nil];
    [self setUserImageAddButton:nil];
    [self setProfileImage:nil];
    [self setUserName:nil];
    [self setEMailId:nil];
    [self setPassword:nil];
    [self setConfirmPassword:nil];
    [self setLoginButton:nil];
    [self setForgotPassword:nil];
    [self setFBLoginButton:nil];
    [self setTwitterLoginButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewWillAppear:(BOOL)animated{

    //this will customise the Current View
    [self customiseCurrentView];
    [super viewWillAppear:animated];
    signUpTableView.userInteractionEnabled = YES;
    [signUpScrollView setContentSize:CGSizeMake(320, 520)];
    
}

#pragma mark View Creations
- (void)customiseCurrentView{

    //this will create the navigationButton on the top of type the Back Bar Buttons
    [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
    NSLog(@"user logged in %d",[TDMUserLogin sharedLoginDetails].isLoggedIn);

    if (![TDMUserLogin sharedLoginDetails].isLoggedIn) 
    {
        [loginButton setTitle:@"Login" forState:UIControlStateNormal];
        userName.hidden = NO;
        password.hidden = NO;
        forgotPassword.hidden = NO;
        FBLoginButton.hidden = NO;
        twitterLoginButton.hidden =NO;
        segment.hidden = NO;
    }
    else
    {
        [loginButton setTitle:@"Logout" forState:UIControlStateNormal];
        userName.hidden = YES;
        password.hidden = YES;
        forgotPassword.hidden = YES;
        FBLoginButton.hidden = YES;
        twitterLoginButton.hidden =YES;
        segment.hidden = YES;
        
    }
    if (profileImage.image!= nil) 
    {
        userImageAddButton.titleLabel.text = @"Change Photo";
    }
    else
    {
        userImageAddButton.titleLabel.text = @"Add Photo";
    }

    [self segmentClick:nil];
 }

#pragma mark  - TextField Delegates
- (BOOL)textFieldShouldReturn: (UITextField *)textField{ 
    [textField resignFirstResponder]; 
    return YES; 
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if (!loginView.isHidden) {
        loginScrollView.contentSize = CGSizeMake(0, 600);
    }
    else if(!signupView.isHidden){
        [signUpScrollView setContentSize:CGSizeMake(0, 600)];
        if([textField isEqual:passwords]||[textField isEqual:confirmPasswords])
        {
            CGRect scrollViewFrame = signUpScrollView.frame;
            
            scrollViewFrame.size.height +=50;
            signUpScrollView.frame = scrollViewFrame;
            [signUpScrollView setContentOffset:CGPointMake(0, 60) animated:NO];
            [signUpScrollView setScrollEnabled:NO];

        }
    }
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string]; 
//    
//    if(textField.tag == kROW_USERNAME)
//        nameUser=newText;
//    else if(textField.tag == kROW_EMAIL)
//        email = newText;
//    else if(textField.tag == kROW_PASSWORD)
//        userPassword  =newText;
//    else if(textField.tag == kROW_CONFIRMPASSWORD)
//        confirmPassword  =newText;
//
//    return YES;
//}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    if (!loginView.isHidden)
    loginScrollView.contentSize = CGSizeMake(0, 0);
    else if(!signupView.isHidden)
        signUpScrollView.contentSize = CGSizeMake(0, 0);
    if(textField.tag == kROW_USERNAME)
        nameUser=textField.text;
    else if(textField.tag == kROW_EMAIL)
        email = textField.text;
    else if(textField.tag == kROW_PASSWORD)
        userPassword  =textField.text;
    else if(textField.tag == kROW_CONFIRMPASSWORD)
        confirmPassword  =textField.text;
}
#pragma mark -  Segment Actions

- (IBAction)segmentClick:(id)sender{
    if (profileImage.image!= nil) 
    {
        userImageAddButton.titleLabel.text = @"Change Photo";
    }
    else
    {
        userImageAddButton.titleLabel.text = @"Add Photo";
    }


    if (segment.selectedSegmentIndex==0) 
    {
         isLogin  = 1;
        //this will create the Navigationbar Title as About Us
        [self createCustomisedNavigationTitleWithString:kNAVBAR_TITLE_LOGIN];
        loginView.hidden = NO;
        loginView.frame = CGRectMake(0, 50, 320, 368);
        [self.view addSubview:loginView];
    }
    else 
    {
        //this will create the Navigationbar Title as About Us
        [self createCustomisedNavigationTitleWithString:kNAVBAR_TITLE_SIGN_UP];
        isLogin  = 0;
        loginView.hidden = YES;
        signupView.hidden  =NO;
        signupView.frame = CGRectMake(0, 50, 320, 368);
        signUpTableView.layer.cornerRadius = kCORNER_RADIUS;
        [self.view addSubview:signupView];
    }
}



#pragma mark Button Actions

- (IBAction)loginButtonClicked:(id)sender {
    if([loginButton.titleLabel.text isEqualToString:@"Login"])
    {
        if ([self isValidLoginDatas]) 
        {
            [password resignFirstResponder];
            [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
            TDMLoginHandler *loginHandler = [[TDMLoginHandler alloc] init];
            [loginHandler loginUserWithUserName:userName.text andPassword:password.text];
            loginHandler.loginHandlerDelegate = self;
        //[loginHandler release];
        }
    }
    else if([loginButton.titleLabel.text isEqualToString:@"Logout"])
    {
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        TDMLogoutHandler *logoutHandler = [[TDMLogoutHandler alloc] init];
        [logoutHandler logoutCurrentUser];
        logoutHandler.logoutHandlerDelegate = self;
    }
    
    //TDMLoginHandler *loginHandler = [[TDMLoginHandler alloc] init];
    //[loginHandler loginUserWithUserName:@"service_tester20" andPassword:@"tester_password"];
    
}


//fired when the forgot password is clicked
- (IBAction)forgotPasswordClick:(id)sender{



    TDMForgotPasswordViewController *forgotPasswordViewController = (TDMForgotPasswordViewController *)[self getClass:kFORGOTPASSWORD_CLASS];
    [self.navigationController pushViewController:forgotPasswordViewController animated:YES];
}


//Fired when Signup is clicked
-(void)signUpButtonClicked:(id)sender {
    [userNames resignFirstResponder];
    [confirmPasswords resignFirstResponder];
    [eMailId resignFirstResponder];
    [password resignFirstResponder];
    isLogin = 0;
    BOOL validated = YES;
    /*TDMSignupHandlerAndProvider *signupHandler = [[TDMSignupHandlerAndProvider alloc] init];
    
    [signupHandler signUpUserWithUserName:@"service_tester20" 
                           havingPassword:@"tester_password" 
                                 andEmail:@"service_tester20@example.com" 
                              withComment:@"register via REST server" 
                     andLegalAcceptOption:1];*/
    
    //TestBed
    
    NSString *emailReg =@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg]; 
    if((nameUser.length ==0||email.length ==0 ||userPassword.length ==0||confirmPassword.length==0))
    {
        validated = NO;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meals" message:@"Please fill empty field(s)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];

    }
    else
    {
        if(!([userPassword isEqualToString:confirmPassword]))
        {
            validated = NO;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meals" message:@"Confirm your password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else if(![emailTest evaluateWithObject:email]) 
        {
            validated = NO;
            UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Enter a valid email address" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
            [loginAlert show]; 
            [loginAlert release];
        }


    }
    if(validated)
    {
        NSString *newName =imageName; 
        newName = [newName stringByReplacingOccurrencesOfString:@"userImage" withString:userNames.text];
        NSLog(@"%@",newName);
        NSFileManager *objFileManager = [NSFileManager defaultManager];
        NSError *err = nil;
        if (imageName != nil)
        {
            [objFileManager moveItemAtPath:imageName toPath:newName error:&err];  
        }   
        
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        TDMSignupHandlerAndProvider *signupHandler = [[TDMSignupHandlerAndProvider alloc] init];
        signupHandler.signupDelegate = self;
        [signupHandler signUpUserWithUserName:nameUser havingPassword:userPassword andEmail:email withComment:@"From REST Server" andLegalAcceptOption:1];
      
    }

}
#pragma add image
- (IBAction)signupAddImageButtonClick:(id)sender {
   
    if (profileImage.image!= nil) 
    {
        userImageAddButton.titleLabel.text = @"Change Photo";
    }
    else
    {
        userImageAddButton.titleLabel.text = @"Add Photo";
    }
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:ACTIONSHEET_TITLE delegate:self cancelButtonTitle:ACTIONSHEET_CANCEL_BUTTON_TITLE destructiveButtonTitle:nil otherButtonTitles:ACTIONSHEET_ADD_PHOTO_BUTTON_TITLE,ACTIONSHEET_ADD_PHOTO_FROM_LIBRARY_BUTTON_TITLE,nil];
    
    [actionSheet showInView:self.tabBarController.view];
    REMOVE_FROM_MEMORY(actionSheet);
}


#pragma mark -  Action sheet delegates
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (TAKE_PHOTO_BUTTON_INDEX == buttonIndex)
    {
        [self takePhoto];
    }
    else if(FROM_LIBRARY_BUTTON_INDEX == buttonIndex)
    {
        [self addFromLibrary];
    }
}


- (void)takePhoto
{
    if ([self isDeviceHasCamera])
    {        
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.delegate = self;
        [picker setCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
        picker.mediaTypes = [[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil] autorelease];
        [self presentModalViewController:picker animated:YES];
        [picker release];
        
    }
    else 
    { 
        kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, ERROR_MSG_DIVICE_WITH_NO_CAMERA);
        
    }  
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
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot find library!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        errorAlert = nil;
        
    }

}

#pragma mark - Camera Handler methods

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
    
 
    NSString *savedDate = @"userImage";
    NSString *imagePath=[NSString stringWithFormat:@"%@/%@.png",folderPath,savedDate];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(compressedImage)];
    
    [imageData writeToFile:imagePath atomically:YES];
    imageName = imagePath;
   

}

#pragma mark - DELEGATE METHODS PickerView delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSDate *startDate = [NSDate date];
    
    [picker dismissModalViewControllerAnimated:YES];
    
    [self saveMediaFromLibrary:info];
    
    NSDate *endDate = [NSDate date];
    
    NSLog(@"Photo Capture Time elapsed: %f", [endDate timeIntervalSinceDate:startDate]);
    
    
    loginView.hidden = YES;
    signupView.hidden = NO;
    NSLog(@"new Image:%@",imageName);
    profileImage.image = [UIImage imageWithContentsOfFile:imageName];
    userImageAddButton.frame = CGRectMake(0, 43, 103, 63);
    userImageAddButton.titleLabel.text = @"Change Photo";
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (UIImage *)compressImage:(UIImage *)imageToCompress
{
    CGSize size = {320, 415};
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

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    
    [picker dismissModalViewControllerAnimated:YES];
}


#pragma mark - Validation Methods
#pragma mark - LOGIN
- (BOOL)isNonEmptyString:(NSString*)string {
    BOOL isValid = NO;
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string length]>0) {
        isValid = YES;
    }
    return isValid;    
}

- (BOOL)isValidUserNameAtLogin {
    BOOL isValid =  NO;
    if ([self isNonEmptyString:userName.text]) {
        isValid = YES;
    }
    return isValid;
}

- (BOOL)isValidPasswordAtLogin {
    BOOL isValid = NO;
    if ([self isNonEmptyString:password.text]) {
        isValid = YES;
    }
    return isValid;
}
//returns TRUE if all fields are valid else FALSE
- (BOOL)isValidLoginDatas {
    
    BOOL isValid = YES;
    NSString * alertMessage;
    do {
        if (![self isNonEmptyString:userName.text]) {
            alertMessage = AS_LOGIN_USERNAME_EMPTY;
            isValid = NO;
            break;
        }
        
        if (![self isNonEmptyString:password.text]) {
            alertMessage = AS_LOGIN_PASSWORD_EMPTY;
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

#pragma mark - Memory Management

- (void)dealloc{
    if (loginView) {
        for (UIView *viewSub in [loginView subviews]) {
            [viewSub removeFromSuperview];
        }
        REMOVE_FROM_MEMORY(loginView)
    }
    if (signupView) {
        for (UIView *innerView in [signupView subviews]) {
            [innerView removeFromSuperview];
        }
        REMOVE_FROM_MEMORY(signupView)
    }
    
    REMOVE_FROM_MEMORY(loginScrollView)
    REMOVE_FROM_MEMORY(signUpScrollView)
    REMOVE_FROM_MEMORY(signUpTableView)
    REMOVE_FROM_MEMORY(segment)
    [userName release];
    [password release];
    [userImageAddButton release];
    [profileImage release];
    [userNames release];
    [eMailId release];
    [passwords release];
    [confirmPasswords release];
    [loginButton release];
    [forgotPassword release];
    [FBLoginButton release];
    [twitterLoginButton release];
    [forgotPassword release];
    
    [super dealloc];
}
#pragma mark - Login delegates

-(void)loggedInSuccessfully {
    
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    [loginButton setTitle:@"Logout" forState:UIControlStateNormal];
    userName.hidden = YES;
    password.hidden = YES;
    forgotPassword.hidden = YES;
    FBLoginButton.hidden = YES;
    twitterLoginButton.hidden =YES;
    segment.hidden = YES;
    [TDMUserLogin sharedLoginDetails].isLoggedIn = YES;
    [self.navigationController popToRootViewControllerAnimated:NO];

}

-(void)loginFailed {
    
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    [userName setText:@""];
    [password setText:@""];
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid Username or Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}

-(void)signupSuccess {

    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    //[TDMUserThumbnailHandlerAndProvider 
 
   
//    TDMUserThumbnailHandlerAndProvider *signupHandler = [[TDMUserThumbnailHandlerAndProvider alloc] init];
//    NSDictionary *dict = [[DatabaseManager sharedManager]getUserDetailsFromDataBase];
//    NSString *uid = [dict objectForKey:@"userid"];
//    [signupHandler signUpWithProfileImage:@"" userId:@"8461"];
    [self.tabBarController setSelectedIndex:3];
}
- (void)invalidUser
{
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    [userName setText:@""];
    [password setText:@""];
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The user name and password you entered do not match our records. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}
-(void)signupFailed {
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"Signup failed due to a server error. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    [[self tabBarController] setSelectedIndex:2];
}

-(void)emailTaken {
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"This email is already taken. If you have already registered, please try logging in" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

-(void)usernameTaken {
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"This username is already taken. Please try a different one" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

-(void)usernameAndEmailTaken {
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"This username and password are already taken. Please try logging in" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

#pragma mark - FB Login

- (IBAction)fbLoginAction:(id)sender 
{
    TDMFaceBook *facebook = [[TDMFaceBook alloc] init];
    
    facebook.title = @"The Daily Meal";
    facebook.titleLink = @"http://www.thedailymeal.com/";
    facebook.description = @"Here is my website";
    facebook.imageURL = @"http://www.thedailymeal.com/";
    facebook.imageLink = @"http://www.thedailymeal.com/";
    
    [facebook load];

}
- (void)FacebookLoginWithAceessTocken {
//    
//    if (!facebookHandler)
//    {
//        facebookHandler = [[TDMFaceBookHandler alloc] init];
//    }
//    
//    facebookHandler.delegate = self;
//    [facebookHandler sendFacebookLoginWithCookie:[facebook accessToken]];
    
}

#pragma mark - Twitter Login

- (IBAction)twitterLoginAction:(id)sender 
{
    if(objTwitter!=nil){
        [objTwitter release];
        objTwitter = nil;
    }
    objTwitter=[[Twitter alloc] initWithNibName:@"Twitter" bundle:nil];
    objTwitter.strTweetContent=@"http://www.thedailymeal.com/twitter/oauthoqrCiNqIWRX5lz6kCGZTQ?ls=1&mt=8";
    
    if(dialog!=nil){
        [dialog release];
        dialog = nil;
        
    }
    dialog=[[ShareView alloc] initWithFrame:([UIScreen mainScreen].applicationFrame) 
                                  ShareType:twitter
                                 andSubView:objTwitter.view];
    objTwitter.parentView=dialog;
    [dialog load];
    
    
}
#pragma mark - Logout delegates
-(void)loggedOutSuccessfully
{
    NSLog(@"Log out successful");
    userName.text =@"";
    password.text = @"";
    [TDMUserLogin sharedLoginDetails].isLoggedIn = NO;
    [[DatabaseManager sharedManager]deleteUserDataBase];
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    userName.hidden = NO;
    password.hidden = NO;
    forgotPassword.hidden = NO;
    FBLoginButton.hidden = NO;
    twitterLoginButton.hidden =NO;
    segment.hidden = NO;
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)logOutFailed
{
    NSLog(@"Logout failed");
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
}
@end
