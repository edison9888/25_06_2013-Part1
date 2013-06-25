//
//  TQProductInGrid.h
//  Torq361
//
//  Created by Jayahari V on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*If you want to modify product item display, please do here. This class is a single 
 product item, you can later add any features to the product display view by 
 just adding any views over the |self|.
 Its in grid view product display
 
 for any doubts regarding these class please contact: Jayahari V, Rapid Value Solutions
 */


#import <UIKit/UIKit.h>
#import "ProductDetails.h"

@interface TQProductInGrid : UIView {
    
    ProductDetails  * product;      /*current category which will be set while we
                                     initialize the TQCategory object*/
    
    UIActivityIndicatorView * indicator;
    
}
@property (nonatomic, retain) ProductDetails * product;
@property (nonatomic, retain) UIActivityIndicatorView * indicator;

- (id)initWithProductDetail:(ProductDetails*)productDetail;

@end
