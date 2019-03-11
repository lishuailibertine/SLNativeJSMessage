//
//  SLViewController.m
//  SLNativeJSMessage
//
//  Created by lishuailibertine on 04/23/2018.
//  Copyright (c) 2018 lishuailibertine. All rights reserved.
//

#import "SLViewController.h"
#import "SLBaseWebViewBridge.h"
#import "SLJSContextManage.h"
#import "SLJSApi.h"
#import "SLNativeApi.h"

@interface SLViewController ()<WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *slWebView;
@property (nonatomic, strong) SLJSContextManage * jsContextManage;
@end

@implementation SLViewController

- (void)viewDidLoad{
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureJSContext) name:@"DidCreateContextNotification" object:nil];
    NSString *sourceStr =[[NSBundle bundleForClass:[self class]] pathForResource:@"test" ofType:@"bundle"];
    NSString *path =[NSString stringWithFormat:@"%@/Test.html",sourceStr];
    
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    WKUserContentController * user_controller = [[WKUserContentController alloc]init];
    configuration.userContentController = user_controller;
    CGRect react = [UIScreen mainScreen].bounds;
    
    self.slWebView = [[WKWebView alloc]initWithFrame:react configuration:configuration];
    [self.view addSubview:self.slWebView];
    self.slWebView.navigationDelegate = self;
    [self.slWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
	// Do any additional setup after loading the view, typically from a nib.
    self.jsContextManage =[[SLJSContextManage alloc] initContextManageWithUserController:user_controller];
    SLNativeApi *nativeApi =[[SLNativeApi alloc] init];
    [self.jsContextManage captureJSContextBrigeWithType:SLJSContextManageType_WKWebview jsServer:@protocol(SLJSApi) nativeImp:nativeApi];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
{
    
}
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    return YES;
//
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSLog(@"success");
//}
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    NSLog(@"error");
//}
@end

@implementation NSObject (hb_uiwebViewDelegator)

- (void)webView:(id)unuse didCreateJavaScriptContext:(JSContext *)ctx forFrame:(id)frame {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidCreateContextNotification" object:ctx];
}
@end
