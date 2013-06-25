//
//  FBRootDialog.h
//  NAVShareKit
//
//  Created by NaveenShan on 16/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FBDialog.h"

@protocol FBRootDelegate;

@interface FBRootDialog : FBDialog {
    
    id <FBRootDelegate> delegate;
}

//@property(nonatomic, assign) id <FBRootDelegate> delegate;

- (id)initWithDelegate:(id)objdelegate;

@end

#pragma mark - FBRootDelegate

@protocol FBRootDelegate <NSObject>

-(void)needToLogout;
-(void)needToPublishFeed;

@end



