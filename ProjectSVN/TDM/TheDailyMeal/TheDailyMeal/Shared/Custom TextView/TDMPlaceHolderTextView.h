//
//  TDMPlaceHolderTextView.h.h
//  TheDailyMeal
//
//  Created by Nithin George on 4/2/12.
//  Copyright 2011 Rapidvalue Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TDMPlaceHolderTextView : UITextView {
    @private
    UILabel *placeHolderLabel;
    
}
@property(nonatomic,copy)NSString *placeHolder;

@end
