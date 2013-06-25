//
//  FirstViewController.m
//  PlistTutorial2
//
//  Created by Kent Franks on 7/18/11.
//  Copyright 2011 TheAppCodeBlog. All rights reserved.
//

#import "FirstViewController.h"

@implementation FirstViewController

@synthesize textField1, textField2, textField3, textField4, textField5;

- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (IBAction) saveArrayToPlist
{
	// First we create our array from the text retrieved from our UITextFields
    
    NSMutableDictionary *temp = [[NSMutableDictionary alloc]init];
    [temp setValue:@"temp" forKey:@"name"];
    [temp setValue:textField2.text forKey:@"last name"];
    [temp setValue:textField3.text forKey:@"address"];
    [temp setValue:textField1.text forKey:@"namef"];
    [temp setValue:textField2.text forKey:@"last naefwme"];
    [temp setValue:textField3.text forKey:@"addreewffss"];
    [temp setValue:textField1.text forKey:@"namweee"];
    [temp setValue:textField2.text forKey:@"ladst name"];
    [temp setValue:textField3.text forKey:@"adddress"];
    [temp setValue:textField1.text forKey:@"namffege"];
    [temp setValue:textField2.text forKey:@"latehethst name"];
    [temp setValue:textField3.text forKey:@"adutukdress"];
    [temp setValue:textField1.text forKey:@"nal'me"];
    [temp setValue:textField2.text forKey:@"l ast name"];
    [temp setValue:textField3.text forKey:@"addrejhgkgss"];
    [temp setValue:textField1.text forKey:@"nsfame"];
    [temp setValue:textField2.text forKey:@"last45 name"];
    [temp setValue:textField3.text forKey:@"add5857ress"];
    [temp setValue:textField1.text forKey:@"nam9780e"];
    [temp setValue:textField2.text forKey:@"las8986=t name"];
    [temp setValue:textField3.text forKey:@"add=0[ress"];
    [temp setValue:textField1.text forKey:@"nam53e"];
    [temp setValue:textField2.text forKey:@"lascact name"];
    [temp setValue:textField3.text forKey:@"add    ress"];
    [temp setValue:textField1.text forKey:@"na    me"];
    [temp setValue:textField2.text forKey:@"la  st name"];
    [temp setValue:textField3.text forKey:@"ad    dress"];
    [temp setValue:textField1.text forKey:@"na    me"];
    [temp setValue:textField2.text forKey:@"la      st name"];
    [temp setValue:textField3.text forKey:@"ad  c dress"];
    [temp setValue:textField1.text forKey:@"na c me"];
    [temp setValue:textField2.text forKey:@"la  v st name"];
    [temp setValue:textField3.text forKey:@"addr  v ess"];    [temp setValue:textField1.text forKey:@"name"];
    [temp setValue:textField2.text forKey:@"last v name"];
    [temp setValue:textField3.text forKey:@"addr  ess"];
    [temp setValue:textField1.text forKey:@"name  "];
    [temp setValue:textField2.text forKey:@"last n  vv ame"];
    [temp setValue:textField3.text forKey:@"addre v  v ss"];
    [temp setValue:textField1.text forKey:@"name   "];
    [temp setValue:textField2.text forKey:@"lastfxbfdh name"];
    [temp setValue:textField3.text forKey:@"adert3tdress"];
    [temp setValue:textField1.text forKey:@"nart3me"];
    [temp setValue:textField2.text forKey:@"laer34rfst name"];
    [temp setValue:textField3.text forKey:@"addr23tf3ress"];
    [temp setValue:textField1.text forKey:@"namf3tfe"];
    [temp setValue:textField2.text forKey:@"lastrf343 name"];
    [temp setValue:textField3.text forKey:@"addrr3tess"];
    [temp setValue:textField1.text forKey:@"nam4r3e"];
    [temp setValue:textField2.text forKey:@"last nam34r43e"];
    [temp setValue:textField3.text forKey:@"addresfr3rt43s"];
    
//    
//	NSMutableArray *array = [[NSMutableArray alloc] init];
//	[array addObject:textField1.text];
//	[array addObject:textField2.text];
//	[array addObject:textField3.text];
//	[array addObject:textField4.text];
//	[array addObject:textField5.text];
//	
//	// get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Data.plist"];
	
	// This writes the array to a plist file. If this file does not already exist, it creates a new one.
	[temp writeToFile:plistPath atomically: TRUE];
	
}


- (void)textFieldShouldReturn:(id)sender
{
	[sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [super dealloc];
}

@end
