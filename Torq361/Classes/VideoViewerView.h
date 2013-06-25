//
//  VideoViewerView.h
//  Torq361
//
//  Created by Rajeev KR on 24/08/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface VideoViewerView : UIViewController {
    NSString *videoPath;
}
@property (nonatomic,retain)NSString *videoPath;

-(void)playVideo;
@end
