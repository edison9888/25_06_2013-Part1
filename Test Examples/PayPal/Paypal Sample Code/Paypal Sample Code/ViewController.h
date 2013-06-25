//
//  ViewController.h
//  Paypal Sample Code
//
//  Created by Rapidvalue on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPal.h"

@interface ViewController : UIViewController<PayPalMEPDelegate>
{
    bool payPalLibraryLoaded;
}
@property (retain, nonatomic) IBOutlet UIButton *buttonzclicked;
- (IBAction)clicked:(id)sender;
@end
