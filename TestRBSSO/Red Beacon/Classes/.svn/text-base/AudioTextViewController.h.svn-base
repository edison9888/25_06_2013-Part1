//
//  AudioTextViewController.h
//  Red Beacon
//
//  Created by Joe on 13/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBSavedStateController.h"
#import "RBDirectoryPath.h"
@class TextPage;
@class AudioPage;
@protocol RBAudioTextViewDelegate <NSObject>
- (void)audioViewDoneButtonFired:(NSString*)audioPath;
@end

@interface AudioTextViewController : UIViewController {
    
    BOOL viewStatus;
    UISegmentedControl *segmentedControl;
    
    //IBVariables
    AudioPage   * audioPage;
    TextPage    * textPage;
    id<RBAudioTextViewDelegate> delegate;
    NSString * temporaryTextDescription;
}

@property (nonatomic)BOOL viewStatus;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSString * temporaryTextDescription;

//IBVariables
@property (nonatomic, retain) IBOutlet AudioPage    * audioPage;
@property (nonatomic, retain) IBOutlet TextPage     * textPage;

- (void)audioDidFinishRecording;
- (void)textFieldChangedCharacter;
- (void)audioDidUse;
- (void)discardAudio;
- (void)toggleButtonState:(BOOL)state;
- (void)saveAudio;

@end