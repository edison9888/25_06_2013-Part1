//
//  AFERootViewController.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFERootViewController.h"
#define KSEARCH_BTN_TAG 1111
#define KSHARE_BTN_TAG 2222


@interface AFERootViewController ()
{
    BOOL isSearchPopoverShown;
    UIImageView *bgImageView;
    PrintANDMailViewController *shareViewController;
    NSData *dataImage;


}

- (void)createCommonButtonsInNavigationBar;
- (void)createAFELogoInNavigationBar;
- (void)searchButtonClicked:(id)sender;
-(void) addBackground;

@end

@implementation AFERootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        isSearchPopoverShown = NO;
        
    }
    return self;

}


-(NSString*) getTabbarTitle
{
    return @"Data Warehouse - AFE Dashboard";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addBackground];
    [self.navigationController customizeNavigationBarForAFE];
    [self createCommonButtonsInNavigationBar];
    [self createAFELogoInNavigationBar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}



#pragma mark - View Creations
//this will create the search Button in the NavigationBar
- (void)createCommonButtonsInNavigationBar{
    
    if(self.navigationItem.rightBarButtonItem.customView)
    {
        [self.navigationItem.rightBarButtonItem.customView removeFromSuperview];
    }
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(57,0, 43, 39)];
    searchButton.tag = KSEARCH_BTN_TAG;
    [searchButton setImage:[UIImage imageNamed:@"searchIcon.png"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"searchIcon.png"] forState:UIControlStateHighlighted];
    [searchButton setImage:[UIImage imageNamed:@"searchIconSelected.png"] forState:UIControlStateSelected];
    searchButton.backgroundColor = [UIColor clearColor];
    
    [searchButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5)
    {
        searchButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }
    //[containerView addSubview:searchButton];
    
    searchBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    searchBarButtonItem.style = UIBarButtonItemStylePlain;
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 43, 39)];
    shareButton.tag = KSHARE_BTN_TAG;
    [shareButton setImage:[UIImage imageNamed:@"shareIcon.png"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"shareIconHover.png"] forState:UIControlStateHighlighted];
    [shareButton setImage:[UIImage imageNamed:@"shareIconHover.png"] forState:UIControlStateSelected];
    shareButton.backgroundColor = [UIColor clearColor];
    
    [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5){
        shareButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }
    
    shareBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    shareBarButtonItem.style = UIBarButtonItemStylePlain;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:searchBarButtonItem, shareBarButtonItem, nil];
    
    
}

-(void) addBackground
{
    if(bgImageView)
        [bgImageView removeFromSuperview];
    else
        bgImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    
    bgImageView.image = [UIImage imageNamed:@"textureBg"];
    [self.view addSubview: bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
}

//this will create the SQLandBI Logo in the NavigationBar
- (void)createAFELogoInNavigationBar{
    
    UIBarButtonItem *tempBarButton = self.navigationItem.leftBarButtonItem;
    if (tempBarButton==nil) {
        UIImage *tempLogoImage = [Utility resizedImage:[UIImage imageNamed:@"logo.png"] forWidth:41 forHeight:36];
        //UIImageView *gvLogo = [[UIImageView alloc]initWithImage:tempLogoImage];
        
        UIButton *gvLogo = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 41, 36)];
        [gvLogo setImage:tempLogoImage forState:UIControlStateNormal];
        gvLogo.userInteractionEnabled = NO;
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5)
        {
            gvLogo.imageEdgeInsets = UIEdgeInsetsMake(5, 5, -5, -5);
        }
        
        UIBarButtonItem *imageBarLogo = [[UIBarButtonItem alloc]initWithCustomView:gvLogo];
        imageBarLogo.style = UIBarButtonItemStylePlain;
        
        self.navigationItem.leftBarButtonItem =imageBarLogo;
    }
}


#pragma mark  - Event Handlers
//this is the click effect of search button on the navigationBar
- (void)searchButtonClicked:(id)sender{
    
    if(sharePopOver)
    {
        @try {
            [sharePopOver dismissPopoverAnimated:NO];
            
            UIView *tempView = shareBarButtonItem.customView;
            UIButton *tempBtn = (UIButton*) tempView;
            
            if(tempBtn)
            {
                [tempBtn setSelected:NO];
            }
        }
        @catch (NSException *exception) {
                    
        }
    }
    
    UIView *tempView = searchBarButtonItem.customView; //self.navigationItem.rightBarButtonItem.customView;
    UIButton *tempBtn = (UIButton*)[tempView viewWithTag:KSEARCH_BTN_TAG];
        //  UIButton *tempBtn = (UIButton*) self.navigationItem.rightBarButtonItem.customView;
    
    if(tempBtn)
    {
        [tempBtn setSelected:YES];
    }

    
    [self showSearchController];
    
    
}

- (void)shareButtonClicked:(id)sender{
    
    UIView *tempView = shareBarButtonItem.customView;
    UIButton *tempBtn = (UIButton*)[tempView viewWithTag:KSHARE_BTN_TAG];
        //  UIButton *tempBtn = (UIButton*) self.navigationItem.rightBarButtonItem.customView;
    
    if(tempBtn)
        {
            [tempBtn setSelected:YES];
        }
    
    
        [self showShareViewController];
    
    
}


-(void) showSearchController
{
    //Need to ovverride in the sub class

}


-(void) showShareViewController{
    if (sharePopOver) {
        [sharePopOver dismissPopoverAnimated:NO];
        sharePopOver = nil;
    }
    shareViewController = [[PrintANDMailViewController alloc] initWithNibName:@"PrintANDMailViewController" bundle:nil];
    shareViewController.delegate = self;
        //  UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:shareViewController];
    sharePopOver = [[UIPopoverController alloc] initWithContentViewController:shareViewController];
    sharePopOver.delegate = self;
    [sharePopOver  setPopoverContentSize:shareViewController.view.frame.size animated:YES];
    [sharePopOver presentPopoverFromBarButtonItem:shareBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)mailButtonClicked{
    
    [sharePopOver dismissPopoverAnimated:YES];
    [self didDismissSearchController];
    [self captureScreen];
    [self sendMail];
    
}

-(void)printButtonClicked{
    
    [sharePopOver dismissPopoverAnimated:YES];
    [self didDismissSearchController];
    [self captureScreen];
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *lastView = (UIView *)[[topWindow subviews]lastObject];
    SPPrintHandler *printHandler = [[SPPrintHandler alloc] init];
    [printHandler printFileOrientation:UIPrintInfoOrientationLandscape popUpFromRect:CGRectMake(1024, 44, 300, 300) delegate:self printData:dataImage AndDisplayView:lastView];
    
}

-(void)captureScreen{
    
    UIWindow *windows = [[UIApplication sharedApplication] keyWindow];
    
    CGRect rect = windows.layer.bounds;
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [windows.layer renderInContext:context];  
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImage * LandscapeImage = image;
    UIImage * PortraitImage = [[UIImage alloc] initWithCGImage: LandscapeImage.CGImage
                                                         scale: 1.0
                                                   orientation: UIImageOrientationRight];
    
    dataImage = UIImagePNGRepresentation(PortraitImage);  
}

-(void)sendMail 
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    [picker shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    
    picker.mailComposeDelegate = self;
    
    [picker setSubject:[self getTabbarTitle]? [self getTabbarTitle]:@"Dashboard AFE - Organisation Summary"];
    
        // Set up recipients
    
    NSArray *toRecipients = [NSArray arrayWithObject:@"support@sqlandbi.com"]; 
    
    [picker setToRecipients:toRecipients];
    
    
    //NSData *myData= [NSData dataWithData:dataImage];
    
    [picker addAttachmentData:dataImage mimeType:@"image/png" fileName:@"Image.png"];
    
        // Fill out the email body text
    
    NSString *emailBody = @"Image is attached";
    
    [picker setMessageBody:emailBody isHTML:NO];
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    
    [topWindow addSubview:picker.view];
    
    [self presentModalViewController:picker animated:YES];
    
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    
        // Notifies users about errors associated with the interface
    
    switch (result)
    
    {
        
        case MFMailComposeResultCancelled:
        
        NSLog(@"Result: canceled");
        
        break;
        
        case MFMailComposeResultSaved:
        
        NSLog(@"Result: saved");
        
        break;
        
        case MFMailComposeResultSent:
        
        NSLog(@"Result: sent");
        
        break;
        
        case MFMailComposeResultFailed:
        
        NSLog(@"Result: failed");
        
        break;
        
        default:
        
        NSLog(@"Result: not sent");
        
        break;
        
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
}



-(void) didDismissSearchController
{
    UIView *tempView = searchBarButtonItem.customView;
    UIButton *tempBtn = (UIButton*)[tempView viewWithTag:KSEARCH_BTN_TAG];
    
    if(tempBtn)
    {
        [tempBtn setSelected:NO];
    }
    
    tempView = shareBarButtonItem.customView;
    UIButton *tempButton = (UIButton*)[tempView viewWithTag:KSHARE_BTN_TAG];
    
    if(tempButton){
        [tempButton setSelected:NO];
    }

}


#pragma mark - Memory management

- (void)dealloc
{

}


@end
