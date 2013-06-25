//
//  Image.h
//  PE
//
//  Created by Nithin George on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Image : NSObject {
    
    int idListImage;
    int idList;
    int imageType;
    
    NSString *imageUrl;
    
}

@property(nonatomic,assign) int idListImage;
@property(nonatomic,assign) int idList;
@property(nonatomic,assign) int imageType;

@property(nonatomic,retain) NSString *imageUrl;

@end
