//
//  TDMPlaceHolderTextView.h
//  TheDailyMeal
//
//  Created by Nithin George on 4/2/12.
//  Copyright 2011 Rapidvalue Inc. All rights reserved.
//

#import "TDMPlaceHolderTextView.h"


@implementation TDMPlaceHolderTextView
@synthesize placeHolder;

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        self.autocorrectionType = UITextAutocorrectionTypeNo;
    
    }
    return self;
}

//loading from Nib
-(void)awakeFromNib{
    
     [super awakeFromNib];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

-(void)drawRect:(CGRect)rect{
   
    
    if(self.placeHolder!=nil || [self.placeHolder length]>0){
        
        if(placeHolderLabel==nil){
            NSUserDefaults *isReviewPage=[NSUserDefaults standardUserDefaults];
            if([isReviewPage boolForKey:@"isReview"]){
               placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(9,7,self.bounds.size.width - 16,0)];
            }
            else
            {
//                if([[[UIDevice currentDevice]systemVersion]doubleValue]>=5)
//                    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(9,7,self.bounds.size.width - 16,0)];
//                else
                    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(9,7,self.bounds.size.width - 16,0)];
            }
            placeHolderLabel.lineBreakMode = UILineBreakModeWordWrap;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:12];
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = [UIColor lightGrayColor];
            placeHolderLabel.alpha = 1;
            [self addSubview:placeHolderLabel];
    
        }
        placeHolderLabel.text = self.placeHolder;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
        
    [super drawRect:rect];
}

-(void)textChanged:(UITextView *)textView{
    
    if([self.placeHolder length]==0){
        return;
    }else if([[self text] length]==0){
         placeHolderLabel.alpha = 1;
    } else{
        placeHolderLabel.alpha = 0;
        
    }
}

- (void)setPlaceHolder:(NSString *)thePlaceholder
{
    if (![thePlaceholder isEqualToString:placeHolder]) {
        [placeHolder release];
        placeHolder  = [thePlaceholder copy];
        [self setNeedsDisplay];
    }
}

#pragma mark TextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        //[textView resignFirstResponder];
       
    }
    return YES;
}

-(void)dealloc{
    
    self.placeHolder = nil;
    [placeHolderLabel release];
    placeHolderLabel = nil;
    [super dealloc];
}


@end
