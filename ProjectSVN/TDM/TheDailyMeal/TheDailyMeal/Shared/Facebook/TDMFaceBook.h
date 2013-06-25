/**************************************************************************************
 *  File Name      : NFaceBook.h
 *  Project Name   : NAVShareKit
 *  Description    : N/A
 *  Version        : 1.0
 *  Created by     : NaveenShan
 *  Created on     : 12/08/2011
 *  Copyright (C) 2011 RapidValue Solutions Pvt. Ltd. All Rights Reserved.
 ***************************************************************************************/

#import <Foundation/Foundation.h>

#import "FBSession.h"

#import "FBLoginDialog.h"

#import "FBStreamDialog.h"

#import "FBRootDialog.h"

@interface TDMFaceBook : NSObject <FBSessionDelegate, FBDialogDelegate> {
    
    FBSession *fbSession;
    
    FBRootDialog *fbRootDialog;
    
    FBLoginDialog *fbLoginDialog;
    
    FBStreamDialog *fbStreamDialog;
    
    NSString *title;
    NSString *description;
    NSString *titleLink;
    NSString *imageURL;
    NSString *imageLink;
}


@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSString *titleLink;
@property(nonatomic, retain) NSString *imageURL;
@property(nonatomic, retain) NSString *imageLink;

-(void)load;

@end
