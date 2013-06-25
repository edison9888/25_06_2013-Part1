//
//  BaseModalViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseModalViewController.h"
#import "Utility.h"
#import "Constants.h"

@interface BaseModalViewController () 

- (BOOL) isEmptyTable:(UITableView*) table;

@end

@implementation BaseModalViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
}

- (void)viewDidLoad {   
    [super viewDidLoad];
    [self setupNavBar];
}

- (void) viewDidUnload {
    [super viewDidUnload];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)setupNavBar {
    // Setup the right nav button
    UIButton *rightBtn = [PlndrBaseViewController createNavBarButtonWithText:@"DONE" withNormalColor:kPlndrTextGold withHighlightColor:kPlndrBlack];
    [rightBtn addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIButton *leftBtn = [PlndrBaseViewController createNavBarButtonWithText:@"CANCEL"];
    [leftBtn addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
}


- (CGRect) defaultFrame {
    return CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - self.navigationController.navigationBar.frame.size.height);
}


- (void)cancelButtonPressed {
    [[Utility getFirstResponder] resignFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)doneButtonPressed {
    [[Utility getFirstResponder] resignFirstResponder];
    
    if ([self isEmptyTable:self.dataTable]) {
        // Do not Save if There are no Cells in Table
        return;
    }
    
    if (![self isModalDataValid]) {
        [self showDataErrors];
        [self.dataTable reloadData];
        return;
    }
    else {
        [self resetErrorHeader];
    }

    [self saveModalData];
    if ([self canBeVerifiedLocally]) {
        [self dismissModalViewControllerAnimated:YES];
    } 
}

- (BOOL)canBeVerifiedLocally {
    return YES; // Override in subclasses if necessary
}

- (void) saveModalData {
    // Override in subclasses
}

- (BOOL) isEmptyTable:(UITableView*) table {
    int section = [self numberOfSectionsInTableView:table];
    for (int i =0; i < section; i++) {
        if ([table numberOfRowsInSection:i] > 0) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isModalDataValid {
    BOOL isValid = YES;
    BOOL oldIsValidatingData = self.isValidatingData;
    self.isValidatingData = YES;
    for (int i = 0; i < [self numberOfSectionsInTableView:self.dataTable]; i++) {
        for (int j = 0; j < [self tableView:self.dataTable numberOfRowsInSection:i]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:indexPath];
            if (!cellMetaData.isValid) {
                isValid = NO;
                break;
            }
        } 
        if (!isValid) {
            break;
        }
    }
    self.isValidatingData = oldIsValidatingData;
    return isValid;  
}

- (BOOL) isDataViewValid {
    return [self isModalDataValid];
}

#pragma mark - TitleAndTextDataCellDelegate

- (void) setDetailString:(NSString*)detailString forTitleAndTextFieldDataCell:(TitleAndTextFieldDataCell*)sender {
    [super setDetailString:detailString forTitleAndTextFieldDataCell:sender];
    [self revalidateDataCell:sender];
    
}

#pragma mark - TitleAndPickerDataCellDelegate

- (void)validatePickerCell:(TitleAndPickerViewDataCell *)sender {
    [self revalidateDataCell:sender];
    
}


@end
