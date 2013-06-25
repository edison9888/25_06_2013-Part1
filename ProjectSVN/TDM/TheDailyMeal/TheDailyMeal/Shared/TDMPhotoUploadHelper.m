//
//  TDMPhotoUploadHelper.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMPhotoUploadHelper.h"
#import "NSDataAdditions.h"

#import "TDMFilePUTHelper.h"

@implementation TDMPhotoUploadHelper

-(void)uploadPhotoFromPath:(NSString *)filePath withFileName:(NSString *)fileName andUploadType:(int)fileType {
    
    NSString * fileuploadURL = [NSString stringWithFormat:@"/app/file"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
        
    NSString *photoPath = [documentsDirectory stringByAppendingPathComponent:@"vivek.jpg"];
    NSLog(@"%@",photoPath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:photoPath]) {
        NSLog(@"It exists");
    }
    
    NSData *fileData = [NSData dataWithContentsOfFile:photoPath];
    
    NSLog(@"Length of the file is %d",fileData.length);
    
    NSString * test64String = [fileData base64Encoded];
    
    //NSLog(@"%@",test64String);
    
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[NSString stringWithFormat:@"%d",fileData.length] forKey:@"filesize"];
    [dictionary setObject:@"vivek.jpg" forKey:@"filename"];
    [dictionary setObject:@"pictures/vivek.jpg" forKey:@"filepath"];
    [dictionary setObject:test64String forKey:@"file"];
    [dictionary setObject:@"6338" forKey:@"uid"];
    
    NSString * requestString = [dictionary JSONRepresentation];
    [dictionary release];
    
    NSLog(@"%@",requestString);
    
    [self postRequest:fileuploadURL RequestBody:requestString withRequestType:kTDMPhotUpload];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed due to server error: %@ %d",request.responseString,request.responseStatusCode);
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"From TDM Photo Upload Finished %@",[[request responseString] JSONValue]);
    
    NSDictionary * dictionary = [[request responseString] JSONValue];
    
    NSLog(@"%@",[dictionary objectForKey:@"fid"]);
    
    TDMFilePUTHelper *filePutter = [[TDMFilePUTHelper alloc] init];
    [filePutter putFileWithFID:[dictionary objectForKey:@"fid"]];
    
    [delegate requestCompletedSuccessfully:request];
} 
@end
