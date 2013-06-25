/**************************************************************************************
 *  File Name      : NFaceBook.m
 *  Project Name   : NAVShareKit
 *  Description    : N/A
 *  Version        : 1.0
 *  Created by     : NaveenShan
 *  Created on     : 12/08/2011
 *  Copyright (C) 2011 RapidValue Solutions Pvt. Ltd. All Rights Reserved.
 ***************************************************************************************/

#import "TDMFaceBook.h"

#import "FBSessionCredentials.h"

#pragma mark -

@implementation TDMFaceBook

@synthesize title;
@synthesize description;
@synthesize titleLink;
@synthesize imageURL;
@synthesize imageLink;

#pragma mark - Private Methods

-(void)showPublishFeedDialog {
    
    if (fbStreamDialog) {
        fbStreamDialog.delegate = nil;
        [fbStreamDialog release];
        fbStreamDialog = nil;
    }
    
    fbStreamDialog = [[FBStreamDialog alloc] init];
    fbStreamDialog.delegate = self;
    fbStreamDialog.userMessagePrompt = @"Enter your comment";
    
    if (!self.imageURL || (NSNull *)self.imageURL == [NSNull null] || [self.imageURL isEqualToString:@""]) {
        fbStreamDialog.attachment=[NSString stringWithFormat:@"{\"name\":\"%@\",\"href\":\"%@\",\"description\":\"%@\"}",self.title,self.titleLink,self.description];
    }
    else    {
        fbStreamDialog.attachment=[NSString stringWithFormat:@"{\"name\":\"%@\",\"href\":\"%@\",\"description\":\"%@\",\"media\":[{\"type\":\"image\",\"src\":\"%@\",\"href\":\"%@\"}]}",self.title,self.titleLink,self.description,self.imageURL,self.imageLink];
    }
    
    fbStreamDialog.attachment = nil;
    
   // fbStreamDialog.actionLinks = [NSString stringWithFormat:@"{\"href\":\"http://blogs.inlandsocal.com/iguide/2011/07/pala-cafe.html\",""}"];
    
     NSLog(@"FB = %@",fbStreamDialog.actionLinks);
    
    
    [fbStreamDialog show];
}

-(void)showLoginDialog    {
    
    if (fbLoginDialog) {
        fbLoginDialog.delegate = nil;
        [fbLoginDialog release];
        fbLoginDialog = nil;
    }
    
    fbLoginDialog = [[FBLoginDialog alloc] initWithSession:fbSession];
    [fbLoginDialog show];
}

-(void)showRootDialog   {
    
    if (fbRootDialog) {
        fbRootDialog.delegate = nil;
        [fbRootDialog release];
        fbRootDialog = nil;
    }
    
    fbRootDialog = [[FBRootDialog alloc] initWithDelegate:self];
    [fbRootDialog show];
}

#pragma mark - Initialization

-(id)init   {
    self = [super init];
    if (self) {
        if (kFBSessionProxy) {
			fbSession = [[FBSession sessionForApplication:kFBApiKey getSessionProxy:kFBSessionProxy
												delegate:self] retain];
		} else {
			fbSession = [[FBSession sessionForApplication:kFBApiKey secret:kFBApiSecret delegate:self] retain];
		}
    }
    
    return self;
}

-(void)load {
    
    [fbSession resume];
    
    if ([fbSession isConnected]) {
        //user already login
    }
    else    {
        [self showLoginDialog];
    }
}

#pragma mark - FBSessionDelegate

/**
 * Called when a user has successfully logged in and begun a session.
 */
- (void)session:(FBSession*)session didLogin:(FBUID)uid {
    
    if (fbLoginDialog) {
        [fbLoginDialog release];
        fbLoginDialog = nil;
    }
    
    [self showPublishFeedDialog];
}

/**
 * Called when a user closes the login dialog without logging in.
 */
- (void)sessionDidNotLogin:(FBSession*)session  {
    
    if (fbLoginDialog) {
        [fbLoginDialog release];
        fbLoginDialog = nil;
    }
}

/**
 * Called when a session is about to log out.
 */
- (void)session:(FBSession*)session willLogout:(FBUID)uid   {
    
}

/**
 * Called when a session has logged out.
 */
- (void)sessionDidLogout:(FBSession*)session    {
    
    [self showLoginDialog];
}

#pragma mark - FBSessionDelegate

-(void)needToLogout {
    
    if (fbRootDialog) {
        [fbRootDialog dismissWithSuccess:NO animated:YES];
        fbRootDialog.delegate = nil;
        [fbRootDialog release];
        fbRootDialog = nil;
    }
    
    [fbSession logout];
}

-(void)needToPublishFeed    {
    
    if (fbRootDialog) {
        [fbRootDialog dismissWithSuccess:NO animated:YES];
        fbRootDialog.delegate = nil;
        [fbRootDialog release];
        fbRootDialog = nil;
    }
    
    [self showPublishFeedDialog];
}

#pragma mark -

- (void)dialogDidCancel:(FBDialog*)dialog   {
   
    if (dialog == fbStreamDialog) {
        [self showRootDialog];
        
        fbStreamDialog.delegate = nil;
        [fbStreamDialog release];
        fbStreamDialog = nil;
    }
}

#pragma mark - Memory Management

-(void)dealloc  {

    if (fbLoginDialog) {
        fbLoginDialog.delegate = nil;
        [fbLoginDialog release];
        fbLoginDialog = nil;
    }
    
    if (fbSession) {
        [fbSession release];
        fbSession = nil;
    }
    
    if (fbStreamDialog) {
        fbStreamDialog.delegate = nil;
        [fbStreamDialog release];
        fbStreamDialog = nil;
    }
    
    if (fbRootDialog) {
        fbRootDialog.delegate = nil;
        [fbRootDialog release];
        fbRootDialog = nil;
    }
    
    [super dealloc];
}


@end
