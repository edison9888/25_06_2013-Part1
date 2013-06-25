/**************************************************************************************
 *  File Name      : SPEmailShare.h
 *  Project Name   : Zenprise
 *  Description    : N/A
 *  Version        : 1.0
 *  Created by     : Sariga V S
 *  Created on     : 26/08/2011
 *  Copyright (C) 2011 RapidValue IT Services Pvt Ltd. Ltd. All Rights Reserved.
 ***************************************************************************************/

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

struct Attachment{
    NSString *attachmentMimeType;
    NSString *attachmentFilename;
    NSString *path;
}attachment;

@interface SPEmailShare : NSObject <MFMailComposeViewControllerDelegate> {
    
    NSString *mailSubject; 
    NSArray *toRecipients;
    NSArray *ccRecipients;
    NSArray *bccRecipients;
    NSString *messageBody;
    NSArray *attachmentList;
}

@property(nonatomic,retain) NSString *mailSubject;
@property(nonatomic,retain) NSArray *toRecipients;
@property(nonatomic,retain) NSArray *ccRecipients;
@property(nonatomic,retain) NSArray *bccRecipients;
@property(nonatomic,retain) NSString *messageBody;
@property(nonatomic,retain) NSArray *attachmentList;

- (BOOL)canSendMail;
- (void)sendMail;

@end
