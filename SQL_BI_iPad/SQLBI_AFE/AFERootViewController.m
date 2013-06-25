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
CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};



@interface AFERootViewController ()
{
    BOOL isSearchPopoverShown;
    UIImageView *bgImageView;
    PrintANDMailViewController *shareViewController;
    NSData *dataImage;
    BOOL orientationLeft;
    MFMailComposeViewController *picker;


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
    return @"";
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
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        orientationLeft = YES;
    }
    if(interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        orientationLeft = NO;
    }
    
	return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight)) ;
}



#pragma mark - View Creations
//this will create the search Button in the NavigationBar
- (void)createCommonButtonsInNavigationBar{
    
    if(self.navigationItem.rightBarButtonItem.customView)
    {
        [self.navigationItem.rightBarButtonItem.customView removeFromSuperview];
    }
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 43, 39)];
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
    
    searchBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    //searchBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"searchIcon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(searchButtonClicked:)];
    searchBarButtonItem.style = UIBarButtonItemStyleDone;
    
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
    [self disMissAllPopOver];
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
    [self disMissAllPopOver];
    UIView *tempView = shareBarButtonItem.customView;
    UIButton *tempBtn = (UIButton*)[tempView viewWithTag:KSHARE_BTN_TAG];
        //  UIButton *tempBtn = (UIButton*) self.navigationItem.rightBarButtonItem.customView;
    
    if(tempBtn)
        {
            [tempBtn setSelected:YES];
        }
    
    
        [self showShareViewController];
    
    
}

-(void)disMissAllPopOver{
    

}

-(void) showSearchController
{
    //Need to ovverride in the sub class

}


-(void) showShareViewController{
    
    if (sharePopOver) {
        [sharePopOver dismissPopoverAnimated:YES];
        sharePopOver = nil;
    }
    
    shareViewController = [[PrintANDMailViewController alloc] initWithNibName:@"PrintANDMailViewController" bundle:nil];
    shareViewController.delegate = self;
    sharePopOver = [[UIPopoverController alloc] initWithContentViewController:shareViewController];
    sharePopOver.delegate = self;
    [sharePopOver  setPopoverContentSize:shareViewController.view.frame.size animated:YES];
    [sharePopOver presentPopoverFromBarButtonItem:shareBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
#pragma mark - PrintANDEmail Delegate
#pragma mark -


-(void)mailButtonClicked{
    
    [sharePopOver dismissPopoverAnimated:YES];
    [self didDismissSearchController];
    [self captureScreen];
    [self sendMail];
    
}

-(void)printButtonClicked{
    
    [picker dismissModalViewControllerAnimated:YES];
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
    
    UIImage * LandscapeImage = [self scaleAndRotateImage:image];
    dataImage = UIImagePNGRepresentation(LandscapeImage);  
}
- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 900; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    
    boundHeight = bounds.size.height;
    bounds.size.height = bounds.size.width;
    bounds.size.width = boundHeight;
    transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width/3.0);
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ){
        transform = CGAffineTransformRotate(transform, M_PI/2.0);

    }
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ){
        transform = CGAffineTransformRotate(transform, M_PI / 2.0);

    }

   
       
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIImageOrientation orient = image.imageOrientation;
        
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
   
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ){
        imageCopy = [self imageRotatedByDegrees:180 :imageCopy];
        
    }
    return imageCopy;
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees :(UIImage*)image
{   
        //degrees = 270;
        // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
        // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
        // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
        //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
        // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;    
}

-(void)sendMail 
{
    picker = [[MFMailComposeViewController alloc] init];
    
    [picker shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    
    picker.mailComposeDelegate = self;
    
    [picker setSubject:[self getEmailSubjectLine]];
    
        // Set up recipients
    
    //NSArray *toRecipients = [NSArray arrayWithObject:@"support@sqlandbi.com"]; 
    
    //[picker setToRecipients:toRecipients];
    
    
    //NSData *myData= [NSData dataWithData:dataImage];
    
    [picker addAttachmentData:dataImage mimeType:@"image/png" fileName:@"Image.png"];
    
        // Fill out the email body text
    
    NSString *emailBody = @"Image is attached";
    
    [picker setMessageBody:emailBody isHTML:NO];
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    
    [topWindow addSubview:picker.view];
    
    [self presentModalViewController:picker animated:YES];
    
}

-(NSString*) getEmailSubjectLine
{
    return [self getTabbarTitle]? [self getTabbarTitle]:@"";
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

-(BOOL)shouldAutorotate {
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationLandscapeLeft;
}

#pragma mark - Memory management

- (void)dealloc
{

}


@end
