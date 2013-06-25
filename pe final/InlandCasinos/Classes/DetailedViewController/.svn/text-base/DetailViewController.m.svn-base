//
//  DetailViewController.m
//  PE
//
//  Created by Nithin George on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "MWPhotoBrowser.h"
#import "MWPhoto.h"
#import "DBHandler.h"
#import "ImageDetails.h"
#import "ThumbDisplayViewController.h"
#import "List.h"
#import "FBSession.h"
#import "ConnectivityCheck.h"
#import "SHK.h"
#import "FacebookTempData.h"
#define SHKFacebookClass @"SHKFacebook"
#define SHKTwitterClass  @"SHKTwitter"
#define SHKMailClass     @"SHKMail"

@implementation DetailViewController

//@synthesize delegate;
@synthesize webView;
@synthesize aminityName;
@synthesize listItems;
@synthesize selectedListID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
     self.tabBarController.hidesBottomBarWhenPushed=YES;
     
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hideTaBar:YES];
    [self webviewTouch];
    //[self webviewSwipe];
    
    [self createCustomNavigationRightButton];
    [self setButtonEnability];
    [self playAdmob];
    
 //   [self handleOrientation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(OrientationDidChange:)
												 name:UIDeviceOrientationDidChangeNotification
											   object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
       [self loadHtml:selectedListID]; 
}

#pragma mark -
#pragma mark Orientation methods

-(void)OrientationDidChange:(UIDeviceOrientation)orientations{

    
    [self loadHtml:selectedListID];
	
}

- (void)viewWillAppear:(BOOL)animated {

    [self createTittle];
}

-(void)playAdmob{
    
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            323,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];
    
    bannerView_.adUnitID = activePublisherID;
    bannerView_.rootViewController = self;
   // bannerView_.backgroundColor=[UIColor redColor];
    [bannerView_ loadRequest:[GADRequest request]];
    [self.view addSubview:bannerView_];
    [bannerView_ release];

}




- (void)addButtonItems {
    
    [[toolBar subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIBarButtonItem *flexibleSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                        target:nil
                                                                                        action:nil];
    
    UIBarButtonItem *shareButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                               target:nil
                                                                               action:@selector(shareButtonClicked:)];

    List *list = [listItems objectAtIndex:selectedListID];
    
    if (list.favorite) {
        
        UIBarButtonItem *trashButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                      target:nil
                                                                                action:@selector(showActionSheetFavorate:)];
        [toolBar setItems:[NSArray arrayWithObjects:flexibleSpace,shareButton,flexibleSpace,
                           trashButton,flexibleSpace,
                           nil]];
        [trashButton release];
        trashButton = nil;
     }
    else {
        
         UIBarButtonItem *favoriteButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
                                                                                        target:nil
                                                                                        action:@selector(showActionSheetFavorate:)];
        [toolBar setItems:[NSArray arrayWithObjects:flexibleSpace,shareButton,flexibleSpace,favoriteButton,flexibleSpace
                           ,
                           nil]];
        [favoriteButton release];
        favoriteButton = nil;
    }
    [flexibleSpace release];
    [shareButton release];
    shareButton   =nil;
    flexibleSpace = nil;
}

- (void)createCustomNavigationBackButton {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:self.aminityName forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
    item = nil;
}

- (void)createCustomNavigationRightButton {

    backwordBtn= [[UIButton alloc] initWithFrame:CGRectMake(0,0,32, 32)];
    backwordBtn.contentMode = UIViewContentModeScaleToFill;
    [backwordBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UPIcon"
                                        ofType:@"png"]]  forState:UIControlStateNormal];
        
    [backwordBtn addTarget:self action:@selector(backWordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    forwordBtn= [[UIButton alloc] initWithFrame:CGRectMake(32,0,32, 32)];
    forwordBtn.contentMode = UIViewContentModeScaleToFill;
    [forwordBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DownIcon"
                                                                                                         ofType:@"png"]]
                               forState:UIControlStateNormal];
    
    [forwordBtn addTarget:self action:@selector(forwordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
 
    
    UIView *navigationView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 32)];

    navigationView.backgroundColor=[UIColor clearColor];
    [navigationView addSubview:forwordBtn];
    [navigationView addSubview:backwordBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithCustomView:navigationView];
    [navigationView release];
    [forwordBtn release];
    [backwordBtn release];
}

- (void)setButtonEnability {
    
    if (selectedListID == 0) {
        backwordBtn.enabled = NO;

    }
     if (selectedListID == [listItems count] - 1) {
          
         forwordBtn.enabled = NO;
     }
    
    if ([listItems count] == 0) {
        
         backwordBtn.enabled = NO;
         forwordBtn.enabled = NO;
    }
}

#pragma Load HTM

- (void)loadHtml:(int)index {
    
   
    [self addButtonItems];
    NSString *html;
    List *list = [listItems objectAtIndex:index];   
    NSString *heading     = list.title;
    NSString *publishDate = list.pubDate;
    //NSString *content     = [list.description removeAllHtmlTags];
    
    //getThumbImagePath format .extension
    NSString *url = [[DBHandler sharedManager] getThumbImagePath:list.idlist];
    NSArray *stringsBySeperation = [url componentsSeparatedByString:@"."];
    NSString *imageformat = [stringsBySeperation lastObject];
    DebugLog(@"image format is:- %@",imageformat);
    
    int casinoID          = [[DBHandler sharedManager] getparentIDMenu:list.parent_idmenu]; 
    NSString *thumbImageLinkPath   = [[self createDocumentPath] stringByAppendingPathComponent:[NSString 
                                                                                    stringWithFormat:@"/%d/%d/%d/%d_%d.%@",casinoID,list.parent_idmenu,list.idlist,[[DBHandler sharedManager] getListImageID:list.idlist],SMALL_IMAGE,imageformat]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:thumbImageLinkPath]) 
    {
        html=[NSString stringWithFormat:HTMLTAG_WITHOUT_IMAGE,heading,publishDate,@"Video", [list.description removeAllHtmlTags]]; 
    }
    else {
        
        List *list = [listItems objectAtIndex:selectedListID]; 
        NSMutableArray *result = [[DBHandler sharedManager]getBigImagesID:list.idlist];
        NSString *imageCount;
        switch ([result count]) {
            case 0:
                imageCount = @"";
                break;
                
            default:
                imageCount = [NSString stringWithFormat:@"image 1 of %d",[result count]];
                break;
        }
        
        html=[NSString stringWithFormat:HTMLTAG_WITH_IMAGE,heading,publishDate,@"Video",thumbImageLinkPath,imageCount, [list.description removeAllHtmlTags]]; 
    }
    
    
  //  NSLog(@"html : %@",html);
    
    [webView loadHTMLString:html baseURL:[NSURL URLWithString:thumbImageLinkPath]];
}

#pragma mark - tittle display

- (void)createTittle {
    
    NSString *labelString = @"";
    labelString = [labelString  stringByAppendingPathComponent:[NSString stringWithFormat:@"%d of %d",self.selectedListID + 1,[listItems count]]];
    self.navigationItem.title = labelString;
}

#pragma mark -webview delegates

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)urlrequest navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *objURL=[urlrequest URL];
	NSString *strURL=[objURL absoluteString];

    //CAPTURE USER LINK-CLICK.
	if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        if([strURL rangeOfString:@"Video"].location != NSNotFound)
        {
            [self gotoPhotoBrowser];
            return NO;
        }
        else
        {
            [self.view addSubview:indicatorView];
        }
        
    }
    

	return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
	
    [indicatorView removeFromSuperview];
}


#pragma mark Handling Touch Events
-(void)webviewTouch{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    tap.numberOfTapsRequired=1;
    tap.delegate = self;
    [webView addGestureRecognizer:tap];
    [tap autorelease];
    
}

- (void)webviewSwipe
{
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightAction:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.delegate = self;
    [webView addGestureRecognizer:swipeRight];//</code>
    
    [swipeRight release];
    
}

- (void)swipeRightAction:(UIGestureRecognizer *)otherGestureRecognizer
{
    DebugLog(@"Swipe Right");
    //add Function
}
    


-(void)handleDoubleTap:(UIGestureRecognizer *)otherGestureRecognizer{
    hideBar=!hideBar;
    if (hideBar) {
        
        [self hideTopBarAndBottomBar:hideBar]; //tabbar not exixt
        bannerView_.frame =CGRectMake(0.0,
                                      600,
                                      GAD_SIZE_320x50.width,
                                      GAD_SIZE_320x50.height);
    }
    else {
        
        [self hideTopBarAndBottomBar:hideBar]; //tabbar exist
        bannerView_.frame =CGRectMake(0.0,
                                        323,
                                           GAD_SIZE_320x50.width,
                                                 GAD_SIZE_320x50.height);
        
    
    }
}

#pragma mark Load Photo browser
-(void)gotoPhotoBrowser {
    
    NSString *locationFolderPath;
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    List *list = [listItems objectAtIndex:selectedListID];
    int casinoID = [[DBHandler sharedManager] getparentIDMenu:list.parent_idmenu];    
    NSMutableArray *result = [[DBHandler sharedManager]getBigImagesID:list.idlist];
    NSMutableArray *url;

    switch ([result count]) {
        case 0:
            break;
        default:
            
            switch ([result count]) {
                case 1:
                    
                    //getThumbImagePath format .extension
                    url = [[DBHandler sharedManager] getBigImagePath:list.idlist];
                    NSArray *stringsBySeperation = [[url objectAtIndex:0] componentsSeparatedByString:@"."];
                    NSString *imageformat = [stringsBySeperation lastObject];
                    DebugLog(@"image format is:- %@",imageformat);
                    
                    locationFolderPath = [[self createDocumentPath] stringByAppendingPathComponent:[NSString 
                                                                                    stringWithFormat:@"/%d/%d/%d/%d_%d.%@",casinoID,list.parent_idmenu,list.idlist,[[result objectAtIndex:0] integerValue],LARGE_IMAGE,imageformat]];
                    [photos addObject:locationFolderPath];
                
                    break;
                default:
                    for (int startvalue = 0; startvalue<[result count]; startvalue++) {
                        
                        
                        //getThumbImagePath format .extension
                        url = [[DBHandler sharedManager] getBigImagePath:list.idlist];
                        NSArray *stringsBySeperation = [[url objectAtIndex:startvalue] componentsSeparatedByString:@"."];
                        NSString *imageformat = [stringsBySeperation lastObject];
                        DebugLog(@"image format is:- %@",imageformat);
                        
                        locationFolderPath = [[self createDocumentPath] stringByAppendingPathComponent:[NSString 
                                                                                                        stringWithFormat:@"/%d/%d/%d/%d_%d.%@",casinoID,list.parent_idmenu,list.idlist,[[result objectAtIndex:startvalue] integerValue],LARGE_IMAGE,imageformat]];

                       
                        NSLog(@"path==%@",locationFolderPath);
                        [photos addObject:locationFolderPath];
                    }
                    
                    break;
            }

            self.navigationItem.title = IMAGE_DISPLAY_NAV_BACK_TITTLE;
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
            [self.navigationController pushViewController:browser animated:YES];
            [browser release];            
            break;
    }
    
    [photos release];
    
}
- (void)showThumDisplay:(NSMutableArray *)photos {
    self.navigationItem.title = @"Story";
    self.navigationController.navigationBarHidden=NO;
    ThumbDisplayViewController *thumbDisplayViewController=[[ThumbDisplayViewController alloc] initWithNibName:@"ThumbDisplayViewController" bundle:nil];
    thumbDisplayViewController.imagePaths=photos;
    [self.navigationController pushViewController:thumbDisplayViewController animated:YES];
    [thumbDisplayViewController release];
    thumbDisplayViewController=nil;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
                          
#pragma mark Hide/Show top/bottom bar
// Hide/show tab bar
- (void)hideTaBar:(BOOL)flag {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.0];
    for (UIView *view in self.tabBarController.view.subviews) {
        if (view.tag==TABBAR_TAG) {
            view.hidden=flag;
        }
    }
     [UIView commitAnimations];
}



//Hide/show navigation bar
-(void)hideTopBarAndBottomBar:(BOOL)flag{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.0];
    [toolBar setHidden:flag];
    self.navigationController.navigationBarHidden=flag;
    [UIView commitAnimations];
}

#pragma  mark - Button Actions

- (IBAction)shareButtonClicked:(id)sender { 
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"E-mail Story",@"Post to Twitter",@"Post to Facebook",nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (IBAction)showActionSheetFavorate:(id)sender {

    UIActionSheet *actionSheet;
    List *list = [listItems objectAtIndex:selectedListID];
    
    //already a favorite item
    if (list.favorite) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Remove from Favorites",nil];
    }
    else {
    
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add to Favorites", nil];
    }
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
    [actionSheet release];
    
    bannerView_.frame =CGRectMake(0.0,
                                            210,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height);
    
}

#pragma mark Action sheet delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    //share Action sheet
   if (0 == actionSheet.tag)
   {
         ConnectivityCheck *networkCheck = [[ConnectivityCheck alloc] init];
        
        if([networkCheck isHostReachable])
        {
            if (0 == buttonIndex)
            {
                [self mailButtonClicked];   
            }
            else if(1 == buttonIndex)
            {
                [self twitterButtonClicked];
            }
            else if(2 == buttonIndex)
            {
                [self FacebookButtonClicked];
            }
        }
        else if(buttonIndex != 3)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                            message:@"No network connectivity"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            alert.delegate = self;
            [alert show];
            [alert release]; 
        }
        [networkCheck release];
        networkCheck = nil;

   }
    //favorite Action sheet
   else if (actionSheet.tag == 1) {
        
        if (buttonIndex == 0) {
            
            List *list = [listItems objectAtIndex:selectedListID];
            if (list.favorite) {
                
                [[DBHandler sharedManager]updateFavoriteSatusNO:list.idlist];
                list.favorite = NO;
            }
            else {
                
                [[DBHandler sharedManager]updateFavoriteSatusYES:list.idlist];
                list.favorite = YES;
            }
            
            [self addButtonItems];//Replacong the favorite button
        }
       
       bannerView_.frame =CGRectMake(0.0,
                                     323,
                                     GAD_SIZE_320x50.width,
                                     GAD_SIZE_320x50.height);  
    }
    

}

- (void)mailButtonClicked
{
    List *list = [listItems objectAtIndex:selectedListID];
    NSString *shareFacebookContent = [NSString stringWithFormat:@"%@,%@",SHARE_TEXT,list.link];
    NSString *subject              = [NSString stringWithFormat:@"Inland Casinos: %@",list.title]; 
    [self seetingMailBodyComponents:@"":subject:shareFacebookContent];

}
- (void)twitterButtonClicked

{
    List *list = [listItems objectAtIndex:selectedListID];
    NSString *shareTwitterContent = [NSString stringWithFormat:@"%@,%@",SHARE_TWITTER_TEXT,list.link];
    [[SHK currentHelper]setRootViewController:nil];
    SHKItem *item = [SHKItem text:shareTwitterContent];
    [NSClassFromString(SHKTwitterClass) performSelector:@selector(shareItem:) withObject:item];
}
- (void)FacebookButtonClicked
{
    List *list = [listItems objectAtIndex:selectedListID];
    
    NSString *shareFacebookContent = [NSString stringWithFormat:@"%@,%@",SHARE_TEXT,list.link];
    
    [[FacebookTempData sharedManager] setFBShareUrl:list.link];
    
    SHKItem *item = [SHKItem text:shareFacebookContent];
    
    [NSClassFromString(SHKFacebookClass) performSelector:@selector(shareItem:) withObject:item];
}


- (void)backButtonClicked:(id)sender {
    [self hideTaBar:NO]; 
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)backWordButtonClicked:(id)sender {
    
    selectedListID = selectedListID - 1;
    forwordBtn.enabled = YES;
    [self setButtonEnability];
    [self createTittle];
    [self loadHtml:selectedListID];
}

- (IBAction)forwordButtonClicked:(id)sender {
    
    selectedListID = selectedListID + 1;
    backwordBtn.enabled = YES;
    [self setButtonEnability];
    [self createTittle];
    [self loadHtml:selectedListID];
    
}

#pragma mark - mail composer
- (void)seetingMailBodyComponents:(NSString *)toAddress:(NSString *)subject:(NSString *)body {
    NSArray *toRecipients;
    MFMailComposeViewController *mailController ;
    if ([MFMailComposeViewController  canSendMail]) {
        mailController = [[[MFMailComposeViewController alloc] init] autorelease];
        if(mailController )
            toRecipients = [NSArray arrayWithObjects:toAddress, nil]; 
        [mailController setToRecipients:toRecipients];
        [mailController setSubject:subject];
        [mailController setMessageBody:body isHTML:false];
        mailController.mailComposeDelegate = self;
        [self  presentModalViewController:mailController animated:true];
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                              
                                                        message:@"Kindly configure your system mail"
                              
                                                       delegate:self
                              
                                              cancelButtonTitle:@"OK"
                              
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}



-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EMailsendung fehlgeschlagen!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [controller dismissModalViewControllerAnimated:true];
}

#pragma mark-

- (void)willPresentAlertView:(UIAlertView *)alertView {

}


#pragma  mark - DocumentPath creation

- (NSString *)createDocumentPath {
    
    NSArray *Localpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [Localpaths objectAtIndex:0];
    NSString *parentFolderName= [documentPath stringByAppendingPathComponent:PARENTFOLDER];
    return parentFolderName;
}

-(void)viewDidDisappear:(BOOL)animated{

}

- (void)viewWillDisappear:(BOOL)animated {
    
}




- (void)viewDidUnload
{
    [super viewDidUnload];
 
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    

}


- (void)dealloc
{
    [super dealloc];
    toolBar          = nil;
    webView.delegate = nil;
    webView          = nil;
    backwordBtn    = nil;
    forwordBtn     = nil;
    indicatorView  = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
       return NO;
}



@end
