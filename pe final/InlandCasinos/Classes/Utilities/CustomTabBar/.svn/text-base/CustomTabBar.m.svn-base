//
//  CustomTabBar.m
//  PE
//
//  Created by Nithin George on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBar.h"
#import "HomeViewController.h"
#import "ListViewController.h"
#import "MapViewController.h"
#import "MoreViewController.h"
#import "Helper.h"
#import "DetailViewController.h"
#import "MWPhotoBrowser.h"

#import "Utilities.h"

@implementation CustomTabBar

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self customizeTabBarView];
    [self loadTabBarItems];   
    
}

#pragma mark - Customize TabBar

-(void)customizeTabBarView{
    
    customTabItems=[[NSMutableArray alloc]init];
    
    UIView *tabBarView=[[UIView alloc] initWithFrame:CGRectMake(self.tabBar.frame.origin.x, self.view.frame.size.height-49, self.tabBar.frame.size.width,  self.tabBar.frame.size.height)];
    tabBarView.tag=TABBAR_TAG;
     UIImageView *tabbarBackgroundView=[[UIImageView alloc] initWithFrame:CGRectMake(self.tabBar.frame.origin.x, 0, self.tabBar.frame.size.width,  self.tabBar.frame.size.height)];
    tabbarBackgroundView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"bar_image" ofType:@"png"]];
    //tabbarBackgroundView.backgroundColor=[UIColor blackColor ];
    [tabBarView addSubview:tabbarBackgroundView];
    [tabbarBackgroundView release];
    tabbarBackgroundView=nil;
    
    int tabX=TAB_X;
    
    //load custom tabs
    for (int tab=0; tab<DEFAULT_TAB_COUNT; tab++) {
        
        UIButton *btnTab=[[UIButton alloc]init];
        btnTab.frame=CGRectMake(tabX, TAB_Y, TAB_WIDTH, TAB_HEIGHT);
        [btnTab setTitleEdgeInsets:UIEdgeInsetsMake(20.0, 10.0, 0.0, 0.0)];
         btnTab.backgroundColor=[UIColor clearColor];
        
        [btnTab setTag:tab];
        btnTab.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        NSString *tabHeader=[NSString stringWithFormat:@"Tab%d",tab];
        [btnTab setTitle:[self readTabBarItems:tabHeader item:TAB_NAME] forState:UIControlStateNormal];
        //For Orginal TabImage
        [btnTab setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[self readTabBarItems:tabHeader item:ICON_NORMAL]ofType:TAB_IMAGE_TYPE]] forState:UIControlStateNormal];
        
         [btnTab setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[self readTabBarItems:tabHeader item:ICON_SELECT]ofType:TAB_IMAGE_TYPE]] forState:UIControlStateSelected];
       
        if (tab==0){ 
            [btnTab setSelected:TRUE];
            //[btnTab setAlpha:1.0];
        }
        [btnTab addTarget:self action:@selector(tabItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [tabBarView addSubview:btnTab];
        [customTabItems addObject:btnTab];
        [btnTab release];
         btnTab=nil;
        
        tabX=tabX+TAB_X_SPACE;
    }
 
    [self.view addSubview:tabBarView];
    [tabBarView release];
    tabBarView=nil;
    
}

-(void)tabItemPressed:(UIButton *)tab{
   
    //button 1,2,4
    
    switch (tab.tag) {
        case 1:
            activePublisherID =PremierPagePublisherID;
            break;
        case 2:
            activePublisherID =PremierPagePublisherID;
            break;
        case 4:
            activePublisherID =PremierPagePublisherID;
            break;

        default:
            break;
    }
    
    
    [tab setSelected:TRUE];
    //[tab setAlpha:1.0];
    //Set TAB ITEM State
    for (UIButton *tabItem in customTabItems) {
        if (tabItem.tag!=tab.tag){ 
            [tabItem setSelected:FALSE];
            //[tabItem setAlpha:0.6];
        }
                    
    }    
   self.selectedIndex=tab.tag; 
    NSArray *navigationsResultArray = self.viewControllers;
    UINavigationController *navigationcontroller = [navigationsResultArray objectAtIndex:tab.tag];
    [navigationcontroller popToRootViewControllerAnimated:YES];

}


#pragma mark -
#pragma mark TabBarItems Loading methods

- (void)loadTabBarItems{
    
    //Array for storing the TabBAr Items
     NSMutableArray *tabItems=[[NSMutableArray alloc] init];
    //=============================TabBar item -Casinos===============================================================================
    
     HomeViewController *homeViewController=[[HomeViewController alloc]initWithNibName:HOMEVIEWCONTROLLER_NIB_NAME bundle:nil];
    
    //homeViewController.homeSectionItems = [[DBHandler sharedManager]readHomeItems:HOME_TYPE];
   // DebugLog(@"name==%@",[[homeViewController.homeSectionItems objectAtIndex:1] title]);
    
     UINavigationController *homeNavigationController=[[UINavigationController alloc]initWithRootViewController:homeViewController];
     [tabItems addObject:homeNavigationController];
    
     [homeViewController release];
     homeViewController=nil;
     [homeNavigationController release];
     homeNavigationController=nil;
    
    //=============================TabBar item -Dinings===============================================================================
    
     ListViewController *listDiningViewController=[[ListViewController alloc]initWithNibName:LISTVIEWCONTROLLER_NIB_NAME bundle:nil];
     UINavigationController *diningNavigationController=[[UINavigationController alloc]initWithRootViewController:listDiningViewController];
     listDiningViewController.selectedButtonID = 12;
     [tabItems addObject:diningNavigationController];
    
     [listDiningViewController release];
     listDiningViewController=nil;
     [diningNavigationController release];
     diningNavigationController=nil;
    
    //=============================TabBar item -Events===============================================================================
    
     ListViewController *listEventViewController=[[ListViewController alloc]initWithNibName:LISTVIEWCONTROLLER_NIB_NAME bundle:nil];
     UINavigationController *eventNavigationController=[[UINavigationController alloc]initWithRootViewController:listEventViewController];
     listDiningViewController.selectedButtonID = 13;
     [tabItems addObject:eventNavigationController];
     
     [listEventViewController release];
     listEventViewController=nil;
     [eventNavigationController release];
     eventNavigationController=nil;
    
    //=============================TabBar item -Map==================================================================================
    
     MapViewController *mapViewController=[[MapViewController alloc]initWithNibName:MAPVIEWCONTROLLER_NIB_NAME bundle:nil];
     mapViewController.mapLink = TABBAR_LOCATION_LINK;
     UINavigationController *mapNavigationController=[[UINavigationController alloc]initWithRootViewController:mapViewController];
     listDiningViewController.selectedButtonID = 0;
     [tabItems addObject:mapNavigationController];
    
     [mapViewController release];
      mapViewController=nil;
     [mapNavigationController release];
      mapNavigationController=nil;
    
    //=============================TabBar item -More=================================================================================
    
     MoreViewController *moreViewController=[[MoreViewController alloc]initWithNibName:MOREVIEWCONTROLLER_NIB_NAME bundle:nil];
     UINavigationController *moreNavigationController=[[UINavigationController alloc]initWithRootViewController:moreViewController];
     [tabItems addObject:moreNavigationController];
     
     [moreViewController release];
     moreViewController=nil;
     [moreNavigationController release];
     moreNavigationController=nil;
    
    //================================================================================================================================
    
    //Adding to the TabBAr
    self.viewControllers=tabItems;
    [tabItems release];
    tabItems = nil;    
    
}

#pragma mark -Class Utilities

//For reading Tabbaritems
-(NSString *)readTabBarItems:(NSString *)rootName item:(NSString *)item{
    
    if(tabBarItems==nil)
       tabBarItems=[[Helper share]readLayoutItems:ROOT_TAB_NAME];
    
    return ([[tabBarItems objectForKey:rootName] objectForKey:item]);

}


#pragma mark -
#pragma mark Orientation methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    UINavigationController *navController = (UINavigationController *)self.selectedViewController;
    UIViewController *visibleViewController = [navController visibleViewController];
    
    if( [visibleViewController isKindOfClass:[DetailViewController class]] || [visibleViewController isKindOfClass:[MWPhotoBrowser class]] ){
         return YES;
    }
       
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation== UIDeviceOrientationPortraitUpsideDown);

    
}

#pragma mark -
#pragma mark Memory Release methods

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc{
    //[tabBarItems release];
    [customTabItems release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{
    
}


@end
