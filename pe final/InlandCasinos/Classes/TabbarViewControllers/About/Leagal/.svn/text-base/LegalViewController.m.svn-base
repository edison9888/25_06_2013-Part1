//
//  LegalViewController.m
//  InlandCasinos
//
//  Created by Nithin George on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LegalViewController.h"


@implementation LegalViewController

@synthesize viewIdentifier;

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
    //0 for Inland Casinos, 1 for Developed By, 2 for legal
    switch (viewIdentifier) {
        case 0://inland casino
           // dataDisplay.text = ABOUT_INLAND_CASINOS;
            self.navigationItem.title = ABOUT_SECSSION1_ROW0_TEXT;
            [self loadHtml:@"AboutUs_InlandCasinos"];
            break;
        case 1:
            self.navigationItem.title = ABOUT_SECSSION1_ROW1_TEXT;
            [self loadHtml:@"AboutUs_RapidValue"];
            break;
        case 2:
           // dataDisplay.text = ABOUT_TEXT;
            self.navigationItem.title = ABOUT_SECSSION2_ROW0_TEXT;
            [self loadHtml:@"AboutUs_Legal"];
            break;
    }
    
}

- (void)loadHtml:(NSString *)htmlPath
{

   [dataDisplay loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:htmlPath ofType:@"html"]isDirectory:NO]]];
    
    
}

#pragma mark -webview delegates

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)urlrequest navigationType:(UIWebViewNavigationType)navigationType{
   
    NSURL *objURL=[urlrequest URL];
	NSString *strURL=[objURL absoluteString];
 
    //CAPTURE USER LINK-CLICK.
	if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        
        if ([strURL rangeOfString:@"mailto"].location != NSNotFound) 
        {
            [self.view addSubview:indicatorView];
            [self seetingMailBodyComponents:SETTING_MAIL2_TO_ADDRESS:SETTING_MAIL2_SUBJECT:SETTING_MAIL2_BODY];
        } 
        else if ([strURL rangeOfString:@"www.inlandsocal.com"].location != NSNotFound)
        {
            [self.view addSubview:indicatorView];
        }
        else if ([strURL rangeOfString:@"http://www.rapidvaluesolutions.com/"].location != NSNotFound)
        {
            [self.view addSubview:indicatorView];
        }

    }
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	
    [indicatorView removeFromSuperview];
}


#pragma mark - mail composer
- (void)seetingMailBodyComponents:(NSString *)toAddress:(NSString *)subject:(NSString *)body {
    NSArray *toRecipients;
    MFMailComposeViewController *mailController ;
    if ([MFMailComposeViewController  canSendMail]) {
        mailController = [[[MFMailComposeViewController alloc] init] autorelease];
        if(mailController )
            toRecipients = [NSArray arrayWithObjects:toAddress, nil]; 
        [mailController setToRecipients:toRecipients];
        [mailController setSubject:subject];
        [mailController setMessageBody:body isHTML:false];
        mailController.mailComposeDelegate = self;
        [self  presentModalViewController:mailController animated:true];
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                              
                                                        message:@"Kindly configure your system mail"
                              
                                                       delegate:self
                              
                                              cancelButtonTitle:@"OK"
                              
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [indicatorView removeFromSuperview];
}



-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EMailsendung fehlgeschlagen!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [controller dismissModalViewControllerAnimated:true];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    dataDisplay.delegate = nil;
    [super dealloc];

    dataDisplay = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
