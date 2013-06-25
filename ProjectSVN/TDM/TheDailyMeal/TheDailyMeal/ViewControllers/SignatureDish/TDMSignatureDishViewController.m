//
//  TDMSignatureDishViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/3/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMSignatureDishViewController.h"
#import "TDMSignatureDishDetailsViewController.h"
#import "DatabaseManager.h"
#import "SignatureDish.h"

@interface TDMSignatureDishViewController()



//private
- (void)customiseCurrentView;
- (void)createImagesInScroll;
- (void)addBannerImageToScrollView:(int)XValue;
- (void)addBannerImageTitleToScrollView:(int)XValue;
- (void)addDishNameToScrollView:(int)XValue signatureDishDetailObj:(SignatureDish *)signatureDish;
- (void)addDishRestaurantNameToScrollView:(int)XValue signatureDishDetailObj:(SignatureDish *)signatureDish;

@end


@implementation TDMSignatureDishViewController
@synthesize scrollView;
@synthesize backgroundImageView;
@synthesize bannerImage;
@synthesize contentBackgroundImageView;
@synthesize bannerImageTitle;
@synthesize contentView;
@synthesize addButton;
@synthesize signatureDataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //this will create the navigation Title as My Profile
        [self createCustomisedNavigationTitleWithString:kNAVBAR_TITLE_BEST_DISHES];
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
    //[self.navigationItem setRBIconImage];
    
    //if add exist
    //[self.contentView setFrame:CGRectMake(0, 25, 320, 460)];
    //else [self.contentView setFrame:CGRectMake(160, 300, 320, 460)];  
    
    //set the banner image title
    self.bannerImageTitle.font = kGET_BOLD_FONT_WITH_SIZE(15);
    self.bannerImageTitle.text= @"The Best Dishes Near You";
    self.bannerImageTitle.textColor = [UIColor whiteColor];
    
    [self populateDishDetailsWithDummyData];
    
    //this will customise Current View
    [self customiseCurrentView];

    
}

- (void)viewDidUnload
{
    
    REMOVE_FROM_MEMORY(scrollView)
    REMOVE_IMAGEVIEW_FROM_MEMORY(backgroundImageView)
    [self setBannerImage:nil];
    [self setBannerImageTitle:nil];
    [self setContentView:nil];
    [self setContentBackgroundImageView:nil];
    [self setAddButton:nil];
    [self setSignatureDataArray:nil];
    [super viewDidUnload];


}

- (void)viewWillAppear:(BOOL)animated{
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View Creations
- (void)customiseCurrentView{
    
    //this will show the Tabbat
    [self showTabbar];
    
    //creates Accountbar on Navigation Bar
    [self createAccountButtonOnNavBar];
    
    //this will create the image in the scroll
    [self createImagesInScroll];
    
}
//this will create the images in the scroll
- (void)createImagesInScroll
{
    int x = 10;
    //int bannerImageXaxis = -10;//21;
    //int bannerImageTitleXaxis = 15;
    int dishNameXaxis = 40;
    int dishRestaurantNameXaxis = 20;
    
    //[self addBannerImageToScrollView:bannerImageXaxis];
    
    NSLog(@"%@",self.signatureDataArray);
    
    for (int i=0; i<[self.signatureDataArray count]; i++) 
    {
        SignatureDish * signatureDish = [self.signatureDataArray objectAtIndex:i];
        NSLog(@"name #################  %@",signatureDish.name);
        NSLog(@"resName #################  %@",signatureDish.resName);
        //[self addBannerImageTitleToScrollView:bannerImageTitleXaxis];
        [self addDishNameToScrollView: (dishNameXaxis - 30) signatureDishDetailObj:signatureDish];
        [self addDishRestaurantNameToScrollView:(dishRestaurantNameXaxis - 30) signatureDishDetailObj:signatureDish];
        
        UIButton *signatureDishImageButton = [[UIButton alloc]initWithFrame:CGRectMake(x+2, 2, 200, 196)];
    
        [signatureDishImageButton.layer setCornerRadius:10.0];
        
        [signatureDishImageButton addTarget:self action:@selector(signatureDishImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [signatureDishImageButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"dish%d.jpg",i+1]] forState:UIControlStateNormal];

        signatureDishImageButton.layer.masksToBounds = YES;
        [signatureDishImageButton setTag:i];
        [self.scrollView addSubview:signatureDishImageButton];
        REMOVE_FROM_MEMORY(signatureDishImageButton); 
        
        //set border of the image
         UIButton *borderButton = [[UIButton alloc]initWithFrame:CGRectMake(x, 0, 204, 200)];
        borderButton.userInteractionEnabled = NO;
        [borderButton.layer setBorderWidth:1.0];
        [borderButton.layer setCornerRadius:10.0];
        [borderButton.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor]];
        [self.scrollView addSubview:borderButton];
        REMOVE_FROM_MEMORY(borderButton);
        
       #define SCROLL_IMAGE_XAXIS 210
        
        x  = x + SCROLL_IMAGE_XAXIS;
        //bannerImageXaxis      = bannerImageXaxis + SCROLL_IMAGE_XAXIS;
        //bannerImageTitleXaxis = bannerImageTitleXaxis + SCROLL_IMAGE_XAXIS;
        dishNameXaxis         = dishNameXaxis +SCROLL_IMAGE_XAXIS;
        dishRestaurantNameXaxis = dishRestaurantNameXaxis + SCROLL_IMAGE_XAXIS;
    }
    self.scrollView.contentSize = CGSizeMake(x, 0);
    
}



- (void)addBannerImageToScrollView:(int)XValue
{
    //Banner Iamge
//    NSString *bannerImgPath = nil;
//    bannerImgPath           =  [[NSBundle mainBundle] pathForResource:@"bar_image"                                                                         
//                                                               ofType:@"png"];
//    UIImage *image          = nil;
//    image                   = [UIImage imageWithContentsOfFile:bannerImgPath];
//    UIImageView *bannerImage= [[UIImageView alloc]init];
//    bannerImage.frame=CGRectMake(XValue, 20, 210, 43);
//    bannerImage.backgroundColor=[UIColor clearColor];
//    bannerImage.userInteractionEnabled = NO;
//    bannerImage.image    = image;
//    [self.view addSubview:bannerImage];
//    REMOVE_FROM_MEMORY(bannerImage);
}

- (void)addBannerImageTitleToScrollView:(int)XValue
{
//    UILabel *bannerTitle=[[UILabel alloc]initWithFrame:CGRectMake(XValue, 30, 200, 20)];
//    bannerTitle.backgroundColor  = [UIColor clearColor];
//    bannerTitle.textColor = [UIColor whiteColor];
//    bannerTitle.font = kGET_BOLD_FONT_WITH_SIZE(15);
//    bannerTitle.textAlignment=UITextAlignmentLeft;
//    bannerTitle.text= @"The Best Dishes Near You";
//    [self.view addSubview:bannerTitle];
//    REMOVE_FROM_MEMORY(bannerTitle);
}

- (void)addDishNameToScrollView:(int)XValue signatureDishDetailObj:(SignatureDish *)signatureDish
{
    UILabel *dishName=[[UILabel alloc]initWithFrame:CGRectMake(XValue, 201, 200, 20)];
    dishName.backgroundColor  = [UIColor clearColor];
    dishName.textColor = [UIColor grayColor];
    dishName.font = kGET_REGULAR_FONT_WITH_SIZE(18);
    dishName.textAlignment=UITextAlignmentCenter;
    //dishName.text= @"\"Dish Name\"";


    NSString *dishNameString = signatureDish.name;
    
    dishName.text = [NSString stringWithFormat:@"\"%@\"",dishNameString];
    
    [self.scrollView addSubview:dishName];
    REMOVE_FROM_MEMORY(dishName);
}

- (void)addDishRestaurantNameToScrollView:(int)XValue signatureDishDetailObj:(SignatureDish *)signatureDish
{
    UILabel *dishRestaurantName=[[UILabel alloc]initWithFrame:CGRectMake(XValue, 218, 250, 20)];
    dishRestaurantName.backgroundColor  = [UIColor clearColor];
    dishRestaurantName.textColor = [UIColor grayColor];
    dishRestaurantName.font = kGET_REGULAR_FONT_WITH_SIZE(15);
    dishRestaurantName.textAlignment=UITextAlignmentCenter;
    //dishRestaurantName.text= @"By The Restaurant  Name";
    
     
    NSString *restaurantNameString = signatureDish.resName;
    
    dishRestaurantName.text = [NSString stringWithFormat:@"By The %@",restaurantNameString];
    [self.scrollView addSubview:dishRestaurantName];
    REMOVE_FROM_MEMORY(dishRestaurantName);
}

#pragma mark  - Button Actions
- (void)signatureDishImageButtonClicked:(id)sender{
    
    UIButton *signatureDishButton = (UIButton *)sender;
    
    NSLog(@"Button with tag %d tapped",signatureDishButton.tag);
    
    TDMSignatureDishDetailsViewController *dishDetailsViewController = (TDMSignatureDishDetailsViewController *)[self getClass:kSIGNATUREDISH_DETAILS_CLASS];
    NSLog(@"%@",self.signatureDataArray);
    dishDetailsViewController.signatureDish = [self.signatureDataArray objectAtIndex:signatureDishButton.tag];
    dishDetailsViewController.selectedDishID = [NSString stringWithFormat:@"%d",signatureDishButton.tag];
    [self.navigationController pushViewController:dishDetailsViewController animated:YES];
    
}


#pragma mark - Memory Management
- (void)dealloc{
    
    REMOVE_FROM_MEMORY(scrollView)
    REMOVE_IMAGEVIEW_FROM_MEMORY(backgroundImageView)
    [bannerImage release];
    [bannerImageTitle release];
    [contentView release];
    [contentBackgroundImageView release];
    [addButton release];
    [super dealloc];
}


- (IBAction)addButtonClicked:(id)sender {
}

-(void)populateDishDetailsWithDummyData {
    
    double lattitude = [[NSUserDefaults standardUserDefaults] doubleForKey:@"CurrentLattitude"];
    double longitude = [[NSUserDefaults standardUserDefaults] doubleForKey:@"CurrentLongitude"];

//    if (!self.signatureDataArray) {
//        
//        self.signatureDataArray = [[NSMutableArray alloc]init];
//    }
    
    self.signatureDataArray  =[[DatabaseManager sharedManager]getCurrentLocationSignatureDishDetails:lattitude longitude:longitude];

    
    NSLog(@"%@",self.signatureDataArray);
}
@end
