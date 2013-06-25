//
//  AFESearchViewController.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFESearchViewController.h"

@interface AFESearchViewController ()
{
    SearchViewController_AFE *afeSearchController;
    PrintANDMailViewController *shareViewController;
    NSData *dataImage;
}

@property (nonatomic,strong) UIPopoverController *searchPopOver;
@property (nonatomic,strong) AFESearchDetailViewController *detailViewController;

-(void) searchWithDataAFEID:(NSString *)afeID;

@end

@implementation AFESearchViewController

@synthesize searchPopOver;
@synthesize detailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = TAB_TITLE_AFE_SEARCH;
        self.navigationItem.title = [self getTabbarTitle];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"currencyActive"];
        self.tabBarItem.unselectedImage = [UIImage imageNamed:@"currency"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailViewController = [[AFESearchDetailViewController alloc]init];
    if(self.detailViewController.view.superview != self.view)
    {
        self.detailViewController.view.frame = CGRectMake(16,16,self.detailViewController.view.frame.size.width, self.detailViewController.view.frame.size.height);
        self.detailViewController.delegate = self;
    }
    [self.view addSubview:self.detailViewController.view];
    [self.view bringSubviewToFront:self.detailViewController.view];
}


#pragma mark - Ovverridden methods
-(void) showSearchController
{
    if (searchPopOver) {
        
        [searchPopOver dismissPopoverAnimated:NO];
        searchPopOver = nil;
    }

    afeSearchController = [[SearchViewController_AFE alloc] initWithNibName:@"SearchViewController_AFE" bundle:nil];
    afeSearchController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:afeSearchController];
    searchPopOver = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    searchPopOver.delegate = self;
    [searchPopOver  setPopoverContentSize:CGSizeMake(350,400) animated:YES];
    [searchPopOver presentPopoverFromBarButtonItem:searchBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

}

-(void) showShareViewController
{
    if(searchPopOver)
    {
        @try {
            [searchPopOver dismissPopoverAnimated:NO];
            
            UIView *tempView = searchBarButtonItem.customView;
            UIButton *tempBtn = (UIButton*) tempView;
            
            if(tempBtn)
            {
                [tempBtn setSelected:NO];
            }
        }
        @catch (NSException *exception) {
            
        }
        
    }
    
    [super showShareViewController];
    
}

-(NSString*) getTabbarTitle
{
    NSString *resultString = @"";
    
    NSString *currentlySelectedAFEName = [[NSUserDefaults standardUserDefaults] objectForKey:@"afeName"];
        
    NSString *currentlySelectedAFENumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"afeNumber"];
    
    if(currentlySelectedAFEName && ![currentlySelectedAFEName isEqualToString:@""] && currentlySelectedAFENumber && ![currentlySelectedAFENumber isEqualToString:@""])
    {
        resultString = [NSString stringWithFormat:@"%@ - %@",currentlySelectedAFENumber, currentlySelectedAFEName];
    }
    
    
    return resultString;
}


-(NSString*) getEmailSubjectLine
{
    NSString *resultString = [self getTabbarTitle];
    
    return resultString;
    
}



-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self didDismissSearchController];
}

#pragma mark - OrganizationSearchController delegate methods

-(void) searchWithDataAFEID:(NSString *)afeID
{
    self.navigationItem.title = [self getTabbarTitle];
    
    [self.detailViewController callAPIforAFEDetailWithAfeID:afeID]; 
    if(searchPopOver)
    {
        [searchPopOver dismissPopoverAnimated:YES];
        [self didDismissSearchController];
    }
}


#pragma mark - For Other classes to trigger the search
-(void) searchAFEDetailsWithAFEObject:(AFE*) afeObj
{
    if(afeObj)
    {
        [[NSUserDefaults standardUserDefaults] setObject:afeObj.afeID forKey:@"AFESearchAFEID"];
        [[NSUserDefaults standardUserDefaults] setObject:afeObj.afeNumber forKey:@"afeNumber"];
        [[NSUserDefaults standardUserDefaults] setObject:afeObj.name forKey:@"afeName"];
        
        [[NSUserDefaults standardUserDefaults] setObject:afeObj.afeID forKey:@"AFESearchAFEID"];
        [[NSUserDefaults standardUserDefaults] setObject:afeObj.afeNumber forKey:@"afeNumberAFESearch"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"afeNameAFESearch"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"AFESearchType"];
        
        [self searchWithDataAFEID:afeObj.afeID];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//	return YES;
//}

@end
