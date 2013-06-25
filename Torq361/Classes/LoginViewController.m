//
//  LoginViewController.m
//  Torq361
//
//  Created by Binoy on 04/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

#import "Base64Converter.h"
#import "HelperFunctions.h"
#import "ConnectivityCheck.h"
#import "AppTmpData.h"
#import "Constants.h"
#import "UserCredentials.h"
#import "Torq361AppDelegate.h"
#import "Home.h"
#import "DatabaseManager.h"
#import "ForgotPassword.h"


@implementation LoginViewController


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	loginScrollView.contentSize = CGSizeMake(0,400);
	m_ErrMessage.text=@"";
	[txtUsername setText:@""];
	[txtPassword setText:@""];
    
    /////////////////for debugging purpose only/////////////////////////////////////////
    //[txtUsername setText:@"rajeevk@rapidvaluesolutions.com"];
	//[txtPassword setText:@"password"];
    ////////////////////////////////////////////////////////////////////////////////////
    
	
	//set navigation bar title
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
	//label.font = [UIFont boldSystemFontOfSize:14.0];
	//label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	[label setFont:[UIFont fontWithName:@"Arial" size:22]];
	self.navigationItem.titleView = label;
	label.text = @"Login";
	[label release];
	
	
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
	
	
	UIImage *image;
	
	image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"login_here" ofType:@"png"]];
	backgroundImageView.image = image;
	[image release];
	image=nil;
	
	image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"login_textbox" ofType:@"png"]];
	usernameFieldImage.image = image;
	passwordFieldImage.image = image;
	[image release];
	image=nil;
	
	image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"log_in" ofType:@"png"]];
	loginButtonImage.image = image;
	[image release];
	image=nil;
	
	
    
}

- (void)viewWillDisappear:(BOOL)animated {
	
	m_ErrMessage.text=@"";
	
	[txtUsername setText:@""];
	
	[txtPassword setText:@""];
    
}



#pragma mark -
#pragma mark TextField methods

-(void)adjustScrollView{		
	if(!bcontentflag)
	{
		icontentsize=850;
		loginScrollView.contentSize= CGSizeMake(0, icontentsize);
		bcontentflag=YES;
	}
	
}

- (void)keyboardWillHide:(NSNotification *)obj_notification{
	if(bcontentflag)
	{
		icontentsize=400;
		loginScrollView.contentSize= CGSizeMake(0, icontentsize);
		bcontentflag=NO;
	}
	[self RestoreScrollview];
}

- (void)keyboardWillShow:(NSNotification *)obj_notification{
	[self adjustScrollView];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
	[self adjustScrollView];
	
	float fval;
	
	if(textField==txtUsername) {
		
		CGRect m_objtextrect=[self.view frame];		
		fval=m_objtextrect.origin.y;
		m_objtextrect=[textField frame];
		fval=fval+m_objtextrect.origin.y;
		if(fval>55){
            if([[AppTmpData sharedManager] getDeviceOrientation]){
                [self startAnimateScrollview:(int)((fval-100))];
            }else{
                [self startAnimateScrollview:(int)((fval-50))];
            }
		}
	}
	
	if(textField==txtPassword){		
		CGRect m_objtextrect=[self.view frame];		
		fval=m_objtextrect.origin.y;
		m_objtextrect=[textField frame];
		fval=fval+m_objtextrect.origin.y;
		if(fval>55){
            if([[AppTmpData sharedManager] getDeviceOrientation]){
                [self startAnimateScrollview:(int)((fval-200))];
            }else{
                [self startAnimateScrollview:(int)((fval-50))]; 
            }
		}		
	}	
	
}


-(void)startAnimateScrollview:(int)iVal{
    CGRect rc = [loginScrollView bounds];
    rc = [loginScrollView convertRect:rc toView:self.view];
    CGPoint pt = rc.origin ;
    pt.x = 0 ;
    pt.y -= iVal*(-1) ;
    [loginScrollView setContentOffset:pt animated:YES];
}
-(void)RestoreScrollview{
    CGPoint pt;
    pt.x = 0 ;
    pt.y = 0 ;
    [loginScrollView setContentOffset:pt animated:YES];
}

#pragma mark -

#pragma mark Button Actions

-(IBAction)loginBtnClicked:(id)Sender {
	
	[txtUsername resignFirstResponder];
    [txtPassword resignFirstResponder];
	
/*	NSDictionary *tempDict = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:@"100",@"101",@"Binoy",@"CM",nil]  forKeys:[NSArray arrayWithObjects:@"idCompany",@"idRoll",@"FirstName",@"LastName",nil]];
	
	[self checkPreviousUserIdAndCompanyId];
	
	[self setUserCredential:tempDict];
	
	Torq361AppDelegate *appDelegate = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
	
	[self dismissModalViewControllerAnimated:YES];
	
	[appDelegate.home onSuccessfulLogin];
	
*/	
    
    NSString *userName=[HelperFunctions trimTxtField:txtUsername.text];
    NSString *pwd=[HelperFunctions trimTxtField:txtPassword.text];
    
    if([userName isEqualToString: @""]&&[pwd isEqualToString: @""]){
        m_ErrMessage.text=@"Please enter Username and Password";
        return;
    }
    if(userName==nil || [userName isEqualToString: @""]){
        m_ErrMessage.text=@"Please enter Username";
        return;
    }
    
    
    if(pwd==nil || [pwd isEqualToString: @""]){
        m_ErrMessage.text=@"Please enter Password";
        return;
    }
    
    

	ConnectivityCheck *connectivityCheck=[[ConnectivityCheck alloc] init];
	
	if([connectivityCheck isHostReachable]){
		
		
		NSString *encodedPassword=[Base64Converter encode:[[HelperFunctions trimTxtField:txtPassword.text] dataUsingEncoding:NSASCIIStringEncoding]];
		
		NSMutableDictionary *dataDict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[HelperFunctions trimTxtField:txtUsername.text],@"username",encodedPassword,@"password",nil];	
		
		JsonParser *jsonParser=[[JsonParser alloc]init];
		
		jsonParser.delegate=self;
		
		NSString *str=[NSString stringWithFormat:@"%@/clientlogin",CMSLink];  // from amason @"%@/torq361login",CMSLinkk];
		
		[jsonParser parseJSONResponseofAPI:str JSONRequest:dataDict];
		
		[dataDict release];
		
		dataDict = nil;
		
		[jsonParser release];
		
		jsonParser = nil;
		
		m_ErrMessage.text = @" ";
        [txtUsername setEnabled:NO];
        [txtPassword setEnabled:NO];
		[obj_status setHidden:NO];
		[m_actindicator setHidden:NO];
		[m_LoginBtn setEnabled:NO];
        [m_TroubleLoginBtn setEnabled:NO];
		
	}
	else {
		m_ErrMessage.text=@"No Connectivity.";
	}
	
	[connectivityCheck release];
 
 
}



-(IBAction)ForgotPasswordBtnClicked:(id)Sender {
	
	ForgotPassword *forgotPassword = [[ForgotPassword alloc] initWithNibName:@"ForgotPassword" bundle:nil];
	
	[[self navigationController] pushViewController:forgotPassword animated:YES];
	
	[forgotPassword release];
	
}


#pragma mark -
#pragma mark JsonParser Delegate Methods

-(void)didfinishedparsing:(JsonParser *)objJsonParser{
	
	Torq361AppDelegate *appDelegate = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
	
	NSMutableDictionary *resultDict = objJsonParser.objResult;
	
	//NSString *strLoginStatus;
	
	NSString *strLoginStatus= [resultDict valueForKey:@"status"];
	
	[obj_status setHidden:YES];
	
	[m_actindicator setHidden:YES];
	
	[m_LoginBtn setEnabled:YES];
    
    [m_TroubleLoginBtn setEnabled:YES];
    
    [txtUsername setEnabled:YES];
    
    [txtPassword setEnabled:YES];

	
	if ([strLoginStatus isEqualToString:@"Success"]) {
        
        NSString *userName=[[NSUserDefaults standardUserDefaults]valueForKey:kUserEmailID];
        
        if(userName!=[HelperFunctions trimTxtField:txtUsername.text]){
            
            [[DatabaseManager sharedManager] resetDatabase];
            NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
            Torq361AppDelegate *appDelegate = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate deleteteFolderStructureInDocumentDirectory:companyid];
        }
		
		[self setUserCredential:resultDict];
		
		[self dismissModalViewControllerAnimated:YES];
		
		[appDelegate.home onSuccessfulLogin];
		
		
			
	}
	
	else if([strLoginStatus intValue]==607) {
		
		m_ErrMessage.text=@"Your Registration request is pending for approval from Administrator.";
	
	
	}
	
	else if([strLoginStatus isEqualToString:@"License Expired"]) {
		
		m_ErrMessage.text=@"Your License Expired Please Contact Administrator.";
		
	}
	
	else {
		
		m_ErrMessage.text=@"Username or Password you entered is incorrect.";
        [txtPassword setText:@""];
        [txtPassword becomeFirstResponder];
		
	}


}
-(void)didfailedwitherror:(JsonParser *)objJsonParser{
	
	[obj_status setHidden:YES];
	[m_actindicator setHidden:YES];
	[m_LoginBtn setEnabled:YES];
	[m_ErrMessage setHidden:NO];
    [m_TroubleLoginBtn setEnabled:YES];
    [txtUsername setEnabled:YES];
    [txtPassword setEnabled:YES];
    
	m_ErrMessage.text=@"Unable to connect to server";	
    
		
}

#pragma mark -

-(void)setUserCredential:(NSDictionary *)Dict {
	
	NSArray *keys= [HelperFunctions getDictionaryKeys:Dict];
	
	for(int i=0;i<[keys count];i++){
		
		NSString *strkey=[keys objectAtIndex:i];
		
		if ( [strkey isEqualToString:@"idCompany"]) {
			
			[[UserCredentials sharedManager] setCompanyID:[Dict valueForKey:strkey]];
			
		}
		else if([strkey isEqualToString:@"idRoll"]) {
			
			[[UserCredentials sharedManager] setRollID:[Dict valueForKey:strkey]];
			
		}
		else if([strkey isEqualToString:@"FirstName"]) {
			
			[[UserCredentials sharedManager] setFirstName:[Dict valueForKey:strkey]];
			
		}
		else if([strkey isEqualToString:@"LastName"]) {
			
			[[UserCredentials sharedManager] setLastName:[Dict valueForKey:strkey]];
			
		}
		else if([strkey isEqualToString:@"idUser"]) {
			
			[[UserCredentials sharedManager] setUserID:[Dict valueForKey:strkey]];
			
		}
		else if([strkey isEqualToString:@"authtoken"]) {
			
			//[[UserCredentials sharedManager] setAuthToken:[Dict valueForKey:strkey]];
			
			[[NSUserDefaults standardUserDefaults]  setValue:[Dict valueForKey:strkey] forKey:kAuthToken];	
			
			NSString *authToken = [[NSUserDefaults standardUserDefaults]  valueForKey:kAuthToken];
			
			NSLog(@"AuthToken : %@",authToken);
			
			NSLog(@"AuthToken : %@",[Dict valueForKey:strkey]);
		}
				
	}
	
	//[[UserCredentials sharedManager] setUserID:txtUsername.text];
	[[NSUserDefaults standardUserDefaults]  setValue:[HelperFunctions trimTxtField:txtUsername.text] forKey:kUserEmailID];
	
	NSString *userMailID = [[NSUserDefaults standardUserDefaults]  valueForKey:kUserEmailID];
	
	NSLog(@"AuthToken : %@",userMailID);
	
	[[UserCredentials sharedManager] setPassword:txtPassword.text];
	
	[[UserCredentials sharedManager] saveUserCredentials];
}


/********checkPreviousUserIdAndCompanyId *******/

// This Method checks the rollid and company id of the last logged in user.
// If the company id of the current user is different from the previous user then we need to clear all the tables (catalog, category, product, content) in the DB.
// If only the Roll id is different and company id same, then we need to clear the product and content table. (because the current Roll id may have permission to view some other products.) 

/********checkPreviousUserIdAndCompanyId *******/

-(void)checkPreviousUserIdAndCompanyId {
	
	NSInteger previousCompanyId = [[NSUserDefaults standardUserDefaults] integerForKey:kPreviousCompanyId];

	NSInteger previousRollId = [[NSUserDefaults standardUserDefaults] integerForKey:kPreviousRollId];
	
	NSLog(@"previousCompanyId = %d",previousCompanyId);
	
	NSLog(@"previousRollid = %d",previousRollId);
	
	if (previousCompanyId != 0 && previousRollId != 0) {
		
		if (previousCompanyId != [[[UserCredentials sharedManager]getCompanyID] intValue]) {
			
			// CompanyId is diffent, so need to clear all tables.
			
			NSLog(@"Cleared catalog, category, product, content Tables");
			
			[[DatabaseManager sharedManager]clearTablesForNewCompany];
			
		}
		
		else if((previousRollId != [[[UserCredentials sharedManager]getRollID] intValue]) && (previousCompanyId == [[[UserCredentials sharedManager]getCompanyID] intValue]) ) {
		
			
			// CompanyId is same but Rollid different, so need to clear product and content tables.
			
			NSLog(@"Cleared product, content Tables");
			
			[[DatabaseManager sharedManager]clearTablesForNewRollid];
			
		}
		
		
	}
	
	// Set previousCompanyId and previousRollId to the current value
	
	[[NSUserDefaults standardUserDefaults] setInteger:[[[UserCredentials sharedManager]getCompanyID] intValue] forKey:kPreviousCompanyId];
	
	[[NSUserDefaults standardUserDefaults] setInteger:[[[UserCredentials sharedManager]getRollID] intValue] forKey:kPreviousRollId];
	
	

	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil]; 
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	
	[backgroundImageView release];
	
	[usernameFieldImage release];
	
	[passwordFieldImage release];
	
	[loginButtonImage release];
			
    [super dealloc];
}


@end
