//
//  PageBrowser.h
//  Ahlan
//
//  Created by NaveenShan on 23/02/2011.
//  Copyright 2011 RapidValue IT Services Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ContentDetails.h"

#define thumpWidth 170
#define thumpHeight 128

#define thumpBorder 2
#define thumpSpacing 5
#define thumpBorderSelColor [UIColor colorWithRed:0.85 green:0.10 blue:0.10 alpha:1.0]

#define thumpBorderColor [UIColor grayColor]

#define downloadingButtonTag 9999
#define thumpBorderColorForDownload [UIColor colorWithRed:0.10 green:0.85 blue:0.10 alpha:1.0]

@interface PageBrowser : UIView <UIScrollViewDelegate> {

	int m_iTotalpages;
	int m_iCurrentPageIndex;
	
	id delegeteObject;
	
	NSMutableArray *m_arrPages;
	UIScrollView *m_scrollView;
	NSMutableArray *m_arrPageViews;
	
}

-(void)initializeView;
-(void)currentPageIndexDidChange;
-(UIImage*)getimage:(ContentDetails *) content;

-(id)initWithImages:(NSMutableArray *)arrImages 
	 SuperViewFrame:(CGRect)frame 
	 DelegateObject:(id)objdelegete;

@end
