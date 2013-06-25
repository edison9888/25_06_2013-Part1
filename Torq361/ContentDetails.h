//
//  ContentDetails.h
//  Torq361
//
//  Created by JK on 22/06/11.
//  Copyright 2011 RapidValue . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ContentDetails : NSObject {
    
	
 
    int       idContent;
    int       idCatalog;
    int       idProduct;
    NSString  *Path;
    NSString  *Type;

    
}

 
 
@property (nonatomic)  int       idContent;
@property (nonatomic)  int       idProduct;
@property (nonatomic)  int       idCatalog;
@property (nonatomic,retain)  NSString  *Path;
@property (nonatomic,retain)  NSString  *Type;

@end
