//
//  TDMRestaurantReviewDetailView.h
//  TheDailyMeal
//
//  Created by Apple on 19/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMRestaurantReviewDetailView.h"
#import "TDMBusinessDetails.h"
#import "TDMAsyncImage.h"
#import "TDMBusinessDetails.h"
#import "BusinessReviewModel.h"
#import "TDMNavigationController.h"
#import "TDMUtilities.h"
#import <QuartzCore/QuartzCore.h>
@interface TDMRestaurantReviewDetailView()
@end

@implementation TDMRestaurantReviewDetailView
@synthesize reviewScrollView;
@synthesize restaurantName,restaurantNameTitle;
@synthesize businessType;
@synthesize nextButton;
@synthesize pageViews;
@synthesize currentPageIndex;
@synthesize previousButton;
//@synthesize review;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setTDMIconImage];
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    self.restaurantName.text =[NSString stringWithFormat:@"Reviews on %@",self.restaurantNameTitle];
    self.previousButton.hidden = YES;
    self.totalPages = [[TDMBusinessDetails sharedBusinessDetails].reviewListHeaders count];
    self.imageHorizontalSpacing = 20;
    self.imageVerticalSpacing = 90;
    
//    self.view.clipsToBounds = YES;
//    self.scrollView.clipsToBounds = NO;
    self.previousButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 186,18 , 27)];
    self.nextButton = [[UIButton alloc]initWithFrame:CGRectMake(300, 186, 18, 27)];

    [super viewDidLoad];
    [self createAdView];
   // reviewScrollView.delegate = self;
  //  [self loadBusinessReview];
    self.subNavigationTitle.text =[NSString stringWithFormat:@"Reviews on %@",self.restaurantNameTitle];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *bgImage = [UIImage imageNamed:@"accessoryleft.png"];
    UIImage *bagImage = [UIImage imageNamed:@"accessory.png"];
    [self.nextButton addTarget:self action:@selector(showNextBestDish:) forControlEvents:UIControlEventTouchUpInside];
    [self.previousButton addTarget:self action:@selector(showPreviousBestDish:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton setBackgroundImage:bagImage forState:UIControlStateNormal];
    [self.previousButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    [self.view addSubview:self.previousButton];
    [self.view addSubview:self.nextButton];
}


- (void)viewDidUnload {
    
//    [self setReviewScrollView:nil];
 //   [self setRestaurantName:nil];
//    [self setRestaurantNameTitle:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    
//    [reviewScrollView release];
  //  [restaurantName release];
//    [restaurantNameTitle release];

    [super dealloc];
}

#pragma mark - button click

-(void)addReviewButtonClick:(id)sender {    
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    int viewControllerCount = [viewControllers count];
    UIViewController *viewController = [viewControllers objectAtIndex:(viewControllerCount - 3)];
    [self.navigationController popToViewController:viewController animated:NO];
}



#pragma mark - Swipe 

- (CGSize)pageSize {
	
	return  CGSizeMake(270, 350);
}

- (UIView *)loadViewForPage:(int)pageIndex {
	
	UIView *reviewView;
    
    @try {

        BusinessReviewModel *tempReview  = [[TDMBusinessDetails sharedBusinessDetails].reviewListHeaders objectAtIndex:pageIndex];
        reviewView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 275, 350)];
        [reviewView setBackgroundColor:[UIColor whiteColor]];
        [reviewView.layer setCornerRadius:5.0];
        reviewView.clipsToBounds = YES;
        reviewView.layer.masksToBounds = YES;
        TDMAsyncImage * asyncImageView = [[TDMAsyncImage alloc]initWithFrame:CGRectMake(6, 6, 60, 60)];
        asyncImageView.tag = 9999;
        NSString *urlpath = @"";
        
        if([tempReview.businessImage isKindOfClass:NSClassFromString(@"NSString")]) {
            if(![tempReview.businessImage isEqualToString:@""]) {
               urlpath = [urlpath stringByAppendingString:tempReview.businessImage];
                if (!([urlpath isKindOfClass:[NSNull class]] )) {
                    if(![urlpath isEqualToString:@""]) 
                    {
                        urlpath = [NSString stringWithFormat:@"%@/%@",DAILYMEAL_SEVER_PROD,urlpath];
                        NSURL *url = [[NSURL alloc] initWithString:urlpath];
                        [asyncImageView loadImageFromURL:url isFromHome:YES];
                        [url release];
                        url = nil;
                    }
                    else {
                        [asyncImageView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
                    }
                }
                else {
                    [asyncImageView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
                }
            }
            else {
                [asyncImageView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
            }
        }
        [reviewView addSubview:asyncImageView]; 
        [asyncImageView release];
        UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(76, 12, 95, 10)];
        userName.font  =[UIFont systemFontOfSize:12.0];
        userName.text  =tempReview.userName;
        [reviewView addSubview:userName];
        [userName release];
        UILabel *reviwerLevel = [[UILabel alloc]initWithFrame:CGRectMake(190, 12, 70, 10)];
        [reviwerLevel setTextColor:[UIColor grayColor]];
        reviwerLevel.font  =[UIFont systemFontOfSize:10.0];
        reviwerLevel.text  =@"Reviewer level";
        [reviewView addSubview:reviwerLevel];
        [reviwerLevel release];
        UILabel *reviewTitle = [[UILabel alloc]initWithFrame:CGRectMake(76, 25, 180, 40)];
        [reviewTitle setNumberOfLines:2];
        reviewTitle.font  =[UIFont boldSystemFontOfSize:13.0];
        reviewTitle.text  =tempReview.reviewTitle;
        [reviewView addSubview:reviewTitle];
        [reviewTitle release];
        //for vertival line
        UILabel *reviewVerticalLine = [[UILabel alloc]initWithFrame:CGRectMake(5, 70, 265, 1)];
        [reviewVerticalLine setBackgroundColor:[UIColor colorWithRed:136/255.0f green:136/255.0f blue:136/255.0f alpha:.5]];
        [reviewView addSubview:reviewVerticalLine];
        [reviewVerticalLine release];

        UIWebView *review = [[UIWebView alloc]initWithFrame:CGRectMake(0, 75, 265, 175)];
        review.delegate = self;
        [review loadHTMLString:[TDMUtilities createHTMLString:tempReview.reviewText] baseURL:nil];
        [reviewView addSubview:review];

               
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception on loadViewForPage at Index %d : %@",pageIndex,[exception description]);
    }
	
	return reviewView;
}


#pragma mark - Swipe Controller


-(void)didChangePageIndex:(int)pageIndex    {
    //a method for overriding....
    if (self.currentPageIndex == 0) 
    {
        self.previousButton.hidden = YES;
    }
    else
    {
        self.previousButton.hidden = NO;
    }
    if (self.currentPageIndex == (self.totalPages - 1)) 
    {
        self.nextButton.hidden = YES;
    }
    else
    {
        self.nextButton.hidden = NO;
    }
}

#pragma mark - Button Actions


- (IBAction)showNextBestDish:(id)sender 
{
   
    [self gotoPageAtIndex:(self.currentPageIndex + 1)];
}

- (IBAction)showPreviousBestDish:(id)sender {
   
    [self gotoPageAtIndex:(self.currentPageIndex - 1)];
}

#pragma web view delegates

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{  
    NSURL *requestURL = [ [ request URL ] retain ];  
    // Check to see what protocol/scheme the requested URL is.  
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {  
        
        NSString *url = [requestURL relativeString];
        NSLog(@"%@",url);
        if([url rangeOfString:@"http://"].location == NSNotFound)
        {
            url = [url stringByReplacingOccurrencesOfString:@"applewebdata://" withString:@""];
            NSLog(@"%@",url);
            
            url = [NSString stringWithFormat:@"%@/%@",DAILYMEAL_SEVER_PROD,url];
            
            return ![ [ UIApplication sharedApplication ] openURL: [NSURL URLWithString:url] ];
        }
        
        return ![ [ UIApplication sharedApplication ] openURL: [ requestURL autorelease ] ];  
    }  
    // Auto release  
    [ requestURL release ];  
    // If request url is something other than http or https it will open  
    // in UIWebView. You could also check for the other following  
    // protocols: tel, mailto and sms  
    return YES;  
  
} 
@end
