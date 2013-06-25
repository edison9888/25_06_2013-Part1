//
//  FileManager.h
//  Torq361
//
//  Created by Nithin George on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ID_DATASTORE_FILENAME @"Torq361.db.zip"//CompanyId1
@interface FileManager : NSObject {
    
    
    
}


- (BOOL)installDataStore:(NSString *)folderName;
-(BOOL)unzipDataStore:(NSString*)strPath;

@end
