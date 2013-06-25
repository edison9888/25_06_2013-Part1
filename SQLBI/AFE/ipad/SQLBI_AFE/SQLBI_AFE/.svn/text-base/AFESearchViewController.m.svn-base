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
        self.navigationItem.title = @"Data Warehouse - AFE Dashboard";
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

/*
-(void)showShareViewController{
    if (searchPopOver) {
        
        [searchPopOver dismissPopoverAnimated:NO];
        searchPopOver = nil;
    }
    shareViewController = [[PrintANDMailViewController alloc] initWithNibName:@"PrintANDMailViewController" bundle:nil];
    shareViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:shareViewController];
    searchPopOver = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    searchPopOver.delegate = self;
    [searchPopOver  setPopoverContentSize:CGSizeMake(250,150) animated:YES];
    [searchPopOver presentPopoverFromRect:CGRectMake(930, -7, 1, 1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        // [searchPopOver presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}
 */

#pragma mark -
#pragma mark ShareViewDelegate
/*
-(void)mailButtonClicked{
    [searchPopOver dismissPopoverAnimated:YES];
    [self didDismissSearchController];
    [self captureScreen];
    [self sendMail];
    
}
-(void)printButtonClicked{
    [searchPopOver dismissPopoverAnimated:YES];
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
    
    dataImage = UIImagePNGRepresentation(image);  
}
-(void)sendMail 
{
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    [picker shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Check out this image!"];
    
    
    
        // Set up recipients
    
    NSArray *toRecipients = [NSArray arrayWithObject:@"sqlbi@gmail.com"]; 
    
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
*/


-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self didDismissSearchController];
}

#pragma mark - OrganizationSearchController delegate methods

-(void) searchWithDataAFEID:(NSString *)afeID
{
    [[NSUserDefaults standardUserDefaults] setObject:afeID forKey:@"AFESearchAFEID"];
    [[NSUserDefaults standardUserDefaults] setObject:afeID forKey:@"afeNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:afeID forKey:@"afeName"];
    
    [self.detailViewController callAPIforAFEDetailWithAfeID:afeID]; 
    if(searchPopOver)
    {
        [searchPopOver dismissPopoverAnimated:YES];
        [self didDismissSearchController];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
