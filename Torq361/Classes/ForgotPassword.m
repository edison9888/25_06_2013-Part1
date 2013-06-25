    //
//  ForgotPassword.m
//  Torq361
//
//  Created by Nithin George on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ForgotPassword.h"
#import "ConnectivityCheck.h"
#import "Constants.h"
#import "HelperFunctions.h"
#import "Torq361AppDelegate.h"
#import "UserCredentials.h"


@implementation ForgotPassword

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}


- (void)viewDidLoad {
	
    [super viewDidLoad];
	[txtUserName becomeFirstResponder];
	
	activityIndicator.hidden = YES;
	connectingLabel.hidden = YES;
	status.hidden = YES;

	//set navigation bar title
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
	//label.font = [UIFont boldSystemFontOfSize:14.0];
	//label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	[label setFont:[UIFont fontWithName:@"Arial" size:22]];
	self.navigationItem.titleView = label;
	label.text = @"Forgot your password";
	[label release];
	
	
	UIImage *image;
	
	image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"login_textbox" ofType:@"png"]];
	userNameImageView.image = image;
	[image release];
	image=nil;
	
	image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"login_here" ofType:@"png"]];
	backGroundImageView.image = image;
	[image release];
	image=nil;
	
}


#pragma mark -
#pragma mark Button Clicked


- (IBAction)submitButtonClicked:(id)sender {
	
    status.text=@"";
    
    NSString *userName=[HelperFunctions trimTxtField:txtUserName.text];
    if(userName==nil || [userName isEqualToString: @""]){
        activityIndicator.hidden = YES;
        connectingLabel.hidden = YES;
        status.hidden = NO;
        
        status.text=@"Please enter User Name";
        return;
    }
	
	activityIndicator.hidden = NO;
	connectingLabel.hidden = NO;
	
	[txtUserName resignFirstResponder];
	//JSON Parsing
	
	ConnectivityCheck *connectivityCheck=[[ConnectivityCheck alloc] init];
	
	if([connectivityCheck isHostReachable]){
		
		NSMutableDictionary *dataDict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[HelperFunctions trimTxtField:txtUserName.text],@"username",nil];	
		
		JsonParser *jsonParser=[[JsonParser alloc]init];
		
		jsonParser.delegate=self;
		
		NSString *str=[NSString stringWithFormat:@"%@/sync/forgotPassword",CMSLink];
		
		[jsonParser parseJSONResponseofAPI:str JSONRequest:dataDict];
		
		[dataDict release];
		
		dataDict = nil;
		
		[jsonParser release];
		
		jsonParser = nil;
		
		}
 
	else {
		status.text=@"No Connectivity.";
	}
	
	[connectivityCheck release];
}
	



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
	

#pragma mark -
#pragma mark JsonParser Delegate Methods

-(void)didfinishedparsing:(JsonParser *)objJsonParser{

	
	Torq361AppDelegate *appDelegate = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
	
	NSMutableDictionary *resultDict = objJsonParser.objResult;
	
	//NSString *strLoginStatus;
	
	NSString *strLoginStatus= [resultDict valueForKey:@"status"];
	
	activityIndicator.hidden = YES;
	
	connectingLabel.hidden = YES;
	
	status.hidden = NO;

	
	
	if ([strLoginStatus isEqualToString:@"success"]) {
		
		//status.text=@"success.";
		
		UIAlertView *alt = [[UIAlertView alloc] initWithTitle: @"New Password" message: @"Successfully changed your password. Please check your mail" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
	 
		[alt show];
	 
		[alt release];
		txtUserName.text=@"";
	}
	
	else if([strLoginStatus intValue]==607) { 
		
		status.text=@"Your Registration request is pending for approval from Administrator.";
        txtUserName.text=@"";
	}
		
	
	else {
		
		NSString *strLoginStatus= [resultDict valueForKey:@"message"];
		
		if ([strLoginStatus isEqualToString:@"License Expired"]) {
			
			status.text=@"Your License Expired Please Contact Administrator.";
            txtUserName.text=@"";
		}
		
		else {
			
			status.text=@"User Name you entered is incorrect.";
            txtUserName.text=@"";
            [txtUserName becomeFirstResponder];
		}

	}

}

-(void)didfailedwitherror:(JsonParser *)objJsonParser{
	
	
	
}


#pragma mark -
#pragma mark Touch Delegates


-(void) touchesBegan :(NSSet *) touches withEvent:(UIEvent *)event
{
	
		[txtUserName resignFirstResponder];
	
	//for closing the iphone key board while clicking outside the textboxes
	//[super touchesBegan:touches withEvent:event];
}


#pragma mark -


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


#pragma mark -



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
}


@end
