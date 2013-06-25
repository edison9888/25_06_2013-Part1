//
//  DownloadImage.m
//  PE
//
//  Created by Nithin George on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadManager.h"
#import "ASIHTTPRequest.h"
#import "DBHandler.h"
#import "Image.h"
#import "XMLParser.h"
#import "Grid.h"
#import "List.h"
#import "Image.h"
#import "ImageDetails.h"
#import "ImageCrop.h"

@implementation DownloadManager

@synthesize networkQueue;

@synthesize delegate;

@synthesize contentIdentifier;

@synthesize operationCount;

static DownloadManager *sharedManager;


+(DownloadManager *)sharedManager{
    
    if (sharedManager==nil) {
        sharedManager=[[DownloadManager alloc]init];
     }
    
    return sharedManager;
}


- (void)StartManualDownload:(int)idListImage {
    
}

#pragma  mark - ASIHTTPRequest NetworkOperations
- (void)startContentSyncing:(BOOL)automaticFalg {
    
    parserCount         = 0;
    self.operationCount = 0;
    downloadItems = [[[[DBHandler sharedManager] getCasionoItems]retain] autorelease];

	if (!networkQueue)
    {
		networkQueue = [[ASINetworkQueue alloc] init];	
	}
    
	[networkQueue reset];
    [networkQueue setShowAccurateProgress:NO];
    [networkQueue setShouldCancelAllRequestsOnFailure:NO];
    [self.networkQueue setDelegate:self];
    [self.networkQueue setRequestDidFinishSelector:@selector(contentDownloadFinished:)];
	[self.networkQueue setRequestDidFailSelector:@selector(contentDownloadFailed:)];
	[self.networkQueue setQueueDidFinishSelector:@selector(contentQueueFinished:)];

    for(Grid *grid in downloadItems)
    {
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:grid.link]];          
        [request addRequestHeader:@"If-Modified-Since" value:[[DBHandler sharedManager] getBuildDate:grid.idmenu]];
        request.identifier=grid.idmenu;
        self.operationCount++;
        if(!automaticFalg)
        {
            //manual Content syncing
            if (grid.idmenu==self.contentIdentifier)
            {
                [self.networkQueue addOperation:request];
                break;
            }
        }          
        else
        {
            //automatic Content syncing
            [self.networkQueue addOperation:request];
        }
        
        [request release];
    }
    
    [self.networkQueue go];

}


-(void)setIdentifier:(int)identifier{
    self.contentIdentifier=identifier;
}

#pragma  mark - ASIHTTPRequest Delegate mehods

-(void)contentDownloadFinished:(ASIHTTPRequest *)request{
    
    NSDictionary *response=[request responseHeaders];
     switch ([request responseStatusCode]) {
        case 304:
                [self updateParserExecution];
            break;
        
        case 200:
            DebugLog(@"parse table insertions");
            XMLParser *xmlParser=[[XMLParser alloc] initXMLParser];
            xmlParser.delegate=self;
            xmlParser.identifier    = request.identifier;
            xmlParser.lastBuildDate = [response objectForKey:@"Date"];
            [xmlParser parseData:[request responseData]];
            [xmlParser release];
            break;
    }  
    
}


-(void)contentDownloadFailed:(NSError *)error{
    
}
-(void)contentQueueFinished:(ASIHTTPRequest *)request{
    
}
#pragma mark - Parsing method

-(void)parsingCompleted:(XMLParser *)parser{
    
     [self updateParserExecution];
}

-(void)updateParserExecution{
    
    parserCount++;
    
    
   // NSUInteger *count=self.networkQueue.operationCount;
    
    double pgr=(double)parserCount/self.operationCount;
    
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(updateProgress:)])
        [self.delegate updateProgress:pgr];
    
    if (self.operationCount== parserCount) {
        
        if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(downloadCompleted:)])
            [self.delegate downloadCompleted:self];
        
        //folder creation
        [self createFolserStructure];
        //image downloading
        [self automaticImageDownloading];
    }

}

-(void)parsingFailed:(NSError *)error{
    
}

#pragma  mark - ASIHTTPRequest NetworkOperations Downloading

- (void)automaticImageDownloading {
    
    NSMutableArray *items = [[DBHandler sharedManager] readListImage];
    
    for(Image *image in items) {
        
        DBHandler *dbHandler =[[DBHandler alloc]init];
        NSMutableArray *imageDetail =  [dbHandler readImageDetails:image.idList];//its parentidmenu and idmenu
        [dbHandler release];
        dbHandler = nil;
        if([imageDetail count]>0)
            [self startImageDownloading:image items:imageDetail];
    }
   
    [self executeNetworkQueue];
}


-(void)startImageDownloading:(Image *)image items:(NSMutableArray *)imageDetail{
    
    if (!networkQueue) {
		networkQueue = [[ASINetworkQueue alloc] init];	
	}
    //[networkQueue reset];
    [networkQueue setShowAccurateProgress:NO];
    [networkQueue setShouldCancelAllRequestsOnFailure:NO];
    [self.networkQueue setDelegate:self];
    [self.networkQueue setRequestDidFinishSelector:@selector(imageDownloadFinished:)];
	[self.networkQueue setRequestDidFailSelector:@selector(imageDownloadFailed:)];
	[self.networkQueue setQueueDidFinishSelector:@selector(imageQueueFinished:)];
    
    NSString *url = image.imageUrl;
    NSArray *listItems = [url componentsSeparatedByString:@"."];
    NSString *imageformat = [listItems lastObject];
    DebugLog(@"image format is:- %@",imageformat);
    //for finding its parentid,id menu...
     ImageDetails * imageDetails = [imageDetail objectAtIndex:0];
     NSString *imagePath=[[self createDocumentPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d/%d/%d/%d_%d.%@",imageDetails.parent_idmenu,imageDetails.idmenu,image.idList,image.idListImage,image.imageType,imageformat]];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:[self urlEncoded:image.imageUrl]]];    
    request.identifier = image.idListImage;
    [request setDownloadDestinationPath:imagePath];
    [self.networkQueue addOperation:request];
    
}

-(void)executeNetworkQueue {
    
   [self.networkQueue go];
}

#pragma  mark - ASIHTTPRequest image downloading Delegate mehods

-(void)imageDownloadFinished:(ASIHTTPRequest *)request{

  if ([[request downloadDestinationPath] rangeOfString:@"_1"].location == NSNotFound) 
    {    
        UIImage* thumbImage = [UIImage imageWithContentsOfFile:[request downloadDestinationPath]];
        thumbImage=[thumbImage  imageByScalingAndCroppingForSize:CGSizeMake(62, 62)];
        NSData* pictureData = UIImagePNGRepresentation(thumbImage);
        [[NSFileManager defaultManager]createFileAtPath:[request downloadDestinationPath] contents:pictureData attributes:nil];
    }
    else
    {
        [self compressAndWriteImage:[request downloadDestinationPath]];
    }
    
    [[DBHandler sharedManager] updateDownloadedImagePath:request.identifier];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadNotification 
                                                        object:[request downloadDestinationPath]];
}

-(void)imageDownloadFailed:(NSError *)error {
      DebugLog(@"imagedownload faild");
   // DebugLog(@"imageDownloadFailed==%@",[error localizedDescription]);
    
}

-(void)imageQueueFinished:(ASIHTTPRequest *)request{
    
    DebugLog(@"imageQueueFinished");
}

#pragma mark    -
#pragma mark    Image Compress Methods
-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);  
	[image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];  
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();  
	UIGraphicsEndImageContext();    
	return newImage;  
}

-(void)compressAndWriteImage :(NSString *)strPath
{
    @try
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        float   compressImageHeight =   0.0f;
        
        float   compressImageWidth  =   0.0f;
        
        float   compressFactor      =   1.0f;
        
        NSString *imageExtension    =   nil;
        
        UIImage *bigImage   =   nil;
        
        NSData *bigImageData   =   [NSData dataWithContentsOfFile:strPath];
        
        
        if (bigImageData != nil && [bigImageData length] > 400000)
        {
            imageExtension    =   [[strPath componentsSeparatedByString:@"."] lastObject];
            
            DebugLog(@"Size of Image : %@ is : %d",strPath,[bigImageData length]);
            
            bigImage   =   [UIImage imageWithData:bigImageData];
            
            if (bigImage != nil)
            {
                if (bigImage.size.height > 1024 || bigImage.size.width > 768)
                {
                    if (bigImage.size.height > bigImage.size.width)
                    {
                        compressFactor  =   bigImage.size.height/1024;
                    }
                    else
                    {
                        compressFactor  =   bigImage.size.width/768;
                    }
                }
                
                compressImageHeight     =   bigImage.size.height/compressFactor;
                
                compressImageWidth      =   bigImage.size.width/compressFactor;
                
                bigImage = [self scaleImage:bigImage toSize:CGSizeMake(compressImageWidth, compressImageHeight)];
                bigImageData = nil;
                
                if ([[imageExtension lowercaseString] isEqualToString:@"jpg"] || [[imageExtension lowercaseString] isEqualToString:@"jpeg"])
                {
                    DebugLog(@"Large Image is JPEG");
                    
                    bigImageData    =   UIImageJPEGRepresentation(bigImage,0.7);
                }
                else if ([[imageExtension lowercaseString] isEqualToString:@"png"])
                {
                    DebugLog(@"Large Image is PNG");
                    
                    bigImageData    =   UIImagePNGRepresentation(bigImage);
                }
                
                bigImage = nil;
                
                if ([bigImageData writeToFile:strPath atomically:YES])
                {
                    DebugLog(@"Large Image cropped and written to the location successfully, \nLocation : %@",strPath);
                }
                else
                {
                    DebugLog(@"Large Image cropped and write to the location failed :( :(, \nLocation : %@",strPath);
                }
                
                imageExtension  =   nil;               
                
            }
        }
        
        bigImageData    =   nil;
        
        [pool drain];
    }
    @catch (NSException *exception)
    {
        DebugLog(@"Exception caught in compressImage of imageDownloadFinished : %@",exception);
    }
    @finally
    {
        
    }
}

#pragma mark- Encoding

- (NSString *) urlEncoded:(NSString*)strInput {
    
    /*CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
                                                                    
                                                                    NULL,
                                                                    
                                                                    (CFStringRef)strInput,
                                                                    
                                                                    NULL,
                                                                    
                                                                    (CFStringRef)@"!*'\"();@&=+$,?%#[]%^ ",
                                                                    
                                                                    kCFStringEncodingUTF8);*/
    NSString *urlString = [strInput stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    return urlString;
    
}

#pragma  mark - creating the folder structure
- (void)createFolserStructure {
    
    DBHandler *dbHandler =[[DBHandler alloc]init];
    NSMutableArray *homeItems = [dbHandler readHomeItems:HOME_TYPE];
    [dbHandler release];
    dbHandler = nil;
    
     for (Grid *grid in homeItems) {
           [self createSubItemPath:grid.idmenu];
    }
}
- (void)createSubItemPath:(int)parentID {
    
    DBHandler *dbHandler =[[DBHandler alloc]init];
    NSMutableArray *subItems = [dbHandler readSubItems:parentID];
    [dbHandler release];
    dbHandler = nil;
    
    for (Grid *grid in subItems) {
         [self createListItemPath:grid.type :parentID :grid.idmenu];
    }
}

- (void)createListItemPath:(NSString *)type:(int)folderNumber:(int)parentID {
    
    NSError *error;
    if ([type isEqualToString:MAPIDETEFIER]) {
          NSString *locationFolderPath = [[self createDocumentPath] stringByAppendingPathComponent:[NSString 
                                                                                                  stringWithFormat:@"/%d/%d/temp",folderNumber,parentID]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:locationFolderPath]){ 
                [[NSFileManager defaultManager] createDirectoryAtPath:locationFolderPath withIntermediateDirectories:YES attributes:nil error:&error];
        }
    }
    
    else {
        
        DBHandler *dbHandler =[[DBHandler alloc]init];
        NSMutableArray *listItems = [dbHandler readlistItems:parentID];
        [dbHandler release];
        dbHandler = nil;
        
        for (List *list in listItems) {
            
            NSString *locationFolderPath = [[self createDocumentPath] stringByAppendingPathComponent:
                                                   [NSString stringWithFormat:@"/%d/%d/%d/temp",folderNumber,parentID,list.idlist]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:locationFolderPath]){
                [[NSFileManager defaultManager] createDirectoryAtPath:locationFolderPath 
                                          withIntermediateDirectories:YES attributes:nil error:&error];
            }
        }
    }
    
}


#pragma  mark - DocumentPath creation
- (NSString *)createDocumentPath {
    
    NSArray *Localpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [Localpaths objectAtIndex:0];
    NSString *parentFolderName= [documentPath stringByAppendingPathComponent:PARENTFOLDER];
    return parentFolderName;
}


#pragma  mark - memory release

- (void)dealloc
{
	[networkQueue release];
	[super dealloc];
}


@end
