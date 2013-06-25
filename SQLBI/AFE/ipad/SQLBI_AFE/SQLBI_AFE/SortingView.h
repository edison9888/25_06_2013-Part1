//
//  SortingView.h
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 20/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SortingViewDelegate <NSObject>

-(void)sortClicked:(BOOL)descending withSortingParameter:(NSString*)parameter withType:(AFESortDirection)type;

@end

@interface SortingView : UIViewController

@property(nonatomic,assign)id<SortingViewDelegate>delegate;
@property(nonatomic,strong)NSString *sortingParameter;
@property(nonatomic,assign)int sortType;

-(IBAction)sortOrder:(id)sender;
@end
