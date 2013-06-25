//
//  ScrollSlideView.h
//  Torq361
//
//  Created by JK on 22/06/11.
//  Copyright 2011 RapidValue . All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScrollSlideView : UIViewController {
    
    IBOutlet UIImageView  * contentImage;
    IBOutlet UIImageView  * playImage;
    IBOutlet UIButton * contentButton;
    IBOutlet UILabel  * tileLabel;
    
}

@property(nonatomic,retain) IBOutlet UIImageView  * contentImage;
@property(nonatomic,retain) IBOutlet UIImageView  * playImage;
@property(nonatomic,retain) IBOutlet UIButton * contentButton;
@property(nonatomic,retain) IBOutlet UILabel  * tileLabel;
 
@end
