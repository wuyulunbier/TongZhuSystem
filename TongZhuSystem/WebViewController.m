//
//  WebViewController.m
//  TongZhuSystem
//
//  Created by hsk on 2021/1/14.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, copy) NSString *url;
@end

@implementation WebViewController

- (instancetype)initWithURL:(NSString *)url {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        _url = url;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _webView = [[WKWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _webView.navigationDelegate = self;
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:7];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0.1, 450, 2)];
    self.progressView.tintColor = [UIColor greenColor];
    self.progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:self.progressView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //     self.navigationItem.title = change[@"new"];
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];

        if (newprogress == 1) {
            
            self.progressView.progress = newprogress;
            [UIView animateWithDuration:1 animations:^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            }];
            
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.webView) {
            self.title = self.webView.title;
            
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
            
        }
    }
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    
}
@end
