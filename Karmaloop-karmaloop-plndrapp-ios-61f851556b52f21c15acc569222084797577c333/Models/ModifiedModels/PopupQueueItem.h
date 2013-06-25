//
//  PopupQueueItem.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PopupViewController;

@interface PopupQueueItem : NSObject

@property (nonatomic, strong) PopupViewController *popupViewController;
@property (nonatomic, strong) id delegate;

@end
