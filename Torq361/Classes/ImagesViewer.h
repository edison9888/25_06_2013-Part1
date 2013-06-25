//
//  ImagesViewer.h
//  Torq361
//
//  Created by JK on 28/06/11.
//  Copyright 2011 RapidValue . All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContentDetails.h"



@interface ImagesViewer : UIViewController <UIScrollViewDelegate> {
    
    NSMutableArray * imagearray;
    int currentImageIndex;
    int totalCount;
    NSString * Type;
    
    IBOutlet UIScrollView   * scollmain;
    IBOutlet UILabel        * labelCount;
    UIScrollView   * scollview0;
    UIScrollView   * scollview1;
    UIScrollView   * scollview2;
    UIImageView    * showimage0;
    UIImageView    * showimage1;
    UIImageView    * showimage2;
    

    
    
    
}

@property(nonatomic,retain) NSMutableArray          * imagearray;
@property(nonatomic,retain) NSString                * Type;
@property(nonatomic)        int                     currentImageIndex;
@property(nonatomic)        int                     totalCount;



-(void)loadimagesonscroll:(int)page:(int)currentindex;
-(void)loadViewImageInitilize;
-(void)loadImageOnindex:(BOOL)forward:(BOOL)initilaLoad;
-(IBAction)closeClicked;
@end
