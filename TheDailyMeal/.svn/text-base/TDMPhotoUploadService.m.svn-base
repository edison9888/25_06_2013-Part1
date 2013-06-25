//
//  TDMPhotoUploadService.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 17/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMPhotoUploadService.h"
#import "NSDataAdditions.h"
#import "TDMFilePUTHelper.h"
#import "Reachability.h"
#import "DatabaseManager.h"

@implementation TDMPhotoUploadService

@synthesize photoUploadServicedelegate;
@synthesize isFromAddDish;
@synthesize isFromReview;

- (void)uploadPhotoToTheReviewWithUID:(NSString *)uid withData:(NSData *)data withFileName:(NSString *)fileName{
    
    if([Reachability connected])
    {
        isFromUserLogin = 0;
        NSString * apiURLString = [NSString stringWithFormat:@"%@/rest/app/file",DAILYMEAL_SEVER_PROD];
        NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setObject:[NSString stringWithFormat:@"%d",data.length] forKey:@"filesize"];
        [dictionary setObject:fileName forKey:@"filename"];
        [dictionary setObject:[data base64Encoded] forKey:@"file"];
        [dictionary setObject:uid forKey:@"uid"];
        [dictionary setObject:@"1" forKey:@"status"];
        NSString * requestString = [dictionary JSONRepresentation];
        [dictionary release];
        [self postRequest:apiURLString RequestBody:requestString];
    }
    else
    {
        if (self.photoUploadServicedelegate && [self.photoUploadServicedelegate  respondsToSelector:@selector(networkErrorInAddinBusinessReview)]) 
        {
            [self.photoUploadServicedelegate networkErrorInAddinBusinessReview];
        }
    }
}

-(void)uploadPhotoFromPath:(NSString *)filePath withFileName:(NSString *)fileName andUploadType:(int)fileType 
{
    if([Reachability connected])
    {
    isFromUserLogin = 1;
    NSString * fileuploadURL = [NSString stringWithFormat:@"%@/rest/app/file",DAILYMEAL_SEVER_PROD];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) 
    {
        NSDictionary *userDetails = [[DatabaseManager sharedManager]getUserDetailsFromDataBase];
        NSString *userId= [userDetails objectForKey:@"userid"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSString * test64String = [fileData base64Encoded];
        NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setObject:[NSString stringWithFormat:@"%d",fileData.length] forKey:@"filesize"];
        [dictionary setObject:fileName forKey:@"filename"];
        [dictionary setObject:test64String forKey:@"file"];
        [dictionary setObject:userId forKey:@"uid"];
        [dictionary setObject:@"1" forKey:@"status"];
        NSString * requestString = [dictionary JSONRepresentation];
        [dictionary release];
        [self postRequest:fileuploadURL RequestBody:requestString];
    }
    else
    {
        [photoUploadServicedelegate noPhoto];
    }
    }
    else
    {
        if (self.photoUploadServicedelegate && [self.photoUploadServicedelegate  respondsToSelector:@selector(networkErrorInAddinBusinessReview)]) 
        {
            [self.photoUploadServicedelegate networkErrorInAddinBusinessReview];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [super requestFailed:request]; 
     [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"fid"];
     if(isFromAddDish)
     {
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"dishURL"];
     }
    if(isFromReview)
    {
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"reviewURL"];
    }
    [photoUploadServicedelegate photoUploadedFailed];

}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString * responseString = [request responseString];
    id response = [responseString JSONValue];
    if (request.responseStatusCode == 200) {
        if ([response count] > 0) 
        {   TDMFilePUTHelper *filePutter = [[TDMFilePUTHelper alloc] init];
            [[NSUserDefaults standardUserDefaults]setObject:[response objectForKey:@"fid"] forKey:@"fid"];
//            if(isFromAddDish)
//            {
//                [[NSUserDefaults standardUserDefaults] setValue:[response objectForKey:@"uri"] forKey:@"dishURL"];
//            }
//            if(isFromReview)
//            {
//                [[NSUserDefaults standardUserDefaults] setValue:[response objectForKey:@"uri"] forKey:@"reviewURL"];
//            }
            if(isFromUserLogin)
            {
                [filePutter putFileWithFID:[response objectForKey:@"fid"]];
            }
            
            [delegate requestCompletedSuccessfully:request];
            if(self.photoUploadServicedelegate &&[self.photoUploadServicedelegate respondsToSelector:@selector(photoUploadedSuccessFully)])
            {
                [photoUploadServicedelegate photoUploadedSuccessFully];
                
            }
           
        }

    }  
    else
    {
         [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"fid"];
          [photoUploadServicedelegate photoUploadedFailed];
    }
    
       
} 


@end
