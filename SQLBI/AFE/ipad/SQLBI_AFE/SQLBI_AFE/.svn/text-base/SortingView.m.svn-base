//
//  SortingView.m
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 20/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SortingView.h"

@interface SortingView ()
{
   IBOutlet UIButton *ascendingButton;
   IBOutlet UIButton *descendingButton;
}

@end

@implementation SortingView

@synthesize delegate;
@synthesize sortType,sortingParameter;

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

    [ascendingButton setTitleColor:[Utility getUIColorWithHexString:@"22313f"] forState:UIControlStateNormal];
    [ascendingButton.titleLabel setFont:FONT_HEADLINE_TITLE];
    [ascendingButton setImage:[UIImage imageNamed:@"ascendingImage"] forState:UIControlStateNormal]; 
    [ascendingButton setBackgroundImage:[UIImage imageNamed:@"newTableRowBg"] forState:UIControlStateNormal];
    [ascendingButton setTitle:@"Sort Ascending" forState:UIControlStateNormal];
    [ascendingButton addTarget:self action:@selector(sortOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    [descendingButton setTitleColor:[Utility getUIColorWithHexString:@"22313f"] forState:UIControlStateNormal];
    [descendingButton.titleLabel setFont:FONT_HEADLINE_TITLE];
    [descendingButton setTitle:@"Sort Descending" forState:UIControlStateNormal];
    [descendingButton setImage:[UIImage imageNamed:@"descendingImage"] forState:UIControlStateNormal]; 
    [descendingButton setBackgroundImage:[UIImage imageNamed:@"newTableRowBg"] forState:UIControlStateNormal];
    [descendingButton addTarget:self action:@selector(sortOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)sortOrder:(id)sender
{
    switch ([sender tag]) {
        case 0:
            self.sortType = AFESortDirectionAscending;
            break;
        case 1:
            self.sortType = AFESortDirectionDescending;
        default:
            self.sortType = AFESortDirectionDescending;
            break;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(sortClicked:withSortingParameter:withType:) ])
    {
        [self.delegate sortClicked:[sender tag] withSortingParameter:self.sortingParameter withType:self.sortType];
    }

    
}
@end
