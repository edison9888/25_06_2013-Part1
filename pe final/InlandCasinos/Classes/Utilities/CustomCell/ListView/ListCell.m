//
//  ListCell.m
//  PE
//
//  Created by Nithin George on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ListCell.h"
#import "List.h"
#import "DBHandler.h"

@implementation ListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

#pragma mark - Display list view

- (void)displayCellItems:(NSMutableArray *)items//:(int)homeCasinoID :(int)selectedIndex
{
    
    int section_x=LISTVIEW_SECTION_X;
    NSString *locationFolderPath;
    //Icon 
    List *list=[items lastObject];
    //Icon 
    UIImageView *imageThumbnail=[[UIImageView alloc]init];
    imageThumbnail.frame=CGRectMake(section_x, LISTVIEW_SECTION_Y, LISTVIEW_SECTION_WIDTH,LISTVIEW_SECTION_HEIGHT);
    imageThumbnail.backgroundColor=[UIColor clearColor];
    imageThumbnail.tag=list.idlist;
    imageThumbnail.userInteractionEnabled = NO;
    
    //getThumbImagePath format .extension
    NSString *url = [[DBHandler sharedManager] getThumbImagePath:list.idlist];
    NSArray *listItems = [url componentsSeparatedByString:@"."];
    NSString *imageformat = [listItems lastObject];
    DebugLog(@"image format is:- %@",imageformat);
    
    int casinoID = [[DBHandler sharedManager] getparentIDMenu:list.parent_idmenu];
    locationFolderPath = [[self createDocumentPath] stringByAppendingPathComponent:[NSString 
                                                                                    stringWithFormat:@"/%d/%d/%d/%d_%d.%@",casinoID,list.parent_idmenu,list.idlist,[[DBHandler sharedManager] getListImageID:list.idlist],SMALL_IMAGE,imageformat]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:locationFolderPath]) {
    
         UIImage* thumbImage = [UIImage imageWithContentsOfFile:locationFolderPath];
        imageThumbnail.image= thumbImage;

    }  
    else 
        imageThumbnail.image=[UIImage imageNamed:DEFAULT_IMAGE]; 

    
    [self addSubview:imageThumbnail];
    [imageThumbnail release];
    imageThumbnail=nil;
    
    //List Heading
    UILabel *listHeading=[[UILabel alloc]initWithFrame:CGRectMake(LISTVIEW_SECTION_HEADERLABLEL_X, LISTVIEW_SECTION_HEADERLABLEL_Y, LISTVIEW_SECTION_HEADERLABLEL_WIDTH, LISTVIEW_SECTION_HEADERLABLEL_HEIGHT)];
    listHeading.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    listHeading.textAlignment=UITextAlignmentLeft;
    //listHeading.backgroundColor = [UIColor blueColor];
    listHeading.text= list.title;
    [self addSubview:listHeading];
    [listHeading release];
    listHeading=nil;
    
     
   //Section listDescription
    UILabel *listDescription=[[UILabel alloc]initWithFrame:CGRectMake(LISTVIEW_SECTION_DETAILLABLEL_X, LISTVIEW_SECTION_DETAILLABLEL_Y, LISTVIEW_SECTION_DETAILLABLEL_WIDTH, LISTVIEW_SECTION_DETAILLABLEL_HEIGHT)];
    listDescription.font=[UIFont fontWithName:@"ArialMT" size:9.0];
    listDescription.textAlignment=UITextAlignmentLeft;
    //listDescription.lineBreakMode = UILineBreakModeWordWrap;
    listDescription.numberOfLines = 0;
    listDescription.text=[list.description getStringFromHtml];
    [self addSubview:listDescription];
    [listDescription release];
    listDescription=nil;

    //Section Date
   UILabel *listDate=[[UILabel alloc]initWithFrame:CGRectMake(LISTVIEW_SECTION_DATELABLEL_X, LISTVIEW_SECTION_DATELABLEL_Y, LISTVIEW_SECTION_DATELABLEL_WIDTH, LISTVIEW_SECTION_DATELABLEL_HEIGHT)];
    listDate.textColor = [UIColor darkGrayColor];
    listDate.font=[UIFont fontWithName:@"ArialMT" size:8.0];
    listDate.textAlignment=UITextAlignmentLeft;
    //listDate.lineBreakMode = UILineBreakModeWordWrap;
    listDate.text=list.pubDate;
    [self addSubview:listDate];
    [listDate release];
    listDate=nil;
    
}

- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect {
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    
    return cropped;
}

// get sub image
- (UIImage*)getSubImageFrom:(UIImage*)img WithRect:(CGRect)rect {
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // translated rectangle for drawing sub image 
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
    
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // draw image
    [img drawInRect:drawRect];
    
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return subImage;
}


#pragma  mark - DocumentPath creation

- (NSString *)createDocumentPath {
    
    NSArray *Localpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [Localpaths objectAtIndex:0];
    NSString *parentFolderName= [documentPath stringByAppendingPathComponent:PARENTFOLDER];
    return parentFolderName;
}

#pragma mark - Memory Release
- (void)dealloc
{
    [super dealloc];
}

@end
