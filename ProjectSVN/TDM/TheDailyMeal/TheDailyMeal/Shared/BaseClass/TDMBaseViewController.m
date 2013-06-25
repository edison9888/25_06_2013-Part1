//
//  TDMBaseViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/4/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMBaseViewController.h"
#import "TDMAccountsViewController.h"
#import "TDMCoreDataManager.h"
#import "TDMSyncManager.h"
#import "TDMReviewRestaurant.h"

#define kNAV_BAR_BUTTON_FRAME CGRectMake(0,0,50,44)
#define kNAVIGATION_LABEL_TAG 999
//login
#define USER_NAME_TAG       @"username"
#define USER_PASSWORD_TAG   @"password"

@interface TDMBaseViewController()
//private

@end
@implementation TDMBaseViewController
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
    accountButton.frame = CGRectMake(0, 0, 80, 30);
    accountButton.titleLabel.font= kGET_BOLD_FONT_WITH_SIZE(14);  
    accountButton.titleLabel.textColor = [UIColor whiteColor];
    [accountButton setTitle:kNAVBAR_TITLE_MY_SETTINGS forState:UIControlStateNormal];
    [accountButton setBackgroundImage:[UIImage imageNamed:ACCOUND_BUTTON_IMAGE] forState:UIControlStateNormal];
    [accountButton addTarget:self action:@selector(accountBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *accountBarButton = [[UIBarButtonItem alloc] initWithCustomView:accountButton];
    self.navigationItem.rightBarButtonItem = accountBarButton;
    REMOVE_FROM_MEMORY(accountBarButton);    
}

- (void)createAddReviewButtonOnNavBar {
    
    UIButton *reviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reviewButton.frame = CGRectMake(0, 0, 80, 30);
    reviewButton.titleLabel.font= kGET_BOLD_FONT_WITH_SIZE(14);  
    reviewButton.titleLabel.textColor = [UIColor whiteColor];
    [reviewButton setTitle:kNAVBAR_TITLE_MY_REVIEW forState:UIControlStateNormal];
    [reviewButton setBackgroundImage:[UIImage imageNamed:ACCOUND_BUTTON_IMAGE] forState:UIControlStateNormal];
    [reviewButton addTarget:self action:@selector(reviewBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *reviewBarButton = [[UIBarButtonItem alloc] initWithCustomView:reviewButton];
    self.navigationItem.rightBarButtonItem = reviewBarButton;
    REMOVE_FROM_MEMORY(reviewBarButton);    
}

//creates either Home Bar Button or Back Bar Button
- (void)createNavigationBarButtonOfType:(int)aButtonType{
   
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

- (void)hideTabbar{
        self.tabBarController.tabBar.hidden = YES;    
}

- (void)showTabbar{
        self.tabBarController.tabBar.hidden = NO;    
}

//this will create the Customised navigation title

- (void)createCustomisedNavigationTitleWithString:(NSString *)titleString{
    UILabel *tempLabel = (UILabel *)[self.navigationItem.titleView viewWithTag:kNAVIGATION_LABEL_TAG];
    if (tempLabel) {
        [tempLabel removeFromSuperview];
        tempLabel = nil;
    }
    CGRect myrect = self.navigationController.navigationBar.frame;
    CGPoint mypoint = CGPointMake(myrect.origin.x + (myrect.size.width / 2), myrect.origin.y + (myrect.size.height / 2));
    UILabel *navLabel = [[UILabel alloc]initWithFrame:CGRectMake(mypoint.x, mypoint.y, 150,44 )];
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
//click on the account Button
- (void)accountBarButtonClicked:(id)sender{
    
    TDMAccountsViewController *accountsViewController = (TDMAccountsViewController *)[self getClass:@"TDMAccountsViewController"];
    [self.navigationController pushViewController:accountsViewController animated:YES];

}

- (void)reviewBarButtonClicked:(id)sender{
    
    TDMReviewRestaurant *reviewViewController = (TDMReviewRestaurant *)[self getClass:@"TDMReviewRestaurant"];
    [self.navigationController pushViewController:reviewViewController animated:YES];
    
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

#pragma mark - Login Parsing

- (void)userlogin:(NSString *)userName password:(NSString *)password
{
    JSONHandler *json = [[JSONHandler alloc]init] ;
    json.delegate   =   self;
    
    NSMutableDictionary *loginCredential  = [[NSMutableDictionary alloc]init];
    [loginCredential setObject:userName forKey:USER_NAME_TAG ];
    [loginCredential setObject:password forKey:USER_PASSWORD_TAG];
    NSString *loginURL                    = [TDM_URL stringByAppendingFormat:@"user/login"];
    
    [json sendJSONRequest:loginCredential RequestUrl:loginURL];
    
    REMOVE_FROM_MEMORY(json);
    REMOVE_FROM_MEMORY(loginCredential);
}


-(void)didfinishedparsing:(JSONHandler *)objJsonHandler
{
   
}
-(void)didfailedwitherror:(JSONHandler *)objJsonHandler
{
    
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
- (UIViewController *)getClass:(NSString *)aClassName{
    Class appClass = NSClassFromString(aClassName);
    UIViewController *classViewController = [[[appClass alloc] initWithNibName:aClassName bundle:nil] autorelease];
    return classViewController;
}

#pragma mark - Database Helpers
//this will give the restaurants from the Databases
- (NSMutableArray *)getBusinessFromDatabaseWithType:(NSString *)busType{
    TDMCoreDataManager *coreDataManager = [[TDMCoreDataManager new] autorelease];
    return [coreDataManager getBusinessWithType:busType];
    
}

@end
