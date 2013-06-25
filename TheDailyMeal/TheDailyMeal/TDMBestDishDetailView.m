//
//  TDMRestaurantReviewDetailView.h
//  TheDailyMeal
//
//  Created by Apple on 19/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMBestDishDetailView.h"
#import "TDMBusinessDetails.h"
#import "TDMAsyncImage.h"
#import "TDMBusinessDetails.h"
#import "BusinessReviewModel.h"
#import "TDMNavigationController.h"
#import "TDMUtilities.h"
#import "SignatureDishModel.h"
#import <QuartzCore/QuartzCore.h>
@interface TDMBestDishDetailView()
@end

@implementation TDMBestDishDetailView
@synthesize reviewScrollView;
@synthesize restaurantName,restaurantNameTitle;
@synthesize businessType;
@synthesize pageControlLeftButton;
@synthesize pageControlRightButton;
@synthesize currentPageIndex;
@synthesize pageViews;
@synthesize review;
//@synthesize index;

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

    self.restaurantName.text = self.restaurantNameTitle;
    self.subNavigationTitle.text = self.restaurantNameTitle;
    self.totalPages = [[TDMBusinessDetails sharedBusinessDetails].signatureDishHeaders count];
    self.imageHorizontalSpacing = 20;
    self.imageVerticalSpacing = 90;
    UIImage *bgImage = [UIImage imageNamed:@"accessoryleft.png"];
    UIImage *bagImage = [UIImage imageNamed:@"accessory.png"];
    self.pageControlLeftButton = [[UIButton alloc]initWithFrame:CGRectMake(2, 186,18 , 27)];
    self.pageControlRightButton = [[UIButton alloc]initWithFrame:CGRectMake(300, 186, 18, 27)];
   
    [self.pageControlLeftButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    [self.pageControlRightButton setBackgroundImage:bagImage forState:UIControlStateNormal];
   // [self.view addSubview:pageControlLeftButton];
    [self.view addSubview:pageControlRightButton];


//    self.view.clipsToBounds = YES;
//    self.scrollView.clipsToBounds = NO;
    
    [super viewDidLoad];
    [self createAdView];
//    reviewScrollView.delegate = self;
   // [self loadBusinessReview];
    [restaurantName setText:restaurantNameTitle];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    
//    [self setReviewScrollView:nil];
    [self setRestaurantName:nil];
    [self setRestaurantNameTitle:nil];
    [self setPageControlLeftButton:nil];
    [self setPageControlRightButton:nil];
    [self setReview:nil];
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
    [restaurantName release];
    [restaurantNameTitle release];
    [pageControlLeftButton release];
    [pageControlRightButton release];
    [review release];
    [super dealloc];
}

#pragma mark - button click

-(void)addReviewButtonClick:(id)sender {    
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    int viewControllerCount = [viewControllers count];
    UIViewController *viewController = [viewControllers objectAtIndex:(viewControllerCount - 3)];
    [self.navigationController popToViewController:viewController animated:NO];
}



-(void)didChangePageIndex:(int)pageIndex    {
    //a method for overriding....
    if (self.currentPageIndex + 1 == [[TDMBusinessDetails sharedBusinessDetails].signatureDishHeaders  count]) 
    {
        pageControlRightButton.hidden = YES;
    }
    else
    {
        pageControlRightButton.hidden = NO;
    }  
    if (self.currentPageIndex == 0) 
    {
        pageControlLeftButton.hidden = YES;
    }
    else
    {
        pageControlLeftButton.hidden = NO;
    } 
    if ([self isPageLoaded:pageIndex]) {
        UIView *pageView = [self.pageViews objectAtIndex:pageIndex];
        [self.scrollView bringSubviewToFront:pageView];
    }
       
}

- (IBAction)pageControlLeftButtonClicked:(id)sender 
{
    [self gotoPageAtIndex:self.currentPageIndex - 1];
}

- (IBAction)pageControlRightButtonClicked:(id)sender 
{
   [self gotoPageAtIndex:self.currentPageIndex + 1];
}



#pragma mark    UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.userInteractionEnabled = YES;
}
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


#pragma mark 

- (CGSize)pageSize {
	
	return  CGSizeMake(270, 350);
}

//- (CGRect)alignView:(UIView *)view forPage:(int)pageIndex {
//	
//	CGSize pageSize = [self pageSize];
//    
//    CGRect scrollViewRect;
//    scrollViewRect.origin.x     = 20;
//    scrollViewRect.origin.y     = imageVerticalSpacing;
//    scrollViewRect.size.width   = ((imageHorizontalSpacing ) + pageSize.width);
//    scrollViewRect.size.height  = pageSize.height;
//    
//	[self.scrollView setFrame:scrollViewRect];
//    
//    CGSize scrollContentSize;
//    scrollContentSize.width     = (self.totalPages*(pageSize.width+ (2*imageHorizontalSpacing)));
//    scrollContentSize.height    = pageSize.height;
//	[self.scrollView setContentSize:scrollContentSize];
//    
//    
//    CGRect pageRect;
//    pageRect.origin.x   = (pageIndex *  ((imageHorizontalSpacing) + pageSize.width));
//    pageRect.origin.y   = 0;
//    pageRect.size.width = pageSize.width;
//    pageRect.size.height= pageSize.height;
//    
//	return pageRect;
//}
//
- (UIView *)loadViewForPage:(int)pageIndex {
	
	UIView *reviewView;
    
    @try {
        
        SignatureDishModel *tempReview  = [[TDMBusinessDetails sharedBusinessDetails].signatureDishHeaders objectAtIndex:pageIndex];
        reviewView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 275, 260)];
        [reviewView setBackgroundColor:[UIColor whiteColor]];
        [reviewView.layer setCornerRadius:5.0];
        
        TDMAsyncImage * asyncImageView = [[TDMAsyncImage alloc]initWithFrame:CGRectMake(6, 6, 60, 60)];
        asyncImageView.tag = 9999;
        NSString *urlpath = @"";
        if([tempReview.signatureDishImage isKindOfClass:NSClassFromString(@"NSString")]) {
            if(![tempReview.signatureDishImage isEqualToString:@""]) {
                urlpath = [urlpath stringByAppendingString:tempReview.signatureDishImage];
                if (!([urlpath isKindOfClass:[NSNull class]] )) {
                    if(![urlpath isEqualToString:@""]) {
                        
                        urlpath =  [NSString stringWithFormat:@"%@/%@",DAILYMEAL_SEVER_PROD,urlpath];
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
        reviewTitle.text  =tempReview.signatureDishTitle;
        [reviewView addSubview:reviewTitle];
        [reviewTitle release];
        UILabel *reviewVerticalLine = [[UILabel alloc]initWithFrame:CGRectMake(5, 70, 265, 1)];
        [reviewVerticalLine setBackgroundColor:[UIColor colorWithRed:136/255.0f green:136/255.0f blue:136/255.0f alpha:.5]];
        [reviewView addSubview:reviewVerticalLine];
        [reviewVerticalLine release];
        
//        UIWebView *review = [[UIWebView alloc]initWithFrame:CGRectMake(0, 75, 265, 175)];
        review.frame = CGRectMake(0, 75, 265, 175);
        review.delegate = self;
        [review loadHTMLString:[TDMUtilities createHTMLString:tempReview.reviewText] baseURL:[NSURL URLWithString:nil]];
        [reviewView addSubview:review];
        
        
        
        
        
        [self.pageControlLeftButton addTarget:self action:@selector(pageControlLeftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.pageControlRightButton addTarget:self action:@selector(pageControlRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:pageControlLeftButton];
      
    }
    @catch (NSException *exception) {
        NSLog(@"Exception on loadViewForPage at Index %d : %@",pageIndex,[exception description]);
    }
	
	return reviewView;
}



@end
