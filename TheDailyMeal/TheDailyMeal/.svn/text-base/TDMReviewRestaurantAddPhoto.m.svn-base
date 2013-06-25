//
//  TDMReviewRestaurantAddPhoto.m
//  TheDailyMeal
//
//  Created by Apple on 19/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//


#import "TDMReviewRestaurantAddPhoto.h"
#import "TDMPhotoUploadService.h"
#import "DatabaseManager.h"
#import "AppDelegate.h"

@class AppDelegate;

@implementation TDMReviewRestaurantAddPhoto

@synthesize addPhotoButton;
@synthesize skipButton;
@synthesize contentLabel,shareButton;
@synthesize imageData,reviewText,restaurantName,facebookShareContent;
@synthesize reviewTitle;
@synthesize reviewDescription;
@synthesize businessId;

- (void)popViewToDetailList {
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    int viewControllerCount = [viewControllers count];
    UIViewController *viewController = [viewControllers objectAtIndex:(viewControllerCount - 3)];
    [self.navigationController popToViewController:viewController animated:YES];
}

- (void)navBarButtonClicked:(id)sender {
 
    [self popViewToDetailList];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
        [self.navigationItem setTDMIconImage];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {

    [super viewDidLoad];
    [self createAdView];
    [self.contentLabel setText:@"Your review has been uploaded"];
    contentLabel.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.addPhotoButton = nil;
    self.skipButton = nil;
    self.contentLabel = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - button Clicks

- (IBAction)addPhotoClick:(id)sender {
    
    UIActionSheet *actionSheet; 
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:self 
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:nil 
                                     otherButtonTitles:@"Take Photo",@"Choose from Library",nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.tabBarController.view];
    [actionSheet release];
}

- (IBAction)skipButtonClick:(id)sender {
    
    [self showOverlayView];
    TDMAddBusinessReviewService *addReview = [[TDMAddBusinessReviewService alloc]init];
    addReview.businessReviewServicedelegate= self;
    [addReview addBusinessReviewWithBody:self.reviewDescription andTitle:self.reviewTitle forVenue:[NSString stringWithFormat:@"%d",businessId]];
   
}

#pragma mark - Camera Handler methods

- (BOOL)isDeviceHasCamera {
    
    BOOL isAvailable = NO;
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] ||
        [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        isAvailable = YES;
    }
    return isAvailable;
}

- (void)showAlertNoDevice {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meal" 
                                                   message:@"Sorry, your device does not have a camera." 
                                                  delegate:nil 
                                         cancelButtonTitle:@"OK" 
                                         otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark- add photo methods
- (void)takePhotoFromCamera {
    
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        
        picker.sourceType = 
        UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = NO;
        picker.delegate = self;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        [[self navigationController] presentModalViewController:picker animated:YES];
    }
    else
    {
        kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, ERROR_MSG_DIVICE_WITH_NO_CAMERA);
    }
    [picker release];
}

- (void)showImagesInPhotoLibrary {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self.navigationController presentModalViewController:imagePickerController animated:YES];
    [imagePickerController release];
    imagePickerController = nil;
}
#pragma mark    Overlay View Management

- (void)removeOverlayView {
    if (overlayView) {
        [overlayView removeFromSuperview];
        [overlayView release];
        overlayView = nil;
    }
}

- (void)showOverlayView {
    
    [self removeOverlayView];
    overlayView = [[TDMOverlayView alloc] initWithSyncStyleAndTitle:@"Adding Review..."];
}

#pragma mark - upload Image

- (void)uploadImage:(NSData* )imageData_ {
    
    [self showOverlayView];
    TDMPhotoUploadService *addReview = [[TDMPhotoUploadService alloc]init];
    NSDictionary *userDetails  =[[DatabaseManager sharedManager]getUserDetailsFromDataBase];
    NSString *userId = [userDetails objectForKey:@"userid"];
    addReview.isFromReview = YES;
    [addReview uploadPhotoToTheReviewWithUID:userId withData:imageData_ withFileName:@"1.jpg"];
    addReview.photoUploadServicedelegate= self;
}

-(void) photoUploadedSuccessFully {
    
   
    [self.contentLabel setText:@"Your photo has been uploaded"];
      
    NSLog(@"%@:%@:%d",self.reviewDescription,self.reviewTitle,self.businessId);
    TDMAddBusinessReviewService *addReview = [[TDMAddBusinessReviewService alloc]init];
    addReview.businessReviewServicedelegate= self;
   [addReview addBusinessReviewWithBody:self.reviewDescription andTitle:self.reviewTitle forVenue:[NSString stringWithFormat:@"%d",businessId]];
   
    
}

-(void) photoUploadedFailed {
    
    [self removeOverlayView];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meal" 
                                                   message:@"Error occured while photo upload" 
                                                  delegate:nil 
                                         cancelButtonTitle:@"OK" 
                                         otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    TDMAddBusinessReviewService *addReview = [[TDMAddBusinessReviewService alloc]init];
     addReview.businessReviewServicedelegate= self;
    [addReview addBusinessReviewWithBody:self.reviewDescription andTitle:self.reviewTitle forVenue:[NSString stringWithFormat:@"%d",businessId]];
   
}

-(void) networkErrorInAddinBusinessReview {
    
    [self removeOverlayView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self popViewToDetailList];
}

#pragma mark UIImagePickerController Delegate Protocol implementation
///**************************************************************************************
// *  Method Name    : imagePickerController
// *  Purpose        : 
// *  Parameters     : 
// *  Return Value   : 
// **************************************************************************************/
//- (void)imagePickerController:(UIImagePickerController *)picker 
//        didFinishPickingImage:(UIImage *)img 
//                  editingInfo:(NSDictionary *)editInfo {
//	
//	@try {
//		
//		UIImage *m_selectedImage=nil;
//		m_selectedImage=(UIImage *)img;
//		
//		UIImageView *imageView=[[UIImageView alloc] initWithImage:m_selectedImage];
//		imageView.frame=CGRectMake(30, 245, 75, 75);
//		[self.view addSubview:imageView];
//		
//	    [picker dismissModalViewControllerAnimated:YES];
//		
//	}
//	@catch (NSException * e) {
//		
//	}
//	@finally {
//		
//	}
//}

/**************************************************************************************
 *  Method Name    : imagePickerController
 *  Purpose        : 
 *  Parameters     : 
 *  Return Value   : 
 **************************************************************************************/

#pragma mark - Saving Media details

- (UIImage *)compressImage:(UIImage *)imageToCompress
{
    CGSize size = {320, 316};
	UIGraphicsBeginImageContext(size);
	
	CGRect rect;
	rect.origin = CGPointZero;
	rect.size = size;
	[imageToCompress drawInRect:rect];
	
	UIImage *shrinked;
	shrinked = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return shrinked; 
}


- (NSString *)getDirectoryPath
{
    NSString *directoryPath = [NSString pathWithComponents:
                               [NSArray arrayWithObjects:[NSString stringWithString:
                                                          [[DOCUMENTS_FOLDER stringByAppendingString:@"/Pictures/"] 
                                                           stringByExpandingTildeInPath]], nil]];
    return directoryPath;
}

- (void)saveMediaFromLibrary:(NSDictionary*)infos
{
    
    UIImage * shrinked =[infos objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *compressedImage = [self compressImage:shrinked];
    NSString *folderPath = [self getDirectoryPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:NULL]) 
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:
         folderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    
    NSString *savedDate = @"dishImage";
    NSString *imagePath=[NSString stringWithFormat:@"%@/%@.png",folderPath,savedDate];
    imageData = [NSData dataWithData:UIImagePNGRepresentation(compressedImage)];
    [imageData retain];
    [[NSUserDefaults standardUserDefaults] setValue:imageData forKey:@"reviewURL"];

    [imageData writeToFile:imagePath atomically:YES];
    [self performSelector:@selector(uploadImage:) withObject:imageData afterDelay:0.1];     
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info	{
		
	[picker dismissModalViewControllerAnimated:YES];
    [self saveMediaFromLibrary:info];
	   	
}

#pragma mark - Action sheet delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
            
    if (buttonIndex == 0) {       
        [self takePhotoFromCamera];
    }
    else if(buttonIndex == 1) {
        [self showImagesInPhotoLibrary];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    
    self.addPhotoButton = nil;
    self.skipButton = nil;
    self.shareButton = nil;
    self.contentLabel = nil;
    self.imageData = nil;
    self.restaurantName = nil;
    [super dealloc];
}
-(void) noPhoto
{
    [self removeOverlayView];
}

#pragma mark - share 
-(IBAction) shareButtonClick:(id)sender{
   
    NSString *reviewingText = [NSString stringWithFormat:@"I vote for the %@",self.restaurantName];
    if(shareViewController){
        [shareViewController release];
        shareViewController = nil;
    }
    shareViewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    shareViewController.parentController = self;
    shareViewController.reviewText = self.reviewText;
    shareViewController.restauraName = self.restaurantName;
    shareViewController.isFromReview = 1;
    shareViewController.reviewBody = reviewingText;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"reviewURL"])
    {
        shareViewController.imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"reviewURL"];
    }
    NSLog(@"image url ====== %@",shareViewController.imagePath);
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:shareViewController.view];
    
}

#pragma mark - share view delegates


- (void)onMailButtonClickWithBody:(NSString *)body
{
    
    if ([MFMailComposeViewController canSendMail]) 
    {
        
        MFMailComposeViewController *picker = 
        [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;    
        [picker.visibleViewController.navigationItem setTDMTitle:@"Share with mail"];
        NSString *title=[NSString stringWithFormat:@"What's the best dish at %@", self.restaurantName];
        [picker setMessageBody:body isHTML:YES];
        [picker setSubject:title];
        if(imageData){
            [picker addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"Picture.jpeg"];
        }
        [self.navigationController presentModalViewController:picker animated:YES];
        [picker release];
        
    }
    else 
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meal" 
                                                       message:@"Please check your mail configuration. We can't send e-mail from your device." 
                                                      delegate:nil 
                                             cancelButtonTitle:@"OK" 
                                             otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
}

#pragma mark - mail composer delagate

- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error 
{
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark - facebook share

- (void)shareContent {
    
    NSString *description = [NSString stringWithFormat:@"I just posted my review using The Daily Meal's Best Dishes app for iPhone. Think there's a better dish at %@? Let me know!",self.restaurantName];
    NSMutableDictionary *params =  
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"The Daily Meal", @"name",
     @"Have a look at this.", @"caption",
     description, @"description",
     @"http://www.facebook.com/TheDailyMeal", @"link",
     nil, @"picture",
     nil];  
    [facebook dialog:@"feed"
           andParams:params
         andDelegate:self];
}


- (void)onFacebookButtonClick:(NSString *)body {
    
    if(facebook){
        
        [facebook release];
        facebook = nil;
    }
    facebook = [[Facebook alloc] initWithAppId:FBAPP_KEY andDelegate:self];
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", nil];
    
    facebook.userFlow = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"])
    {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        [self shareContent];
    }
    
    if (![facebook isSessionValid]) {
        [facebook authorize:permissions];
    }
}


- (void)fbDidLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self shareContent];
}

- (void)fbDidLogout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    
} 


-(void) businessReviewAddedSuccessfully
{
    
    [self removeOverlayView];
    [addPhotoButton setHidden:YES];
    [skipButton setHidden:YES];

    [self.contentLabel setText:@"Your review has been uploaded"];
    contentLabel.hidden = NO;
    
}

-(void) businessReviewFailed {
    
    [self removeOverlayView];
    [addPhotoButton setHidden:YES];
    [skipButton setHidden:YES];
    kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Failed to upload review")
     [self popViewToDetailList];
    
}



@end
