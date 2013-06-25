//
//  InformationViewController.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 12/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InformationViewController.h"

@interface InformationViewController (){

    IBOutlet UITextView *infoTextView;

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

@implementation UIPageControl (Custom)

- (void)setCurrentPage:(NSInteger)page {
    
    NSString* imgActive = [[NSBundle mainBundle] pathForResource:@"roundSelected" ofType:@"png"];
    NSString* imgInactive = [[NSBundle mainBundle] pathForResource:@"roundDefault" ofType:@"png"];
    
    for (int subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        subview.layer.cornerRadius=8.0;
        subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y, 7, 7);
        if (subviewIndex == page)
            [subview setImage:[UIImage imageWithContentsOfFile:imgActive]];
        else 
            [subview setImage:[UIImage imageWithContentsOfFile:imgInactive]];
    }
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
        //  scrollViewINFO.contentSize = CGSizeMake(scrollViewINFO.frame.size.width * 2, scrollViewINFO.frame.size.height);
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed)];
    [self.navigationItem setRightBarButtonItem:cancelButton animated:NO];

    infoTextView.font = [UIFont fontWithName:COMMON_FONTNAME_NORMAL size:14.0];
    infoTextView.textColor = [UIColor blackColor];
    infoTextView.backgroundColor = [UIColor lightTextColor];

    // Do any additional setup after loading the view from its nib.
    
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    infoTextView.text = [NSString stringWithFormat:@"Feature-rich application allows engineers to track Capital and LOE projects completed on schedule and budget. \n\nVersion: %@", appVersion];
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
