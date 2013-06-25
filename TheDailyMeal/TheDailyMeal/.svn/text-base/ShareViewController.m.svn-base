//
//  ShareViewController.m
//  TheDailyMeal
//
//  Created by Jai Raj on 20/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "ShareViewController.h"
#import "AppDelegate.h"
//#import "FBSession.h"
#import "SHK.h"
#import "TDMBusinessDetailViewController.h"
#import "TDMBusinessViewController.h"

#define SHKFacebookClass @"SHKFacebook"
#define SHKTwitterClass  @"SHKTwitter"
#define SHKMailClass     @"SHKMail"

@implementation ShareViewController

@synthesize parentController;
@synthesize restauraName;
@synthesize restauraAddress;
@synthesize restauraCategory;
@synthesize shareBody,shareBodyImage;
@synthesize imagePath;
@synthesize dishName,reviewText;
@synthesize isFromReview;
@synthesize isFromAddDish;
@synthesize addDishBody;
@synthesize reviewBody;
@synthesize isFromBusinessHome;
@synthesize isFromBusinessDetail;
@synthesize twitterBody;
@synthesize imageData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setTDMIconImage];
        
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

//-(NSString*)getCurrentSystemTime{
//    NSDate* date = [NSDate date];
//    
//    //Create the dateformatter object
//    
//    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
//   [formatter setDateFormat:@"hh:mm a"];        
//    NSString* currentTime = [formatter stringFromDate:date]; 
//    
//    NSLog(@"time%@",currentTime); 
//    
//    return currentTime;
//}
- (void)formTheSharetext {
    
    
    NSString *imageURl;
    NSLog(@"Image URl%@",self.imagePath);
    if(self.imagePath){
        imageURl=[NSString stringWithFormat:@"The review and photo are at <a href=%@>%@</a></br><br/>",self.imagePath,self.imagePath];
    }
    else
    {
        imageURl=@"";
    }

    
    urlString=@"http://www.thedailymeal.com/bestdishes";
    if([self.restauraCategory length]> 0){
      
        //self.shareBody = [NSString stringWithFormat:@"Restaurant Name :- %@ (%@)",self.restauraName,self.restauraCategory];
         self.shareBody = [NSString stringWithFormat:@"I just viewed %@ and hope you will like it.</br></br> %@ I'm using The Daily Meal's Best Dishes app for iPhone.You can try it at <a href = \"www.thedailymeal.com/bestdishes\">www.thedailymeal.com/bestdishes</a>",self.restauraName,imageURl];
       
    }
    else {
        self.shareBody = [NSString stringWithFormat:@"Restaurant Name :- %@ ",self.restauraName];
    }
    
    if([self.dishName length]>0)
    {                 
       self.shareBody = [NSString stringWithFormat:@"I just added  %@ at %@ and hope you will like it.</br></br> %@ I'm using The Daily Meal's Best Dishes app for iPhone.You can try it at <a href = \"www.thedailymeal.com/bestdishes\">www.thedailymeal.com/bestdishes</a>",self.dishName,self.restauraName,imageURl];
    
        
    }
    else if([self.reviewText length] > 0)
    {
        self.shareBody = [NSString stringWithFormat:@"I just reviewed %@ and  hope you will like it.</br></br> I'm using The Daily Meal's Best Dishes app for iPhone.You can try it at <a href = \"www.thedailymeal.com/bestdishes\">www.thedailymeal.com/bestdishes</a>",self.restauraName];//my review :- %@ ,self.reviewText
    }
    
    if(self.restauraAddress)
        self.shareBody = [NSString stringWithFormat:@"%@   Address : %@" , shareBody,self.restauraAddress];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.view.frame = appDelegate.window.frame;
    [self.navigationItem setHidesBackButton:YES];
    [self formTheSharetext];
    
    UIActionSheet *actionSheet; 
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:self 
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:nil 
                                     otherButtonTitles:@"Facebook",@"Twitter",@"Email",nil];
    
    actionSheet.tag = 0;
           

    [actionSheet showInView:appDelegate.window];
    [actionSheet release];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    
    self.parentController = nil;
    self.restauraName = nil;
    self.restauraAddress = nil;
    self.restauraCategory = nil;
    self.shareBody= nil;
    self.shareBodyImage = nil;
    self.reviewText = nil;
    [super dealloc];
}

- (void)removeView {
    
    [self.view removeFromSuperview];
}

#pragma mark - buttonClicks

- (void)onFacebookButtonClick {
    
//    NSString *shareFacebookContent = self.shareBody;
//    
////    SHKItem *item = [SHKItem text:shareFacebookContent];
//    SHKItem *item = [SHKItem image:[UIImage imageNamed:@"imageNotAvailable"] title:shareFacebookContent];
//    
//    [NSClassFromString(SHKFacebookClass) performSelector:@selector(shareItem:) withObject:item];
//    [self.navigationController popViewControllerAnimated:NO];
    
    [parentController onFacebookButtonClick:self.shareBody];
    [self removeView];
}

- (void)onTwitterButtonClick  {
    
    NSLog(@"image path : %@",self.imagePath);
    NSString *shareTwitterContent = self.shareBody;
    if (self.isFromBusinessHome) {
        shareTwitterContent = self.twitterBody;
    }
    if (self.isFromAddDish) {
         shareTwitterContent = self.addDishBody;
    }
    else if (self.isFromReview)
    {
        shareTwitterContent =self.reviewBody;
    }
    [[SHK currentHelper] setRootViewController:parentController];
//    SHKItem *item = [SHKItem text:shareTwitterContent];
    SHKItem *item;
    if (isFromReview || isFromAddDish) {
        if (self.imageData) 
        {
            item = [SHKItem image:[UIImage imageWithData:self.imageData] title:shareTwitterContent];
        }
        else
        {
            item = [SHKItem image:[UIImage imageNamed:@"imageNotAvailable.png"] title:shareTwitterContent];
        }

    }
    else {
        if (self.imagePath) 
        {
            item = [SHKItem image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imagePath]]] title:shareTwitterContent];
        }
        else
        {
            item = [SHKItem image:[UIImage imageNamed:@"imageNotAvailable.png"] title:shareTwitterContent];
        }
    }
        [NSClassFromString(SHKTwitterClass) performSelector:@selector(shareItem:) withObject:item];
    [self removeView];
}

- (void)onMailButtonClick
{
    
    if ([MFMailComposeViewController canSendMail]) 
    {
       
        MFMailComposeViewController *picker = 
        [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;    
        [picker.visibleViewController.navigationItem setTDMTitle:@"Share with mail"];

        [picker setMessageBody:self.shareBody isHTML:YES];
        [picker setSubject:@"Mail"];
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
- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error 
{
    [controller dismissModalViewControllerAnimated:YES];
    [self removeView];
}

#pragma mark - Action sheet delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self onFacebookButtonClick];
    }
    else if(buttonIndex == 1)
    {
        [self onTwitterButtonClick];
    }
    else if(buttonIndex == 2)
    {
        [self removeView];
        [parentController onMailButtonClickWithBody:self.shareBody];
//        if([parentController isKindOfClass:[TDMBusinessDetailViewController class]])
//            [(TDMBusinessDetailViewController *)parentController onMailButtonClickWithBody:self.shareBody];
//        else if([parentController isKindOfClass:[TDMBusinessViewController class]])
//             [(TDMBusinessViewController *)parentController onMailButtonClickWithBody:self.shareBody];
    }
    else if(buttonIndex == 3)
    {
        [self removeView];
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{

    if([[actionSheet subviews]objectAtIndex:0]){
        UIImageView *faceBookButtonImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"facebook.png"]];
               faceBookButtonImage.frame=CGRectMake(70, 26, 35, 35);
               [actionSheet addSubview:faceBookButtonImage];
               [faceBookButtonImage release];
    }
    if([[actionSheet subviews]objectAtIndex:1]){
                UIImageView *twitterButtonImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"twiter.png"]];
                twitterButtonImage.frame=CGRectMake(82, 79, 35, 35);
                [actionSheet addSubview:twitterButtonImage];
                [twitterButtonImage release];
 
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
