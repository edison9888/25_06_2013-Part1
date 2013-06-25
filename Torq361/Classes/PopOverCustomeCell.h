//  
//  PopOverCustomeCell.h
//  torq361
//
//  Created by Nithin George on 13/04/2011.
//  Copyright 2010 RVS. All rights reserved.


#import <UIKit/UIKit.h>


@interface PopOverCustomeCell : UITableViewCell {

	IBOutlet UIImageView *popImage;
	IBOutlet UILabel *popTitle;
}

@property (nonatomic,retain) UIImageView *popImage;
@property (nonatomic,retain) UILabel *popTitle;
@end
