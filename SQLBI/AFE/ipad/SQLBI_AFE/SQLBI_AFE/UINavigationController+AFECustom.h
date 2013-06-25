//
//  RBNavigationController.h
//  TheDailyMeal
//
//  Created by Nithin George on 02/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface UINavigationController (AFECustom) 

//-(void) createBackButtonForAFEWithDelegateForAFE:(NSObject*) delegate;
-(void) customizeNavigationBarForAFE;

@end


@interface UINavigationItem (AFE) 

//- (void)setTitle:(NSString *)title;

@end