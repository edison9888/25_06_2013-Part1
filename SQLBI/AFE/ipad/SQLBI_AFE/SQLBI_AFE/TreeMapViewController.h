//
//  TreeMapViewController.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreemapView.h"
#import "TreeMapAnimationCell.h"


 
@interface TreeMapViewController : UIViewController < TreemapViewDelegate, TreemapViewDataSource ,TreeMapAnimationCellDelegate >
{

}

@property(nonatomic ,strong) IBOutlet TreemapView *treeMapV;
@property(nonatomic ,strong) TreeMapAnimationCell *treeMapAnmtnCell;
@property(nonatomic, strong) UIView *backgroundView; 
-(void)draWTreeMapWith:(NSArray*)graphValue drawType:(TreeGraphDrawType)type;

@end
