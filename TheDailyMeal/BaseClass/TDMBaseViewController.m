//
//  TDMBaseViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/4/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMBaseViewController.h"

#import "TDMAccountsViewController.h"
#import "TDMRestaurantReviewList.h"
//#import "TDMCoreDataManager.h"
//#import "TDMSyncManager.h"
//#import "TDMReviewRestaurant.h"
//#import "TDMRestaurantReviewList.h"
#import "DisplayMap.h"


#define ADD_DISH_URL @"http://www.thedailymeal.com/rest/app/tdm_node"
//#define ADD_DISH_URL @"http://192.168.1.207:8080/TDMWebService/add.json"

#define kNAV_BAR_BUTTON_FRAME CGRectMake(0,0,60,35)
#define kNAVIGATION_LABEL_TAG 999
//login
#define USER_NAME_TAG       @"username"
#define USER_PASSWORD_TAG   @"password"

@interface TDMBaseViewController()

@property (nonatomic,retain) JSONHandler *json;
//private
- (void)initiateJSON;

@end

@implementation TDMBaseViewController

@synthesize json;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark  - ViewCreations
- (void)createAccountButtonOnNavBar {
    
    UIButton *accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    accountButton.frame = CGRectMake(0, 0, 70, 35);
//    accountButton.titleLabel.font= kGET_BOLD_FONT_WITH_SIZE(14);  
//    accountButton.titleLabel.shadowColor = [UIColor lightGrayColor];
//    accountButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
//    accountButton.titleLabel.textColor = [UIColor whiteColor];
//    [accountButton setTitle:kNAVBAR_TITLE_MY_SETTINGS forState:UIControlStateNormal];
    [accountButton setBackgroundImage:[UIImage imageNamed:ACCOUND_BUTTON_IMAGE] forState:UIControlStateNormal];
    [accountButton addTarget:self action:@selector(accountBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *accountBarButton = [[UIBarButtonItem alloc] initWithCustomView:accountButton];
    self.navigationItem.rightBarButtonItem = accountBarButton;
    REMOVE_FROM_MEMORY(accountBarButton);    
}

- (void)createRefreshButtonOnNavBarForViewController {
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake(0, 0, 32, 29);
    //refreshButton.frame = CGRectMake(0, 0, 64,59);

    refreshButton.titleLabel.font= kGET_REGULAR_FONT_WITH_SIZE(14);  
    refreshButton.titleLabel.shadowColor = [UIColor lightGrayColor];
    refreshButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    refreshButton.titleLabel.textColor = [UIColor whiteColor];
   
    [refreshButton setBackgroundImage:[UIImage imageNamed:@"refresh_btn"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.leftBarButtonItem = refreshBarButton;
//    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshBarButtonClicked)];
//   // [refreshBarButton setTintColor:[UIColor colorWithRed:.742 green:.70 blue:.664 alpha:1]];
//    [refreshBarButton setBackgroundImage:[UIImage imageNamed:ACCOUND_BUTTON_IMAGE] forState:UIControlStateNormal barMetrics:<#(UIBarMetrics)#>
//    self.navigationItem.leftBarButtonItem = refreshBarButton;
//    REMOVE_FROM_MEMORY(refreshBarButton);    
}


- (void)createReviewListButtonOnNavBar {
    
    UIButton *reviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reviewButton.frame = CGRectMake(0, 0, 90, 30);
    reviewButton.titleLabel.font= kGET_BOLD_FONT_WITH_SIZE(14);  
    reviewButton.titleLabel.textColor = [UIColor whiteColor];
    [reviewButton setTitle:kNAVBAR_TITLE_MY_REVIEW forState:UIControlStateNormal];
    [reviewButton setBackgroundImage:[UIImage imageNamed:@"accountButtonImage"] forState:UIControlStateNormal];
    [reviewButton addTarget:self action:@selector(reviewBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *reviewBarButton = [[UIBarButtonItem alloc] initWithCustomView:reviewButton];
    self.navigationItem.rightBarButtonItem = reviewBarButton;
    REMOVE_FROM_MEMORY(reviewBarButton);    
}

-(void) createAdView
{
//    UIWebView *adWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 22, 320, 50)];
//    [adWebView scalesPageToFit];
//    [adWebView loadHTMLString:@" <body leftmargin=\"0\" rightmargin=\"0\" topmargin=\"0\" bottommargin=\"0\">\
//     <img id=\"Image-Maps_1\" src=\"adImage.png\" />\
//     </body>" baseURL:[[NSBundle mainBundle] bundleURL]]; 
//    [self.view addSubview:adWebView];
    
    
    
    UIWebView *adWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 22, 320, 50)];
    
    NSString *baseHtml = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"adHTML" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
    
    [adWebView scalesPageToFit];
   // NSLog(@"%f",[[UIDevice currentDevice].systemVersion floatValue]);
    if ([[UIDevice currentDevice].systemVersion floatValue] > 4.4)
    {
        adWebView.scrollView.scrollEnabled = NO;
    }   
    [adWebView setDelegate:self];
    
    [adWebView loadHTMLString:baseHtml baseURL:nil]; 
    //adWebView.scrollView.scrollEnabled = NO;
    [self.view addSubview:adWebView];
    [adWebView release];
    adWebView = nil;
    
}

//creates either Home Bar Button or Back Bar Button
- (void)createNavigationBarButtonOfType:(int)aButtonType
{
   
    UIButton *navBarButton= [[UIButton alloc]initWithFrame:kNAV_BAR_BUTTON_FRAME];
    switch (aButtonType) {
        case kBACK_BAR_BUTTON_TYPE:{
            [navBarButton setImage:kNAV_BAR_BACK_IMAGE forState:UIControlStateNormal];
            [navBarButton setImage:kNAV_BAR_BACK_IMAGE forState:UIControlStateSelected];
            navBarButton.tag = kBACK_BAR_BUTTON_TYPE;
            
        }
        break;
        case kHOME_BAR_BUTTON_TYPE:{
            [navBarButton setImage:kNAV_BAR_HOME_IMAGE forState:UIControlStateNormal];
            [navBarButton setImage:kNAV_BAR_HOME_IMAGE forState:UIControlStateSelected];
            navBarButton.tag = kHOME_BAR_BUTTON_TYPE;
        }
        break;
        default:
        break;
    }
    navBarButton.adjustsImageWhenHighlighted = NO;
    [navBarButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [navBarButton addTarget:self action:@selector(navBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *aBarButton = [[UIBarButtonItem alloc]initWithCustomView:navBarButton];
    REMOVE_FROM_MEMORY(navBarButton)
    self.navigationItem.leftBarButtonItem = aBarButton;
    REMOVE_FROM_MEMORY(aBarButton)
}

- (void)disableBackButton:(BOOL)value
{
    self.navigationItem.leftBarButtonItem.enabled = value;
}
- (void)hideTabbar{
        self.tabBarController.tabBar.hidden = YES;    
}

- (void)showTabbar
{
    self.tabBarController.tabBar.hidden = NO;
}

//this will create the Customised navigation title

- (void)createCustomisedNavigationTitleWithString:(NSString *)titleString
{
    UILabel *tempLabel = (UILabel *)[self.navigationItem.titleView viewWithTag:kNAVIGATION_LABEL_TAG];
    if (tempLabel) {
        [tempLabel removeFromSuperview];
        tempLabel = nil;
    }
    CGRect myrect = self.navigationController.navigationBar.frame;
    CGPoint mypoint = CGPointMake(myrect.origin.x + (myrect.size.width / 2), myrect.origin.y + (myrect.size.height / 2));
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(mypoint.x, mypoint.y, 150,44 )];
    navLabel.text = titleString;
    navLabel.textColor = [UIColor whiteColor];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.textAlignment  = UITextAlignmentCenter;
    navLabel.adjustsFontSizeToFitWidth = YES;
    navLabel.tag = kNAVIGATION_LABEL_TAG;
    navLabel.font = kGET_BOLD_FONT_WITH_SIZE(21.0f);
    self.navigationItem.titleView = navLabel;
    REMOVE_FROM_MEMORY(navLabel)
}


#pragma mark  - Button Actions

-(void) refreshBarButtonClicked
{
     
}

//click on the account Button
- (void)accountBarButtonClicked:(id)sender{
    
    TDMAccountsViewController *accountsViewController = [[TDMAccountsViewController alloc] initWithNibName:@"TDMAccountsViewController" bundle:nil];
    [self.navigationController pushViewController:accountsViewController animated:YES];
    [accountsViewController release];
    accountsViewController = nil;

}


//click on the navigationBar
- (void)navBarButtonClicked:(id)sender{
    
    UIButton *aButton = (UIButton *)sender;
    switch (aButton.tag) {
        case kBACK_BAR_BUTTON_TYPE:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case kHOME_BAR_BUTTON_TYPE:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
    
}

#pragma mark    -
#pragma mark    UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [request.URL absoluteString];
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSURL *url = [NSURL URLWithString:urlString];
        
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView   {

    [webView stringByEvaluatingJavaScriptFromString:@"writeImage()"];
    [webView stringByEvaluatingJavaScriptFromString:@"setSize()"];
}

#pragma mark - Channel Parsing

- (void)parseChannelsContents
{

   int index = [[NSUserDefaults standardUserDefaults]  integerForKey:SELECTED_CHANNEL_CATEGORY_ID_KEY];
    NSString *XMLPath = [kARRAY_OF_CHANNEL_CATEGORY_XML_LINKS objectAtIndex:index];

    XMLParser *parseObj = [[XMLParser alloc] init];
    
    NSString *xmlFilePath=XMLPath;
    parseObj.myDelegate=self;
    [parseObj parseXMLFileAtURL:xmlFilePath];
    REMOVE_FROM_MEMORY(parseObj);
}

#pragma mark - XML Parser Delegates

-(void)didFinished:(NSMutableArray *)channels{
    

}

-(void) didFailedWithError{
    
}

#pragma mark - Helpers
//this will take the class and alloc it accordingly
- (UIViewController *)getClass:(NSString *)aClassName
{
    Class appClass = NSClassFromString(aClassName);
    UIViewController *classViewController = [[[appClass alloc] initWithNibName:aClassName bundle:nil] autorelease];
    return classViewController;
}

#pragma mark - Added By Bittu for JSON
//this will initiate the JSON Class
- (void)initiateJSON{
    if (self.json) {
        self.json.delegate = nil;
        self.json=nil;
    }
    JSONHandler *tempJson = [[JSONHandler alloc]init];
    self.json = tempJson;
    [tempJson release];
    tempJson = nil;
    self.json.delegate = self;
}

//this will send the request for Add dish
- (void)sendRequestToAddDishWithDictionary:(NSMutableDictionary *)dict{
    [self initiateJSON];
    [self.json sendJSONRequest:dict RequestUrl:ADD_DISH_URL];
}

@end
