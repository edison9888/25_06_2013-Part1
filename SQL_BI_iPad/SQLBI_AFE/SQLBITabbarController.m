//
//  SQLBITabbarController.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SQLBITabbarController.h"
#import "UITabBarItem+AFECustom.h"
#import "Utility.h"

#define TAG_OFFSET 1000

@interface SQLBITabbarController ()

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *titleLabelArray;

@end

@implementation SQLBITabbarController
@synthesize buttonArray, titleLabelArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [Utility removeAllSubViewsFromSuperView:self.view];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   
}


-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
}


-(void) setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
    
    [self createCustomTabbarLayout];
    
}

//Creates a custom tab background and buttons that sits on top of the self.view
-(void) createCustomTabbarLayout
{
    UIImageView *tabbarBGView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 719, 1026, 49)];
	tabbarBGView.backgroundColor=[UIColor lightGrayColor];
    tabbarBGView.image=[UIImage imageNamed:@"bottomBar.png"];
    [tabbarBGView setUserInteractionEnabled:YES];
    [self.view addSubview:tabbarBGView];
    
    UIButton *tempButtonItem; 
    
    int iCount = 0;
    float buttonItemWidth = 180;
    float tabDividerWidth = 2;
    UIImageView *tabDividerView;
    
    float tempX = (tabbarBGView.frame.size.width - self.viewControllers.count*buttonItemWidth)/2 - tabDividerWidth*self.viewControllers.count/2;
    
    if(!self.buttonArray)
        self.buttonArray = [[NSMutableArray alloc] init];
    if(!self.titleLabelArray)
        self.titleLabelArray = [[NSMutableArray alloc] init];
    
    for(UIViewController *tempVC in  self.viewControllers)
    {
        tabDividerView = [[UIImageView alloc] initWithFrame:CGRectMake(tempX, 0, tabDividerWidth, tabbarBGView.frame.size.height)];
        tabDividerView.image = [UIImage imageNamed:@"bottomSeparator"];
        [tabDividerView setBackgroundColor:[UIColor whiteColor]];
        [tabbarBGView addSubview:tabDividerView];
    
        tempButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [tempButtonItem setBackgroundImage:nil forState:UIControlStateNormal]; 
        [tempButtonItem setBackgroundImage:[UIImage imageNamed:@"bottomBarSelected"] forState:UIControlStateSelected];
        [tempButtonItem setBackgroundImage:nil forState:UIControlStateHighlighted];
        
        [tempButtonItem setTitleColor:[UIColor colorWithRed:29/255 green:47/255 blue:88/255 alpha:1] forState:UIControlStateNormal];
        [tempButtonItem setTitleColor:[UIColor colorWithRed:29/255 green:47/255 blue:88/255 alpha:1] forState:UIControlStateNormal];
        [tempButtonItem setImage:tempVC.tabBarItem.unselectedImage forState:UIControlStateNormal];
        [tempButtonItem setImage:tempVC.tabBarItem.selectedImage forState:UIControlStateSelected];
        [tempButtonItem setImage:tempVC.tabBarItem.unselectedImage forState:UIControlStateHighlighted];
        CGSize size = [[tempButtonItem titleForState:UIControlStateNormal] sizeWithFont:tempButtonItem.titleLabel.font];
        
        //Even if allignment if made correct with the below two line code, it cannot accomodate bigger text. Eg "Organizational Summary"
        [tempButtonItem setImageEdgeInsets:UIEdgeInsetsMake(-17, 0, 0, -size.width)];
        [tempButtonItem setTitleEdgeInsets:UIEdgeInsetsMake(27, 0, 0, tempButtonItem.imageView.image.size.width + 5)];

        [tempButtonItem setTag:iCount];
        tempButtonItem.frame = CGRectMake(tempX+tabDividerWidth, 0, buttonItemWidth, tabbarBGView.frame.size.height);
        [tempButtonItem addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        tempButtonItem.tag = TAG_OFFSET + iCount;
        [tabbarBGView addSubview:tempButtonItem];
        
        //Adding label to show Title of the button.This was done because of the allignment issue in UIButton. 
        CGRect titleLabelFrame = tempButtonItem.frame;
        titleLabelFrame.origin.x = 0;
        titleLabelFrame.size.height = 13;
        titleLabelFrame.origin.y = 32;
        UILabel *tempTitleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        tempTitleLabel.font = FONT_MAIN_TABBAR;
        tempTitleLabel.textColor = [UIColor blackColor];
        tempTitleLabel.textAlignment = UITextAlignmentCenter;
        tempTitleLabel.backgroundColor = [UIColor clearColor];
        tempTitleLabel.text = tempVC.title;
        tempTitleLabel.tag = tempButtonItem.tag;
        tempTitleLabel.shadowColor = [UIColor whiteColor];
        tempTitleLabel.shadowOffset = CGSizeMake(0, 1);
        
        [tempButtonItem addSubview:tempTitleLabel];
        
        if(self.viewControllers.lastObject == tempVC)
            {
                tabDividerView = [[UIImageView alloc] initWithFrame:CGRectMake(tempX + buttonItemWidth+tabDividerWidth, 0, tabDividerWidth, tabbarBGView.frame.size.height)];
                tabDividerView.image = [UIImage imageNamed:@"bottomSeparator"];
                [tabDividerView setBackgroundColor:[UIColor whiteColor]];
                [tabbarBGView addSubview:tabDividerView];

            }
        
        [self.titleLabelArray addObject:tempTitleLabel];
        [self.buttonArray addObject:tempButtonItem];
    
        tempX += tabDividerWidth + buttonItemWidth;
        
        iCount++;
    }


    
    [self selectTab:0];
    
}


//Catches the Button click and use it to trigger the actual tab selection.
- (void)buttonClicked:(id)sender{
    
	int tagNum = [sender tag];

    [self selectTab:tagNum-TAG_OFFSET];
    
}


//Selects a particular tab with index as tabID and also arranges the view of the custom tab Views
- (void)selectTab:(int)tabID{
    
    UIButton *tempBtn;
    
	for(tempBtn in self.buttonArray)
    {
        
        if(tempBtn.tag == tabID + TAG_OFFSET)
        {
            [tempBtn setUserInteractionEnabled:NO];
            
            for(UILabel *tempLabel in self.titleLabelArray)
            {
                if(tempLabel.tag == TAG_OFFSET + tempBtn.tag)
                {
                    tempLabel.textColor = COLOR_MAIN_TABBAR_SLECTED; //[UIColor colorWithRed:25/255 green:33/255 blue:41/255 alpha:1];
                    break;
                }
            }
            [tempBtn setSelected:YES];
        }
        else
        {
            UILabel * tempLabel;
            
            for(int i = 0; i < self.titleLabelArray.count; i++)
            {
                tempLabel  = (UILabel*) [self.titleLabelArray objectAtIndex:i];
                
                if(tempLabel && tempLabel.tag == (TAG_OFFSET + tempBtn.tag))
                {
                    tempLabel.textColor = COLOR_MAIN_TABBAR_UNSLECTED; //[UIColor colorWithRed:29/255 green:47/255 blue:88/255 alpha:1];
                    break;
                }
            }
            
            [tempBtn setUserInteractionEnabled:YES];
            [tempBtn setSelected:NO];
        }
    }
	
	//self.selectedIndex = tabID;
    [self setSelectedIndex:tabID];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
	
}

-(void) dealloc
{
    
}

@end
