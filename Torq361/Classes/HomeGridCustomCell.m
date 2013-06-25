//
//  HomeGridCustomCell.m
//  Torq361
//
//  Created by Binoy on 12/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeGridCustomCell.h"
#import "Home.h"
#import "ProductDetails.h"
#import "TQProductInGrid.h"


@implementation HomeGridCustomCell

@synthesize rowProducts;


- (id)initWithProductDetails:(NSArray*)_products reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewStylePlain reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialize cell with the array of elemenst to display
        self.rowProducts = _products;
        
    }
    return self;
}

- (void)setProducts:(NSArray *)products {
    
    for(UIView *view in [self subviews]) 
    {		
        [view removeFromSuperview];
    }
    
    self.rowProducts = products;
}

-(void)layoutSubviews {
    
    CGRect frame = CGRectMake(4, 2, 210, 250);
    
    for(ProductDetails *productDetail in self.rowProducts) {
        TQProductInGrid * product = [[TQProductInGrid alloc] initWithProductDetail:productDetail];
        [product setFrame:frame];
        [product addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:product 
                                                                               action:@selector(onTouchProduct:)] autorelease]];
        [self addSubview:product];		 
        [product release];
        frame.origin.x = frame.origin.x + frame.size.width + 15;
    }
}

- (void)dealloc {
	
   // NSLog(@"Deallocating home grid custom cell");
    self.rowProducts = nil;
    [super dealloc];
}


@end
