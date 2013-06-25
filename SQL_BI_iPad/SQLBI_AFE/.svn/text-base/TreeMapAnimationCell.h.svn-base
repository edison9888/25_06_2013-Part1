//
//  TreeMapAnimationCell.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TreeMapAnimationCellDelegate <NSObject>
-(void)removeAnimatedCell;
@end

@interface TreeMapAnimationCell : UIView

@property (nonatomic,retain) id <TreeMapAnimationCellDelegate> delegate;

-(void)initWithView:(UIView *)cellView:(CGRect)viewFrame;

@end
