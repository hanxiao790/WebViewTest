//
//  WebViewController.m
//  WebViewTest
//
//  Created by HanXiao on 20/04/2017.
//  Copyright © 2017 Xiao Han. All rights reserved.
//

#import "WebViewController.h"
#import <WebViewJavascriptBridge.h>

@interface WebViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic) WebViewJavascriptBridge *bridge;
@property (nonatomic) WKWebView *webView;

@end

@implementation WebViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _url = @"http://www.baidu.com/";
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    [SVProgressHUD show];
    
    if (_bridge) {
        return;
    }
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [SVProgressHUD dismiss];
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [SVProgressHUD dismiss];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [SVProgressHUD dismiss];
}


#pragma mark - Lazy Loading

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *userContent = [[WKUserContentController alloc] init];
        webConfig.userContentController = userContent;
        
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [userContent addUserScript:wkUserScript];
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:webConfig];
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        
        _webView.navigationDelegate = self;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
        [_webView loadRequest:request];
    }
    return _webView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
