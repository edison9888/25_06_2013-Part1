//
//  TQCategory.h
//  Torq361
//
//  Created by Jayahari V on 21/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*Modify any changes to the category item display changes here. This class is a single 
 category item, you can later add any features to the category display view by 
 just adding any views over the |self| 
 
 for any doubts regarding these class please contact: Jayahari V, Rapid Value Solutions
 */

#import <UIKit/UIKit.h>
#import "CategoryDetails.h"

@interface TQCategory : UIView {

    UIImageView *   imageView;      /*Display image for each category*/
    UILabel *       title;          /*title of each category*/
    
    CategoryDetails * category;     /*current category which will be set while we
                                     initialize the TQCategory object*/
    
    UIActivityIndicatorView * indicator;
    
}
@property (nonatomic, retain) UIImageView *    imageView; 
@property (nonatomic, retain) UILabel *        title;
@property (nonatomic, retain) CategoryDetails * category;
@property (nonatomic, retain) UIActivityIndicatorView * indicator;

- (id)initWithCategoryDetails:(CategoryDetails*)categoryDetails;

@end
