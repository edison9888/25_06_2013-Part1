//
//  DataSyncManager.m
//  Torq361
//
//  Created by Binoy on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataSyncManager.h"
#import "AppTmpData.h"
#import "Torq361AppDelegate.h"
#import "Home.h"
#import "DownloadEngine.h"
#import "UserCredentials.h"

@implementation DataSyncManager

@synthesize m_objImgViewSyncStatus,m_objImgViewBackground;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	
	if([[AppTmpData sharedManager] getDeviceOrientation]){
		
		self.view.frame=CGRectMake(0, 0, 768, 1004);
				
		[self setPortrateView];
	}
	
	else {
		
		self.view.frame=CGRectMake(0, 0, 1024, 748);	
			
		[self setLandscapeView];
	}
	
	[self checkDBSyncStatus];
	
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

-(void)setPortrateView{
		
	if (bBackgroundImgStatus) {
		
		self.view.backgroundColor = [UIColor blackColor];
		
		UIImage *image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Default-Portrait" ofType:@"png"]];
		
		m_objImgViewBackground.image = image;
		
		[image release];
		
		image = nil;
		
		
	}
	
	else {
		
		 m_objImgViewBackground.image = nil;
	}

}

-(void)setLandscapeView{
	
	if (bBackgroundImgStatus) {
		
		self.view.backgroundColor = [UIColor blackColor];
	
		UIImage *image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Default-Landscape" ofType:@"png"]];
		
		m_objImgViewBackground.image = image;
		
		[image release];
		
		image = nil;
				
	}
	
	else {
		
		m_objImgViewBackground.image = nil;
		
	}

}

-(void)checkDBSyncStatus{
	
	syncDB=[[SyncDB alloc] init];
	
	syncDB.delegate=self;
	
	[syncDB onSyncDB];	
    
    [syncDB release];
    syncDB=nil;
}

-(void)didfailedSyncwitherror:(SyncDB *)objSyncDB{
	
	
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sync Failed" 
												  message:@"" 
												 delegate:nil 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
	 [alert show];
	 [alert release];
    
    Torq361AppDelegate *appDelegate = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
	
	
	[appDelegate.home hideDataSyncManager];
	
		
}

-(void)didfinishedSync:(SyncDB *)objSyncDB{
	/*UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Finished Sync" 
												  message:@"" 
												 delegate:nil 
										cancelButtonTitle:@"OK" 
										otherButtonTitles:nil];
	[alert show];
	[alert release];*/
	
	
	

	
	Torq361AppDelegate *appDelegate = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
	
	[appDelegate createFolderStructureInDocumentDirectory:[[UserCredentials sharedManager]getCompanyID]];
    
	[self loadThumbImages];
	[appDelegate.home hideDataSyncManager];
	
	
}

-(void)loadThumbImages{	
	
    
	objDownloadThumbnails = [[DownloadThumbinals alloc] init];
	[objDownloadThumbnails downloadThumbinalImages:@"Catalog"];
	
	//objDownloadCategoryThumbnails = [[DownloadThumbinals alloc] init];
	[objDownloadThumbnails downloadThumbinalImages:@"Category"];
	
	//objDownloadProductThumbnails = [[DownloadThumbinals alloc] init];
	[objDownloadThumbnails downloadThumbinalImages:@"Product"];
    
   
	
	[[DownloadEngine sharedManager] StartAutoDownload];
    
    
	
	//[[DownloadEngine sharedManager] StartManualDownload:1];
	
	
}

- (void)setBackgroundImageStatus :(BOOL)bStatus {
	bBackgroundImgStatus = bStatus;
}

- (BOOL)getBackgroundImageStatus {
	return bBackgroundImgStatus;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
    [objDownloadThumbnails release];
    
    objDownloadThumbnails=nil;
	
	[message release];
	
	[m_objImgViewBackground release];
	
	[m_objImgViewSyncStatus release];
	
    [super dealloc];
}


@end
