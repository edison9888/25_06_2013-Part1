//
//  ThumbGridCell.m
//  PE
//
//  Created by Nithin George on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ThumbGridCell.h"
#import "ImageCrop.h"

@implementation ThumbGridCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayCellItems:(NSMutableArray *)items {
    
    int section_x=THUMB_X;
    //DebugLog(@"thumb view array count%d",[items count]);
    for(int col=0; col<[items count];col++){
        //Icon 
        UIButton *btnHome_Section=[[UIButton alloc]init];
        btnHome_Section.frame=CGRectMake(section_x, THUMB_Y, THUMB_WIDTH,THUMB_HEIGHT);
        btnHome_Section.backgroundColor=[UIColor clearColor];
        btnHome_Section.tag=col;
        btnHome_Section.contentMode = UIViewContentModeScaleAspectFit;
        btnHome_Section.backgroundColor = [UIColor redColor];
        //For Orginal TabImage
        UIImage* thumbImage = [UIImage imageWithContentsOfFile:[items objectAtIndex:col]];

        [btnHome_Section setImage:[thumbImage  imageByScalingAndCroppingForSize:CGSizeMake(62, 62)] forState:UIControlStateNormal];
        
        //[btnHome_Section setBackgroundImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        
        [btnHome_Section addTarget:[self superview] action:@selector(sectionButtonPresssed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnHome_Section];
        [btnHome_Section release];
        btnHome_Section=nil;
        section_x=section_x+THUMB_SPACE;
  }
}
    
- (void)dealloc
{
    [super dealloc];
}

@end
