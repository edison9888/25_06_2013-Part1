//
//  TDMBusinessDetailsViewController.m
//  TheDailyMeal
//
//  Created by user on 18/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMBusinessDetailsViewController.h"
#import "TDMBusinessDetails.h"

@implementation TDMBusinessDetailsViewController
@synthesize businessDetailView;
@synthesize businessNameLabel;
@synthesize businessAddressLabel;
@synthesize businessPhoneLabel;
@synthesize businessCategoriesLabel;
@synthesize businessWebsiteLabel;
@synthesize businessNoteLabel;
@synthesize businessHoursLabel;
@synthesize businessAddressValueLabel;
@synthesize businessPhoneValueLabel;
@synthesize businessCategoriesValueLabel;
@synthesize businessWebsiteValueLabel;
@synthesize businessNoteValueLabel;
@synthesize businessHoursValueLabel;
@synthesize businessDishScrollView;
@synthesize businessReviewView;
@synthesize businessDetailId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //this will create the back button on the navigation bar
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
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
    [self initialiseDetails];
    [self.navigationItem setRBIconImage];
    UIScrollView *mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 250, 320, 120)];
    [mainScrollView setContentSize:CGSizeMake(320,200)];
    mainScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainScrollView];
    [mainScrollView release];
    UIView *scrollViewContainerView = [[UIView alloc]initWithFrame:CGRectMake(20, 10, 280, 80)];
    [scrollViewContainerView.layer setCornerRadius:5.0];
    scrollViewContainerView.backgroundColor =[UIColor whiteColor];
    [mainScrollView addSubview:scrollViewContainerView];
    [scrollViewContainerView release];
    businessDishScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(5, 5, 250, 70)];
    businessDishScrollView.backgroundColor = [UIColor clearColor];
    [scrollViewContainerView addSubview:businessDishScrollView];
    static int x = 10;    
    for (int i=0; i<5; i++) 
    {
        NSLog(@"creating view frame at x value %d",x+2);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x+3, 6, 60, 60)];
        [imageView.layer setCornerRadius:5.0];
        imageView.image = [UIImage imageNamed:@"business1"];
        [businessDishScrollView addSubview:imageView];
        
        //set border of the image
        UIButton *borderButton = [[UIButton alloc]initWithFrame:CGRectMake(x+3, 4, 62, 60)];
        borderButton.userInteractionEnabled = NO;
        [borderButton.layer setBorderWidth:1.0];
        [borderButton.layer setCornerRadius:5.0];
        [borderButton.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor]];
        [businessDishScrollView addSubview:borderButton];
        REMOVE_FROM_MEMORY(borderButton);
                x  = x + 70;    

    }
    self.businessDishScrollView.contentSize = CGSizeMake(x, 0);
    UIView *reviewContainerView = [[UIView alloc]initWithFrame:CGRectMake(20, 100, 280, 80)];
    [reviewContainerView.layer setCornerRadius:5.0];
    reviewContainerView.backgroundColor =[UIColor whiteColor];
    
    UIImageView *reviewImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5,10, 65, 65)];
    [reviewImageView.layer setCornerRadius:5.0];
    reviewImageView.image = [UIImage imageNamed:@"business1"];
    [reviewContainerView addSubview:reviewImageView];
    [mainScrollView addSubview:reviewContainerView];
    //set border of the image
    UIButton *borderButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 8, 67, 65)];
    borderButton.userInteractionEnabled = NO;
    [borderButton.layer setBorderWidth:1.0];
    [borderButton.layer setCornerRadius:5.0];
    [borderButton.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor]];
    [reviewContainerView addSubview:borderButton];
    REMOVE_FROM_MEMORY(borderButton);
    
    UILabel *reviewLabel = [[UILabel alloc]initWithFrame:CGRectMake(75,10, 100, 20)];
    reviewLabel.text = @"Review by";
    reviewLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [reviewContainerView addSubview:reviewLabel];
    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(135,10, 75, 20)];
    userNameLabel.text = @"User Name";
    userNameLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [reviewContainerView addSubview:userNameLabel];
    
    UILabel *review = [[UILabel alloc]initWithFrame:CGRectMake(75,30, 200, 40)];
    review.numberOfLines =3;
    review.textColor = [UIColor lightGrayColor];
    review.font = [UIFont systemFontOfSize:11];
    review.text = @"Review by userReview by userReview by userReview by userReview by userReview by userReview by userReview by userReview by userReview by userReview by userReview by userReview by userReview by userReview by userReview by userReview by userReview by userReview by userReview by user";

    [reviewContainerView addSubview:review];
    
    
    
    [reviewContainerView release];
    x=0;
    // Do any additional setup after loading the view from its nib.
}
- (void)initialiseDetails
{
    detailsArray = [TDMBusinessDetails sharedCurrentBusinessDetails].sharedBusinessDetails;
    dict = [detailsArray objectAtIndex:businessDetailId];
    businessNameLabel.text = [dict objectForKey:@"name"];
    businessAddressValueLabel.text = [NSString stringWithFormat:@"%@, %@, %@",[dict objectForKey:@"address"],[dict objectForKey:@"city"],[dict objectForKey:@"country"]];
    businessPhoneValueLabel.text = [dict objectForKey:@"formattedphone"];
    businessCategoriesValueLabel.text = [dict objectForKey:@"category"];
    businessWebsiteValueLabel.text = [dict objectForKey:@"url"];
}
- (void)viewDidUnload
{

    [self setBusinessDetailView:nil];
    [self setBusinessNameLabel:nil];
    [self setBusinessAddressLabel:nil];
    [self setBusinessPhoneLabel:nil];
    [self setBusinessCategoriesLabel:nil];
    [self setBusinessWebsiteLabel:nil];
    [self setBusinessNoteLabel:nil];
    [self setBusinessHoursLabel:nil];
    [self setBusinessAddressValueLabel:nil];
    [self setBusinessPhoneValueLabel:nil];
    [self setBusinessCategoriesValueLabel:nil];
    [self setBusinessWebsiteValueLabel:nil];
    [self setBusinessNoteValueLabel:nil];
    [self setBusinessHoursValueLabel:nil];
    [self setBusinessDishScrollView:nil];
    [self setBusinessReviewView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {

    [businessDetailView release];
    [businessNameLabel release];
    [businessAddressLabel release];
    [businessPhoneLabel release];
    [businessCategoriesLabel release];
    [businessWebsiteLabel release];
    [businessNoteLabel release];
    [businessHoursLabel release];
    [businessAddressValueLabel release];
    [businessPhoneValueLabel release];
    [businessCategoriesValueLabel release];
    [businessWebsiteValueLabel release];
    [businessNoteValueLabel release];
    [businessHoursValueLabel release];
    [businessDishScrollView release];
    [businessReviewView release];
    [super dealloc];
}
@end
