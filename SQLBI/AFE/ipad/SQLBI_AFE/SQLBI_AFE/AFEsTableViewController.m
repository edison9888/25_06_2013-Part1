//
//  AFEsTableViewController.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFEsTableViewController.h"
#import "AFECustomCell.h"
#import "AFE.h"

@interface AFEsTableViewController ()
{
   // NSArray* _afeArray;
}

@end

@implementation AFEsTableViewController
@synthesize afeArray;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        
//    }
//    return self;
//}

-(id) initWithFrame:(CGRect)frame
{
    self = (AFEsTableViewController*) [[[NSBundle mainBundle] loadNibNamed:@"AFEsTableViewController" owner:self options:nil] lastObject];
    if (self) {
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
    }
    return self;
}

//-(id) initWithAFEArray:(NSArray*) afeArrayToBeUsed
//{
//    self = [super initWithNibName:@"AFEsTableViewController" bundle:nil];
//    
//    if(self)
//    {
//        self.afeArray = afeArrayToBeUsed;
//    }
//
//    return self;
//}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//}
//
//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

-(void) refreshDataWithAFEArray:(NSArray*) afeArrayToUse
{
    self.afeArray = afeArrayToUse;
     
    [afeTableView reloadData];
}


#pragma mark - table view datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.afeArray? self.afeArray.count:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AFECustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AFECustomCell"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AFECustomCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    AFE *tempAFE = [self.afeArray objectAtIndex:indexPath.row];
   
    if(tempAFE)
    {
        cell.afeNameLabel.text = tempAFE.name;
        cell.afeClassLabel.text = tempAFE.afeClassName;
        cell.afeBudgetLabel.text = [NSString stringWithFormat:@"$ %.f",tempAFE.budget];
        cell.afeFieldEstimateLabel.text = [NSString stringWithFormat:@"$ %.f",tempAFE.fieldEstimate];
        cell.afeActualsLabel.text = [NSString stringWithFormat:@"$ %.f",tempAFE.actual];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    cell.afeNameLabel.text = [NSString stringWithFormat:@"AFE# %d",indexPath.row];
//    cell.afeClassLabel.text = [NSString stringWithFormat:@"Drilling"];
//    cell.afeBudgetLabel.text = [NSString stringWithFormat:@"$ %d",(indexPath.row+1)*2000];
//    cell.afeFieldEstimateLabel.text = [NSString stringWithFormat:@"$ %d",(indexPath.row+1)*2100];
//    cell.afeActualsLabel.text = [NSString stringWithFormat:@"$ %d",(indexPath.row+1)*1800];
    
    return cell;
}

-(void) dealloc
{
    self.afeArray = nil;
}

@end
