//
//  WellSearchView.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 12/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WellDetailView.h"
#import "WellDetail.h"

@interface WellDetailView (){
    

}
@property (nonatomic,strong) NSArray* wellDetailArray;
@property (nonatomic,strong) IBOutlet UILabel *wellNamStatcLbl;
@property (nonatomic,strong) IBOutlet UILabel *wellNamValLbl;
@property (nonatomic,strong) IBOutlet UILabel *unitLeaseStatcLbl;
@property (nonatomic,strong) IBOutlet UILabel *unitLeaseValLbl;
@property (nonatomic,strong) IBOutlet UILabel *subAreaStatcLbl;
@property (nonatomic,strong) IBOutlet UILabel *subAreaValLbl;
@property (nonatomic,strong) IBOutlet UILabel *areaStatcLbl;
@property (nonatomic,strong) IBOutlet UILabel *areaValLbl;
@property (nonatomic,strong) IBOutlet UILabel *wrkngIntrstStatcLbl;
@property (nonatomic,strong) IBOutlet UILabel *wrkngIntrstValLbl;
@property (nonatomic,strong) IBOutlet UILabel *oilNRIStatcLbl;
@property (nonatomic,strong) IBOutlet UILabel *oilNRIValLbl;
@property (nonatomic,strong) IBOutlet UILabel *distrctStatcLbl;
@property (nonatomic,strong) IBOutlet UILabel *distrctValLbl;
@property (nonatomic,strong) IBOutlet UILabel *busnsUntStatcLbl;
@property (nonatomic,strong) IBOutlet UILabel *busnsUntValLbl;
@property (nonatomic,strong) IBOutlet UILabel *opertdStatcLbl;
@property (nonatomic,strong) IBOutlet UILabel *opertdValLbl;
@property (nonatomic,strong) IBOutlet UILabel *spudDateStatcLbl;
@property (nonatomic,strong) IBOutlet UILabel *spudDateValLbl;
@property (nonatomic,strong) IBOutlet UILabel *gasNRIStatcLbl;
@property (nonatomic,strong) IBOutlet UILabel *gasNRIValLbl;
@property (nonatomic,strong) IBOutlet UILabel *apiStatcLbl;
@property (nonatomic,strong) IBOutlet UILabel *apiValLbl;


@end

@implementation WellDetailView

@synthesize wellDetailArray;
@synthesize wellNamStatcLbl;
@synthesize wellNamValLbl;
@synthesize unitLeaseStatcLbl;
@synthesize unitLeaseValLbl;
@synthesize subAreaStatcLbl;
@synthesize subAreaValLbl;
@synthesize areaStatcLbl;
@synthesize areaValLbl;
@synthesize wrkngIntrstStatcLbl;
@synthesize wrkngIntrstValLbl;
@synthesize oilNRIStatcLbl;
@synthesize oilNRIValLbl;
@synthesize distrctStatcLbl;
@synthesize distrctValLbl;
@synthesize busnsUntStatcLbl;
@synthesize busnsUntValLbl;
@synthesize opertdStatcLbl;
@synthesize opertdValLbl;
@synthesize spudDateStatcLbl;
@synthesize spudDateValLbl;
@synthesize gasNRIStatcLbl;
@synthesize gasNRIValLbl;
@synthesize apiStatcLbl;
@synthesize apiValLbl;


- (id)initWithFrame:(CGRect)frame
{
    self = (WellDetailView*) [[[NSBundle mainBundle] loadNibNamed:@"WellDetailView" owner:self options:nil] lastObject];
    if (self) {
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
    }
    return self;

}

-(void)awakeFromNib{
    self.wellNamStatcLbl.font = FONT_SUMMARY_DATE;
    [self.wellNamStatcLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.wellNamValLbl.font = FONT_HEADLINE_VALUE;
    [self.wellNamValLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    
    self.unitLeaseStatcLbl.font = FONT_SUMMARY_DATE;
    [self.unitLeaseStatcLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.unitLeaseValLbl.font = FONT_HEADLINE_VALUE;
    [self.unitLeaseValLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    
    self.subAreaStatcLbl.font = FONT_SUMMARY_DATE;
    [self.subAreaStatcLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.subAreaValLbl.font = FONT_HEADLINE_VALUE;
    [self.subAreaValLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    
    self.areaStatcLbl.font = FONT_SUMMARY_DATE;
    [self.areaStatcLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.areaValLbl.font = FONT_HEADLINE_VALUE;
    [self.areaValLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    
    self.wrkngIntrstStatcLbl.font = FONT_SUMMARY_DATE;
    [self.wrkngIntrstStatcLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.wrkngIntrstValLbl.font = FONT_HEADLINE_VALUE;
    [self.wrkngIntrstValLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    
    self.oilNRIStatcLbl.font = FONT_SUMMARY_DATE;
    [self.oilNRIStatcLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.oilNRIValLbl.font = FONT_HEADLINE_VALUE;
    [self.oilNRIValLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    
    self.distrctStatcLbl.font = FONT_SUMMARY_DATE;
    [self.distrctStatcLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.distrctValLbl.font = FONT_HEADLINE_VALUE;
    [self.distrctValLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    
    self.busnsUntStatcLbl.font = FONT_SUMMARY_DATE;
    [self.busnsUntStatcLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.busnsUntValLbl.font = FONT_HEADLINE_VALUE;
    [self.busnsUntValLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    
    self.opertdStatcLbl.font = FONT_SUMMARY_DATE;
    [self.opertdStatcLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.opertdValLbl.font = FONT_HEADLINE_VALUE;
    [self.opertdValLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    
    self.spudDateStatcLbl.font = FONT_SUMMARY_DATE;
    [self.spudDateStatcLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.spudDateValLbl.font = FONT_HEADLINE_VALUE;
    [self.spudDateValLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    
    self.gasNRIStatcLbl.font = FONT_SUMMARY_DATE;
    [self.gasNRIStatcLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.gasNRIValLbl.font = FONT_HEADLINE_VALUE;
    [self.gasNRIValLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    
    self.apiStatcLbl.font = FONT_SUMMARY_DATE;
    [self.apiStatcLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.apiValLbl.font = FONT_HEADLINE_VALUE;
    [self.apiValLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
}
-(void) refreshDataWithWellArray:(NSArray*) wellArrayToUse{
    self.wellDetailArray = wellArrayToUse;
        [self SetData];
    
}
-(void)SetData{
    
    if([self.wellDetailArray count]){
             WellDetail * tempWellDetail =  [self.wellDetailArray objectAtIndex:0];
            self.wellNamValLbl.text = [NSString stringWithFormat:@"%@",tempWellDetail.wellName];
            self.unitLeaseValLbl.text = [NSString stringWithFormat:@"%@",tempWellDetail.unitLease];
            self.subAreaValLbl.text = [NSString stringWithFormat:@"%@",tempWellDetail.subArea];
            self.areaValLbl.text = [NSString stringWithFormat:@"%@",tempWellDetail.area];
            
            self.wrkngIntrstValLbl.text = [NSString stringWithFormat:@"%.2f",tempWellDetail.workingInterest];
            self.oilNRIValLbl.text = [NSString stringWithFormat:@"%.2f",tempWellDetail.oilNri];
            self.distrctValLbl.text = [NSString stringWithFormat:@"%@",tempWellDetail.district];
            self.busnsUntValLbl.text = [NSString stringWithFormat:@"%@",tempWellDetail.businessUnit];
            BOOL operatd = tempWellDetail.operated; 
            self.opertdValLbl.text = @"NO";
            if(operatd)
                self.opertdValLbl.text = @"YES";
                // self.oilNRIValLbl.text = [NSString stringWithFormat:@"%.2f",tempWellDetail.oilNri];
            self.spudDateValLbl.text = [NSString stringWithFormat:@"%@",tempWellDetail.spudDate];
            self.gasNRIValLbl.text = [NSString stringWithFormat:@"%.2f",tempWellDetail.gasNri];
            self.apiValLbl.text = [NSString stringWithFormat:@"%@",tempWellDetail.api];
    }
    else {
        self.wellNamValLbl.text =@"";
        self.unitLeaseValLbl.text =@"";
        self.subAreaValLbl.text =@"";
        self.areaValLbl.text = @"";
        self.wrkngIntrstValLbl.text =@"";
        self.oilNRIValLbl.text =@"";
        self.distrctValLbl.text =@"";
        self.busnsUntValLbl.text =@"";
        self.opertdValLbl.text =@"";
        self.spudDateValLbl.text =@"";
        self.gasNRIValLbl.text =@"";
        self.apiValLbl.text =@"";
    }
}

@end
