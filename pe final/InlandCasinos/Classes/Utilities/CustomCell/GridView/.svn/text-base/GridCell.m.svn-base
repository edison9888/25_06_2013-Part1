//
//  GridCell.m
//  PE
//
//  Created by God bless you... on 26/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GridCell.h"
#import "Grid.h"

@implementation GridCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

- (void)displayCellItems:(NSMutableArray *)items:(int)pageID {
    
    int section_x=SECTION_X;
    //DebugLog(@"Grid view array count%d",[items count]);
    for(int col=0; col<[items count];col++){
        
        //Icon 
        Grid *grid=[items objectAtIndex:col];
        UIButton *btnHome_Section=[[UIButton alloc]init];
        btnHome_Section.frame=CGRectMake(section_x, SECTION_Y, SECTION_WIDTH,SECTION_HEIGHT);
        btnHome_Section.backgroundColor=[UIColor clearColor];
        btnHome_Section.tag=grid.idmenu;
        btnHome_Section.contentMode = UIViewContentModeScaleAspectFit;

        //For Orginal TabImage
        [btnHome_Section setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:grid.icon_path ofType:TAB_IMAGE_TYPE]] forState:UIControlStateNormal];
        
        //[btnHome_Section setBackgroundImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        
        [btnHome_Section addTarget:[self superview] action:@selector(sectionButtonPresssed:) forControlEvents:UIControlEventTouchUpInside];
        [btnHome_Section setTitle:grid.title forState:UIControlStateNormal];
        [self addSubview:btnHome_Section];
        [btnHome_Section release];
        btnHome_Section=nil;
        
        //Section Name
        UILabel *sectionName=[[UILabel alloc]initWithFrame:CGRectMake(section_x, SECTION_LABLEL_Y, SECTION_LABLEL_WIDTH, SECTION_LABLEL_HEIGHT)];
        
        //setting the text shadow property
        /*sectionName.shadowColor = [UIColor grayColor];
        sectionName.shadowOffset = CGSizeMake(3, 2);
        */
        sectionName.backgroundColor=[UIColor clearColor];
        sectionName.textColor = [UIColor whiteColor];
        sectionName.font      =[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        sectionName.textAlignment =UITextAlignmentCenter;
        sectionName.lineBreakMode = UILineBreakModeWordWrap;
        sectionName.numberOfLines = 0;
        sectionName.text=grid.title;
        [self addSubview:sectionName];
        [sectionName release];
        sectionName=nil;
        section_x=section_x+SECTION_SPACE;
    }

}


- (void)dealloc{
    
    [super dealloc];
}

@end
