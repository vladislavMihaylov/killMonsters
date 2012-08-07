//
//  HtmlWebViewController.m
//

#import "HtmlWebViewController.h"

@implementation HtmlWebViewController

@synthesize webview, activityIndicator;

- (id)initWithURLString:(NSString *)url {
	if(self = [super init]) {
		urlToLoad = [url retain];
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"";
	
	webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	webview.delegate = self;
	[self.view addSubview:webview];
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activityIndicator startAnimating];
	activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2.0 - activityIndicator.frame.size.width / 2.0, self.view.frame.size.height / 2.0 - activityIndicator.frame.size.height / 2.0, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
	[self.view addSubview:activityIndicator];
	
//	[webview setBackgroundColor:[UIColor clearColor]];
	webview.opaque = YES;
	webview.scalesPageToFit = NO;
	
	[webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlToLoad]]];
}

- (void)dealloc {
	webview.delegate = nil;
	[webview release];
	[urlToLoad release];
	
    [super dealloc];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	activityIndicator.hidden = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	activityIndicator.hidden = YES;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	if ([error code] != -999) {
		activityIndicator.hidden = YES;
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		[[UIApplication sharedApplication] openURL:[request URL]];
		return NO;
	}
	
	return YES;
}

@end
