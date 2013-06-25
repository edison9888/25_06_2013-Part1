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
//#import "ELCImagePickerController.h"
//#import "TDMAssetsTablePicker.h"

#import "AppDelegate.h"
//#import "TDMFaceBook.h"
#import "TDMDataStore.h"
#import "TDMAddSignatureDishViewController.h"
#import "DatabaseManager.h"
#import "TDMPhotoUploadService.h"
#import "TDMReviewRestaurant.h"
#import "TDMNavigationController.h"
#import "TDMOverlayView.h"
//
//#import "TDMBusinessReviewListHandlerAndProvider.h"

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


#define kNUMBER_OF_ROWS 4
#define kCORNER_RADIUS 10.0f
#define kCELL_TEXT_COLOR [UIColor darkGrayColor]
#define kCELL_TEXTFIELD_FRAME CGRectMake(0, 0, 231, kNORMAL_CELL_HEIGHT)


NSString * const AS_LOGIN_USERNAME_EMPTY         = @"Please enter Username";
NSString * const AS_LOGIN_PASSWORD_EMPTY         = @"Please enter password";

static NSString *CellIdentifier = @"Cell";

@interface TDMLoginViewController()
- (void)takePhoto;
- (void)addFromLibrary;
- (BOOL)isDeviceHasCamera;
- (void)removeOverlayView;
- (void)showOverlayView;
@end

@implementation TDMLoginViewController
@synthesize userName;
@synthesize eMailId;
@synthesize password;
@synthesize confirmPassword;
@synthesize signUpImageView;
@synthesize navigationLabel;
@synthesize mainScrollView;
@synthesize usrNameImageView;
@synthesize passwordImageView;
@synthesize signUpButton;
@synthesize passwords;
@synthesize userImageAddButton;
@synthesize loginTable;
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
@synthesize imageName;
@synthesize isfromSettings;
@synthesize termsButton;
@synthesize termsLabel;
@synthesize facebook;

#pragma mark - Memory Management

- (void)dealloc
{
    if (loginView)
    {
        for (UIView *viewSub in [loginView subviews]) 
        {
            [viewSub removeFromSuperview];
        }
        REMOVE_FROM_MEMORY(loginView)
    }
    if (signupView) 
    {
        for (UIView *innerView in [signupView subviews]) 
        {
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
    [logoutHandler release];
    [signUpImageView release];
    [navigationLabel release];
    [mainScrollView release];
    [usrNameImageView release];
    [passwordImageView release];
    [loginTable release];
    [signUpButton release];
    [termsButton release];
    [termsLabel release];
    [super dealloc];
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
    [self setSignUpImageView:nil];
    [self setNavigationLabel:nil];
    [self setMainScrollView:nil];
    [self setUsrNameImageView:nil];
    [self setPasswordImageView:nil];
    [self setLoginTable:nil];
    [self setSignUpButton:nil];
    [self setTermsButton:nil];
    [self setTermsLabel:nil];
    [super viewDidUnload];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        [self.navigationItem setTDMIconImage];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginView.backgroundColor = [UIColor clearColor];
    self.FBLoginButton.hidden = YES;
    self.twitterLoginButton.hidden = YES;
    self.userName.tag =5;
    self.password.tag = 6;
    [self addSegmentedControl];
    if (profileImage.image!= nil) 
    {
        userImageAddButton.titleLabel.text = @"Change Photo";
    }
    else
    {
        userImageAddButton.titleLabel.text = @"Add Photo";
    }
    self.loginTable.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{  
    userName.autocorrectionType=UITextAutocorrectionTypeNo;
    userNames.autocorrectionType=UITextAutocorrectionTypeNo;
    password.autocorrectionType=UITextAutocorrectionTypeNo;
    confirmPasswords.autocorrectionType=UITextAutocorrectionTypeNo;
    eMailId.autocorrectionType=UITextAutocorrectionTypeNo;
    [self customiseCurrentView];
    
    self.signUpTableView.userInteractionEnabled = NO;
    [signUpScrollView setContentSize:CGSizeMake(320, 100)];
    [super viewWillAppear:animated];
}


#pragma mark - Handle Orientations

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View Creations

- (void)customiseCurrentView
{
    //this will create the navigationButton on the top of type the Back Bar Buttons
    [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
    [self.loginScrollView setScrollEnabled:NO];
    [self.signUpScrollView setScrollEnabled:NO];
    [self createAdView];
    if (![TDMDataStore sharedStore].isLoggedIn) 
    {
       [self.loginButton setTitle:@"Log In" forState:UIControlStateNormal];
        userName.hidden = NO;
        password.hidden = NO;
        forgotPassword.hidden = NO;
        FBLoginButton.hidden = YES;
        twitterLoginButton.hidden =YES;
        segment.hidden = NO;
    }
    else
    {
        [self.loginButton setTitle:@"Log Out" forState:UIControlStateNormal];
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

#pragma mark - SignUP TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"";
    cell.backgroundColor=[UIColor whiteColor];
    if(indexPath.row==0){
        userNames.frame=CGRectMake(15, 5, 180, 25);
        [cell.contentView addSubview:userNames];
        userNames.font=[UIFont fontWithName:@"Trebuchet MS" size:15];
        userNames.placeholder=@"User Name";
        
    }
    else if(indexPath.row==1){
        eMailId.frame=CGRectMake(15, 5, 180, 25);
        [cell.contentView addSubview:eMailId];
        eMailId.font=[UIFont fontWithName:@"Trebuchet MS" size:15];
        eMailId.placeholder=@"Email";
    }
    else if(indexPath.row==2){
        passwords.frame=CGRectMake(15, 5, 180, 25);
        [cell.contentView addSubview:passwords];
        passwords.font=[UIFont fontWithName:@"Trebuchet MS" size:15];
        passwords.placeholder=@"Password";

    }
    else
    {
        confirmPasswords.frame=CGRectMake(15, 5, 180, 25);
        [cell.contentView addSubview:confirmPasswords];
        confirmPasswords.font=[UIFont fontWithName:@"Trebuchet MS" size:15];
        confirmPasswords.placeholder=@"Confirm Password";
    }
    return cell; 
}

#pragma mark  - TextField Delegates

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    // Try to find next responder
    UIResponder* nextResponder = nil;
    if(textField.tag == kROW_USERNAME){
        nextResponder = [textField.superview viewWithTag:kROW_EMAIL];
        [self.mainScrollView setContentOffset:CGPointMake(0, 60)];
        [eMailId becomeFirstResponder];
        
    }
    else if(textField.tag == kROW_EMAIL){
        nextResponder = [textField.superview viewWithTag:kROW_PASSWORD];
        [self.mainScrollView setContentOffset:CGPointMake(0, 60)];
        [passwords becomeFirstResponder];
    }
    else if(textField.tag == kROW_PASSWORD){
        nextResponder = [textField.superview viewWithTag:kROW_CONFIRMPASSWORD];
        [self.mainScrollView setContentOffset:CGPointMake(0, 100)];
        [confirmPasswords becomeFirstResponder];
    }
    else if(textField.tag == kROW_CONFIRMPASSWORD){
        [self.mainScrollView setContentOffset:CGPointMake(0, 60)];
 
        [self signUpButtonClicked:nil];
    }
    else if ([textField isEqual:userName])
    {
        [self.password becomeFirstResponder];
        [self.mainScrollView setContentOffset:CGPointMake(0, 60)];
        
    }
    else if([textField isEqual:password])
    {
        [self.mainScrollView setContentOffset:CGPointMake(0, 60)];
        [self.password resignFirstResponder];
        [self loginButtonClicked:nil];
    }
        return NO; // We do not want UITextField to insert line-breaks.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if (!loginView.isHidden) 
    {
        loginScrollView.contentSize = CGSizeMake(0, 600);
         [mainScrollView setContentSize:CGSizeMake(0, 500)];
        
    }
    else if(!signupView.isHidden)
    {
        if ([textField isEqual:eMailId]) 
        {
            [textField setKeyboardType:UIKeyboardTypeEmailAddress];
        }
        [signUpScrollView setContentSize:CGSizeMake(0, 650)];
        [mainScrollView setContentSize:CGSizeMake(0, 500)];
        [signUpScrollView setScrollEnabled:YES];
        if([textField isEqual:passwords]||[textField isEqual:confirmPasswords]||[textField isEqual:password])
        {
            CGRect scrollViewFrame = signUpScrollView.frame;
            scrollViewFrame.size.height +=50;
            signUpScrollView.frame = scrollViewFrame;
            [signUpScrollView setContentOffset:CGPointMake(0, 60) animated:NO];
            //[signUpScrollView setScrollEnabled:NO];

        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string]; 

    if(textField.tag == kROW_USERNAME){
       
        self.nameUser=newText;
    }
    else if(textField.tag == kROW_EMAIL){
        [self.eMailId becomeFirstResponder];
        self.email = newText;
    }
    else if(textField.tag == kROW_PASSWORD){
        [self.passwords becomeFirstResponder];
        self.userPassword  =newText;
    }
    else if(textField.tag == kROW_CONFIRMPASSWORD){
        self.confirmPassword  =newText;
    }
    return YES;
}




- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (!loginView.isHidden)
    loginScrollView.contentSize = CGSizeMake(0, 0);
    else if(!signupView.isHidden)
        signUpScrollView.contentSize = CGSizeMake(0, 0);
    if(textField.tag == kROW_USERNAME)
        self.nameUser=textField.text;
    else if(textField.tag == kROW_EMAIL)
        self.email = textField.text;
    else if(textField.tag == kROW_PASSWORD)
        self.userPassword  =textField.text;
    else if(textField.tag == kROW_CONFIRMPASSWORD)
        self.confirmPassword  =textField.text;

    
}

#pragma mark -  Segment Actions

- (IBAction)signUpButtonClicked:(id)sender {
    
    [userNames resignFirstResponder];
    [confirmPasswords resignFirstResponder];
    [eMailId resignFirstResponder];
    [password resignFirstResponder];
    isLogin = 0;
    BOOL validated = YES;

    //TestBed
    
    NSString *emailReg =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg]; 
    if((self.nameUser.length ==0||self.email.length ==0 ||self.userPassword.length ==0||self.confirmPassword.length==0))
    {
        validated = NO;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meals" message:@"Please fill empty field(s)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }
    else
    {
        if ([self isNonEmptyString:self.nameUser]) 
        {
            validated = YES;
        }
        if(!([self.userPassword isEqualToString:self.confirmPassword]))
        {
            validated = NO;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meals" message:@"Please confirm your password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else if(![emailTest evaluateWithObject:self.email]) 
        {
            validated = NO;
            UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Please enter a valid email address" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
            [loginAlert show]; 
            [loginAlert release];
        }
        
        
    }
    if(validated)
    {
        [NSThread detachNewThreadSelector:@selector(sentSignUpRequest) toTarget:self withObject:nil];
      
        [self showOverlayView];
        
        
    }}

- (IBAction)segmentClick:(id)sender
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 5)
        [self changeUISegmentFont:self.segment];
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
        self.navigationLabel.text =@"Log In";
         isLogin  = 1;
        self.signupView.hidden = YES;
        self.loginView.hidden = NO;
        [mainScrollView setContentSize:CGSizeMake(320, 450)];
        //this will create the Navigationbar Title as About Us
        [self createCustomisedNavigationTitleWithString:kNAVBAR_TITLE_LOGIN];

        loginView.frame = CGRectMake(0, 60, 320, 368);
        [self.navigationItem setTDMIconImage];
        [mainScrollView addSubview:loginView];
    }
    else 
    {
        

        self.loginView.hidden =YES;
        self.signupView.hidden = NO;
        [mainScrollView setContentSize:CGSizeMake(320, 390)];
        //this will create the Navigationbar Title as About Us
        self.navigationLabel.text = @"Sign Up";
        [self createCustomisedNavigationTitleWithString:kNAVBAR_TITLE_SIGN_UP];
        isLogin  = 0;
        loginView.hidden = YES;
        signupView.hidden  =NO;
        signupView.frame = CGRectMake(0, 60, 320, 368);
        signUpTableView.layer.cornerRadius = kCORNER_RADIUS;
        [self.navigationItem setTDMIconImage];
        [mainScrollView addSubview:signupView];
    }
}

#pragma mark - Button Actions

- (IBAction)loginButtonClicked:(id)sender
{
    
    if(![TDMDataStore sharedStore].isLoggedIn)
    {
        if ([self isValidLoginDatas]) 
        {
            [self.loginButton setSelected:YES];
            [password resignFirstResponder];
            
           
            [self showOverlayView];
            [NSThread detachNewThreadSelector:@selector(sentLoginRequest) toTarget:self withObject:nil];
           
        }
    }
    else 
    {
        self.forgotPassword.hidden =YES;
        self.usrNameImageView.hidden = YES;
        self.passwordImageView.hidden = YES;
    }
    
}

- (void)sentLoginRequest
{
    NSAutoreleasePool  *pool = [[NSAutoreleasePool alloc]init];
    TDMHTTPLoginService *loginHandler = [[TDMHTTPLoginService alloc] init];
    loginHandler.loginHandlerDelegate = self;
    [loginHandler loginUserWithUserName:userName.text andPassword:password.text];
    
    [pool drain];
    
    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@" http://stage.thedailymeal.com:8081/rest/app/user/login"]];
//    
//    NSString *string = @"{\"username\":\"vivek\",\"password\":\"vivek\"}"; 
//    [request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"" forKey:@"Content-Type"];
    
    
}

 - (void)sentLogoutRequest
{
    
    NSAutoreleasePool  *pool = [[NSAutoreleasePool alloc]init];
    logoutHandler = [[TDMLogoutService alloc] init];
    [logoutHandler logoutCurrentUser];
    logoutHandler.logoutHandlerDelegate = self;
    [pool drain];
}
//fired when the forgot password is clicked
- (IBAction)forgotPasswordClick:(id)sender
{
    
    [self.forgotPassword setSelected:YES];
    TDMForgotPasswordViewController *forgotPasswordViewController = (TDMForgotPasswordViewController *)[self getClass:kFORGOTPASSWORD_CLASS];
    [self.navigationController pushViewController:forgotPasswordViewController animated:YES];
}


//Fired when Signup is clicked

- (void)sentSignUpRequest
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    TDMSignUpService *signUpHandler = [[TDMSignUpService alloc]init];
    signUpHandler.signupDelegate = self;
    [signUpHandler signUpUserWithUserName:userNames.text havingPassword:passwords.text andEmail:eMailId.text withComment:@"From REST Server" andLegalAcceptOption:1];
   
    [pool drain];
}
#pragma add image
- (IBAction)signupAddImageButtonClick:(id)sender 
{
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
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
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
       // picker.mediaTypes = [[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil] autorelease];
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
    NSString *imagePath=[NSString stringWithFormat:@"%@/%@",folderPath,savedDate];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(compressedImage)];
    
    [imageData writeToFile:imagePath atomically:YES];
    self.imageName = imagePath;
   

}

#pragma mark - DELEGATE METHODS PickerView delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    [self saveMediaFromLibrary:info];
    loginView.hidden = YES;
    signupView.hidden = NO;
    profileImage.image = [UIImage imageWithContentsOfFile:self.imageName];
    userImageAddButton.frame = CGRectMake(14, 20, 70, 70);
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


#pragma mark - LOGIN

- (BOOL)isNonEmptyString:(NSString*)string 
{
    BOOL isValid = NO;
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string length]>0) {
        isValid = YES;
    }
    return isValid;    
}

- (BOOL)isValidUserNameAtLogin {
    BOOL isValid =  NO;
    if ([self isNonEmptyString:userName.text]) 
    {
        isValid = YES;
    }
    return isValid;
}

- (BOOL)isValidPasswordAtLogin 
{
    BOOL isValid = NO;
    if ([self isNonEmptyString:password.text]) 
    {
        isValid = YES;
    }
    return isValid;
}
//returns TRUE if all fields are valid else FALSE
- (BOOL)isValidLoginDatas {
    
    BOOL isValid = YES;
    NSString * alertMessage;
    do {
        if (![self isNonEmptyString:userName.text]) 
        {
            alertMessage = AS_LOGIN_USERNAME_EMPTY;
            isValid = NO;
            break;
        }
        
        if (![self isNonEmptyString:password.text]) 
        {
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


#pragma mark - Login delegates

-(void)loggedInSuccessfully 
{
    [self.loginButton setSelected:NO];
    [self removeOverlayView];
    [loginButton setTitle:@"Log Out" forState:UIControlStateNormal];
    userName.hidden = YES;
    password.hidden = YES;
    forgotPassword.hidden = YES;
    FBLoginButton.hidden = YES;
    twitterLoginButton.hidden =YES;
    segment.hidden = YES;
    [TDMDataStore sharedStore].isLoggedIn = YES;
    NSString *toView = [[NSUserDefaults standardUserDefaults]objectForKey:kIS_TO_LOGIN];
    if ([toView isEqualToString:@"review"]) 
    {
        NSString *restaurantName = [[NSUserDefaults standardUserDefaults]objectForKey:@"reviewRestaurantName"];
        TDMReviewRestaurant *review = [[TDMReviewRestaurant alloc]initWithNibName:@"TDMReviewRestaurant" bundle:nil];
        review.isFromLogin = YES;
        [review setRestaurantName:restaurantName];
        [self.navigationController pushViewController:review animated:NO];
    }
    else if ([toView isEqualToString:@" "]) 
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([toView isEqualToString:@"bestDish"]) 
    {
        TDMAddSignatureDishViewController *addDish = [[TDMAddSignatureDishViewController alloc]initWithNibName:@"TDMAddSignatureDishViewController" bundle:nil];
        addDish.isFromBusinessHome = 0;
        addDish.isFromLogin = 1;
        [self.navigationController pushViewController:addDish animated:NO];
    }
    else if(!toView)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else if([toView isEqualToString:@"fromBusinessDetail"])
    {
        int index = ([self.navigationController.viewControllers count] -2) - 1; //to the second last viewController (count - 2)
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index] animated:YES];
    }

}
- (void)networkError
{
    [self.loginButton setSelected:NO];
    [self.signUpButton setSelected:NO];
    [self removeOverlayView];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}

-(void)loginFailed 
{
    [self.loginButton setSelected:NO];
 
    [self removeOverlayView];
    [userName setText:@""];
    [password setText:@""];    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid Username or Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}

#pragma mark - Sign Up delegates

- (void)uploadProfilePhoto {
    
    newImagePath = self.imageName;     
    TDMPhotoUploadService *signupHandler = [[TDMPhotoUploadService alloc] init];
    NSDictionary *dict = [[DatabaseManager sharedManager]getUserDetailsFromDataBase];
    NSString *fileName = [dict objectForKey:@"username"];
    signupHandler.photoUploadServicedelegate = self;
    [signupHandler uploadPhotoFromPath:newImagePath withFileName:fileName andUploadType:1];
}

-(void)signupSuccess 
{

    [self performSelector:@selector(uploadProfilePhoto) withObject:nil afterDelay:3];

}
- (void)invalidUser
{
 
     [self removeOverlayView];
    [userName setText:@""];
    [password setText:@""];
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The user name and password you entered do not match our records. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}
-(void)signupFailed 
{
  
     [self removeOverlayView];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"Signup failed due to a server error. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
  
}

-(void)emailTaken
{
  
     [self removeOverlayView];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"This email is already taken. If you have already registered, please try logging in" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

-(void)usernameTaken 
{
  
     [self removeOverlayView];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"This username is already taken. Please try a different one" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

-(void)usernameAndEmailTaken 
{
    
     [self removeOverlayView];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"This username and password are already taken. Please try logging in" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

#pragma mark - FB Login



- (IBAction)fbLoginAction:(id)sender 
{
//    facebook = [[TDMFaceBook alloc] init];
//    
//    facebook.title = @"The Daily Meal";
//    facebook.titleLink = @"http://www.thedailymeal.com/";
//    facebook.description = @"Here is my website";
//    facebook.imageURL = @"http://www.thedailymeal.com/";
//    facebook.imageLink = @"http://www.thedailymeal.com/";
//    
//    [facebook load];

}


- (void)sentLoginRequestWithUID:(NSString *)uid andUrl:(NSString *)url
{
    [self showOverlayView];
    NSAutoreleasePool  *pool = [[NSAutoreleasePool alloc]init];
    TDMHTTPLoginService *loginHandler = [[TDMHTTPLoginService alloc] init];
    loginHandler.loginHandlerDelegate = self;
    [loginHandler loginUserWithFBUid:uid andRedirectUrl:url];
    [pool drain];
    
}

- (void)FacebookLoginWithAceessTocken {
    
    [self sentLoginRequestWithUID:[facebook accessToken] andUrl:[facebook redirectUri]];
}


#pragma mark - Twitter Login

- (IBAction)twitterLoginAction:(id)sender 
{
//    if(objTwitter!=nil){
//        [objTwitter release];
//        objTwitter = nil;
//    }
//    objTwitter=[[Twitter alloc] initWithNibName:@"Twitter" bundle:nil];
//    objTwitter.strTweetContent=@"http://www.thedailymeal.com/twitter/oauthoqrCiNqIWRX5lz6kCGZTQ?ls=1&mt=8";
//    
//    if(dialog!=nil){
//        [dialog release];
//        dialog = nil;
//        
//    }
//    dialog=[[ShareView alloc] initWithFrame:([UIScreen mainScreen].applicationFrame) 
//                                  ShareType:twitter
//                                 andSubView:objTwitter.view];
//    objTwitter.parentView=dialog;
//    [dialog load];
    
    
}


#pragma mark - Logout Handler Delegates

-(void)loggedOutSuccessfully
{
    [TDMDataStore sharedStore].isLoggedIn = NO;
    [[DatabaseManager sharedManager]deleteUserDataBase];
    [self removeOverlayView];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)logOutFailed
{
    [self removeOverlayView];
}

#pragma mark - Segment Control 
- (void) addSegmentedControl 
{
    NSArray * segmentItems = [NSArray arrayWithObjects: @"Log In", @"Sign Up", nil];
    self.segment = [[[UISegmentedControl alloc] initWithItems: segmentItems] autorelease];
    self.segment.segmentedControlStyle = UISegmentedControlStylePlain;
    self.segment.frame = CGRectMake(88, 30, 150, 30);
    self.segment.selectedSegmentIndex = SEGMENT_CONTROL_LIST_BUTTON;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:kGET_BOLD_FONT_WITH_SIZE(14)
                                                               forKey:UITextAttributeFont];
        
        [self.segment setTitleTextAttributes:attributes 
                                           forState:UIControlStateNormal];
        attributes = nil;
    }
    else
    {
      [self changeUISegmentFont:self.segment];
    }
    [self.segment addTarget: self action: @selector(segmentClick:) 
                  forControlEvents: UIControlEventValueChanged];
    [self.mainScrollView addSubview:self.segment];
    if (self.isfromSettings) {
        [self.segment setSelectedSegmentIndex:1];
    }
    else
    {
    [self.segment setSelectedSegmentIndex:0];
    }
    
}
-(void) changeUISegmentFont:(UIView*) myView 
{
    if ([myView isKindOfClass:[UILabel class]]) {  // Getting the label subview of the passed view
        UILabel* label = (UILabel*)myView;
        [label setTextAlignment:UITextAlignmentCenter];
        [label setFont:kGET_BOLD_FONT_WITH_SIZE(13)]; // Set the font size you want to change to
        
    }
    
    NSArray* subViewArray = [myView subviews]; // Getting the subview array
   
    NSEnumerator* iterator = [subViewArray objectEnumerator]; // For enumeration
    
    UIView* subView;
    
    while (subView = [iterator nextObject]) { // Iterating through the subviews of the view passed
        
        [self changeUISegmentFont:subView]; // Recursion
        
    }
    
}


- (void)fbDidLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [self FacebookLoginWithAceessTocken];
}

- (void)fbDidLogout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    
}


- (IBAction)fbLoginButtonClicked:(id)sender {
    
    
    if(facebook){
        
        [facebook release];
        facebook = nil;
    }
    facebook = [[Facebook alloc] initWithAppId:FBAPP_KEY andDelegate:self];
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", nil];
    
    facebook.userFlow = YES;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.logindelegate = facebook;
    
    [facebook logout:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"])
    {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        [self FacebookLoginWithAceessTocken];
    }
    
    if (![facebook isSessionValid]) {
        [facebook authorize:permissions];
    }  

}

- (IBAction)termsButtonClicked:(id)sender {
    
        NSString *url = @"http://www.thedailymeal.com/legal";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]; 
}

#pragma mark    Overlay View Management
- (void)showOverlayView
{
    [self removeOverlayView];
    
    overlayView = [[TDMOverlayView alloc] initWithSyncStyleAndTitle:@"Signing In..."];
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

-(void) photoUploadedSuccessFully 
{
   
    [self removeOverlayView];

//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meal" 
//                                                   message:@"Your photo has been uploaded" 
//                                                  delegate:self 
//                                         cancelButtonTitle:@"OK" 
//                                         otherButtonTitles:nil];
//    [alert show];
//    [alert release];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) noPhoto
{
  
    [self removeOverlayView];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) photoUploadedFailed 
{
   
    [self removeOverlayView];

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meal" 
                                                   message:@"Error occured while photo upload" 
                                                  delegate:nil 
                                         cancelButtonTitle:@"OK" 
                                         otherButtonTitles:nil];
    [alert show];
    [alert release];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) networkErrorInAddinBusinessReview 
{
    [self removeOverlayView];
      [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.signUpScrollView setContentSize:CGSizeMake(0, 0)];
}

@end
