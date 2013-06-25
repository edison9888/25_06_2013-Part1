//
//  TDMCustomTabBar.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 13/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMCustomTabBar.h"
#import <QuartzCore/QuartzCore.h>
#import "TDMNavigationController.h"
#import "TDMBarsViewController.h"
#import "TDMRestaurantsViewController.h"
#import "TDMMoreView.h"
#import "TDMChannelsViewController.h"
#import "TDMCityGuideViewController.h"
#import "TDMSignatureDishViewController.h"
#import "TDMAddSignatureDishViewController.h"
#import "TDMMyFavoritesViewController.h"

@implementation TDMCustomTabBar

#define TABBAR_TAG 100
#define TAB_IMAGE_TYPE @"png"
#define kBARS_TABBAR_INDEX 0
#define kRESTAURANTS_TABBAR_INDEX 1
#define kADD_DISH_TABBAR_INDEX 2
#define kSIGNATUE_DISH_TABBAR_INDEX 3
#define kMORE_TABBAR_INDEX 4
#define TAB_X 0
#define TAB_Y 9
#define DEFAULT_TAB_COUNT 5
#define ADD_DISH_BUTTON_Y 3
#define TAB_WIDTH 60
#define TAB_HEIGHT 50
#define ADD_DISH_BUTTON_HIGHT 55
#define BUTTON_TITLE_RECT CGRectMake(tabX, 43, 55, 10)
#define kARRAY_OF_BAR_NAMES [NSArray arrayWithObjects:@"Bars",@"Restaurants",@"Add Dish",@"Best Dishes",@"More",nil]
#define TAB_X_SPACE 65;
#define kWISH_LIST_TABBAR_INDEX 4
#define kCITY_GUIDE_TABBAR_INDEX 5
#define kCHANNEL_TABBAR_INDEX 6

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc 
{
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTabBarItems];
    
    [self customizeTabBarItems];
    
    UIButton *addDishSelectedButton = (UIButton*)[customTabItems objectAtIndex:kSIGNATUE_DISH_TABBAR_INDEX];
    [self tabItemPressed:addDishSelectedButton];
    [self setSelectedIndex:kSIGNATUE_DISH_TABBAR_INDEX];
}

#pragma mark - Handle Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Customize TabBar 

-(void)removeDefaultTabbarButton    {
    //to avoid display of more view.
    
    for (UIView *subView in [self.view subviews]) {
        if ([subView isKindOfClass:[UITabBar class]]) {
            
            for (UIView *tabSubView in [subView subviews]) {
                if ([[[tabSubView class] description] isEqualToString:@"UITabBarButton"]) {
    
                        [tabSubView removeFromSuperview];
                }
            }
        }
    }
}

- (void)customizeTabBarItems
{
    customTabItems=[[NSMutableArray alloc]init];
    
    tabBarView=[[UIView alloc] initWithFrame:CGRectMake(self.tabBar.frame.origin.x, self.view.frame.size.height-58, self.tabBar.frame.size.width ,  self.tabBar.frame.size.height)];
    tabBarView.tag=TABBAR_TAG;
    tabBarView.backgroundColor=[UIColor clearColor];
    
    UIImageView *tabbarBackgroundView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tabBar.frame.size.width ,  (self.tabBar.frame.size.height + 9))];
    tabbarBackgroundView.image = [UIImage imageNamed:@"tabbarBG"];
    tabbarBackgroundView.backgroundColor=[UIColor clearColor];
    [tabBarView addSubview:tabbarBackgroundView];
    [tabbarBackgroundView release];
    tabbarBackgroundView=nil;
    
     int tabX=TAB_X;
    
    for (int tab=0; tab<DEFAULT_TAB_COUNT; tab++)
    {
        NSString *normalIconSelectedImagePath=[NSString stringWithFormat:@"iconSelected%d",tab];
        UIButton *btnTab=[[UIButton alloc]init];
        if (kADD_DISH_TABBAR_INDEX == tab) 
        {
            btnTab.frame=CGRectMake(tabX+4, ADD_DISH_BUTTON_Y, 56, 56);
        }
        else
        {
            btnTab.frame=CGRectMake(tabX, TAB_Y, TAB_WIDTH, TAB_HEIGHT);
        }
        
        [btnTab setTitleEdgeInsets:UIEdgeInsetsMake(0, 0.0, 0.0, 0.0)];
        btnTab.backgroundColor=[UIColor clearColor];
        [btnTab setTag:tab];
        btnTab.titleLabel.font = kGET_BOLD_FONT_WITH_SIZE(10);
        [btnTab setTitle:[kARRAY_OF_BAR_NAMES objectAtIndex:tab] forState:UIControlStateNormal];
        btnTab.titleLabel.shadowColor=[UIColor grayColor];
        [btnTab.titleLabel setShadowOffset:CGSizeMake(1.0f, 1.0f)];

        [btnTab setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
        [btnTab setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        NSString *normalIconImagePath=[NSString stringWithFormat:@"iconNormal%d",tab];
        [btnTab setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:normalIconImagePath ofType:TAB_IMAGE_TYPE]] forState:UIControlStateNormal];
        [btnTab setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:normalIconSelectedImagePath ofType:TAB_IMAGE_TYPE]] forState:UIControlStateSelected];     
//        if (kADD_DISH_TABBAR_INDEX == tab)
//        { 
//            [btnTab setSelected:TRUE];
//        }
        [btnTab addTarget:self action:@selector(tabItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [tabBarView addSubview:btnTab];
        [customTabItems addObject:btnTab];
        [btnTab release];
        btnTab=nil;
        
        tabX=tabX+TAB_X_SPACE;
    }
    [self.view addSubview:tabBarView];
    [tabBarView release];
}
- (int)getSelectedTabIndex
{
  
    int selectedIndex = [[[NSUserDefaults standardUserDefaults]objectForKey:PREVIOUSLY_SELECTED_TAB_ID]intValue];
    
    return selectedIndex;
}

- (void)selectTabAtIndex:(int)index {
    
    if(index < ([customTabItems count] - 1)){
        UIButton *tabbuttun = [customTabItems objectAtIndex:index];
        [self tabItemPressed:tabbuttun];
    }
}
- (void)tabItemPressed:(UIButton *)tab 
{
    //to remove default tabbar buttons.
    //why we call on every tabItemPressed is because of the default button is created when a non-visible viewcontroller put in display.
    [self removeDefaultTabbarButton];
    
   // [NSUserDefaults standardUserDefaults]setInteger:tab.tag forKey:<#(NSString *)#>
    [tab setSelected:TRUE];
    for (UIButton *tabItem in customTabItems) {
        if (tabItem.tag!=tab.tag) {
            [tabItem setSelected:FALSE];
        }
    }
    
    if (tab.tag == kMORE_TABBAR_INDEX)
    {
        TDMMoreView *moreView = [[TDMMoreView alloc]initWithFrame:CGRectMake(400,0, 400,400)];
        [self.view addSubview:moreView];
        [moreView release];
    }

    else
    {
        [[NSUserDefaults standardUserDefaults] setInteger:tab.tag  forKey:PREVIOUSLY_SELECTED_TAB_ID];
        self.selectedIndex=tab.tag; 
        NSArray *navigationsResultArray = self.viewControllers;
        UINavigationController *navigationcontroller = [navigationsResultArray objectAtIndex:tab.tag];
        [navigationcontroller popToRootViewControllerAnimated:NO];
        
        TDMSignatureDishViewController *signatureController = (TDMSignatureDishViewController *)[navigationcontroller visibleViewController];
        if([signatureController isKindOfClass:[TDMSignatureDishViewController class]]){
            [signatureController gotoPageAtIndex:0];
        }
        
        [self setSelectedIndex:tab.tag];
    }
}

- (void)loadTabBarItems
{
    NSMutableArray *tabItems=[[NSMutableArray alloc] init];
    TDMBarsViewController *barViewController=[[TDMBarsViewController alloc]initWithNibName:@"TDMBarsViewController" bundle:nil];
    TDMNavigationController *barNavigationController=[[TDMNavigationController alloc]initWithRootViewController:barViewController];
    
    [tabItems addObject:barNavigationController];
    REMOVE_FROM_MEMORY(barViewController)
    REMOVE_FROM_MEMORY(barNavigationController)
    
    
    TDMRestaurantsViewController *restaurantsViewController=[[TDMRestaurantsViewController alloc]initWithNibName:@"TDMRestaurantsViewController" bundle:nil];
    TDMNavigationController *restNavigationController=[[TDMNavigationController alloc]initWithRootViewController:restaurantsViewController];
    [tabItems addObject:restNavigationController];
    REMOVE_FROM_MEMORY(restaurantsViewController)
    REMOVE_FROM_MEMORY(restNavigationController)
    
    //Add Dish
    TDMAddSignatureDishViewController *addDishViewController = 
                                        [[TDMAddSignatureDishViewController alloc]
                                         initWithNibName:@"TDMAddSignatureDishViewController" 
                                         bundle:nil];
     TDMNavigationController *addDishNavigationController=[[TDMNavigationController alloc]initWithRootViewController:addDishViewController];
    [tabItems addObject:addDishNavigationController];
    REMOVE_FROM_MEMORY(addDishViewController)
    REMOVE_FROM_MEMORY(addDishNavigationController)
    
    //Signature Dish
    TDMSignatureDishViewController *signatureDishViewController = [[TDMSignatureDishViewController alloc] initWithNibName:@"TDMSignatureDishViewController" bundle:nil];
    TDMNavigationController *signatureDishNavigationController=[[TDMNavigationController alloc]initWithRootViewController:signatureDishViewController];
    [tabItems addObject:signatureDishNavigationController];
    
    REMOVE_FROM_MEMORY(signatureDishViewController)
    REMOVE_FROM_MEMORY(signatureDishNavigationController)
    
    //Tabbar City Guide
    TDMCityGuideViewController *cityGuidesViewController = [[TDMCityGuideViewController alloc]initWithNibName:@"TDMCityGuideViewController" bundle:nil];
    TDMNavigationController *cityGuideNavigationController=[[TDMNavigationController alloc]initWithRootViewController:cityGuidesViewController];
    [tabItems addObject:cityGuideNavigationController];
    
    REMOVE_FROM_MEMORY(cityGuidesViewController)
    REMOVE_FROM_MEMORY(cityGuideNavigationController)
     
    // Channels 
    TDMChannelsViewController *channelsViewController = [[TDMChannelsViewController alloc]initWithNibName:@"TDMChannelsViewController" bundle:nil];
    TDMNavigationController *channelsNavigationController=[[TDMNavigationController alloc]initWithRootViewController:channelsViewController];
    [tabItems addObject:channelsNavigationController];
    
    REMOVE_FROM_MEMORY(channelsViewController)
    REMOVE_FROM_MEMORY(channelsNavigationController) 
    
    TDMMyFavoritesViewController *favoritesViewController = [[TDMMyFavoritesViewController alloc]initWithNibName:@"TDMMyFavoritesViewController" bundle:nil];
     TDMNavigationController *favoritesNavigationController=[[TDMNavigationController alloc]initWithRootViewController:favoritesViewController];
    
    [tabItems addObject:favoritesNavigationController];
    REMOVE_FROM_MEMORY(favoritesViewController)
    REMOVE_FROM_MEMORY(favoritesNavigationController)
    
    self.viewControllers = tabItems;
    [tabItems release];
}

- (void)changeInteratcion:(BOOL)value
{
    tabBarView.userInteractionEnabled = value;
}

@end
