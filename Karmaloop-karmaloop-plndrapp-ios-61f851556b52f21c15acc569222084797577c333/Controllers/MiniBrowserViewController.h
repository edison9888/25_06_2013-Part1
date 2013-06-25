#import <UIKit/UIKit.h>
#import "PlndrBaseViewController.h"

@interface MiniBrowserViewController : PlndrBaseViewController <UIWebViewDelegate, UIScrollViewDelegate>{
    
}

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIButton *browserBackButton;
@property (nonatomic, strong) IBOutlet UIButton *forwardButton;
@property (nonatomic, strong) IBOutlet UIView *bottomNavBar;
@property (nonatomic, strong) NSURLRequest *request;

- (id)initWithUrl:(NSURLRequest*)request;

@end
