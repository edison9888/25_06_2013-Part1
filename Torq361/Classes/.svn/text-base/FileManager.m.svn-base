//
//  FileManager.m
//  Torq361
//
//  Created by Nithin George on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileManager.h"
#import "ZipArchive.h"

@implementation FileManager

- (BOOL)installDataStore:(NSString *)folderName {
    
	// Copy resource files
	NSError *error = nil;
	BOOL success = YES;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *destPath = [paths objectAtIndex:0];
	NSString *srcPath = [[NSBundle mainBundle] resourcePath];
	
	NSArray *fileList = [fileManager contentsOfDirectoryAtPath:srcPath error:&error];
	
	for(int i = 0; i < [fileList count]; i++)
	{
		BOOL isDirectory = YES;
        
		NSString *fn = [fileList objectAtIndex:i];
		BOOL ok = YES;
		
		if (![fn isEqualToString:folderName])//ID_DATASTORE_FILENAME]) 
			ok=NO;
		
		
		// We got the datastore file,copy it
		if (ok)
		{
			NSString *dataStoreFolder= [destPath stringByAppendingFormat:@"/%@",folderName];//ID_DATASTORE_FILENAME ];
			NSString *fileTo = [destPath stringByAppendingPathComponent:fn];
			NSString *fileFrom = [srcPath stringByAppendingPathComponent:fn];
			
			// If the file does not exist, copy it from the app bundle.
			if(![fileManager fileExistsAtPath:dataStoreFolder isDirectory:&isDirectory])
			{
				if([fileManager fileExistsAtPath:fileTo]){
					return [self unzipDataStore:fileTo];
					
				}
				// Set path to the app bundle file.
				NSLog(@"Installing %@ to %@", fileFrom, fileTo);
				success = [fileManager copyItemAtPath:fileFrom toPath:fileTo error:&error];
				if (success) {
					[self unzipDataStore:fileTo];
				}else{
					NSLog(@"Copy error: %@",[error localizedDescription]);
					success=NO;
				}
			}
			else {
				NSLog(@"File exists at path : %@",dataStoreFolder);
			}
			
			return success;
            
		}
	}
	
	return success;
}

-(BOOL)unzipDataStore:(NSString *)strPath{
	ZipArchive* za = [[ZipArchive alloc] init];
	NSString *strRoot=nil;
	if( [za UnzipOpenFile: strPath] ) {
		//get Root Directory
		strRoot=[za getRootDirectory];
		NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		BOOL ret = [za UnzipFileTo: [NSString stringWithFormat: @"%@/",docsDirectory ] overWrite:YES];
        if( NO==ret ) {
            NSLog(@"Failed to decompress content %@", strPath);
			return NO;
        } else {
            NSError *error = nil;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL success = [fileManager removeItemAtPath:strPath error:&error];
            if (success == NO) {
                NSLog(@"Failed to remove DataStore.zip , %@", error);
            }
		}
        [za UnzipCloseFile];
    }
	return YES;
    [za release];
}
@end
