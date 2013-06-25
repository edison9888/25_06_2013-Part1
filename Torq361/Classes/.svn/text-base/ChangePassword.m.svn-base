    //
//  ChangePassword.m
//  Torq361
//
//  Created by Nithin George on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChangePassword.h"
#import "ConnectivityCheck.h"
#import "Constants.h"
#import "HelperFunctions.h"
#import "UserCredentials.h"
#import "Base64Converter.h"
#import "Torq361AppDelegate.h"
#import "NavigationView.h"

@implementation ChangePassword

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


- (void)viewDidLoad {
	
	@try {
		
		[super viewDidLoad];
		
		scrollView.contentSize = CGSizeMake(540,620);
		
		activityIndicator.hidden = YES;
		connectingLabel.hidden = YES;
		statusLalel.hidden = YES;
		
		//close button
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(0, 0, 30, 30);
		[button setBackgroundImage:[UIImage imageNamed:@"CloseHomeButton.png"] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
		self.navigationItem.rightBarButtonItem = item;
        
		//Code for adding the custom view to the navigationtittle view
		UIImage *myImage = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"ChangePassTittle" ofType:@"png"]];
		NSString *tittleName = @"Change Password";
		NavigationView *navigationView = [[NavigationView alloc]init]; 
		navigationView.frame =CGRectMake(0 , 0, 202, 40);
		navigationView.backgroundColor=[UIColor clearColor];
		
		navigationView.image = myImage;
		
		navigationView.tittle = tittleName;
		
		self.navigationItem.titleView = navigationView;
		
		[navigationView release];
		navigationView = nil;
        
        [myImage release];
		 myImage = nil;

		
		UIImage *image;
		
		
		image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"login_textbox" ofType:@"png"]];
		//userNameImageView.image = image;
		oldPasswordImageView.image = image;
		newPasswordImageView.image = image;
		conformPasswordImageView.image = image;
		[image release];
		image=nil;
		
		image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"login_here" ofType:@"png"]];
		backgroundImageView.image = image;
		[image release];
		image=nil;
        
		
	}
	
	@catch (NSException * e) {
		
		
	}
	
	@finally {
		
	}	
	
}


#pragma mark -
#pragma mark TextBox Delegates

-(void) textFieldDidBeginEditing:(UITextField *)textField {
	
}


#pragma mark -


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}



#pragma mark -
#pragma mark Button Clicked


- (IBAction)closeButtonClicked:(id)sender {
	
	//[self dismissModalViewControllerAnimated:YES];
    [[self navigationController] dismissModalViewControllerAnimated:YES];
	//[[self navigationController] popViewControllerAnimated:YES];
	
}


- (IBAction)submitButtonClicked:(id)sender {
	
	//[[[NSUserDefaults standardUserDefaults] valueForKey:kUserCredentials] ];
	//[NSKeyedUnarchiver unarchiveObjectWithData:userData];
	
	
	
	NSLog(@"FristName : %@",[[UserCredentials sharedManager]getFirstName]);
	
	NSLog(@"AuthToken111 : %@",[[UserCredentials sharedManager]getPassword]);
	
	
	@try {
		statusLalel.text=@"";
		activityIndicator.hidden = NO;
		connectingLabel.hidden = NO;
        
        NSString *oldPwd=[HelperFunctions trimTxtField:txtOldPassword.text];
        NSString *newPwd=[HelperFunctions trimTxtField:txtNewPassword.text];
        NSString *confirmPwd=[HelperFunctions trimTxtField:txtConformPassword.text];
        
        if(oldPwd==nil || [oldPwd isEqualToString: @""]){
            activityIndicator.hidden = YES;
            connectingLabel.hidden = YES;
            statusLalel.hidden = NO;
            
            statusLalel.text=@"Please enter Current Password";
            txtOldPassword.text=@"";
            [txtOldPassword becomeFirstResponder];
            return;
        }
        if(newPwd==nil || [newPwd isEqualToString: @""]){
            [txtNewPassword becomeFirstResponder];
            activityIndicator.hidden = YES;
            connectingLabel.hidden = YES;
            statusLalel.hidden = NO;
            
            statusLalel.text=@"Please enter New Password";
            txtNewPassword.text=@"";
            return;
        }
        if(confirmPwd==nil || [confirmPwd isEqualToString: @""]){
            [txtConformPassword becomeFirstResponder];
            activityIndicator.hidden = YES;
            connectingLabel.hidden = YES;
            statusLalel.hidden = NO;
            
            statusLalel.text=@"Please Re-type New Password";
            
            txtConformPassword.text=@"";
            
            return;
        }
		[txtConformPassword resignFirstResponder];
        [txtOldPassword resignFirstResponder];
        [txtNewPassword resignFirstResponder];
		//checking with the old password
		if ([[[UserCredentials sharedManager]getPassword] isEqualToString:[HelperFunctions trimTxtField:txtOldPassword.text]]) {
			
			if ( [[HelperFunctions trimTxtField:txtNewPassword.text] isEqualToString:[HelperFunctions trimTxtField:txtConformPassword.text] ]) {
                
                
                
                
				
				ConnectivityCheck *connectivityCheck=[[ConnectivityCheck alloc] init];
				
				if([connectivityCheck isHostReachable]){
					
					NSString *encodedPassword=[Base64Converter encode:[[HelperFunctions trimTxtField:txtOldPassword.text] dataUsingEncoding:NSASCIIStringEncoding]];
					NSString *encodedNewPassword=[Base64Converter encode:[[HelperFunctions trimTxtField:txtNewPassword.text] dataUsingEncoding:NSASCIIStringEncoding]];
					
					//store authtoken in nsuserdefault
					
					
					NSString *userName = [[NSUserDefaults standardUserDefaults]  valueForKey:kUserEmailID];
					
					NSLog(@"User Name=========%@",userName);
					
					NSString *authToken = [[NSUserDefaults standardUserDefaults]  valueForKey:kAuthToken];
					NSLog(@"AuthToken : %@",authToken);
					
					NSMutableDictionary *dataDict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:
												   userName,@"username",
												   encodedPassword,@"oldpassword",encodedNewPassword ,@"newpassword",
												   authToken,@"authtoken",nil];	
					
					JsonParser *jsonParser=[[JsonParser alloc]init];
					
					jsonParser.delegate=self;
					
					NSString *str=[NSString stringWithFormat:@"%@/sync/changePassword",CMSLink];
					
					NSLog(@"URL : %@",str);
					
					[jsonParser parseJSONResponseofAPI:str JSONRequest:dataDict];
					
					[dataDict release];
					dataDict = nil;
					
					[jsonParser release];
					jsonParser = nil;
					
				}
				
				else {
					
					statusLalel.text=@"No Connectivity.";
					
				}
				
				[connectivityCheck release];
				
				
				
			}
			
			else {
				
				statusLalel.text = @"New Password is Mismatching.";
                
				
				[self clearValue];
                [txtNewPassword becomeFirstResponder ];
			
			}
			
			
		}
		
		else {
	
			statusLalel.text = @"Current Password is incorrect.";
			
			[self clearValue];
			[txtOldPassword becomeFirstResponder];
		}
		
	}
	
	@catch (NSException * e) {
		
		
	}
	
	@finally {
		
		
	}
	
	
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSRange textRange;
    textRange =[string rangeOfString:@" "];
    
    if(textRange.location != NSNotFound)
    {
        
        return NO;
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

#pragma mark -
#pragma mark alertView Delegates


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 0)
	{
		[[self navigationController] popViewControllerAnimated:YES];
	}
	else
	{
		NSLog(@"cancel");
	}
}


- (void)clearValue {
	activityIndicator.hidden = YES;
	connectingLabel.hidden = YES;
	statusLalel.hidden = NO;

	txtOldPassword.text = @"";
	txtNewPassword.text = @"";
	txtConformPassword.text = @"";
	
}



#pragma mark -
#pragma mark JsonParser Delegate Methods

-(void)didfinishedparsing:(JsonParser *)objJsonParser{
	
	
	Torq361AppDelegate *appDelegate = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
	
	NSMutableDictionary *resultDict = objJsonParser.objResult;
	
	//NSString *strLoginStatus;
	
	NSString *strLoginStatus= [resultDict valueForKey:@"status"];
	
	activityIndicator.hidden = YES;
	
	connectingLabel.hidden = YES;
	
	statusLalel.hidden = NO;
	
	
	
	if ([strLoginStatus isEqualToString:@"Success"]) {
		
		//statusLalel.text=@"success.";
		
		UIAlertView *alt = [[UIAlertView alloc] initWithTitle: @"New Password" message: @"Your Password is succesfully changed" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		[alt show];
		
		[alt release];
		
        [self clearValue];
	}
	
	else if([strLoginStatus intValue]==607) { 
		
		statusLalel.text=@"Your Registration request is pending for approval from Administrator.";
        [self clearValue];
	}
	
	
	else {
		
		NSString *strLoginStatus= [resultDict valueForKey:@"message"];
		
		statusLalel.text=strLoginStatus;
	  
		NSLog(@"Fail Message=========%@",strLoginStatus);
		
		/*	if ([strLoginStatus isEqualToString:@"License Expired"]) {
			
			statusLalel.text=@"Your License Expired Please Contact Administrator.";
		}
		
		else {
			
			statusLalel.text=@"Username you entered is incorrect.";
		}
		*/
        [self clearValue];
	}
	
}

-(void)didfailedwitherror:(JsonParser *)objJsonParser{
    statusLalel.text=@"Error occured while processing request. Please try later...";
}



#pragma mark -
#pragma mark Memory


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
    [super dealloc];
    
    [backgroundImageView release];
    backgroundImageView = nil;
    
    [scrollView release];
    scrollView = nil;
    
    [oldPasswordImageView release];
    oldPasswordImageView = nil;
    
    [newPasswordImageView release];
    newPasswordImageView = nil;  
    
    [conformPasswordImageView release];
    conformPasswordImageView = nil;
    
    [txtOldPassword release];
    txtOldPassword = nil;
    
    [txtNewPassword release];
    txtNewPassword = nil;
    
    [txtConformPassword release];
    txtConformPassword = nil;
    
    [activityIndicator release];
    activityIndicator = nil;
    
    [connectingLabel release];
    connectingLabel = nil;
    
    [statusLalel release];
    statusLalel = nil;
    
}


@end
