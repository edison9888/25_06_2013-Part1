//
//  LoginViewController.m
//  Red Beacon
//
//  Created by Joe on 12/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "JobRequestFinishedViewController.h"
#import "RBAlertMessageHandler.h"
#import "RBFacebookHandler.h"
#import "Reachability.h"

@interface LoginViewController (Private)
- (void)hideOverlay;
- (IBAction)onTouchUpHiddenContainer:(id)sender;
@end

@implementation LoginViewController

@synthesize delegate;
@synthesize overlay;
@synthesize username;
@synthesize password;
@synthesize email;
@synthesize telephone;
@synthesize loginImage;
@synthesize loginLabel;
@synthesize loginTable;
@synthesize hiddenContainer;
@synthesize loginDialogView = _loginDialogView;
@synthesize facebook;


NSString * const AS_SIGNUP_USERNAME_EMPTY        = @"Username is empty";
NSString * const AS_SIGNUP_EMAIL_EMPTY           = @"Email is empty";
NSString * const AS_SIGNUP_EMAIL_NOTVALID        = @"Email not valid";
NSString * const AS_SIGNUP_PASSWORD_EMPTY        = @"Password is empty";
NSString * const AS_SIGNUP_CONFIRMPASSWORD_EMPTY = @"Confirmation password is empty";
NSString * const AS_SIGNUP_PASSWORDMISMATCH      = @"Password mismatch";
NSString * const AS_LOGIN_USERNAME_EMPTY         = @"Username is empty";
NSString * const AS_LOGIN_PASSWORD_EMPTY         = @"Password is empty";
//NSString * const AS_LOGIN_ERROR = @"Login Error";
NSString * const AS_INCORRECT_CREDENTIALS         = @"Incorrect username or password";
NSString * const AS_SIGNUP_ERROR_TITLE            = @"Signup Error";
NSString * const AS_SIGNUP_ERROR_MESSAGE          = @"Error occured while signing up";
NSString * const AS_SIGNUP_SUCESSFULL_TITLE       = @"Signup Successful";
NSString * const AS_SIGNUP_SUCCESSFULL_MESSAGE    = @"User registration successful.";
NSString * const AS_SIGNUP_USERNAME_TAKEN_MESSAGE = @"This username is already taken. Please choose another one!";
NSString * const AS_SIGNUP_EMAIL_TAKEN_MESSAGE    = @"This email is already taken. Please choose another one!";

NSString * kLoginRightSelected                    = @"RBRegistrationRightSelected";
NSString * kLoginRightUnSelected                  = @"RBRegistrationRightUnSelected";
NSString * kLoginLeftSelected                     = @"RBRegistrationLeftSelected";
NSString * kLoginLeftUnSelected                   = @"RBRegistrationLeftUnSelected";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    loginTable.backgroundColor = [UIColor clearColor];
    [self addSegmentedControl];
}

- (void)enableLoginMode {
    
    NSString * path;
    UIImage * image;
    
    path = [[NSBundle mainBundle] pathForResource:kLoginLeftSelected
                                           ofType:kRBImageType];
    image = [[UIImage alloc] initWithContentsOfFile:path];      
    [segmentedControl setImage:image forSegmentAtIndex:0];
    [image release];
    
    path = [[NSBundle mainBundle] pathForResource:kLoginRightUnSelected
                                           ofType:kRBImageType];
    image = [[UIImage alloc] initWithContentsOfFile:path];
    [segmentedControl setImage:image forSegmentAtIndex:1];
    [image release];
    
}

- (void)enableSignUpMode {
    
    NSString * path;
    UIImage * image;
    
    path = [[NSBundle mainBundle] pathForResource:kLoginLeftUnSelected
                                           ofType:kRBImageType];
    image = [[UIImage alloc] initWithContentsOfFile:path];      
    [segmentedControl setImage:image forSegmentAtIndex:0];
    [image release];
    
    path = [[NSBundle mainBundle] pathForResource:kLoginRightSelected
                                           ofType:kRBImageType];
    image = [[UIImage alloc] initWithContentsOfFile:path];
    [segmentedControl setImage:image forSegmentAtIndex:1];
    [image release];
}

- (void) addSegmentedControl 
{
    NSArray * segmentItems = [NSArray arrayWithObjects: @"Login", @"Signup", nil];
    segmentedControl = [[[UISegmentedControl alloc] initWithItems: segmentItems] retain];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = 1;
    [segmentedControl addTarget: self action: @selector(onSegmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    [segmentedControl setFrame:CGRectMake(0, 0, 141, 25)];
    [self enableSignUpMode];
    loginTable.frame = CGRectMake(0, 25, 320, 393);
}

- (void) onSegmentedControlChanged:(UISegmentedControl *) sender {
    
    if (hiddenContainer)
    {
        
        [hiddenContainer removeFromSuperview];  
    }
    
    if (segmentedControl.selectedSegmentIndex == 0) 
    { 
        loginLabel.hidden=loginLabelStatus;
        loginTable.frame = CGRectMake(0, 25, 320, 331);
        [loginTable reloadData];
        [self enableLoginMode];
        
    } else if (segmentedControl.selectedSegmentIndex == 1)
    {
        //loginLabel.hidden=YES;
        loginTable.frame = CGRectMake(0, 25, 320, 393);
        [loginTable reloadData];
        [self enableSignUpMode];
    }

}


- (void)setupNavigationBar
{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    button=nil;
    [item release];
    item = nil;
    
    button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 60, 30);
    item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    [button release];
    button=nil;
    [item release];
    item = nil;
    
}


#pragma mark -
#pragma mark Table view data source

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath	{
 
 return 66;
 }*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int numberOfRows = 0;

    if(section == 0) {

        if (segmentedControl.selectedSegmentIndex == 0) { 
            numberOfRows = 2; 
        }
        else if (segmentedControl.selectedSegmentIndex == 1) {
            numberOfRows = 3;
        }       
    }
    if (section == 1)
    {
        numberOfRows = 1;
    }
    if (section == 2)
    {
        numberOfRows = 1;
    }
    return numberOfRows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if ([cell.contentView subviews]){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
   cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //tableView.separatorColor = [UIColor lightGrayColor];

    switch (indexPath.section) {

        case 0:
        {
            cell.textLabel.text = @"";
            CGRect frame = CGRectMake(5 ,8 , 282, 25);
            txtField = [[UITextField alloc]initWithFrame:frame];
            [txtField setDelegate:self];
            [txtField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [txtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [txtField setReturnKeyType:UIReturnKeyNext];

            switch (indexPath.row) {
                case 0:
                    if (segmentedControl.selectedSegmentIndex == 0)
                    { 
                        txtField.placeholder=@"Email address or username";  
                        usernameTextField = txtField;
                    }
                    else if (segmentedControl.selectedSegmentIndex == 1) 
                    { 
                         txtField.placeholder = @"Enter your email address";
                         userNameAtSignUpTextField = txtField;
                    }
                    
                    break;
                case 1:
                    if (segmentedControl.selectedSegmentIndex == 0)
                    { 
                        txtField.placeholder = @"Password";
                        passwordTextField = txtField;
                        [txtField setSecureTextEntry:YES];
                        [txtField setReturnKeyType:UIReturnKeyGo];
                    }
                    else if (segmentedControl.selectedSegmentIndex == 1) 
                    {
                        txtField.placeholder = @"Enter your password"; 
                        cell.backgroundColor=[UIColor whiteColor];
                        passwordAtSignUpTextField = txtField;
                        [txtField setSecureTextEntry:YES];
                    }
                    break;
                case 2:
                {
                    txtField.placeholder = @"Enter your phone number";
                    cell.backgroundColor=[UIColor whiteColor];
                    telephoneSignUpTextField = txtField;
                    [txtField setReturnKeyType:UIReturnKeyGo];
                    
                }
                    break;
            }    
            [cell.contentView addSubview:txtField];
            [txtField release];
            
            
            
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"";
            cell.backgroundColor=[UIColor clearColor];
            UIButton *btnHome_Section=[[UIButton alloc]init];
            btnHome_Section.frame=CGRectMake(-3, -3, 307, 53);
            btnHome_Section.backgroundColor=[UIColor clearColor];
            btnHome_Section.contentMode = UIViewContentModeScaleAspectFill;
            
            [btnHome_Section setBackgroundImage:[UIImage imageNamed:@"loginButton.png"] forState:UIControlStateNormal];
            
            [btnHome_Section addTarget:self action:@selector(loginButtonPresssed:) forControlEvents:UIControlEventTouchUpInside];
            
            btnHome_Section.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:18]; 
            
            if (segmentedControl.selectedSegmentIndex == 0)
            { 
                [btnHome_Section setTitle:@"Log in" forState:UIControlStateNormal];
            }
            else if (segmentedControl.selectedSegmentIndex == 1) 
            {
                [btnHome_Section setTitle:@"Sign up - it's FREE!" forState:UIControlStateNormal];
            }
            
            [btnHome_Section setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:btnHome_Section];
            cell.backgroundColor=[UIColor clearColor];
            [btnHome_Section release];
            btnHome_Section=nil;
            
//            //clear section boarder color
//            UIView *myView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
//            myView.backgroundColor = [UIColor clearColor];
//            cell.backgroundView = myView;
            break;
            
        }
        case 2:
        {
//            //clear section boarder color
//            UIView *facebookButtonBackView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
//            facebookButtonBackView.backgroundColor = [UIColor clearColor];
//            cell.backgroundView = facebookButtonBackView;
            
            cell.textLabel.text = @"";                       
            cell.backgroundColor=[UIColor clearColor];
            UIButton *btnHome_Section=[[UIButton alloc]init];
            btnHome_Section.frame=CGRectMake(-3, -3, 307, 53);
            btnHome_Section.backgroundColor=[UIColor clearColor];
            btnHome_Section.contentMode = UIViewContentModeScaleAspectFill;
            
            [btnHome_Section setBackgroundImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
            
            [btnHome_Section addTarget:self action:@selector(facebookButtonPresssed:) forControlEvents:UIControlEventTouchUpInside];
            
            btnHome_Section.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:16]; 
            
            if (segmentedControl.selectedSegmentIndex == 0)
            { 
                
                [btnHome_Section setTitle:@"or Log in with Facebook" forState:UIControlStateNormal];
            }
            else if (segmentedControl.selectedSegmentIndex == 1) 
            {
                [btnHome_Section setTitle:@"or Sign up with Facebook" forState:UIControlStateNormal];
            }
            
            [btnHome_Section setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            
            [cell.contentView addSubview:btnHome_Section];
            [btnHome_Section release];
            btnHome_Section=nil;
            break;
        }
      
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -

- (void)showRequestFinishController {
    
    UIBarButtonItem *barButton = self.navigationItem.leftBarButtonItem;
    UIButton *doneButton = (UIButton *)barButton.customView;
    doneButton.titleLabel.text = @"Home";
    
    [self.navigationItem.titleView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 200, 20)];		
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    label.text = @"Request Received";
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    self.navigationItem.titleView=label;
    
    JobRequestFinishedViewController *requestFinishedViewController=[[JobRequestFinishedViewController alloc]initWithNibName:@"JobRequestFinishedViewController" bundle:nil];
    [self.view addSubview:requestFinishedViewController.view];
    [requestFinishedViewController release];
    requestFinishedViewController=nil;

}

- (void)hideLoginLabel:(BOOL)status{
    loginLabel.hidden = loginLabelStatus = status;
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
    if ([self isNonEmptyString:usernameTextField.text]) {
        isValid = YES;
    }
    return isValid;
}

- (BOOL)isValidPasswordAtLogin {
    BOOL isValid = NO;
    if ([self isNonEmptyString:passwordTextField.text]) {
        isValid = YES;
    }
    return isValid;
}
//returns TRUE if all fields are valid else FALSE
- (BOOL)isValidLoginDatas {
    
    BOOL isValid = YES;
    NSString * alertMessage;
    do {
        if (![self isNonEmptyString:usernameTextField.text]) {
            alertMessage = AS_LOGIN_USERNAME_EMPTY;
            isValid = NO;
            break;
        }
        
        if (![self isNonEmptyString:passwordTextField.text]) {
            alertMessage = AS_LOGIN_PASSWORD_EMPTY;
            isValid = NO;
        }
        //add for more checking here
        //...
        //...
        
    } while (FALSE);
    
    if (!isValid) {
        [RBAlertMessageHandler showAlert:alertMessage
                          delegateObject:nil];
        
    }
    return isValid;    
}

#pragma mark - SIGN UP
//email validation is done here
- (BOOL)isValidEmailAddress:(NSString*)emailAddress {
    
    BOOL isValid = NO;
    
    //email address format 
    NSString *emailRegex = @"^([_a-z0-9_+.]+)(\\.[_a-z0-9-]+)*@([a-z0-9-]+)(\\.[a-z0-9-]+)*(\\.[a-z]{2,4})$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    //evalute with the predicate
    if ([emailTest evaluateWithObject:emailAddress])
    {        
        //true, email
        isValid = YES;
    }	  
    
    return isValid; 
}


- (BOOL)isValidSignUpDatas {
    BOOL isValid = YES;
    NSString * alertMessage;
    do {
        if (![self isNonEmptyString:userNameAtSignUpTextField.text]) {
            alertMessage = AS_SIGNUP_USERNAME_EMPTY;
            isValid = NO;
            break;
        }        
        
        if (![self isNonEmptyString:passwordAtSignUpTextField.text]) {
            alertMessage = AS_SIGNUP_PASSWORD_EMPTY;
            isValid = NO;
            break;
        }
        
        if (![self isNonEmptyString:telephoneSignUpTextField.text]) {
            alertMessage = AS_SIGNUP_CONFIRMPASSWORD_EMPTY;
            isValid = NO;
            break;
        }  
        
        //add for more checking here
        //...
        //...
        
    } while (FALSE);
    
    if (!isValid) {
        [RBAlertMessageHandler showAlert:alertMessage 
                          delegateObject:nil];
    }
    
    return isValid;
}

#pragma mark - Login/SignUp methods
- (void)login 
{
     NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if (!loginHandler)
    {
        loginHandler = [[RBLoginHandler alloc] init];
    }
    
    loginHandler.delegate = self;

    [loginHandler sendLoginRequestWithUsername:username andPassword:password];
    [pool drain];
}

- (void)signUp
{
     NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    if (!signUpHandler)
    {
        signUpHandler = [[RBSignUpHandler alloc] init];
    }
    
    signUpHandler.delegate = self;

    //[signUpHandler sendUsernameNotTakenRequest:username];
    
    //sign up request
    [signUpHandler sendSignUpRequestWithUsername: self.username 
                                     andPassword:self.password :self.telephone];

    [pool drain];
}

#pragma mark- button click
- (IBAction)loginButtonPresssed:(id)sender
{
    if ([Reachability connected]) {
        Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
        if (segmentedControl.selectedSegmentIndex == 0) 
        {
            [usernameTextField resignFirstResponder];  
            [passwordTextField resignFirstResponder];
            // Save the values of the UI controls in member variables to avoid accessing
            // UI elements from a non-main thread
            self.username = usernameTextField.text;
            self.password = passwordTextField.text;
            //LOGIN
            if ([self isValidLoginDatas]) 
            {
                self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                                  withMessage:@"Logging in..." 
                                                     animated:YES];
                
                [NSThread detachNewThreadSelector:@selector(login) 
                                         toTarget:self 
                                       withObject:nil];
            } 
        }
        else 
        {
            [userNameAtSignUpTextField resignFirstResponder];  
            [passwordAtSignUpTextField resignFirstResponder]; 
            [telephoneSignUpTextField resignFirstResponder]; 
            // Save the values of the UI controls in member variables to avoid accessing
            // UI elements from a non-main thread
            self.password = passwordAtSignUpTextField.text;
            self.username = userNameAtSignUpTextField.text;
            self.telephone = telephoneSignUpTextField.text;
            //SIGN UP
            if ([self isValidSignUpDatas]) 
            {
                self.overlay = 
                [RBLoadingOverlay loadOverView:appDelegate.window
                                   withMessage:@"Signing up..." 
                                      animated:YES];
                [NSThread detachNewThreadSelector:@selector(signUp) 
                                         toTarget:self 
                                       withObject:nil];
            }
        }
    }    
}

- (IBAction)facebookButtonPresssed:(id)sender
{   
    Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[UIApplication sharedApplication].delegate;
    
    facebook = [[Facebook alloc] initWithAppId:@"163802440329834" andDelegate:self];
    
    appDelegate.logindelegate = self.facebook;
    
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
        [facebook authorize:nil];
    }   
    
}

- (BOOL)segmentClickIdentification
{
    BOOL value =  NO;
    if (segmentedControl.selectedSegmentIndex == 0)
    { 
        value = YES; 
    }
    else if (segmentedControl.selectedSegmentIndex == 1) 
    {
        value = NO; 
    }
    return value;
}


-(IBAction)cancelButtonClicked:(id)sender
{
    if (hiddenContainer)
    {
        [hiddenContainer removeFromSuperview];  
    }

    [delegate loginCancelled];
   // [LoginViewController releaseMe];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)onTouchUpHiddenContainer:(id)sender {

    if (0 == segmentedControl.selectedSegmentIndex) 
    { 
        [usernameTextField resignFirstResponder];  
        [passwordTextField resignFirstResponder]; 
        
    } else if (1 == segmentedControl.selectedSegmentIndex)
    {
        [userNameAtSignUpTextField resignFirstResponder];   
        [passwordAtSignUpTextField resignFirstResponder]; 
        [telephoneSignUpTextField resignFirstResponder]; 
    }
    [hiddenContainer removeFromSuperview];
}

#pragma  mark-

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.loginLabel = nil;
    self.loginImage = nil;
    self.loginTable = nil;
    self.hiddenContainer = nil;
    self.loginDialogView = nil;
}

- (void)dealloc
{
    [overlay release];
    
    [segmentedControl release];
    segmentedControl = nil;
    
    [loginImage release];
    loginImage = nil;
    
    [loginLabel release];
    loginLabel = nil;
    
    [loginTable release];
    loginTable = nil;
    
    [hiddenContainer release];
    hiddenContainer = nil;
    
    [username release];
    [password release];
    [email release];
    [telephone release];
    [facebookHandler release];
    [loginHandler release];

    self.loginDialogView = nil;
    
    Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.logindelegate = nil;

    [super dealloc];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void)saveUserCredentialsWithUserName:(NSString*)theUsername 
{
    RBDefaultsWrapper * sharedWrapper = [RBDefaultsWrapper standardWrapper];
    [sharedWrapper updateUserName:theUsername];
}

#pragma mark - Overlay Method
- (void)hideOverlay {
    [self.overlay removeFromSuperview:YES];
    self.overlay = nil;
}

#pragma mark - RBBaseHTTPHandler Delegate
- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request
{
    do
    {
        RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request];
        
        if (requestType == kLogin) 
        {
            if ([request responseStatusCode] == 302) 
            {
                //login was successfull
                [self saveUserCredentialsWithUserName:usernameTextField.text];
                [self.navigationController popToRootViewControllerAnimated:YES];
                [loginHandler release];
                loginHandler = nil;
                [delegate loginSuccessful];
                [self hideOverlay];
                break;
            }
            
            [self hideOverlay];
            // If we are here, then login was not successful
            [RBAlertMessageHandler showAlert:AS_INCORRECT_CREDENTIALS 
                                  delegateObject:nil];
            break;
        }
        
        if (requestType == kSignUp) 
        {
            NSString *errorMessage;
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSDictionary * responseDictionary = [responseString JSONValue];
            
            NSDictionary * errorResponseDict = [responseDictionary valueForKey:@"errors"];
            NSArray *phone =[errorResponseDict objectForKey:@"phone"];
            NSArray *mail =[errorResponseDict objectForKey:@"email"];
            
    
            if ([phone count]>0 && [mail count]>0) {
                
                errorMessage = [[mail objectAtIndex:0] stringByAppendingFormat:@"\n%@",[phone objectAtIndex:0]]; 
            }
            else
            {
             
                if ([phone count]>0) 
                {
                    
                    errorMessage = [phone objectAtIndex:0];
                }
                if ([mail count]>0)
                {
                    
                    errorMessage = [mail objectAtIndex:0];

                }
            }
            
            if ([[responseDictionary valueForKey:@"success"] intValue])
            {
                //signUp was successful
                [self saveUserCredentialsWithUserName:[responseDictionary objectForKey:@"new_username"]];
                [self.navigationController popToRootViewControllerAnimated:YES];
                [signUpHandler release];
                signUpHandler = nil;
                [self hideOverlay];
                [delegate loginSuccessful];
                [RBAlertMessageHandler showAlert:AS_SIGNUP_SUCESSFULL_TITLE
                                  delegateObject:nil];
                break;
            }
            else
            {
                [self hideOverlay];
                // If we are here, then signup was not successful
                [RBAlertMessageHandler showAlert:errorMessage
                                  delegateObject:nil];
                break;  
            }

        }
        
        if (requestType == kFacebookLogin)
        {
            [facebookHandler release];
            facebookHandler = nil;
            
            NSDictionary* responseDict = [[request responseString] JSONValue];
            if ([responseDict objectForKey:@"success"])
            {
                //[self.navigationController popToRootViewControllerAnimated:YES];
                NSLog(@"Facebook login success");
                NSString* fullName = [responseDict objectForKey:@"full_name"];
                [self saveUserCredentialsWithUserName:fullName];
                [delegate loginSuccessful];
                
                [self hideOverlay];
                
                [self.navigationController popViewControllerAnimated:YES];
                
//                [self dismissModalViewControllerAnimated:YES];
//                [self.navigationController popToRootViewControllerAnimated:YES];
                break;
                
            }
            
            // If we are here, then facebook login was not successful
            [RBAlertMessageHandler showAlert:AS_INCORRECT_CREDENTIALS 
                              delegateObject:nil];
            
            break;
        }
        
        
    } while (0);
}

- (void)requestCompletedWithErrors:(ASIHTTPRequest*)request 
{
    [self hideOverlay];
    
    RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request];
    
    do 
    {
        
        if (request == nil)
        {
            // You will reach here only if no internet connection exists
            break;
        }
        
        if (requestType == kLogin) 
        {
            NSLog(@"Login error");
            
            [loginHandler release];
            loginHandler = nil;
            
            [RBAlertMessageHandler showAlert:AS_FAILED_LOGIN_REQ_ALERT_MESSAGE 
                              delegateObject:nil];
            
            break;
        }
        
        if (requestType == kSignUp           || 
            requestType == kUsernameNotTaken || 
            requestType == kEmailNotTaken) 
        {
            NSLog(@"Signup error");
            
            [signUpHandler release];
            signUpHandler = nil;
            
            [RBAlertMessageHandler showAlert:AS_FAILED_SIGNUP_REQ_ALERT_MESSAGE 
                              delegateObject:nil];
            
            break;
        }
        
        if (requestType == kFacebookLogin)
        {
            NSLog(@"Facebook login error");
            
            [facebookHandler release];
            facebookHandler = nil;
            
            [RBAlertMessageHandler showAlert:AS_FAILED_FBLOGIN_REQ_ALERT_MESSAGE 
                              delegateObject:nil];
            
            break;
        }

        
    } while (0);
}


#pragma mark - TextField Delegate methods
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField 
{
    // [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    //view for hidding the keyboard
    [self.view addSubview:hiddenContainer];
    [hiddenContainer setFrame:CGRectMake(0, 0, 320, 30)];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    
    if (textField==usernameTextField)
    {
        [passwordTextField becomeFirstResponder];
    }
    else if (textField == userNameAtSignUpTextField)
    {
        [passwordAtSignUpTextField becomeFirstResponder];
    }

    else if (textField == passwordAtSignUpTextField)
    {
        [telephoneSignUpTextField becomeFirstResponder];
    }
    else 
    {
        [self loginButtonPresssed:nil];
        [textField resignFirstResponder];                                                              
    }
    return YES; 
}


#pragma mark- Facebook Delegates

- (void)fbDidLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
    self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                      withMessage:@"Logging in..." 
                                         animated:YES];
    [self FacebookLoginWithAceessTocken];
}

- (void)fbDidLogout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];

}

#pragma mark - 

- (void)FacebookLoginWithAceessTocken {
    
    if (!facebookHandler)
    {
        facebookHandler = [[RBFacebookHandler alloc] init];
    }
    
    facebookHandler.delegate = self;
    [facebookHandler sendFacebookLoginWithCookie:[facebook accessToken]];
    
}
@end
