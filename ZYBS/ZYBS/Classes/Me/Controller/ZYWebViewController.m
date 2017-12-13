//
//  ZYWebViewController.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/4.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYWebViewController.h"

@interface ZYWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardItem;
@end

@implementation ZYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)back:(id)sender {
    [self.webView goBack];
}
- (IBAction)forward:(id)sender {
    [self.webView goForward];
}
- (IBAction)reload:(id)sender {
    [self.webView reload];
}


#pragma mark ----- UIWebViewDelegate -----

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.backItem.enabled = webView.canGoBack;
    self.forwardItem.enabled = webView.canGoForward;
}


@end
