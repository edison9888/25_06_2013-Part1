////
////  TDMMFBHelper.m
////  TheDailyMeal
////
////  Created by RapidValue Solutions on 5/30/11.
////  Copyright 2011 __MyCompanyName__. All rights reserved.
////
//
//#import "TDMMFBHelper.h"
//#import "FBLoginDialog.h"
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//// This application will not work until you enter your Facebook application's API key here:
//
//
////static NSString* kApiKey = @"156097511108547";
////static NSString* kApiKey = @"218031904877113";
////static NSString* kApiKey = @"2375348157";
//
//static NSString* kApiKey    = @"169827579749932";
//static NSString* kApiSecret = @"ef8e45e31d3b17766e93df3094bf44f1";
//
//// Enter either your API secret or a callback URL (as described in documentation):
////static NSString* kApiSecret = @"19b26e1f2b98c89676cf1359d2151c56";  // @"<YOUR SECRET KEY>";
////static NSString* kApiSecret = @"20362f52a6acf597c8c41b666519f59c";  // @"<YOUR SECRET KEY>";
////static NSString* kApiSecret = @"c9bfb83d8947b33086b3600eb5e6d75d";
//
//static NSString* kGetSessionProxy = nil; // @"<YOUR SESSION CALLBACK)>";
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//
//@implementation TDMMFBHelper
//
//@synthesize delegate;
//@synthesize _session;
//
//-(void)initFaceBook {
//    
//    if (kGetSessionProxy) {
//        self._session = [[FBSession sessionForApplication:kApiKey getSessionProxy:kGetSessionProxy
//                                            delegate:self] retain];
//    } else {
//        self._session = [[FBSession sessionForApplication:kApiKey secret:kApiSecret delegate:self] retain];
//    }
//}
//
//- (void)loginToFacebook{
//    
//    [_session resume];
//    
////    [_session logout];
//    
//    if (_session.isConnected) {
//        [_session logout];
//    } else {
//        FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:_session] autorelease];
//        [dialog show];
//    }
//}
//
//- (void)logoutOfFacebook{
//    
//    [_session logout];
//}
//
//#pragma mark FBSessionDelegate
//
//- (void)session:(FBSession*)session didLogin:(FBUID)uid {
//    
//    NSLog(@"Facebook Login Sucess : %llu",uid);
//    NSString * uidString = [NSString stringWithFormat:@"%llu", uid];
//    [delegate fbDidLogin:uidString];
//}
//
//- (void)sessionDidNotLogin:(FBSession*)session {
//
//    NSLog(@"Cancelled FB login");
//}
//
//- (void)sessionDidLogout:(FBSession*)session {
//    
//    NSLog(@"FB login failed");
//	
//}
//
//#pragma mark -
//
//- (void)dealloc{
//    
//    [_session release];
//    _session = nil;
//    
//    [super dealloc];
//}
//
//
//@end
