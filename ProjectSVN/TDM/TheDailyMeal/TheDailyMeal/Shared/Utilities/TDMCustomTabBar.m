//
//  TDMCustomTabBar.m
//  TheDailyMeal
//
//  Created by Nithin George on 06/01/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//


#import "TDMCustomTabBar.h"
#import <QuartzCore/QuartzCore.h>
#import "TDMBarsViewController.h"
#import "TDMRestaurantsViewController.h"
#import "TDMSignatureDishViewController.h"
#import "TDMFavoritesViewController.h"
#import "TDMChannelsViewController.h"
#import "TDMCityGuidesViewController.h"
#import "TDMAddSignatureDishViewController.h"
#import "Reachability.h"
#import "TDMCityGuideListOfCitiesHandler.h"


#define BARVIEWCONTROLLER_NIB_NAME        @"TDMBarsViewController"
#define RESTAURANTVIEWCONTROLLER_NIB_NAME @"TDMRestaurantsViewController"
#define SIGNATUREDISHCONTROLLER_NIB_NAME  @"TDMSignatureDishViewController"
#define FAVOURITEVIEWCONTROLLER_NIB_NAME  @"TDMFavoritesViewController"
#define CHANNEL_CONTROLLER_NIB_NAME       @"TDMChannelsViewController"
#define CITYGUIDE_CONTROLLER_NIB_NAME     @"TDMCityGuidesViewController"
#define ADDSIGNATURE_DISH_CONTROLLER_NIB_NAME     @"TDMAddSignatureDishViewController"

#define CHANNEL_SECTION_IMAGE @"ChannelTableSection.png"
#define TABBAR_SELECTED_IMAGE @"TabBarSelected"

#define PREVIOUSLY_SELECTED_TAB_ID @"previouslySelectedTab"

#define MORE_FAV_ROW_COUNT 1


//TAB BAR ITEMS
#define DEFAULT_TAB_COUNT 5

#define TAB_X 7
#define TAB_Y 10
#define ADD_DISH_BUTTON_Y 3

#define TAB_X_SPACE 65;

#define TAB_WIDTH 44
#define TAB_HEIGHT 34
#define ADD_DISH_BUTTON_HIGHT 55

#define TABBAR_TAG 100

#define ROOT_TAB_NAME @"TabItems"

#define TAB_IMAGE_TYPE @"png"

#define TAB_NAME @"tabName"
#define NAVIGATION_NAME @"navigationName"

#define ICON_NORMAL @"iconNormal"

#define ICON_SELECT @"iconSelect"

#define kARRAY_OF_BAR_NAMES [NSArray arrayWithObjects:@"Bars",@"Restaurants",@"Add Dish",@"Best Dishes",@"More",nil]

//table

#define MORE_SECSSION_COUNT 3

//animation
#define ANIMATION_RIGHT @"right"
#define ANIMATION_LEFT  @"left"
#define SWIPE_ANIMATION_KEY @"swipeAnimation"

#define BUTTON_TITLE_RECT CGRectMake(tabX - 5, 45, 55, 10)
#define WISH_LIST_RECT CGRectMake(0,0,320,40)
#define WISH_LIST_TITLE_FRAME CGRectMake(15,15,100,21)
#define IMAGE_FRAME CGRectMake(100,10,25,25)


@interface TDMCustomTabBar (Private)

- (void)customizeTabBarView;
- (void)loadTabBarItems;
- (void)tabItemPressed:(UIButton *)tab;

- (UIView *)addWishList;

@end


@implementation TDMCustomTabBar

@synthesize listOfCities;

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
    
    [self customizeTabBarView];
    [self loadTabBarItems]; 
    UIButton *addDishSelectedButton = (UIButton*)[customTabItems objectAtIndex:kADD_DISH_TABBAR_INDEX];
    [self tabItemPressed:addDishSelectedButton];
    [self setSelectedIndex:kSIGNATUE_DISH_TABBAR_INDEX];
    
}


#pragma mark - Customize TabBar

-(void)customizeTabBarView
{
    
    customTabItems=[[NSMutableArray alloc]init];
    
    tabBarView=[[UIView alloc] initWithFrame:CGRectMake(self.tabBar.frame.origin.x, self.view.frame.size.height-58, self.tabBar.frame.size.width ,  self.tabBar.frame.size.height)];
    tabBarView.tag=TABBAR_TAG;
    tabBarView.backgroundColor=[UIColor clearColor];
    
    UIImageView *tabbarBackgroundView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tabBar.frame.size.width ,  (self.tabBar.frame.size.height + 9))];
    UIImage *raisedImage = [UIImage imageNamed:@"tabbarBG.png"];
    tabbarBackgroundView.image = raisedImage;
    tabbarBackgroundView.backgroundColor=[UIColor clearColor];
    //tabbarBackgroundView.contentMode = UIViewContentModeScaleToFill;
    [tabBarView addSubview:tabbarBackgroundView];
    [tabbarBackgroundView release];
    tabbarBackgroundView=nil;
    
    int tabX=TAB_X;
    
    //load custom tabs
    for (int tab=0; tab<DEFAULT_TAB_COUNT; tab++) {
        
        NSString *normalIconSelectedImagePath=[NSString stringWithFormat:@"iconSelected%d",tab];
        UIButton *btnTab=[[UIButton alloc]init];
        if (kADD_DISH_TABBAR_INDEX == tab) {
            
            btnTab.frame=CGRectMake(tabX + 3 , ADD_DISH_BUTTON_Y, 42, 42);
        }
        else
        {
            btnTab.frame=CGRectMake(tabX, TAB_Y, TAB_WIDTH, TAB_HEIGHT);
        }
        
        [btnTab setTitleEdgeInsets:UIEdgeInsetsMake(20, 10.0, 0.0, 0.0)];
        btnTab.backgroundColor=[UIColor clearColor];
        [btnTab setTag:tab];

        NSLog(@"Button Tab Frame %f %f",btnTab.frame.size.width,btnTab.frame.size.height);
        
        NSString *normalIconImagePath=[NSString stringWithFormat:@"iconNormal%d",tab];
        
        
        
        [btnTab setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:normalIconImagePath ofType:TAB_IMAGE_TYPE]] forState:UIControlStateNormal];

       
        
        [btnTab setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:normalIconSelectedImagePath ofType:TAB_IMAGE_TYPE]] forState:UIControlStateSelected];     
       
        if (kADD_DISH_TABBAR_INDEX == tab){ 
            [btnTab setSelected:TRUE];
            //[btnTab setAlpha:1.0];
        }
        [btnTab addTarget:self action:@selector(tabItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [tabBarView addSubview:btnTab];
        [customTabItems addObject:btnTab];
        [btnTab release];
        btnTab=nil;
        UILabel *buttonTitle = [[UILabel alloc]initWithFrame:BUTTON_TITLE_RECT];
        buttonTitle.backgroundColor = [UIColor clearColor];
        buttonTitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:9.0];
        buttonTitle.textColor = [UIColor whiteColor]; ;
        buttonTitle.textAlignment = UITextAlignmentCenter;
        buttonTitle.text     = [kARRAY_OF_BAR_NAMES objectAtIndex:tab];
        [tabBarView addSubview:buttonTitle];
        REMOVE_FROM_MEMORY(buttonTitle);
        
        tabX=tabX+TAB_X_SPACE;
    }
    
    [self.view addSubview:tabBarView];
    [tabBarView release];
    //tabBarView=nil;
    
}

-(void)tabItemPressed:(UIButton *)tab 
{
    
    [tab setSelected:TRUE];
    //[tab setAlpha:1.0];
    for (UIButton *tabItem in customTabItems) 
    {
        if (tabItem.tag!=tab.tag){ 
            [tabItem setSelected:FALSE];
            //[tabItem setAlpha:0.6];
            // tabItem.backgroundColor = [UIColor clearColor];
        }
        
    }
     
    self.selectedIndex=tab.tag; 
    NSArray *navigationsResultArray = self.viewControllers;
    UINavigationController *navigationcontroller = [navigationsResultArray objectAtIndex:tab.tag];
    [navigationcontroller popToRootViewControllerAnimated:YES];
    [self setSelectedIndex:tab.tag];

}

#pragma mark -
#pragma mark TabBarItems Loading methods

- (void)loadTabBarItems{
    
    //Array for storing the TabBAr Items
    NSMutableArray *tabItems=[[NSMutableArray alloc] init];
    
    //TabBar item -Bar    
    TDMBarsViewController *barViewController=[[TDMBarsViewController alloc]initWithNibName:BARVIEWCONTROLLER_NIB_NAME bundle:nil];
    
    TDMNavigationController *barNavigationController=[[TDMNavigationController alloc]initWithRootViewController:barViewController];
    [tabItems addObject:barNavigationController];
    
    REMOVE_FROM_MEMORY(barViewController)
    REMOVE_FROM_MEMORY(barNavigationController)
    
    //TabBar item -Restaurant
    
    TDMRestaurantsViewController *restaurantsViewController=[[TDMRestaurantsViewController alloc]initWithNibName:RESTAURANTVIEWCONTROLLER_NIB_NAME bundle:nil];
    TDMNavigationController *restaurantNavigationController=[[TDMNavigationController alloc]initWithRootViewController:restaurantsViewController];
    
    [tabItems addObject:restaurantNavigationController];
    
    REMOVE_FROM_MEMORY(restaurantsViewController)
    REMOVE_FROM_MEMORY(restaurantNavigationController)
    
    
    //TabBar item -Add Dishes
    
    TDMAddSignatureDishViewController *AddSignatureDishViewController=[[TDMAddSignatureDishViewController alloc]initWithNibName:ADDSIGNATURE_DISH_CONTROLLER_NIB_NAME bundle:nil];
    AddSignatureDishViewController.businessType = 1;
    TDMNavigationController *addSignatureDishNavigationController=[[TDMNavigationController alloc]initWithRootViewController:AddSignatureDishViewController];
    
    [tabItems addObject:addSignatureDishNavigationController];
    
    REMOVE_FROM_MEMORY(AddSignatureDishViewController)
    REMOVE_FROM_MEMORY(addSignatureDishNavigationController)
    
    //TabBar item -Signature Dishes    
    
    TDMSignatureDishViewController *signatureDishViewController=[[TDMSignatureDishViewController alloc]initWithNibName:SIGNATUREDISHCONTROLLER_NIB_NAME bundle:nil];
    TDMNavigationController *signatureDishNavigationController=[[TDMNavigationController alloc]initWithRootViewController:signatureDishViewController];
    [tabItems addObject:signatureDishNavigationController];
    
    REMOVE_FROM_MEMORY(signatureDishViewController)
    REMOVE_FROM_MEMORY(signatureDishNavigationController)
    
    //TabBar item -Favourite
    
    TDMFavoritesViewController *favoritesViewController=[[TDMFavoritesViewController alloc]initWithNibName:FAVOURITEVIEWCONTROLLER_NIB_NAME bundle:nil];
    TDMNavigationController *favouriteNavigationController=[[TDMNavigationController alloc]initWithRootViewController:favoritesViewController];
    [tabItems addObject:favouriteNavigationController];
    
    REMOVE_FROM_MEMORY(favoritesViewController)
    REMOVE_FROM_MEMORY(favouriteNavigationController)
    
    
    //Tabbar Channels
    TDMCityGuidesViewController *cityGuidesViewController = [[TDMCityGuidesViewController alloc]initWithNibName:CITYGUIDE_CONTROLLER_NIB_NAME bundle:nil];
    TDMNavigationController *cityGuideNavigationController=[[TDMNavigationController alloc]initWithRootViewController:cityGuidesViewController];
    [tabItems addObject:cityGuideNavigationController];
    
    REMOVE_FROM_MEMORY(cityGuidesViewController)
    REMOVE_FROM_MEMORY(cityGuideNavigationController)
    
    //Tabbar Channels
    TDMChannelsViewController *channelsViewController = [[TDMChannelsViewController alloc]initWithNibName:CHANNEL_CONTROLLER_NIB_NAME bundle:nil];
    TDMNavigationController *channelsNavigationController=[[TDMNavigationController alloc]initWithRootViewController:channelsViewController];
    [tabItems addObject:channelsNavigationController];
    
    REMOVE_FROM_MEMORY(channelsViewController)
    REMOVE_FROM_MEMORY(channelsNavigationController)
    
    //Adding to the TabBAr
    self.viewControllers=tabItems;
    
    REMOVE_FROM_MEMORY(tabItems)   
    
}

@end
