//
//  DataEntryCell.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseDataCell.h"
#import "Constants.h"
#import "Utility.h"
#import "PlndrBaseViewController.h"

@interface BaseDataCell ()

- (void) touchedNext:(id)sender;
- (void) touchedPrevious:(id)sender;
- (void) touchedDismiss:(id)sender;
   
@end

@implementation BaseDataCell

@synthesize baseDataCellDelegate = _baseDataCellDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void) initSubviews {
    self.textLabel.textColor = kPlndrBlack;
    self.detailTextLabel.textColor = kPlndrBlack;
    
    self.textLabel.font = kFontBoldCond16;
    self.detailTextLabel.font = kFontRoman16;
}

- (void) update {
    [self setNeedsLayout];
}

- (void) setCellEnabled:(BOOL)isEnabled {
    self.userInteractionEnabled = isEnabled;
    
    self.textLabel.textColor = isEnabled ? kPlndrBlack : kPlndrLightGreyTextColor;
    self.detailTextLabel.textColor = isEnabled ? kPlndrBlack : kPlndrLightGreyTextColor;
}


- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (highlighted) {
        self.backgroundColor = kListHighlightColor;
    } else {
        self.backgroundColor = [self.baseDataCellDelegate isBaseDataCellValid:self] ? [UIColor whiteColor] : kPlndrDataCellErrorColor;
    }
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated{
    if (selected) {
        self.backgroundColor = kListHighlightColor;
    } else {
        self.backgroundColor = [self.baseDataCellDelegate isBaseDataCellValid:self] ? [UIColor whiteColor] : kPlndrDataCellErrorColor;
    }
}

- (UIView*) getInputAccessoryViewWithType:(InputAccessoryViewType)type {
    if (type == InputAccessoryNone) {
        return  nil;
    }
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    NSMutableArray *barButtonItems = [NSMutableArray array];
    
    if (type == InputAccessoryPreviousDismiss || type == InputAccessoryPreviousNextDismiss || type == InputAccessoryPreviousDismissGo) {
        UIButton *previousBarButton = [PlndrBaseViewController createNavBarButtonWithText:@"Previous" withNormalColor:kPlndrTextGold withHighlightColor:kPlndrBlack];
        [previousBarButton addTarget:self action:@selector(touchedPrevious:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:previousBarButton];
        [barButtonItems addObject:barItem];
    }
    
    if (type == InputAccessoryNextDismiss || type == InputAccessoryPreviousNextDismiss) {
        UIButton *nextBarButton = [PlndrBaseViewController createNavBarButtonWithText:@"Next" withNormalColor:kPlndrTextGold withHighlightColor:kPlndrBlack];
        [nextBarButton addTarget:self action:@selector(touchedNext:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:nextBarButton];
        [barButtonItems addObject:barItem];
    }
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barButtonItems addObject:flexibleSpace];
    
    UIImage *dismissButtonImage = [UIImage imageNamed:@"dismiss_btn.png"];
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton setFrame:CGRectMake(0, 0, dismissButtonImage.size.width, dismissButtonImage.size.height)];
    [dismissButton setImage:dismissButtonImage forState:UIControlStateNormal];
    [dismissButton setImage:[UIImage imageNamed:@"dismiss_btn_hl.png"] forState:UIControlStateHighlighted];
    [dismissButton addTarget:self action:@selector(touchedDismiss:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:dismissButton];
    [barButtonItems addObject:barItem];
    
    
    [toolbar setItems:barButtonItems];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar sizeToFit];
    toolbar.frame = CGRectMake(0, 0, toolbar.frame.size.width, 40);

    return toolbar;
}

- (void)touchedNext:(id)sender {
    if ([self.baseDataCellDelegate respondsToSelector:@selector(executeNextBlockForBaseDataCell:)]) {
        [self.baseDataCellDelegate performSelector:@selector(executeNextBlockForBaseDataCell:) withObject:self];
    }
}

- (void)touchedPrevious:(id)sender {
    if ([self.baseDataCellDelegate respondsToSelector:@selector(executePreviousBlockForBaseDataCell:)]) {
        [self.baseDataCellDelegate performSelector:@selector(executePreviousBlockForBaseDataCell:) withObject:self];
    }
}

- (void)touchedDismiss:(id)sender {
    [[Utility getFirstResponder] resignFirstResponder];
}

- (UIReturnKeyType)getReturnKeyTypeForInputAccessoryView:(InputAccessoryViewType)accessoryType {
    switch (accessoryType) {
        case InputAccessoryPreviousNextDismiss:
        case InputAccessoryNextDismiss:
            return UIReturnKeyNext;
        case InputAccessoryPreviousDismiss:
            return UIReturnKeyDone;
		case InputAccessoryPreviousDismissGo:
			return UIReturnKeyGo;
        case InputAccessoryNone:
        default:
            return UIReturnKeyDefault;
    }
}

- (void) becomeFirstResponderIfCapable {
    // To be implemented by capable subclasses
}

- (float)alphaForCellContents:(BOOL)isCellEnabled {
    return isCellEnabled ? 1.0f : 0.6f;
}

- (void)prepareForReuse {
    self.tag = kBaseDataCellInvalidIndexTag;
    // The cell tries to figure things out about its previous state. which is based on its old index path, which we get from the tag.
    // But if that's out of date, this can cause crashes.
    // So if the cell is about to be re-used, don't let it prepare based on old data - it'll fix itself during update anyway.
    [super prepareForReuse];
}

@end
