    //
//  UserSetting.m
//  Torq361
//
//  Created by Nithin George on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserSetting.h"
#import "ChangePassword.h"
#import "ChangeProfile.h"
#import "NavigationView.h"
#import "DatabaseManager.h"
#import "Torq361AppDelegate.h"
#import "UserCredentials.h"

@implementation UserSetting

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
		
		//UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"close.png"] style:UIBarButtonItemStylePlain  target:self action:@selector(closeButtonClicked:)];
	
		//self.navigationItem.rightBarButtonItem =closeButton;
		//[closeButton release];
        
        [self checkSocialNetworkLoginStatus ];
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(0, 0, 30, 30);
		[button setBackgroundImage:[UIImage imageNamed:@"CloseHomeButton.png"] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
		self.navigationItem.rightBarButtonItem = item;
			
		
		//Code for adding the custom view to the navigationtittle view
		UIImage *myImage = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"UserSetting" ofType:@"png"]];
		NSString *tittleName = @"Settings";
		NavigationView *navigationView = [[NavigationView alloc]init]; 
		navigationView.frame =CGRectMake(0 , 0, 202, 40);
		navigationView.backgroundColor=[UIColor clearColor];
		
		navigationView.image = myImage;
		
		navigationView.tittle = tittleName;
		
		self.navigationItem.titleView = navigationView;
        
        [myImage release];
		 myImage=nil;
		
		[navigationView release];
		navigationView = nil;
						
		
		
		
	/*	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
		//label.font = [UIFont boldSystemFontOfSize:14.0];
		//label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		label.textColor = [UIColor whiteColor];
		[label setFont:[UIFont fontWithName:@"Arial" size:22]];
		self.navigationItem.titleView = label;
		label.text = @" User Setting";
		[label release];
	*/	
		UIImage *image;
		
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
#pragma mark Button Clicked


- (IBAction)closeButtonClicked:(id)sender {
	
	//[self dismissModalViewControllerAnimated:YES];
    
   [[self navigationController] dismissModalViewControllerAnimated:YES];
	//[[self navigationController] popViewControllerAnimated:YES];

	
}

- (IBAction)changePasswordButtonClicked:(id)sender {
	
	@try {
		
		ChangePassword *changePassword = [[ChangePassword alloc] initWithNibName:@"ChangePassword" bundle:nil];
		
		[[self navigationController] pushViewController:changePassword animated:YES];
		
		[changePassword release];
        changePassword = nil;
		
		
	}
	
	@catch (NSException * e) {
		
		
	}
	
	@finally {
		
		
	}
	
}

- (IBAction)resetContentButtonClicked:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Torq361" message:@"This action will clear all your data from database and will start automatic syncing. Do you want to continue?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
    [alert show];
    [alert release];
    alert=nil;
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        
        [[DatabaseManager sharedManager] resetDatabase];
        
        NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
        Torq361AppDelegate *appDelegate = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate deleteteFolderStructureInDocumentDirectory:companyid];
        
        [[self navigationController] dismissModalViewControllerAnimated:YES];
        NSLog(@"Resyncing Started...");
        
        [self performSelector: @selector(restartSyncing) withObject:self afterDelay:1];
    }else{
        NSLog(@"User cancelled syncing...");
    }
}
-(void)restartSyncing{
    Torq361AppDelegate *appDelegate = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.home syncDB:NO];
    
}

-(void)checkSocialNetworkLoginStatus{
    BOOL bFacebook=NO,bTwitter=NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *fbUserName=[defaults valueForKey:@"FBUserId"];
    NSString *twitterAccess=[SHK getAuthValueForKey:@"accessKey" forSharer:SHKTwitterClass];
    
    if(fbUserName!=nil){
        bFacebook=YES;
    }
    if(twitterAccess!=nil){
        bTwitter=YES;
    }
    facebookButton.enabled=bFacebook;
    twitterButton.enabled=bTwitter;
    
    if(!bFacebook){
        [facebookButton setTitle:@"Facebook : Not Authenticated" forState:UIControlStateNormal];
    }
    
    if(!bTwitter){
        [twitterButton setTitle:@"Twitter : Not Authenticated" forState:UIControlStateNormal];
    }
}
-(IBAction)logoutFromFacebookButtonClicked:(id)sender{
    [SHK logoutOfService:SHKFacebookClass];
    [self checkSocialNetworkLoginStatus];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Torq361" message:@"You have succesfully logged Out from facebook!!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
    [alert release];
    alert=nil;
}
-(IBAction)logoutFromTwitterButtonClicked:(id)sender{
    [SHK logoutOfService:SHKTwitterClass];
    [self checkSocialNetworkLoginStatus];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Torq361" message:@"You have succesfully logged Out from twitter!!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
    [alert release];
    alert=nil;

}
/*
- (IBAction)changeProfileButtonClicked:(id)sender {
	
	@try {
		
		ChangeProfile *changeProfile = [[ChangeProfile alloc] initWithNibName:@"ChangeProfile" bundle:nil];
		
		changeProfile.view.frame = CGRectMake( 270, 310, 540, 620);
		
		[[self navigationController] pushViewController:changeProfile animated:YES];
		
		[changeProfile release];
	}
	
	@catch (NSException * e) {
		
		
	}
	
	@finally {
		
		
	}
	
}

*/

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
    
    [backgroundImageView release];
    backgroundImageView = nil;
    
    [changePasswordButton release];
    changePasswordButton = nil;
}


@end
