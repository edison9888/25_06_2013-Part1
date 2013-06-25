//
//  FirstViewController.h
//  PlistTutorial2
//
//  Created by Kent Franks on 7/18/11.
//  Copyright 2011 TheAppCodeBlog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController 
{
	
	UITextField *textField1;
	UITextField *textField2;
	UITextField *textField3;
	UITextField *textField4;
	UITextField *textField5;
	
}

@property (nonatomic, retain) IBOutlet UITextField *textField1;
@property (nonatomic, retain) IBOutlet UITextField *textField2;
@property (nonatomic, retain) IBOutlet UITextField *textField3;
@property (nonatomic, retain) IBOutlet UITextField *textField4;
@property (nonatomic, retain) IBOutlet UITextField *textField5;

- (IBAction) saveArrayToPlist;


@end
