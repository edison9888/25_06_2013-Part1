//
//  TreeMapViewController.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TreeMapViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TreeMapViewController (){
    float width;
    float height;
    float xPos;
    float yPos;

}
@property(nonatomic, assign) CGRect actualSizeTRemember;
@property(nonatomic, assign) NSMutableArray *treeMapValues;

@end

@implementation TreeMapViewController;
@synthesize actualSizeTRemember,treeMapValues,treeMapV,backgroundView,treeMapAnmtnCell;

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
    treeMapV.delegate = self;
    treeMapV.dataSource = self;
   
     // treeMapV.frame= CGRectMake (0,0,500,500); 
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

-(void)draWTreeMapWith:(NSArray*)graphValue drawType:(TreeGraphDrawType)type{
    [treeMapV reloadData];
    
}


#pragma mark -

- (void)updateCell:(TreemapViewCell *)cell forIndex:(NSInteger)index {
      
	cell.backgroundColor = [UIColor colorWithHue:(float)index / (5 + 3)
									  saturation:1 brightness:0.75 alpha:1];
}
#pragma mark -
#pragma mark TreemapView delegate

- (void)treemapView:(TreemapView *)treemapView tapped:(NSInteger)index {
    
    UIView *tmpView = (UIView*) [self.view.subviews objectAtIndex:index];
   self.actualSizeTRemember = CGRectMake(tmpView.frame.origin.x, tmpView.frame.origin.y, tmpView.frame.size.width, tmpView.frame.size.height);
        // indexToRemember = index;
    
    width = self.actualSizeTRemember.size.width;
    height = self.actualSizeTRemember.size.height;
    xPos = self.actualSizeTRemember.origin.x;
    yPos = self.actualSizeTRemember.origin.y;
        //float width = self.treeMapV.frame.size.width;
   self.backgroundView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.treeMapV.frame.size.width , self.treeMapV.frame.size.height)];
    
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = 0.6;
    [self.view addSubview:self.backgroundView];
    
    self.treeMapAnmtnCell = [[TreeMapAnimationCell alloc] initWithFrame:tmpView.frame];
    self.treeMapAnmtnCell.backgroundColor = tmpView.backgroundColor;
    self.treeMapAnmtnCell.frame =tmpView.frame;
    self.treeMapAnmtnCell.delegate = self;
    self.treeMapAnmtnCell.frame = tmpView.frame;
    self.treeMapAnmtnCell.layer.borderColor = [UIColor whiteColor].CGColor;
    self.treeMapAnmtnCell.layer.borderWidth = 2.0;
    [self.view addSubview:self.treeMapAnmtnCell];
    
    [UIView animateWithDuration:0.5 animations:^{
      self.treeMapAnmtnCell.frame = CGRectMake(10,10,self.treeMapV.frame.size.width -20,self.treeMapV.frame.size.height-20);
    }completion:^(BOOL finished){
        [self setLabels];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self 
                   action:@selector(btnTouched)
         forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.text = @"Click";
        button.frame =CGRectMake(0,0,self.treeMapV.frame.size.width -20,self.treeMapV.frame.size.height-20);
        [self.treeMapAnmtnCell addSubview:button]; 
                        
    }];
}

- (void)btnTouched {
    [self removeAnimatedCell];
}

-(void)setLabels {
    
    UIView *containerView = [[ UIView alloc ] init];
    containerView.tag = 12345;
    containerView.frame = CGRectMake((self.treeMapV.frame.size.width/2)-100,(self.treeMapV.frame.size.height/2)-50,200,100);
    containerView.backgroundColor = [UIColor clearColor];
    
    UILabel *afeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 60, 20)];
    afeLbl.text = @"AFE : ";
    [afeLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    afeLbl.backgroundColor = [UIColor clearColor];
    afeLbl.textColor = [UIColor whiteColor];
    afeLbl.textAlignment = UITextAlignmentLeft;
    [containerView addSubview:afeLbl];
    
    UILabel *afeNumLbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 140, 20)];
    afeNumLbl.text = @"AFE Number";
    [afeNumLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    afeNumLbl.backgroundColor = [UIColor clearColor];
    afeNumLbl.textColor = [UIColor whiteColor];
    afeNumLbl.textAlignment = UITextAlignmentLeft;
    [containerView addSubview:afeNumLbl];
    
    UILabel *afeEstimateLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 100, 0)];
    afeEstimateLbl.text = @"AFE Estimate: ";
    [afeEstimateLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    afeEstimateLbl.backgroundColor = [UIColor clearColor];
    afeEstimateLbl.textColor = [UIColor whiteColor];
    afeEstimateLbl.textAlignment = UITextAlignmentLeft;
    afeEstimateLbl.autoresizingMask = NO;
    [containerView addSubview:afeEstimateLbl];
    
    UILabel *afeEstmtDataLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, 140, 20)];
    afeEstmtDataLbl.text = @"$100000";
    [afeEstmtDataLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    afeEstmtDataLbl.backgroundColor = [UIColor clearColor];
    afeEstmtDataLbl.textColor = [UIColor whiteColor];
    afeEstmtDataLbl.textAlignment = UITextAlignmentLeft;
    [containerView addSubview:afeEstmtDataLbl];
    
    UILabel *feldEstimateLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 110, 20)];
    feldEstimateLbl.text = @"Field Estimate: ";
    [feldEstimateLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    feldEstimateLbl.backgroundColor = [UIColor clearColor];
    feldEstimateLbl.textColor = [UIColor whiteColor];
    feldEstimateLbl.textAlignment = UITextAlignmentLeft;
    [containerView addSubview:feldEstimateLbl];
    
    UILabel *fldEstmtDataLbl = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, 90, 20)];
    fldEstmtDataLbl.text = @"$200000";
    [fldEstmtDataLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    fldEstmtDataLbl.backgroundColor = [UIColor clearColor];
    fldEstmtDataLbl.textColor = [UIColor whiteColor];
    fldEstmtDataLbl.textAlignment = UITextAlignmentLeft;
    [containerView addSubview:fldEstmtDataLbl];
    
    UILabel *consmpnLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 120, 20)];
    consmpnLbl.text = @"% Consumption: ";
    [consmpnLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    consmpnLbl.backgroundColor = [UIColor clearColor];
    consmpnLbl.textColor = [UIColor whiteColor];
    consmpnLbl.textAlignment = UITextAlignmentLeft;
    [containerView addSubview:consmpnLbl];
    
    UILabel *consmpnDataLbl = [[UILabel alloc] initWithFrame:CGRectMake(120, 80, 100, 20)];
    consmpnDataLbl.text = @"200%";
    [fldEstmtDataLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    consmpnDataLbl.backgroundColor = [UIColor clearColor];
    consmpnDataLbl.textColor = [UIColor whiteColor];
    consmpnDataLbl.textAlignment = UITextAlignmentLeft;
    [containerView addSubview:consmpnDataLbl];
        // containerView.center = self.treeMapV.center;
    [self.treeMapAnmtnCell addSubview:containerView];
    
}


#pragma mark -
#pragma mark TreeMapAnimationCell Delegate
-(void)removeAnimatedCell{
    [self.backgroundView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.backgroundView removeFromSuperview];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationCurveEaseInOut forView:self.treeMapAnmtnCell cache:YES];
    [self.view addSubview:treeMapAnmtnCell];
    self.treeMapAnmtnCell.frame = self.actualSizeTRemember;
    [UIView setAnimationDidStopSelector:@selector(myAnimationStopped)];
    
    [UIView commitAnimations];
    [self.treeMapAnmtnCell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *ViewTmp = [self.treeMapV viewWithTag:12345];
    if(ViewTmp){
        [ViewTmp removeFromSuperview];
    }

}
-(void)myAnimationStopped {
    [self.treeMapAnmtnCell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.treeMapAnmtnCell removeFromSuperview];
    [self.backgroundView removeFromSuperview];

}

#pragma mark -
#pragma mark TreemapView data source

- (NSArray *)valuesForTreemapView:(TreemapView *)treemapView {
    self.treeMapValues = [NSMutableArray arrayWithObjects:@"20",@"30",@"40",@"50",nil];
    return self.treeMapValues;
}

- (TreemapViewCell *)treemapView:(TreemapView *)treemapView cellForIndex:(NSInteger)index forRect:(CGRect)rect {
	TreemapViewCell *cell = [[TreemapViewCell alloc] initWithFrame:rect];
	[self updateCell:cell forIndex:index];
	return cell;
}

- (void)treemapView:(TreemapView *)treemapView updateCell:(TreemapViewCell *)cell forIndex:(NSInteger)index forRect:(CGRect)rect {
	[self updateCell:cell forIndex:index];
}


@end
