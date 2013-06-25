//
//  ThumbCustomeCell.h
//  scrollTest
//
//  Created by Rapidvalue on 26/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ThumbCustomeCell : UITableViewCell {
	IBOutlet UIImageView *imageView1;
	IBOutlet UIImageView *imageView2;
	IBOutlet UIImageView *imageView3;
	IBOutlet UIImageView *imageView4;
	
	IBOutlet UILabel *label1;
	IBOutlet UILabel *label2;
	IBOutlet UILabel *label3;
	IBOutlet UILabel *label4;
	
	IBOutlet UIButton *button1;
	IBOutlet UIButton *button2;
	IBOutlet UIButton *button3;
	IBOutlet UIButton *button4;
}

@property(nonatomic,retain) UIImageView *imageView1;
@property(nonatomic,retain) UIImageView *imageView2;
@property(nonatomic,retain) UIImageView *imageView3;
@property(nonatomic,retain) UIImageView *imageView4;

@property(nonatomic,retain) UILabel *label1;
@property(nonatomic,retain) UILabel *label2;
@property(nonatomic,retain) UILabel *label3;
@property(nonatomic,retain) UILabel *label4;

@property(nonatomic,retain) UIButton *button1;
@property(nonatomic,retain) UIButton *button2;
@property(nonatomic,retain) UIButton *button3;
@property(nonatomic,retain) UIButton *button4;

@end
