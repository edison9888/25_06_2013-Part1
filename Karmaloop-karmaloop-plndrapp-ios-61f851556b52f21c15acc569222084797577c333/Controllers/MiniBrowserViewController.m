#import "MiniBrowserViewController.h"
#import "Utility.h"
#import "GANTracker.h"

@interface MiniBrowserViewController ()

- (void) browserBackClicked;
- (void) forwardClicked;
- (void) fixButtonStates;
- (void) backButtonPressed;
@end

@implementation MiniBrowserViewController

@synthesize webView = _webView, browserBackButton = _browserBackButton, forwardButton = _forwardButton, bottomNavBar = _bottomNavBar, request = _request;

- (id)initWithUrl:(NSURLRequest*)request {

    self = [super initWithNibName:@"MiniBrowserView" bundle:nil];

    if (self) {
        self.request = request;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
    self.webView.multipleTouchEnabled = YES;
    [self.webView setScalesPageToFit:YES];
    
    CGRect sectionMenuBarFrame;
    UIImage *backButtonDisabledImage;
    UIImage *forwardButtonDisabledImage;
    UIImage *bottomNavImage;
    

    sectionMenuBarFrame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    backButtonDisabledImage = [UIImage imageNamed:@"btn_browser_back_disable.png"];
    forwardButtonDisabledImage = [UIImage imageNamed:@"btn_browser_forward_disable.png"];
    bottomNavImage = [UIImage imageNamed:@"browser_bar.png"];
    
    [self.webView loadRequest:self.request];
    [self showLoadingView];
    
    [self.browserBackButton addTarget:self action:@selector(browserBackClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.forwardButton addTarget:self action:@selector(forwardClicked) forControlEvents:UIControlEventTouchUpInside];

    [self.bottomNavBar setBackgroundColor:[UIColor colorWithPatternImage:bottomNavImage]];
    [self.browserBackButton setImage:backButtonDisabledImage forState:UIControlStateDisabled];
    [self.forwardButton setImage:forwardButtonDisabledImage forState:UIControlStateDisabled];
    
    [self fixButtonStates];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView.delegate = nil;
    self.webView = nil;
    self.browserBackButton = nil;
    self.forwardButton = nil;
    self.bottomNavBar = nil;
}

- (void)dealloc {
    self.webView.delegate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - webview delegate
#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoadingView];
    self.title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self fixButtonStates];
    
    [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/%@", self.title] withError:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self fixButtonStates];
    [self showLoadingView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.webView;
}

#pragma mark - private

- (void) fixButtonStates {
    self.browserBackButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
}

- (void) browserBackClicked {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void) forwardClicked {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (void) backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PlndrBaseViewController Overrides

- (UIColor*) loadingViewBackgroundColor {
    return [UIColor clearColor];
}

- (CGRect)loadingViewFrame {
    return CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.bottomNavBar.frame.origin.y);
}

@end
