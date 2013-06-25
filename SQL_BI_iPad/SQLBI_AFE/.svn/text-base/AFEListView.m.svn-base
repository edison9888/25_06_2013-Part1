//
//  AFEListView.m
//  SQLBI_AFE
//
//  Created by Rapidvalue on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFEListView.h"
#import "AFEListViewModel.h"

#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW CGRectMake(11,13,293,205)

@interface AFEListView() 
{
    UIActivityIndicatorView *activityIndicView;
    UIView *activityIndicContainerView;
    UIView *activityIndicBGView;
    UILabel *messageLabel;
}

@property (nonatomic, strong) NSIndexPath *lastIndex;
@property (nonatomic,strong) AFEListViewModel *listViewModel;
-(void)customizeCurrentView;
@end

@implementation AFEListView
@synthesize searchData;
@synthesize delegate;
@synthesize lastIndex;
@synthesize listViewModel;
@synthesize tableViewForList;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self customizeCurrentView];
        
    }
    return self;
}

-(void)customizeCurrentView
{
    UIImageView *backgroungImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,236)];
    backgroungImage.image = [UIImage imageNamed:@"innerPopup.png"];
    [self addSubview:backgroungImage];
    self.tableViewForList = [[UITableView alloc] initWithFrame:CGRectMake(14,16,287,180) style:UITableViewStylePlain];
    self.tableViewForList.delegate = self;
    self.tableViewForList.dataSource = self;
    [self addSubview:tableViewForList];
}

#pragma mark - View modification methods

-(void) showActivityIndicatorOverlayView
{
    [self removeActivityIndicatorOverlayView];
    
    if(!activityIndicView)
    {
        activityIndicView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    else
        [activityIndicView removeFromSuperview];
    
    if(!activityIndicContainerView)
        activityIndicContainerView = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW];
    else
    {
        [activityIndicContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [activityIndicContainerView removeFromSuperview];
        
    }
        
    if(!activityIndicBGView)
        activityIndicBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, activityIndicContainerView.frame.size.width, activityIndicContainerView.frame.size.height)];
    else
        [activityIndicBGView removeFromSuperview];
    
    //Set Styling for all Views
    activityIndicContainerView.backgroundColor = [UIColor clearColor];
    activityIndicBGView.backgroundColor = [UIColor blackColor];
    activityIndicBGView.alpha = 0.05;
    activityIndicView.frame = CGRectMake((activityIndicContainerView.frame.size.width-50)/2, (activityIndicContainerView.frame.size.height-50)/2, 50, 50);
    activityIndicView.color = [UIColor darkGrayColor];
    
    [activityIndicContainerView addSubview:activityIndicBGView];
    [activityIndicContainerView addSubview:activityIndicView];
    [self addSubview:activityIndicContainerView];
    
    [activityIndicView startAnimating];
    
}

-(void) removeActivityIndicatorOverlayView
{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(activityIndicView)
        [activityIndicView stopAnimating];
    
}

-(void) showMessageOnView:(NSString*) message
{
    if(self.tableViewForList)
    {
        [searchData removeAllObjects];
        [tableViewForList reloadData];   
    }
    
    if(!activityIndicContainerView)
        activityIndicContainerView = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW];
    else
    {
        [activityIndicContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [activityIndicContainerView removeFromSuperview];
        
    }

    if(!messageLabel)
    {
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (activityIndicContainerView.frame.size.height-15)/2 + 8, activityIndicContainerView.frame.size.width, 15)];
    }
    
    messageLabel.font = [UIFont fontWithName:COMMON_FONTNAME_BOLD size:15];
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.backgroundColor= [UIColor clearColor];
    messageLabel.text = message? message:@"";
    messageLabel.textAlignment = UITextAlignmentCenter;
    
    [activityIndicContainerView addSubview:messageLabel];
    [self addSubview:activityIndicContainerView];
    
}

-(void) hideMessageOnView
{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(messageLabel)
        messageLabel.text = @"";
}

-(void) reloadData
{
    if(self.tableViewForList)
        [self.tableViewForList reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchData? [searchData count]:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
        // if(indexPath.row < [searchData count]){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if(indexPath.row < [searchData count]){
            listViewModel = [searchData objectAtIndex:indexPath.row];
            cell.textLabel.text = listViewModel.name;
            [cell.textLabel setFont:FONT_SEARCH_VALUE_LABEL_BOLD];
            if (listViewModel.isSelected)
                {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.lastIndex = indexPath;	
                }
                else
                    cell.accessoryType = UITableViewCellAccessoryNone;
        }
                
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        
        return cell;

   }


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AFEListViewModel *tempListModel;

    for(int i = 0; i < [searchData count]; i++)
    {
        tempListModel = [searchData objectAtIndex:i];
        
        if(i == indexPath.row)
        {
            tempListModel.isSelected = YES;
        }
        else
        {
            tempListModel.isSelected = NO;
        }
    }
    
    [tableView reloadData];
    
    
  /*  UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    
	int presentRow=[indexPath row];
	int oldRow= (self.lastIndex != nil) ? [self.lastIndex row] : -1;
	
	if(presentRow!=oldRow)
	{
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
		UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndex]; 
		oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        if (oldRow >= 0) {
            listViewModel = [self.searchData objectAtIndex:presentRow];
            listViewModel.isSelected = NO;
        }

		
		self.lastIndex = indexPath;	
        
	}
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    listViewModel = [self.searchData objectAtIndex:indexPath.row];
    listViewModel.isSelected = YES; */

    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(didSelectdropDownList:)])
        [delegate didSelectdropDownList:self.searchData];
}

@end
