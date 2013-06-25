//
//  InformationViewController.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 12/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InformationViewController.h"

@interface InformationViewController (){


}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewINFO;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControlINFO;

@end

@implementation UITextView (DisableCopyPaste)

- (BOOL)canBecomeFirstResponder
{
    return NO;
}

@end

@implementation InformationViewController
@synthesize scrollViewINFO;
@synthesize pageControlINFO;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollViewINFO.contentSize = CGSizeMake(scrollViewINFO.frame.size.width * 2, scrollViewINFO.frame.size.height);
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed)];
    [self.navigationItem setRightBarButtonItem:cancelButton animated:NO];


    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setScrollViewINFO:nil];
    [self setPageControlINFO:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)cancelButtonPressed{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(cancelBtnClikced)])
        [self.delegate cancelBtnClikced];

}

- (void)scrollViewDidScroll:(UIScrollView *)sender{
      int page = floor((scrollViewINFO.contentOffset.x - 400 / 2) / 400) + 1;
      if(1 == page) 
          pageControlINFO.currentPage= 0;
      else {
          pageControlINFO.currentPage= 1;

      }

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
