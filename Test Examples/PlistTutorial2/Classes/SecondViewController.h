//
//  SecondViewController.h
//  PlistTutorial2
//
//  Created by Kent Franks on 7/18/11.
//  Copyright 2011 TheAppCodeBlog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController 
{

	NSMutableArray	*array;
	
	UITableView		*tableView;
}

@property (nonatomic, retain) IBOutlet UITableView	*tableView;

@end
