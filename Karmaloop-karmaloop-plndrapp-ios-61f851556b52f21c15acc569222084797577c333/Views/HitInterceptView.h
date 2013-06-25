//
//  HitInterceptView.h
//  Metro-iOS
//
//  Created by DX079 on 12-02-15.
//  Copyright (c) 2012 Michael Waterfall. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HitInterceptDelegate <NSObject>

- (void) interceptOccurred;

@end

@interface HitInterceptView : UIView

@property (nonatomic, unsafe_unretained) id<HitInterceptDelegate> delegate;

@end
