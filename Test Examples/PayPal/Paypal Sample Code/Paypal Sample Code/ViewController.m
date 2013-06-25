//
//  ViewController.m
//  Paypal Sample Code
//
//  Created by Rapidvalue on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

// PayPal imports
#import "PayPal.h"
#import "MEPAmounts.h"
#import "MEPAddress.h"
#import "PayPalMEPPayment.h"


@interface ViewController ()

@end

@implementation ViewController
@synthesize buttonzclicked;

- (void)viewDidLoad
{
    [super viewDidLoad];
    payPalLibraryLoaded = NO;
    
    
    [PayPal initializeWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_SANDBOX];	
	UIButton *button = [[PayPal getInstance] getPayButton:self buttonType:BUTTON_278x43 startCheckOut:@selector(payWithPayPal) PaymentType:DONATION withLeft:20 withTop:240];	
	[self.view addSubview:button];
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated {
	[PayPal initializeWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_SANDBOX];	
	while (!payPalLibraryLoaded) {
		if([[PayPal getInstance] initialized]) {
			payPalLibraryLoaded = YES;
			UIButton *button = [[PayPal getInstance] getPayButton:self buttonType:BUTTON_278x43 startCheckOut:@selector(payWithPayPal) PaymentType:DONATION withLeft:20 withTop:240];	
			[self.view addSubview:button];
		}
	}
}

#pragma mark -
#pragma mark PayPal Delegates

-(void)payWithPayPal {
	PayPal *pp = [PayPal getInstance]; 
	[pp DisableShipping]; 
	[pp feePaidByReceiver];
	
	PayPalMEPPayment *payment =[[PayPalMEPPayment alloc] init]; 
	payment.paymentCurrency= @"USD"; 
	payment.paymentAmount= [NSString stringWithString:@"500.0"]; 
	payment.itemDesc = @"Musicbrainz Donation"; 
	payment.recipient = @"jenslu_1279886203_biz@googlemail.com"; 
	payment.merchantName = @"Jens Lukas's Test Store"; 
	[pp Checkout:payment]; 
	[payment release];	
}

-(void)paymentSuccess:(NSString*)transactionID {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Donation successful" 
													message:@"Thank you for your donation." 
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(void)paymentCanceled {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Donation canceled" 
													message:@"You canceled your donation." 
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(void)paymentFailed:(PAYPAL_FAILURE)errorType {
	//NSLog("%@", errorType);
}
- (void)viewDidUnload
{
    [self setButtonzclicked:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)dealloc {
    [buttonzclicked release];
    [super dealloc];
}
- (IBAction)clicked:(id)sender {
}
@end
