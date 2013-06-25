//
//  SyncDB.m
//  Torq361
//
//  Created by Binoy on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "SyncDB.h"

#import "Constants.h"
#import "DatabaseManager.h"
#import "HelperFunctions.h"
#import "UserCredentials.h"

@implementation SyncDB
@synthesize delegate;

-(void)onSyncDB {
    
    
    //[self performSelector:@selector(testFunction) withObject:nil afterDelay:1];
	//return;
		
	NSMutableArray *tmpSyncTableValues = [[DatabaseManager sharedManager] getSyncTables];
	
	//NSString *authToken = [[NSUserDefaults standardUserDefaults]  valueForKey:kAuthToken];
	
	NSMutableDictionary *objDataDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[UserCredentials sharedManager]getRollID],@"idRoll",[[UserCredentials sharedManager]getCompanyID],@"idCompany",[[UserCredentials sharedManager]getUserID],@"userId",[[NSUserDefaults standardUserDefaults]  valueForKey:kAuthToken],@"authtoken",tmpSyncTableValues,@"tableDetails",nil];
	//NSMutableDictionary *objDataDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[UserCredentials sharedManager]getRollID],@"idRoll",[[UserCredentials sharedManager]getCompanyID],@"idCompany",[[UserCredentials sharedManager]getUserID],@"userId",[[UserCredentials sharedManager]getAuthToken],@"authtoken",tmpSyncTableValues,@"tableDetails",nil];
	//NSMutableDictionary *objDataDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[UserCredentials sharedManager]getRollID],@"idRoll",[[UserCredentials sharedManager]getCompanyID],@"idCompany",[[UserCredentials sharedManager]getUserID],@"userId",[[UserCredentials sharedManager]getAuthToken],@"authtoken",tmpSyncTableValues,@"tableDetails",nil];	
	
	JsonParser *jsonParser=[[JsonParser alloc]init];
	
	jsonParser.delegate=self;
	
	NSString *str=[NSString stringWithFormat:@"%@%@",CMSLink,SyncAPI];
	
	[jsonParser parseJSONResponseofAPI:str JSONRequest:objDataDic];
	
	[objDataDic release];
	
	objDataDic = nil;
	
	[jsonParser release];
	
	jsonParser = nil;
	
 
}


///remove aftr testing...errrorrrrr
/*-(void)testFunction{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(didfailedSyncwitherror:)])
		[self.delegate didfailedSyncwitherror:self]; 
}*/


-(void)didfinishedparsing:(JsonParser *)objJsonParser{
	
	
	NSMutableDictionary *resultDict = objJsonParser.objResult;	 
	
	NSArray *keys= [HelperFunctions getDictionaryKeys:resultDict];
	
	NSLog(@"Number of Table to sync : %d",[keys count]);
	
	BOOL bSyncSuccess=NO;
	for (int i=0; i<[keys count]; i++) {
		
		NSString *key = [keys objectAtIndex:i];
		
		if ( [key isEqualToString:@"productContent"]) {
			bSyncSuccess=NO;
			[self addTOContentTable:[resultDict valueForKey:key]];
			bSyncSuccess=YES;
			NSLog(@"Content synced");
		}
		
		else if ( [key isEqualToString:@"category"]) {
			bSyncSuccess=NO;
			[self addTOCategoryTable:[resultDict valueForKey:key]];
			bSyncSuccess=YES;
			NSLog(@"Category synced");
		}
		
		else if ( [key isEqualToString:@"product"]) {
			bSyncSuccess=NO;
			[self addTOProductTable:[resultDict valueForKey:key]];
			bSyncSuccess=YES;
			NSLog(@"Product synced");
		}
		
		else if ( [key isEqualToString:@"catalog"]) {
			bSyncSuccess=NO;
			[self addTOCatalogTable:[resultDict valueForKey:key]];
			bSyncSuccess=YES;
			NSLog(@"Catalog synced");
		}
		
		/*else if ( [key isEqualToString:@"SyncTable"]) {			
			[self addToSyncTable:[resultDict valueForKey:key]];
			NSLog(@"SyncTable synced");
		}*/
		
	}	
	
	 if (bSyncSuccess) {	
		 NSArray *keys= [HelperFunctions getDictionaryKeys:[resultDict valueForKey:@"synctable"]];
		 [self addToSyncTable:[resultDict valueForKey:@"synctable"]:keys];
		NSLog(@"SyncTable synced");
	}
	
	// [UIApplication sharedApplication].applicationIconBadgeNumber=0;
 

	
	if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(didfinishedSync:)])
		[self.delegate didfinishedSync:self];
 

}

-(void)didfailedwitherror:(JsonParser *)objJsonParser{
	
	if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(didfailedSyncwitherror:)])
		[self.delegate didfailedSyncwitherror:self];
	 
}

-(void)addTOCatalogTable:(id)value {
	
	if([value isKindOfClass:[NSArray class]]){
		
		for (int ii=0; ii<[value count]; ii++) {
			
			NSMutableDictionary *tmpDict=[value objectAtIndex:ii];
			
			NSString *idCatalog = [tmpDict valueForKey:@"idCatalog"];
			NSString *name = [tmpDict valueForKey:@"name"];
			NSString *description = [tmpDict valueForKey:@"description"];
			NSString *thumbnailImgPath = [tmpDict valueForKey:@"thumbNailImgPath"];
			NSString *validityFromDate = [tmpDict valueForKey:@"validityFromDate"];
			if ([validityFromDate isEqual:[NSNull null]]||validityFromDate==nil || [[NSString stringWithFormat:@"%@",validityFromDate] isEqualToString:@"<null>"]) {
				validityFromDate=@"";
			}
			NSString *validityToDate = [tmpDict valueForKey:@"validityToDate"];
			if ([validityToDate isEqual:[NSNull null]]||validityToDate==nil || [[NSString stringWithFormat:@"%@",validityToDate] isEqualToString:@"<null>"]) {
				validityToDate=@"";
			}
			
			NSString *active = [NSString stringWithFormat:@"%@",[tmpDict valueForKey:@"active"]];
			if ([active isEqual:[NSNull null]]||active==nil || [[NSString stringWithFormat:@"%@",active] isEqualToString:@"<null>"]) {
				active=@"0";
			}
			
			NSString *deleted = [NSString stringWithFormat:@"%@",[tmpDict valueForKey:@"deleted"]];
			if ([deleted isEqual:[NSNull null]]||deleted==nil || [[NSString stringWithFormat:@"%@",deleted] isEqualToString:@"<null>"]) {
				deleted=@"0";
			}
			
			[[DatabaseManager sharedManager] insertIntoCatalogTable:idCatalog :name :description :thumbnailImgPath :validityFromDate :validityToDate :active :deleted];
		}
	}
	else if([value isKindOfClass:[NSDictionary class]]) {
		
		NSString *idCatalog = [value valueForKey:@"idCatalog"];
		NSString *name = [value valueForKey:@"name"];
		NSString *description = [value valueForKey:@"description"];
		NSString *thumbnailImgPath = [value valueForKey:@"thumbNailImgPath"];
		NSString *validityFromDate = [value valueForKey:@"validityFromDate"];
		if ([validityFromDate isEqual:[NSNull null]]||validityFromDate==nil || [[NSString stringWithFormat:@"%@",validityFromDate] isEqualToString:@"<null>"]) {
			validityFromDate=@"";
		}
		NSString *validityToDate = [value valueForKey:@"validityToDate"];
		if ([validityToDate isEqual:[NSNull null]]||validityToDate==nil || [[NSString stringWithFormat:@"%@",validityToDate] isEqualToString:@"<null>"]) {
			validityToDate=@"";
		}
		
		NSString *active = [NSString stringWithFormat:@"%@",[value valueForKey:@"active"]];
		if ([active isEqual:[NSNull null]]||active==nil || [[NSString stringWithFormat:@"%@",active] isEqualToString:@"<null>"]) {
			active=@"0";
		}
		
		NSString *deleted = [NSString stringWithFormat:@"%@",[value valueForKey:@"deleted"]];
		if ([deleted isEqual:[NSNull null]]||deleted==nil || [[NSString stringWithFormat:@"%@",deleted] isEqualToString:@"<null>"]) {
			deleted=@"0";
		}
		
		[[DatabaseManager sharedManager] insertIntoCatalogTable:idCatalog :name :description :thumbnailImgPath :validityFromDate :validityToDate :active :deleted];
	}
	
}


-(void)addTOCategoryTable:(id)value{
	
	if([value isKindOfClass:[NSArray class]]) {
		
		for (int ii=0; ii<[value count]; ii++) {
			
			NSMutableDictionary *tmpDict=[value objectAtIndex:ii];
			
			NSString *idCategory = [tmpDict valueForKey:@"idcategory"];
			if ([idCategory isEqual:[NSNull null]]||idCategory==nil || [[NSString stringWithFormat:@"%@",idCategory] isEqualToString:@"<null>"]) {
				idCategory=@"";
			}
			
			NSString *idCatalog = [tmpDict valueForKey:@"idCatalog"];
			if ([idCatalog isEqual:[NSNull null]]||idCatalog==nil || [[NSString stringWithFormat:@"%@",idCatalog] isEqualToString:@"<null>"]) {
				idCatalog=@"";
			}
			
			NSString *idParentCategory = [tmpDict valueForKey:@"idParentCategory"];
			if ([idParentCategory isEqual:[NSNull null]]||idParentCategory==nil || [[NSString stringWithFormat:@"%@",idParentCategory] isEqualToString:@"<null>"]) {
				idParentCategory=@"";
			}
			
			NSString *name = [tmpDict valueForKey:@"name"];
			if ([name isEqual:[NSNull null]]||name==nil || [[NSString stringWithFormat:@"%@",name] isEqualToString:@"<null>"]) {
				name=@"";
			}
			
			NSString *description = [tmpDict valueForKey:@"description"];
			if ([description isEqual:[NSNull null]]||description==nil || [[NSString stringWithFormat:@"%@",description] isEqualToString:@"<null>"]) {
				description=@"";
			}
			
			NSString *thumbNailImgPath = [tmpDict valueForKey:@"thumbnailimgpath"];
			if ([thumbNailImgPath isEqual:[NSNull null]]||thumbNailImgPath==nil || [[NSString stringWithFormat:@"%@",thumbNailImgPath] isEqualToString:@"<null>"]) {
				thumbNailImgPath=@"";
			}
			
			NSString *active = [NSString stringWithFormat:@"%@",[tmpDict valueForKey:@"active"]];
			if ([active isEqual:[NSNull null]]||active==nil || [[NSString stringWithFormat:@"%@",active] isEqualToString:@"<null>"]) {
				active=@"0";
			}
			
			NSString *deleted = [NSString stringWithFormat:@"%@",[tmpDict valueForKey:@"deleted"]];
			if ([deleted isEqual:[NSNull null]]||deleted==nil || [[NSString stringWithFormat:@"%@",deleted] isEqualToString:@"<null>"]) {
				deleted=@"0";
			}
			
			[[DatabaseManager sharedManager] insertInToCategoryTable:idCategory :idCatalog :idParentCategory :name :description :thumbNailImgPath :active :deleted];
		}
		
	}
	else if([value isKindOfClass:[NSDictionary class]]) {
		
		NSString *idCategory = [value valueForKey:@"idcategory"];
		if ([idCategory isEqual:[NSNull null]]||idCategory==nil || [[NSString stringWithFormat:@"%@",idCategory] isEqualToString:@"<null>"]) {
			idCategory=@"";
		}
		
		NSString *idCatalog = [value valueForKey:@"idCatalog"];
		if ([idCatalog isEqual:[NSNull null]]||idCatalog==nil || [[NSString stringWithFormat:@"%@",idCatalog] isEqualToString:@"<null>"]) {
			idCatalog=@"";
		}
		
		NSString *idParentCategory = [value valueForKey:@"idParentCategory"];
		if ([idParentCategory isEqual:[NSNull null]]||idParentCategory==nil || [[NSString stringWithFormat:@"%@",idParentCategory] isEqualToString:@"<null>"]) {
			idParentCategory=@"";
		}
		
		NSString *name = [value valueForKey:@"name"];
		if ([name isEqual:[NSNull null]]||name==nil || [[NSString stringWithFormat:@"%@",name] isEqualToString:@"<null>"]) {
			name=@"";
		}
		
		NSString *description = [value valueForKey:@"description"];
		if ([description isEqual:[NSNull null]]||description==nil || [[NSString stringWithFormat:@"%@",description] isEqualToString:@"<null>"]) {
			description=@"";
		}
		
		NSString *thumbNailImgPath = [value valueForKey:@"thumbnailimgpath"];
		if ([thumbNailImgPath isEqual:[NSNull null]]||thumbNailImgPath==nil || [[NSString stringWithFormat:@"%@",thumbNailImgPath] isEqualToString:@"<null>"]) {
			thumbNailImgPath=@"";
		}
		
		NSString *active = [NSString stringWithFormat:@"%@",[value valueForKey:@"active"]];
		if ([active isEqual:[NSNull null]]||active==nil || [[NSString stringWithFormat:@"%@",active] isEqualToString:@"<null>"]) {
			active=@"0";
		}
		
		NSString *deleted = [NSString stringWithFormat:@"%@",[value valueForKey:@"deleted"]];
		if ([deleted isEqual:[NSNull null]]||deleted==nil || [[NSString stringWithFormat:@"%@",deleted] isEqualToString:@"<null>"]) {
			deleted=@"0";
		}
		
		[[DatabaseManager sharedManager] insertInToCategoryTable:idCategory :idCatalog :idParentCategory :name :description :thumbNailImgPath :active :deleted];
	}
	
}



-(void)addTOProductTable:(id)value {

	if([value isKindOfClass:[NSArray class]]){
		
		for (int ii=0; ii<[value count]; ii++) {
			
			NSMutableDictionary *tmpDict=[value objectAtIndex:ii];
			NSString *idProduct = [tmpDict valueForKey:@"idProduct"];
			NSString *name = [tmpDict valueForKey:@"name"];
			NSString *description = [tmpDict valueForKey:@"description"];
            NSString *prodDetails=[tmpDict valueForKey:@"productDetails"];
            NSString *techDetails=[tmpDict valueForKey:@"technicalDetails"];
			NSString *thumbnailImgPath = [tmpDict valueForKey:@"thumbNailImgPath"];
			NSString *idCategory =[tmpDict valueForKey:@"idCategory"];
			NSString *lastModified = [tmpDict valueForKey:@"lastModified"];
			if ([lastModified isEqual:[NSNull null]]||lastModified==nil || [[NSString stringWithFormat:@"%@",lastModified] isEqualToString:@"<null>"]) {
				lastModified=@"";
			}
			
			NSString *active = [NSString stringWithFormat:@"%@",[tmpDict valueForKey:@"active"]];
			NSString *deleted = [NSString stringWithFormat:@"%@",[tmpDict valueForKey:@"deleted"]];

			[[DatabaseManager sharedManager] insertIntoProductTable:idProduct :name :description :prodDetails:techDetails:thumbnailImgPath :idCategory :lastModified :active :deleted];
		}
	}
	else if([value isKindOfClass:[NSDictionary class]]) {
		
		NSString *idProduct = [value valueForKey:@"idProduct"];
		NSString *name = [value valueForKey:@"name"];
		NSString *description = [value valueForKey:@"description"];
        NSString *prodDetails=[value valueForKey:@"productDetails"];
        NSString *techDetails=[value valueForKey:@"technicalDetails"];
		NSString *thumbnailImgPath = [value valueForKey:@"thumbNailImgPath"];
		NSString *idCategory =[value valueForKey:@"idCategory"];
		NSString *lastModified = [value valueForKey:@"lastModified"];
		if ([lastModified isEqual:[NSNull null]]||lastModified==nil || [[NSString stringWithFormat:@"%@",lastModified] isEqualToString:@"<null>"]) {
			lastModified=@"";
		}
		
		NSString *active = [NSString stringWithFormat:@"%@",[value valueForKey:@"active"]];
		NSString *deleted = [NSString stringWithFormat:@"%@",[value valueForKey:@"deleted"]];
		
		[[DatabaseManager sharedManager] insertIntoProductTable:idProduct :name :description :prodDetails:techDetails:thumbnailImgPath :idCategory :lastModified :active :deleted];
	}

}





-(void)addTOContentTable:(id)value {
	
		if([value isKindOfClass:[NSArray class]]){
			
			for (int ii=0; ii<[value count]; ii++) {
				
				NSMutableDictionary *tmpDict=[value objectAtIndex:ii];
				
				NSString *idContent=[tmpDict valueForKey:@"idContent"];
				if ([idContent isEqual:[NSNull null]]||idContent==nil || [[NSString stringWithFormat:@"%@",idContent] isEqualToString:@"<null>"]) {
					idContent=@"";
				}
				
				NSString *idProduct=[tmpDict valueForKey:@"idProduct"];
				if ([idProduct isEqual:[NSNull null]]||idProduct==nil || [[NSString stringWithFormat:@"%@",idProduct] isEqualToString:@"<null>"]) {
					idProduct=@"";
				}
				
				NSString *idCatalog=[tmpDict valueForKey:@"idCatalog"];	
				if ([idCatalog isEqual:[NSNull null]]||idCatalog==nil || [[NSString stringWithFormat:@"%@",idCatalog] isEqualToString:@"<null>"]) {
					idCatalog=@"";
				}
				
				NSString *Path=[tmpDict valueForKey:@"path"];
				NSString *type=[tmpDict valueForKey:@"type"];
				NSString *videoPath=@"";
				
				NSString *deleted = @"";
								
				[[DatabaseManager sharedManager] insertInToContentTable:idContent :idProduct :idCatalog :Path :type :videoPath :deleted];
						
				
			}
			
		}
		else if([value isKindOfClass:[NSDictionary class]]) {
			
			NSString *idContent = [value valueForKey:@"idContent"];
			if ([idContent isEqual:[NSNull null]]||idContent==nil || [[NSString stringWithFormat:@"%@",idContent] isEqualToString:@"<null>"]) {
				idContent=@"";
			}
			
			NSString *idProduct = [value valueForKey:@"idProduct"];
			if ([idProduct isEqual:[NSNull null]]||idProduct==nil || [[NSString stringWithFormat:@"%@",idProduct] isEqualToString:@"<null>"]) {
				idProduct=@"";
			}
			
			NSString *idCatalog = [value valueForKey:@"idCatalog"];		
			if ([idCatalog isEqual:[NSNull null]]||idCatalog==nil || [[NSString stringWithFormat:@"%@",idCatalog] isEqualToString:@"<null>"]) {
				idCatalog=@"";
			}
			
			NSString *Path = [value valueForKey:@"path"];
			NSString *type = [value valueForKey:@"type"];
			NSString *videoPath=@"";
			
			NSString *deleted =@"";
			
			[[DatabaseManager sharedManager] insertInToContentTable:idContent :idProduct :idCatalog :Path :type :videoPath :deleted];
			
						
		}
	
}



-(void)addToSyncTable:(id)value :(NSArray*)keyarr{
	
	 
	if([value isKindOfClass:[NSArray class]]){
		/*for (int i=0; i<[value count]; i++) {
			
			NSMutableDictionary *tmpDict=[value objectAtIndex:i];	
			NSString *tableName=[tmpDict valueForKey:@"TableName"];
			NSString *lastModified=[tmpDict valueForKey:@"LastModified"];
			
			[[DatabaseManager sharedManager] insertIntoSyncTable:tableName :lastModified];
		}*/
	}
	else if([value isKindOfClass:[NSDictionary class]]) {
		for (int i=0; i<[keyarr count]; i++) {
			NSString *str=[keyarr objectAtIndex:i];
			//NSString *tableName=[value valueForKey:@"TableName"];
			NSString *lastModified=[value valueForKey:str];
			str=[self getTablename:str];
			[[DatabaseManager sharedManager] insertIntoSyncTable:str :lastModified];
			
		}
	}
	
}

-(NSString*)getTablename:(NSString*)strTable{
	NSString *strTableName=@"";
	if ([strTable isEqualToString:@"catalogTableLastModified"]) {
		strTableName=@"Catalogs";
	}
	else if ([strTable isEqualToString:@"categoryTableLastModified"]) {
		strTableName=@"Category";
	}
	else if ([strTable isEqualToString:@"productContentLastModified"]) {
		strTableName=@"ProductContent";
	}
	else if ([strTable isEqualToString:@"productTableLastModified"]) {
		strTableName=@"Product";
	}
	
	
	return strTableName;
}

/*

-(void)deleteLocalContent:(NSString*)strstatus :(NSString*)strLast_updated_date :(NSString*)strContentUpdatedDate :(NSString*)strId :(NSString*)strContent_type :(NSString*)strPath{
	
	//BOOL bsuccess;
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [paths objectAtIndex:0];
	
	
	if(([strstatus isEqualToString:@"inactive"])|| ([strLast_updated_date isEqualToString:strContentUpdatedDate])){
		NSString *strContentPath=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@_%@",strContent_type,strId,strPath]];
		if ([[NSFileManager defaultManager] fileExistsAtPath:strContentPath ]){
			
			[[NSFileManager defaultManager] removeItemAtPath:strContentPath error:&error];
			
			[[AppTmpData sharedManager] refreshDownloadDetailsArr:strId];
		}
	}
}

*/
 


- (void)dealloc {
	self.delegate=nil;
	
    [super dealloc];
}

@end
