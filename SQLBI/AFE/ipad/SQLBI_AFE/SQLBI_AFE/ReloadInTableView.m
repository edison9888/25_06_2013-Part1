//
//  ReloadInTableView.m
//  MedAmerica
//
//  Created by Elbin John on 01/03/12.
//  Copyright (c) 2012 RapidValue . All rights reserved.
//

#import "ReloadInTableView.h"

@implementation ReloadInTableView

@synthesize textLoading = textLoading;
@synthesize textPull = textPull; 
@synthesize textRelease = textRelease;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initilizeView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)initilizeView{
    
    
    self.frame= CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    20, 35);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [self addSubview:refreshLabel];
    [self addSubview:refreshArrow];
    [self addSubview:refreshSpinner];
    
    textPull = [[NSString alloc] initWithString:@"Pull down to refresh..."];
    textRelease = [[NSString alloc] initWithString:@"Release to refresh..."];
    textLoading = [[NSString alloc] initWithString:@"Loading..."];
    
}
- (void)setState:(RefreshState)aState{
	
	switch (aState) {
		case RefreshPulling:
            case RefreshStop:
			
            refreshLabel.text=textRelease;        
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			refreshArrow.layer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case RefreshNormal:
            	
            if (prevState ==  RefreshPulling){
                
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                refreshArrow.layer.transform = CATransform3DIdentity;
                [CATransaction commit];
                
                
            }
            refreshLabel.text=textPull;
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
            refreshArrow.layer.hidden = NO;
            refreshArrow.layer.transform = CATransform3DIdentity;
            [CATransaction commit];

//			_statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");

			[refreshSpinner stopAnimating];

//			
//			[self refreshLastUpdatedDate];
			
			break;
		case RefreshLoading:
			
			refreshLabel.text = textLoading;
			[refreshSpinner startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			refreshArrow.layer.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	prevState = aState;
}



@end
