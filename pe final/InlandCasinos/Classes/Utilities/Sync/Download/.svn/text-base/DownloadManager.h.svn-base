//
//  DownloadImage.h
//  PE
//
//  Created by Nithin George on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "XMLParser.h"
#import "DownloadManager.h"

@protocol DownloadManagerDelegate <NSObject>

-(void)updateProgress:(float)progress;
-(void)downloadCompleted:(id)downloadManager;
@end


@interface DownloadManager : NSObject<XMLParserDelegate> {
    
    ASINetworkQueue *networkQueue;
    NSMutableArray *downloadItems;
    NSOperationQueue *parserQueue;
    int contentIdentifier;  
    int parserCount;
    int operationCount;
    double progress;
    id <DownloadManagerDelegate> delegate;
    NSString *oldBuildDate;
    
}

@property (retain) id <DownloadManagerDelegate> delegate;

@property (retain) ASINetworkQueue *networkQueue;

@property (nonatomic,assign) int contentIdentifier; 
@property (nonatomic,assign) int operationCount;  

+(DownloadManager *)sharedManager;

-(void)setIdentifier:(int)identifier;
-(void)startContentSyncing:(BOOL)automaticFalg;
//////image download///////////
-(void)automaticImageDownloading;
-(void)startImageDownloading:(Image *)image items:(NSMutableArray *)imageDetail;
-(void)executeNetworkQueue;
//////////////////////////////
-(void)updateParserExecution;
-(void)createFolserStructure;
-(void)createSubItemPath:(int)parentID;
-(void)createListItemPath:(NSString *)type:(int)folderNumber:(int)parentID;

- (NSString *)createDocumentPath;
- (NSString *) urlEncoded:(NSString*)strInput; 

#pragma mark    Image Compress Methods
-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;
-(void)compressAndWriteImage :(NSString *)strPath;

@end
