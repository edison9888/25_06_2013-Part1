//
//  Twitter.m
//  ElDiario
//
//  Created by NaveenShan on 10/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Twitter.h"



@implementation Twitter

@synthesize strTweetContent;
@synthesize parentView;

#pragma mark -

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[self loadTwitterPage:nil];
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -

#pragma mark -
#pragma mark Twitter 

- (void)loadTwitterPage:(id)sender	
{
	
    [m_objTextView setText:strTweetContent];
	m_itextCount=[strTweetContent length];
	[m_lblCount setText:[NSString stringWithFormat:@"%d",(140-m_itextCount)]];
	//[self.view addSubview:m_objTwitterView];	
	
	oAuth = [[OAuth alloc] initWithConsumerKey:OAUTH_CONSUMER_KEY andConsumerSecret:OAUTH_CONSUMER_SECRET];
	[oAuth loadOAuthTwitterContextFromUserDefaults];
	
	[self resetUi];
}

-(IBAction)onStatusButtonClick:(id)sender	{
	
	if(m_btnStatus.selected){
		
		[self logout];
		[m_btnStatus setImage:[UIImage imageWithContentsOfFile:
							   [[NSBundle mainBundle] pathForResource:@"twitter_signin" ofType:@"png"]] 
					 forState:UIControlStateNormal];

	}
	else {
		
		[self login];
		[m_btnStatus setImage:[UIImage imageWithContentsOfFile:
							   [[NSBundle mainBundle] pathForResource:@"twitter_signout" ofType:@"png"]] 
					 forState:UIControlStateSelected];
	}
}


- (void)login {
	
	self.view.alpha=0.9;
	//m_btnStatus.enabled=NO;
	//[self resetUi];
	//[self logout];
	if(loginPopup){
		[loginPopup release];
		loginPopup = nil;
	
	}
   // if (!loginPopup) {
		
        loginPopup = [[TwitterLoginPopup alloc] initWithNibName:@"TwitterLoginPopup" bundle:nil];        
        loginPopup.oAuth = oAuth;
        loginPopup.delegate = self;
        loginPopup.uiDelegate = nil;
		
		ShareView *dialog=[[ShareView alloc] initWithFrame:([UIScreen mainScreen].applicationFrame) 
												 ShareType:twitter
												andSubView:loginPopup.webView];
		
		[loginPopup setParentViewController:dialog];
    
		[loginPopup getPin:nil];
	[dialog load];

		
   // }
	}

- (void)logout {
	
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc]init];
	NSString *url=[NSString
				   stringWithFormat:@"https://api.twitter.com/oauth/authenticate?oauth_token=%@&force_login=true",
				   oAuth.oauth_token];
    [request addRequestHeader:@"Authorization"
                        value:[oAuth oAuthHeaderForMethod:@"POST"
                                                   andUrl:url 
                                                andParams:nil]];
	
	
    [request startSynchronous];
	[request release];
    [oAuth forget];
    [oAuth saveOAuthTwitterContextToUserDefaults];
    [self resetUi];
}


-(IBAction)postTweet:(id)sender	{
	
    
	// We assume that the user is authenticated by this point and we have a valid OAuth context,
    // thus no need to do context checking.
    m_objTextView.text=@"http://www.google.com";
	m_objActionSheet=[[UIActionSheet alloc]initWithTitle:@"Posting the Tweet" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	[m_objActionSheet showInView:self.view];
	
	
    NSString *postUrl = @"https://api.twitter.com/1/statuses/update.json";
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]
                                   initWithURL:[NSURL URLWithString:postUrl]];
    [request setPostValue:m_objTextView.text forKey:@"status"];
    [request addRequestHeader:@"Authorization"
                        value:[oAuth oAuthHeaderForMethod:@"POST"
                                                   andUrl:postUrl
                                                andParams:[NSDictionary dictionaryWithObject:m_objTextView.text
                                                    forKey:@"status"]]];
    
    [request startSynchronous];
    
	// NSLog(@"Status posted. HTTP result code: %d", request.responseStatusCode);
    
    
	if(request.responseStatusCode==401) {
		
		[m_objActionSheet dismissWithClickedButtonIndex:0 animated:YES];
		[self showAlert:@"User not signed in" delegateObject:nil];
	}
	else if(request.responseStatusCode>=500) {
		
		[m_objActionSheet dismissWithClickedButtonIndex:0 animated:YES];
		[self showAlert:@"Service Unavailable :  Try again later." delegateObject:nil];
	}
    else if(request.responseStatusCode==0)
    {
        if(![NetworkCheck isServerAvailable])
        {
        [m_objActionSheet dismissWithClickedButtonIndex:0 animated:YES];
		[m_objActionSheet release];
        [self showAlert:@"No internet connection" delegateObject:nil];
       // [parentView cancel];
        }
 
    }
	else {
		
		[m_objActionSheet dismissWithClickedButtonIndex:0 animated:YES];
		[m_objActionSheet release];
		[m_objTextView setText:@""];
		
		/*
		if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(dismissPopover)])
			[self.delegate dismissPopover];
		*/
		[self showAlert:@"Tweet posted." delegateObject:nil];
		
		[parentView cancel];
	}
    
    [request release];
    
    [m_objTextView resignFirstResponder];
}

-(void)resetUi	{
	
	if (oAuth.oauth_token_authorized) {
		
		[m_lblScreenName setText:oAuth.screen_name];
		[m_btnStatus setSelected:YES];
		[m_btnStatus setImage:[UIImage imageWithContentsOfFile:
							   [[NSBundle mainBundle] pathForResource:@"twitter_signout" ofType:@"png"]] 
					 forState:UIControlStateSelected];
	}
	else {
		
		[m_lblScreenName setText:@"Not Logged In"];
		[m_btnStatus setSelected:NO];
	}
}

#pragma mark -
#pragma mark TwitterLoginPopupDelegate

- (void)twitterLoginPopupDidCancel:(TwitterLoginPopup *)popup {
	
    [loginPopup release]; loginPopup = nil; // was retained as ivar in "login"
}

- (void)twitterLoginPopupDidAuthorize:(TwitterLoginPopup *)popup {
	
	self.view.alpha=1.0;
	m_btnStatus.enabled=YES;      
    //[loginPopup release]; loginPopup = nil; // was retained as ivar in "login"
    [oAuth saveOAuthTwitterContextToUserDefaults];
    [self resetUi];
}

#pragma mark -
#pragma mark AlertView

-(void)showAlert:(NSString *)strAlertMessage delegateObject:(id)Delegate {
	
	UIAlertView *objAlert=[[UIAlertView alloc] initWithTitle:@"The Daily Meal" 
										message:strAlertMessage 
									   delegate:Delegate 
							  cancelButtonTitle:nil
							  otherButtonTitles:@"OK",nil];
	[objAlert show];
	[objAlert release];
	objAlert = nil;
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
    
    if (oAuth) {
        [oAuth release];
        oAuth = nil;
    }
    
    
    [super dealloc];
}


@end
