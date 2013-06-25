//
//  TDMReviewConfirmationViewController.m
//  TheDailyMeal
//
//  Created by Nithin George on 06/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMReviewConfirmationViewController.h"
#import "TDMAssetsTablePicker.h"
#import "ELCImagePickerController.h"

#define LABEL_THANKS @"thanks!"
#define LABEL_SUCESS_ADD_REVIEW_TEXT @"Your review has been uploaded."
#define LABEL_SUCESS_ADD_REVIEW_PHOTO @"Your photo has been uploaded."

#define ACTIONSHEET_TITLE   @""
#define ACTIONSHEET_ADD_PHOTO_BUTTON_TITLE   @"Take Photo"
#define ACTIONSHEET_ADD_PHOTO_FROM_LIBRARY_BUTTON_TITLE   @"Choose From Library"
#define ACTIONSHEET_CANCEL_BUTTON_TITLE     @"Cancel"

#define TAKE_PHOTO_BUTTON_INDEX   0
#define FROM_LIBRARY_BUTTON_INDEX    1


@interface TDMReviewConfirmationViewController()

- (void)setTheLabelText:(NSString *)successString;
- (void)setFrames;

- (void)takePhoto;
- (void)addFromLibrary;

- (BOOL)isDeviceHasCamera;

@end
@implementation TDMReviewConfirmationViewController
@synthesize backGorudImageView;
@synthesize viewTitleImageView;
@synthesize viewTitleLabel;
@synthesize reviewThanksLabel;
@synthesize reviewConfirmationLabel;
@synthesize adButton;
@synthesize addPhotoButton;
@synthesize skipButton;
@synthesize contentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //this will create the back button on the navigation bar
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
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
    [self.navigationItem setRBIconImage];
    [self setFrames];
    self.reviewThanksLabel.text       = LABEL_THANKS;
    [self setTheLabelText:LABEL_SUCESS_ADD_REVIEW_TEXT];
}

#pragma mark- set the views content

- (void)setTheLabelText:(NSString *)successString
{
    self.reviewConfirmationLabel.text       = LABEL_SUCESS_ADD_REVIEW_TEXT;
}

- (void)setFrames
{
    self.reviewThanksLabel.frame = CGRectMake(110, 40, 210, 30);
    self.reviewThanksLabel.font = kGET_BOLD_FONT_WITH_SIZE(20);
    self.reviewThanksLabel.textColor = [UIColor grayColor];
    self.reviewThanksLabel.backgroundColor  = [UIColor clearColor];
    self.reviewThanksLabel.textAlignment=UITextAlignmentLeft;
    
    self.reviewConfirmationLabel.frame = CGRectMake(10, 75, 300, 30);
    self.reviewConfirmationLabel.font = kGET_BOLD_FONT_WITH_SIZE(20);
    self.reviewConfirmationLabel.textColor = [UIColor grayColor];
    self.reviewConfirmationLabel.backgroundColor  = [UIColor clearColor];
    self.reviewConfirmationLabel.textAlignment=UITextAlignmentCenter;
    
    self.addPhotoButton.frame = CGRectMake(20, 130, 260, 35);
    self.skipButton.frame     = CGRectMake(20, 180, 260, 35);

}

- (void)viewDidUnload
{
    [self setBackGorudImageView:nil];
    [self setViewTitleImageView:nil];
    [self setViewTitleLabel:nil];
    [self setContentView:nil];
    [self setReviewThanksLabel:nil];
    [self setReviewConfirmationLabel:nil];
    [self setAddPhotoButton:nil];
    [self setSkipButton:nil];
    [self setAdButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [backGorudImageView release];
    [viewTitleImageView release];
    [viewTitleLabel release];
    [contentView release];
    [reviewThanksLabel release];
    [reviewConfirmationLabel release];
    [addPhotoButton release];
    [skipButton release];
    [adButton release];
    [super dealloc];
}


- (IBAction)addPhotoButtonClicked:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:ACTIONSHEET_TITLE delegate:self cancelButtonTitle:ACTIONSHEET_CANCEL_BUTTON_TITLE destructiveButtonTitle:nil otherButtonTitles:ACTIONSHEET_ADD_PHOTO_BUTTON_TITLE,ACTIONSHEET_ADD_PHOTO_FROM_LIBRARY_BUTTON_TITLE,nil];
       
    [actionSheet showInView:self.tabBarController.view];
    REMOVE_FROM_MEMORY(actionSheet);
}

- (IBAction)skipButtonClicked:(id)sender {
}

- (IBAction)adButtonClicked:(id)sender {
}

- (void)takePhoto
{
    if ([self isDeviceHasCamera])
    {        
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.delegate = self;
        [picker setCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
        picker.mediaTypes = [[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil] autorelease];
        [self presentModalViewController:picker animated:YES];
        [picker release];
        
    }
    else 
    { 
        kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, ERROR_MSG_DIVICE_WITH_NO_CAMERA);

    }  
}
- (void)addFromLibrary
{
    TDMAssetsTablePicker *assetsPicker = [[TDMAssetsTablePicker alloc] initWithNibName:@"TDMAssetsTablePicker" 
                                                                              bundle:[NSBundle mainBundle]];    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:assetsPicker];
    [assetsPicker setParent:elcPicker];
    [elcPicker setDelegate:self];    
    [self presentModalViewController:elcPicker animated:YES];
    [elcPicker release];
    [assetsPicker release];
}

#pragma mark -  Action sheet delegates
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (TAKE_PHOTO_BUTTON_INDEX == buttonIndex)
    {
        [self takePhoto];
    }
    else if(FROM_LIBRARY_BUTTON_INDEX == buttonIndex)
    {
        [self addFromLibrary];
    }
}

#pragma mark - Camera Handler methods

- (BOOL)isDeviceHasCamera
{
    BOOL isAvailable = NO;
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] ||
        [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
    {
        isAvailable = YES;
    }
    
    return isAvailable;
}

#pragma mark - Saving Media details

- (void)saveMediaFromCamera:(NSDictionary*)info
{
    
}

- (void)saveMediaFromLibrary:(NSArray*)infos
{
    
}

#pragma mark - DELEGATE METHODS PickerView delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSDate *startDate = [NSDate date];
    
    [picker dismissModalViewControllerAnimated:YES];
    
    [self saveMediaFromCamera:info];
    
    NSDate *endDate = [NSDate date];
    
    NSLog(@"Photo Capture Time elapsed: %f", [endDate timeIntervalSinceDate:startDate]);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)infos
{
    
    NSDate *startDate = [NSDate date];

    if ([infos count]<=0){
        //do nothing, since nothing is selected, nothing exists already. 
        kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE,NO_IMAGE_IS_SELECTED );
    }
    else {
        
        [self saveMediaFromLibrary:infos];
        
        NSDate *endDate = [NSDate date];
        
        NSLog(@"Image Library Selection Time elapsed: %f", [endDate timeIntervalSinceDate:startDate]);
        
    }
    
    [picker dismissModalViewControllerAnimated:YES];  
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    
    [picker dismissModalViewControllerAnimated:YES];
}

@end
