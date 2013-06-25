//
//  ProductDetailView.m
//  Torq361
//
//  Created by JK on 22/06/11.
//  Copyright 2011 RapidValue . All rights reserved.
//

#import "ProductDetailView.h"
#import "UserCredentials.h"
#import "SHKItem.h"
#import "SHK.h"
#import "SHKReadItLater.h"
#import  "VideoViewerView.h"

@implementation ProductDetailView

@synthesize productId;
@synthesize deligate; 
@synthesize productDetails;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    currIndex=1;
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"idProduct == %d", self.productId];
    
    NSArray * products = [[AppTmpData sharedManager]getProductDetailsArray];
    
    NSArray * fileteredArray = [products filteredArrayUsingPredicate:predicate];
    
    self.productDetails = [fileteredArray objectAtIndex:0];

    [self setDisplay];
    
    //sharing
    //[SHK flushOfflineQueue];
    
    
    
    [self showThumbnailScrollView];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
   
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    //[self.view removeFromSuperview];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
}

-(void)showThumbnailScrollView{
    
    
    pageBrowser=[[PageBrowser alloc] initWithImages:contentslist
                                     SuperViewFrame:thumbnailContainer.frame
                                     DelegateObject:self];
    [thumbnailContainer addSubview:pageBrowser];
    [thumbnailContainer bringSubviewToFront:pageBrowser];
}

-(void)unloadThumbnailScrollView{
    [pageBrowser removeFromSuperview];
    [pageBrowser release];
    thumbnailContainer=nil;
}

-(void)setDisplay{
    
    
   // [self createScrollviewContent]; ////Commented by Rajeev
    totalContentCount=0;
    contentslist=[[NSMutableArray alloc] init];

    NSMutableArray*  imageContents = [[DatabaseManager sharedManager]getContentsForProductID:self.productDetails.idProduct :@"image"];
    [contentslist addObjectsFromArray:imageContents];
    imagecount  =[imageContents count];
    
    NSMutableArray*  pdfContents   = [[DatabaseManager sharedManager]getContentsForProductID:self.productDetails.idProduct :@"pdf"];
    [contentslist addObjectsFromArray:pdfContents];
    pdfcount    =[pdfContents count];
    
    NSMutableArray*  VideoContents = [[DatabaseManager sharedManager]getContentsForProductID:self.productDetails.idProduct :@"video"];
    [contentslist addObjectsFromArray:VideoContents];
    videocount  =[VideoContents count];
    
    totalContentCount=imagecount+pdfcount+videocount;
    
    productName.text=self.productDetails.Name;
    textViewDescription.text=self.productDetails.Description;
    textViewDetailedDescription.text=self.productDetails.prodDetails;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0]; ///Users/rinishrvs/Library/Application Support/iPhone Simulator/4.2/Applications/BCA8AB2A-1ABE-4907-A4BC-803637928FE0/Documents
    NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
    NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@/ProductThumb",@"CompanyId",companyid]];///Users/rinishrvs/Library/Application Support/iPhone Simulator/4.2/Applications/BCA8AB2A-1ABE-4907-A4BC-803637928FE0/Documents/CompanyId1/CatagoryThumb
    
    
    
    NSArray *objExtension = [self.productDetails.ThumbNailImgPath componentsSeparatedByString:@"/"];
    
    //imageIncrement ++;
    NSString *strDownloadDestiantionPath=[NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
    
    UIImage *image=[[UIImage alloc]initWithContentsOfFile:strDownloadDestiantionPath];
    prodThumpImage.image=image;
    [image release];
    image=nil;

    
}

- (IBAction)backButtonClicked:(id)sender{
    
    [self unloadThumbnailScrollView];

    [self dismissModalViewControllerAnimated:YES];
 
    
    if(self.deligate!=nil && [self.deligate respondsToSelector:@selector(productDetailViewClosed)])
    {
       [self.deligate productDetailViewClosed];
    }
   
    
}
-(void)scrollclicked:(UIButton *)sender{
    
    ContentDetails * content=( ContentDetails * )[contentslist objectAtIndex: sender.tag];
    
    NSArray *objExtension = [content.Path componentsSeparatedByString:@"/"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];	
    NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
    NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@/ProductContent/Portrait/%@",@"CompanyId",companyid,content.Type]];		
    NSString *strDownloadDestiantionPath = [NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
    if ([content.Type isEqualToString: @"image"]){
		
		[self showImageViewerWithIndex:sender.tag fromPath:strDownloadDestiantionPath];
		
	}
    else if ([content.Type isEqualToString: @"pdf"]){
            
        [self showPdfViewerWithFile:strDownloadDestiantionPath];
        
    }
    else if([content.Type isEqualToString: @"video"]){
        [self showVideoViwerWithFile:strDownloadDestiantionPath];
    }

	    
    
}
-(void)scrollThumbClicked:(UIButton *)sender{
    
   
    //currIndex=sender.tag;
    //[self scrollViewDidEndDecelerating:contentScrollView];
    
    //[self loadContentScroll:sender.tag];
    
    [self scrollclicked:sender];

}

-(void)pageBrowserCurrentPageIndexDidChange:(int)index{

    int maxScrollToShow=6;
    if([[AppTmpData sharedManager]getDeviceOrientation]){
        maxScrollToShow=4;
    }
    if(index==0){
        prodThumpScrollBack.hidden=YES;
    }else{
        prodThumpScrollBack.hidden=NO;
    }
    
    if(index+maxScrollToShow >=[contentslist count]){
        prodThumpScrollFront.hidden=YES;
    }else{
        prodThumpScrollFront.hidden=NO;
    }
}
    
-(void)showImageViewerWithIndex:(int)index fromPath:(NSString*)strDownloadDestiantionPath{
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:strDownloadDestiantionPath]) {
        
        ImagesViewer *imageViewer = [[ImagesViewer alloc]initWithNibName:@"ImagesViewer" bundle:nil];
        imageViewer.imagearray =contentslist;
        imageViewer.totalCount = imagecount;
        imageViewer.currentImageIndex = index;
        imageViewer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:imageViewer animated:YES];
        [imageViewer release];
        imageViewer = nil;
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Torq361" message:@"Please wait... Download in progress..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
    
}

-(void)showVideoViwerWithFile:(NSString *)filePath{
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        
        VideoViewerView *videoViewerView = [[VideoViewerView alloc]initWithNibName:@"VideoViewerView" bundle:nil];
        videoViewerView.videoPath =filePath;
        videoViewerView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:videoViewerView animated:YES];
        
        [videoViewerView release];
        videoViewerView = nil;
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Torq361" message:@"Please wait... Download in progress..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
}

-(void)showPdfViewerWithFile:(NSString*)pdfFile{
    
 if ([[NSFileManager defaultManager]fileExistsAtPath:pdfFile]) {       
    ReaderDocument *document = [[[ReaderDocument alloc] initWithFilePath:pdfFile password:nil] autorelease];
    
	ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
    
	readerViewController.delegate = self; // Set the ReaderViewController delegate to self
    readerViewController.title=productName.text;
    
	readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
	[self presentModalViewController:readerViewController animated:YES];
    
	[readerViewController release]; // Release the ReaderViewController
    readerViewController=nil;
 }else {
     
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Torq361" message:@"Please wait... Download in progress..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     
     [alert show];
     [alert release];
 }

}
- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    
    
    // dismiss modal view controller
    [self dismissModalViewControllerAnimated:YES];
}


-(IBAction)productDetailedDescButtonClicked:(id)sender{
    UIButton *btn=(UIButton*)sender;
    if(btn.tag==999){ //prod desc
        
        textViewDetailedDescription.text=self.productDetails.prodDetails;
        
        descriptionButtonImage.image= [UIImage imageNamed:@"newProdDetails_clicked.png"];
        
    }else if(btn.tag==111){ //tech desc
        textViewDetailedDescription.text=self.productDetails.techDetails;
        descriptionButtonImage.image= [UIImage imageNamed:@"newTechDetails_clicked.png"];
    }
}
-(IBAction)facebookButtonClicked:(id)sender{
    
    NSString *destcription= textViewDescription.text;
    NSString *prodName=productName.text;
    
    NSString *dataToShare=[NSString stringWithFormat:@"%@ \r\n\r\n %@",prodName,destcription];
    SHKItem *item;
    if (dataToShare.length > 0){
        [[SHK currentHelper]setRootViewController:nil];
        if(prodThumpImage.image){
            item = [SHKItem image:prodThumpImage.image title:dataToShare];
        }else{
            item = [SHKItem text:dataToShare];  
        }
        
        [NSClassFromString(SHKFacebookClass) performSelector:@selector(shareItem:) withObject:item];
    }
}
-(IBAction)twitterButtonClicked:(id)sender{
    
    [fBButton setEnabled:NO];
    [twitterbutton setEnabled:NO];
    
    NSString *destcription= textViewDescription.text;
    NSString *prodName=productName.text;
    
    NSString *dataToShare=[NSString stringWithFormat:@"%@ \r\n\r\n %@",prodName,destcription];
    

    if (dataToShare.length > 0){
        [[SHK currentHelper]setRootViewController:nil];
        [[SHK currentHelper]setFormDelegate:self];
        SHKItem *item = [SHKItem text:dataToShare];
        [NSClassFromString(SHKTwitterClass) performSelector:@selector(shareItem:) withObject:item];
    }

}

//fb and twitter delegate
-(void)willCloseForm{
    NSLog(@"willCloseForm");
    
    [fBButton setEnabled:YES];
    [twitterbutton setEnabled:YES];
}
-(IBAction)mailButtonClicked:(id)sender{
    NSString *destcription= textViewDescription.text;
    NSString *prodName=productName.text;
    

    NSString *dataToShare=[NSString stringWithFormat:@"Hi, \r\n I thought of sharing some interesting product with you.\r\n\r\n%@ : \r\n %@",prodName,destcription];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
    NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@/ProductThumb",@"CompanyId",companyid]];
    
    
    NSArray *objExtension = [self.productDetails.ThumbNailImgPath componentsSeparatedByString:@"/"];
    
    NSString *strDownloadDestiantionPath=[NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
    
    
    // get a new new MailComposeViewController object 
    if ([MFMailComposeViewController canSendMail] == NO) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Torq361"                                                           message:@"Mail functionality not enabled. Please check your mail account settings" delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
		[theAlert show]; [theAlert release]; // Show and cleanup
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager]; // Creating the object of filemanager.
    NSDictionary *fileAttributes = [fileManager fileAttributesAtPath:strDownloadDestiantionPath traverseLink:YES]; // Getting the attributes of the file in the path
        NSString *filesize=@"0";
    if(fileAttributes != nil)
    {  
         filesize = [fileAttributes objectForKey:@"NSFileSize"]; // Getting the value 
    }
    NSNumber  *sizeNumber = [NSNumber numberWithInt:[filesize integerValue]];
	unsigned long long fileSize = [sizeNumber unsignedLongLongValue];
    
	if (fileSize < (unsigned long long)15728640) // Check attachment size limit (15MB)
	{
		NSURL *fileURL = [NSURL fileURLWithPath:strDownloadDestiantionPath]; NSString *fileName=[objExtension lastObject];
        
		NSData *attachment = [NSData dataWithContentsOfURL:fileURL options:(NSDataReadingMapped|NSDataReadingUncached) error:nil];
        MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
        
		if (attachment != nil) // Ensure that we have valid  file attachment data
		{
            NSArray *filetype=[[objExtension lastObject]componentsSeparatedByString:@"."];
            NSString *mimetype=[NSString stringWithFormat:@"application/%@", [filetype lastObject]];
			[mailComposer addAttachmentData:attachment mimeType:mimetype fileName:fileName];
            
        }
        if (dataToShare.length > 0){
            NSString *sub=[NSString stringWithFormat: @"Torq361 : %@",prodName];
            [mailComposer setSubject:sub];
        
            [mailComposer setMessageBody:dataToShare isHTML:NO]; 
        
            mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
        
            mailComposer.mailComposeDelegate = self; // Set the delegate
        
            [self presentModalViewController:mailComposer animated:YES];
        }
        
        [mailComposer release]; // Cleanup
        mailComposer=nil;

	}
	else // The  file is too large to email alert
	{
		UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Torq361"                                                           message:@"File too large" delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
		[theAlert show]; [theAlert release]; // Show and cleanup
	}

}
// delegate function callback  
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {  
    
    NSString *response=@"";
    // switchng the result  
    switch (result) {  
        case MFMailComposeResultCancelled:  
           response=@"Mail discarded.";   
            break;  
        case MFMailComposeResultSaved:  
            response=@"Mail saved.";  

            break;  
        case MFMailComposeResultSent:  
            response=@"Mail sent.";  

            break;  
        case MFMailComposeResultFailed:  
            response=[NSString stringWithFormat:@"Mail send error: %@.", [error localizedDescription]];  

            break;  
        default:  
            break;  
    }  
    
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Torq361"
                                                       message:response delegate:NULL
                                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [theAlert show]; [theAlert release]; // Show and cleanup

    // hide the modal view controller  
    [self dismissModalViewControllerAnimated:YES];  
}  
//this function is added to remove the unwanted memeory, as this is not 
//appreciated by Apple, still we can reduce memory by the below method. also
//make sure application is not crashing :)
- (void)releaseIBObjects {
    
    //labels(2)
    if (productName) {
        [productName release];
        productName = nil;
    }
    
    if (labelShareWith) {
        [labelShareWith release];
        labelShareWith = nil;
    }
    
    //imageViews(5)
    if (descriptionButtonImage) {
        descriptionButtonImage.image = nil;
        [descriptionButtonImage release];
        descriptionButtonImage = nil;
    }
    if (thumbnailSelectionImage) {
        thumbnailSelectionImage.image = nil;
        [thumbnailSelectionImage release];
        thumbnailSelectionImage = nil;
    }
    if (thumbnailContainer) {
        thumbnailContainer.image = nil;
        [thumbnailContainer release];
        thumbnailContainer = nil;
    }
    
    if (imageViewred_border) {
        imageViewred_border.image = nil;
        [imageViewred_border release];
        imageViewred_border = nil;
    }
    if (backgroundImage) {
        backgroundImage.image = nil;
        [backgroundImage release];
        backgroundImage = nil;
    }
    
    if(prodThumpImage){
        prodThumpImage.image = nil;
        [prodThumpImage release];
        prodThumpImage = nil;

    }
    if(prodThumpImageBg){
        prodThumpImageBg.image = nil;
        [prodThumpImageBg release];
        prodThumpImageBg = nil;
        
    }

    
    //Buttons(6) 
    if (descriptionButton) {
        [descriptionButton setImage:nil forState:UIControlStateNormal];
        [descriptionButton release];
        descriptionButton = nil;
    }
    if (productDetailsButton) {
        [productDetailsButton setImage:nil forState:UIControlStateNormal];
        [productDetailsButton release];
        productDetailsButton = nil;
    }
    if (TechnicalDetailsButton) {
        [TechnicalDetailsButton setImage:nil forState:UIControlStateNormal];
        [TechnicalDetailsButton release];
        TechnicalDetailsButton = nil;
    }
    if (fBButton) {
        [fBButton setImage:nil forState:UIControlStateNormal];
        [fBButton release];
        fBButton = nil;
    }
    if (twitterbutton) {
        [twitterbutton setImage:nil forState:UIControlStateNormal];
        [twitterbutton release];
        twitterbutton = nil;
    }
    if (MailButton) {
        [MailButton setImage:nil forState:UIControlStateNormal];
        [MailButton release];
        MailButton = nil;
    }

    //textViews(2)
    if (textViewDescription) {
        textViewDescription.text = nil;
        [textViewDescription release];
        textViewDescription = nil;
    }
    
    
    //views(4)
    if (textBackgroundView) {
        [[textBackgroundView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [textBackgroundView release];
        textBackgroundView = nil;
    }
    if (shareOptionsView) {
        [[shareOptionsView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [shareOptionsView release];
        shareOptionsView = nil;
    }   
    
    if (bottomContainerView) {
        [bottomContainerView release];
        bottomContainerView = nil;
    }
    if (selectionButtonView) {
        [[selectionButtonView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [selectionButtonView release];
        selectionButtonView = nil;
    }
     
}

- (void)dealloc
{
    [self releaseIBObjects];
     
    ScrollButton0=nil;
    ScrollButton1=nil;
    ScrollButton2=nil;

 
    [contentslist removeAllObjects];
    [contentslist release];
    
    self.productDetails =nil;
    self.deligate=nil;
    

    [super dealloc];
}

@end
