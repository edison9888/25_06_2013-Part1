//
//  CategoryCustomCell.m
//  Torq361
//
//  Created by Binoy on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryCustomCell.h"
#import "Torq361AppDelegate.h"
#import "Home.h"

#import "TQCategory.h"


@implementation CategoryCustomCell

@synthesize rowcategories;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)dealloc {
	
	NSLog(@"CategoryCustomCell Dealloc");

    self.rowcategories = nil;
	
    [super dealloc];
}

-(id)initWithCategories:(NSArray*)_categories reuseIdentifier:(NSString*)_identifier {
    
    self = [super initWithStyle:UITableViewStylePlain reuseIdentifier:_identifier];
    if(self) {
        self.rowcategories = _categories;
    }
    return self;
}

-(void)layoutSubviews {
    
    CGRect frame = CGRectMake(4, 2, 155, 145);
    
    for(TQCategory *category in self.rowcategories) {
        
        [category setFrame:frame];
        [category addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:category 
                                                                             action:@selector(onTouchCategory:)] autorelease]];
        [self addSubview:category];		 
        frame.origin.x = frame.origin.x + frame.size.width + 4;
    }
}

-(void)setCategories:(NSArray *)categories {
    
    for(UIView *view in [self subviews]) 
    {		
        [view removeFromSuperview];
    }
    
    self.rowcategories = categories;
}



@end
