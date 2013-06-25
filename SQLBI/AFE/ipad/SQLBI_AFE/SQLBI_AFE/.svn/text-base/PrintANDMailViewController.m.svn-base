//
//  PrintANDMailViewController.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrintANDMailViewController.h"

@interface PrintANDMailViewController ()
@property (strong, nonatomic) IBOutlet UIButton *emailBtn;
@property (strong, nonatomic) IBOutlet UIButton *printBtn;
- (IBAction)printBtnTouched:(id)sender;
- (IBAction)emailBtnTouched:(id)sender;

@end

@implementation PrintANDMailViewController
@synthesize emailBtn;
@synthesize printBtn;
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
    [self setContentSizeForViewInPopover:CGSizeMake(176, 90)];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setEmailBtn:nil];
    [self setPrintBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
- (IBAction)printBtnTouched:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(printButtonClicked)])
        [self.delegate printButtonClicked];

}

- (IBAction)emailBtnTouched:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(mailButtonClicked)])
        [self.delegate mailButtonClicked];
}
@end
