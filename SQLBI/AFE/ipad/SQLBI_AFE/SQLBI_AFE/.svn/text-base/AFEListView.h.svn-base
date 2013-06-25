//
//  AFEListView.h
//  SQLBI_AFE
//
//  Created by Rapidvalue on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AFEListViewDelegate <NSObject>

- (void)didSelectdropDownList:(NSMutableArray *)result;

@end
@interface AFEListView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)id<AFEListViewDelegate>delegate;
@property(nonatomic,strong)NSMutableArray *searchData;
@property(nonatomic,strong) UITableView *tableViewForList; 


-(void) showActivityIndicatorOverlayView;
-(void) removeActivityIndicatorOverlayView;
-(void) showMessageOnView:(NSString*) message;
-(void) hideMessageOnView;
-(void) reloadData;

@end
