//
//  ShareView.h
//  ElDiario
//
//  Created by NaveenShan on 10/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
	faceBook = 1,
	twitter = 2,
} ShareType;


@interface ShareView : UIView {

	ShareType m_ShareType;
	
	UILabel *_titleLabel;
	UIButton *_closeButton;
	UIImageView *_iconView;
	UIView *_subView;
    
    UIDeviceOrientation _orientation;
}

-(void)load;
- (void)cancel;
- (void)sizeToFitOrientation:(BOOL)transform;

- (id)initWithFrame:(CGRect)frame ShareType:(ShareType)itype andSubView:(UIView *)view;

- (void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(float)radius;
- (void)drawRect:(CGRect)rect fill:(const CGFloat*)fillColors radius:(CGFloat)radius;
- (void)strokeLines:(CGRect)rect stroke:(const CGFloat*)strokeColor;

@end
