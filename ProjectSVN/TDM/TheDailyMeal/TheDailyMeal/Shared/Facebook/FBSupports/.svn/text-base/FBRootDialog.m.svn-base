//
//  FBRootDialog.m
//  NAVShareKit
//
//  Created by NaveenShan on 16/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBRootDialog.h"


@implementation FBRootDialog

//@synthesize delegate;

#pragma mark - Initialization

- (id)initWithDelegate:(id)objdelegate {
    self = [super init];
    if (self) {
        delegate = objdelegate;
    }
    return self;
}



#pragma mark private

- (void)loadLoginPage {

    FBUserName *name =[[[NSUserDefaults standardUserDefaults] stringForKey:@"FBUserName"] copy];
    
    if (!name || (NSNull *)name == [NSNull null]) {
        name = @"";
    }
    
    NSString *emmbededhtml = @"<html><head><title>Facebook Home</title>\
    <meta name=\"viewport\" content=\"width=280, initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" />\
    </head>\
    <body><form name =\"rootForm\" id=\"root_form\" action=\"#\">\
    <center>\
    <br><br><br>\
    <span id=\"title\"><b><font face=\"Arial\" size=4 color=\"#3b5998\">Logged in as  %@</font></b></SPAN>\
    <br><br><br>\
    <div id=\"share\" onclick=\"document.location='fbconnect:share'\" style=\"position:inherit; top:75px; width:130px; height:35px; background-color:#3b5998; text-align:center; vertical-align:middle; \">\
    <b><font face=\"Arial\" size=4 color=\"#ffffff\">Tap to share </font></b></div>\
    <br><br>\
    <div id=\"logout\" onclick=\"document.location='fbconnect:logout'\" style=\"position:inherit; top:75px; left:400px; width:130px; height:30px; background-color:#aaaaaa; text-align:center; vertical-align:middle; \" ><b><font face=\"Arial\" size=4 color=\"#ffffff\">Logout </font></b></div>\<br>\
    </center>\
    </form>\
    </body></html>";
    
    NSString *html = [NSString stringWithFormat:emmbededhtml,name];
    
    name = nil;
    emmbededhtml = nil;
    
    [self loadString:html baseURL:nil];
}

#pragma mark FBDialog Overwritten Methods

- (void)load {
    [self loadLoginPage];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL* url = request.URL;

    if ([url.scheme isEqualToString:@"fbconnect"]) {
        if ([url.resourceSpecifier isEqualToString:@"share"]) {
            
            if (delegate && [delegate respondsToSelector:@selector(needToPublishFeed)]) {
                [delegate needToPublishFeed];
            }
        } else if ([url.resourceSpecifier isEqualToString:@"logout"]) {
            
            if (delegate && [delegate respondsToSelector:@selector(needToLogout)]) {
                [delegate needToLogout];
            }
        }
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Memory Management

-(void)dealloc  {
    
    delegate = nil;
    
    [super dealloc];
}

@end
