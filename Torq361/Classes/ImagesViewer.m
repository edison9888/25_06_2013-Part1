//
//  ImagesViewer.m
//  Torq361
//
//  Created by JK on 28/06/11.
//  Copyright 2011 RapidValue . All rights reserved.
//

#import "ImagesViewer.h"
#import "UserCredentials.h"


@implementation ImagesViewer
@synthesize currentImageIndex;
@synthesize imagearray;
@synthesize totalCount;
@synthesize Type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    scollmain.contentSize=CGSizeMake(768*3, 1004);
    scollmain.pagingEnabled=TRUE;
    
    scollview0=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 768, 1004)];
    showimage0=[[UIImageView alloc] init];
    showimage0.frame=CGRectMake(0,0,768, 1004);
    [scollview0 addSubview:showimage0];
    [scollmain addSubview:scollview0];
    scollview0.minimumZoomScale=1;
    scollview0.maximumZoomScale=10;
    scollview0.delegate=self;
    [showimage0 release];
    [scollview0 release];
    
    scollview1=[[UIScrollView alloc] initWithFrame:CGRectMake(768, 0, 768, 1004)];
    showimage1=[[UIImageView alloc] init];
    showimage1.frame=CGRectMake(0,0,768, 1004);
    [scollview1 addSubview:showimage1];
    [scollmain addSubview:scollview1];
    scollview1.minimumZoomScale=1;
    scollview1.maximumZoomScale=10;
    scollview1.delegate=self;
    [showimage1 release];
    [scollview1 release];

    
    scollview2=[[UIScrollView alloc] initWithFrame:CGRectMake(768*2, 0, 768, 1004)]; 
    showimage2=[[UIImageView alloc] init];
    showimage2.frame=CGRectMake(0,0,768, 1004);
    [scollview2 addSubview:showimage2];
    [scollmain addSubview:scollview2];
    scollview2.minimumZoomScale=1;
    scollview2.maximumZoomScale=10;
    scollview2.delegate=self;
    [showimage2 release];
    [scollview2 release];
    
    [self loadViewImageInitilize];
    [self loadImageOnindex:TRUE:TRUE];
    labelCount.text=[NSString stringWithFormat:@"%d/%d",currentImageIndex+1,totalCount];
    [super viewDidLoad];
    
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft|self.interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        
        [self setViewOnOrentation:FALSE];
    }
    else{
        [self setViewOnOrentation:TRUE];
    }
    
   
}


#pragma mark - deligates

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    
    
 
        
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft|toInterfaceOrientation==UIInterfaceOrientationLandscapeRight){
        
        [self setViewOnOrentation:FALSE];
    }
    else{
        [self setViewOnOrentation:TRUE];
    }
}

-(void)setViewOnOrentation:(BOOL)poterate{
    
    if(!poterate){
        
        if (totalCount>3) {
            
            scollmain.contentSize=CGSizeMake(1024*3, 748);
        }
        else{
            
            scollmain.contentSize=CGSizeMake(1024*totalCount, 748);
            
        }
        
        showimage0.frame=CGRectMake(0, 0, 1024,748);
        showimage1.frame=CGRectMake(0, 0, 1024,748);
        showimage2.frame=CGRectMake(0, 0, 1024,748);
        
        scollview0.frame=CGRectMake(0, 0, 1024,748);
        scollview1.frame=CGRectMake(1024, 0, 1024,748);
        scollview2.frame=CGRectMake(1024*2, 0, 1024,748);
    }
    else{
        if (totalCount>3) {
            
            scollmain.contentSize=CGSizeMake(768*3, 1004);
        }
        else{
            
            scollmain.contentSize=CGSizeMake(768*totalCount, 1004);
            
        }
        
        showimage0.frame=CGRectMake(0, 0, 768,1004);
        showimage1.frame=CGRectMake(0, 0, 768,1004);
        showimage2.frame=CGRectMake(0, 0, 768,1004);
        
        scollview0.frame=CGRectMake(0, 0, 768,1004);
        scollview1.frame=CGRectMake(768, 0, 768,1004);
        scollview2.frame=CGRectMake(768*2, 0, 768,1004);
    }
     [self loadImageOnindex:TRUE:TRUE];
      
}

 

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return [[scrollView subviews]objectAtIndex:0];
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    
}
 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    float widthchk;
           
    if (self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft|| self.interfaceOrientation==UIInterfaceOrientationLandscapeRight) {
          widthchk=scollmain.frame.size.height;
    }
    else{
        
          widthchk=scollmain.frame.size.width;
    }
      
        
    widthchk=scollmain.frame.size.width;
    if(scrollView.tag==1){
    if (totalCount>3) {
         
             if(scrollView.contentOffset.x>widthchk){
                 if (currentImageIndex+1<totalCount-1) {
                     
                     
                     [self loadImageOnindex:TRUE:FALSE];
                      

                 }
                  
                 
                 
             }
             else  if(scrollView.contentOffset.x<widthchk){
                 
                 [self loadImageOnindex:FALSE:FALSE];
                 

                 
             }
         
         
     }
    
    
     
    NSLog(@" %f    v1 %f v2 %f v3 %f",scrollView.contentOffset.x ,scollview0.frame.size.width  ,scollview1.frame.size.width,scollview1.frame.size.width);
    
    if(scrollView.contentOffset.x<widthchk)
    {
     currentImageIndex=showimage0.tag;
     labelCount.text=[NSString stringWithFormat:@"%d/%d",showimage0.tag+1,totalCount];
    }
    else if(scrollView.contentOffset.x==widthchk)
    {
        currentImageIndex=showimage1.tag;
        labelCount.text=[NSString stringWithFormat:@"%d/%d",showimage1.tag+1,totalCount];
    }else  if(scrollView.contentOffset.x>widthchk)
    {
          currentImageIndex=showimage2.tag;
         labelCount.text=[NSString stringWithFormat:@"%d/%d",showimage2.tag+1,totalCount];
    }
   
    
    }
}

 




-(void)loadImageOnindex:(BOOL)forward:(BOOL)initilaLoad{
    
    
    NSLog(@"curren index %d" ,currentImageIndex);
   
    if (totalCount<=3) {
        
        
        
        if(self.interfaceOrientation==UIInterfaceOrientationPortrait||self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown){
        
            [scollmain scrollRectToVisible:CGRectMake(768*totalCount,0,768, 1004) animated:NO];
            
        }
        else{
            
            [scollmain scrollRectToVisible:CGRectMake(1024*totalCount,0,1024, 748) animated:NO];
        }
            
        
    }

    if(!initilaLoad)
    {
    if (forward) {
        if (currentImageIndex+1<totalCount-1) {
            currentImageIndex+=1;
    
        }
        else{
            currentImageIndex=totalCount-2; 
            return;
        }
    }
    else{
        
        if(currentImageIndex>1){
            currentImageIndex-=1;
        }
        else
        {
            currentImageIndex=0;
            return;
        }

    }
    
    }
     
    
    
        
     
    [self loadimagesonscroll:0 :currentImageIndex-1];
 
    [self loadimagesonscroll:1 :currentImageIndex];
 
 
    
    if(self.interfaceOrientation==UIInterfaceOrientationPortrait||self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown){
        
        [scollmain scrollRectToVisible:CGRectMake(768,0,768, 1004) animated:NO];
        
    }
    else{
        
       [scollmain scrollRectToVisible:CGRectMake(1024,0,1024, 748) animated:NO];
    }

     
    [self loadimagesonscroll:2 :currentImageIndex+1];
    
    scollview0.zoomScale=1;
    scollview1.zoomScale=1;
    scollview2.zoomScale=1;
    
}



-(void)loadViewImageInitilize{
    
    int count=0;
    
   if(totalCount>0)
   {
       if (totalCount>3) {
           count=3;
           scollmain.contentSize=CGSizeMake(768*3, 1004);
       }
       else{
           count=totalCount;
           scollmain.contentSize=CGSizeMake(768*count, 1004);
       
       }
       
       for (int i=0;i<count; i++) {
           
           [self loadimagesonscroll:i :i];
       }

   }
    
        
    
}


-(void)loadimagesonscroll:(int)page:(int)currentindexload{

    if(currentindexload<0 || currentindexload >=[imagearray count])
        return;
    
    ContentDetails * content=( ContentDetails * )[imagearray objectAtIndex: currentindexload];
    
    NSArray *objExtension = [content.Path componentsSeparatedByString:@"/"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];	
    NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
    NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@/ProductContent/Portrait/%@",@"CompanyId",companyid,content.Type]];		
    NSString *strDownloadDestiantionPath = [NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
    UIImage *image = [[UIImage alloc]initWithContentsOfFile:strDownloadDestiantionPath];
    
    objExtension                =   nil;    
    paths                       =   nil;    
    companyid                   =   nil;    
    companyid                   =   nil;    
    strThumbImagess             =   nil; 
    strDownloadDestiantionPath  =   nil; 
    content                     =   nil;
    
    switch (page) {
        case 0:
            showimage0.image=nil;
            showimage0.image=image;
            showimage0.tag=currentindexload;
            [image release];
            image=nil;
            break;
        case 1:
            showimage1.image=nil;
            showimage1.image=image;
            showimage1.tag=currentindexload;
            [image release];
            image=nil;
            break;
        case 2:
            showimage2.image=nil;
            showimage2.image=image;
            showimage2.tag=currentindexload;
            [image release];
            image=nil;
            break;
            
        default:
            break;
    }
        
    
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(IBAction)closeClicked{
    [self dismissModalViewControllerAnimated:YES];
    
}
- (void)dealloc
{
    
    imagearray      =   nil;
    scollmain       =   nil;
    scollview0      =   nil;
    scollview1      =   nil;
    scollview2      =   nil;
    showimage0.image=   nil;
    showimage0      =   nil;
    showimage1.image=   nil;
    showimage1      =   nil;
    showimage2.image=   nil;
    showimage2      =   nil;
    labelCount.text =   nil;
    labelCount      =   nil;
    self.Type       =nil;
    [super dealloc];
}

@end
