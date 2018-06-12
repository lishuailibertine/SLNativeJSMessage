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

@interface SLViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *slWebView;
@property (nonatomic, strong) SLJSContextManage * jsContextManage;
@end

@implementation SLViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureJSContext) name:@"DidCreateContextNotification" object:nil];
    NSString *sourceStr =[[NSBundle bundleForClass:[self class]] pathForResource:@"test" ofType:@"bundle"];
    NSString *path =[NSString stringWithFormat:@"%@/Test.html",sourceStr];
    [self.slWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)captureJSContext{
    self.jsContextManage =[[SLJSContextManage alloc] initContextManageWithWebview:self.slWebView];
    SLNativeApi *nativeApi =[[SLNativeApi alloc] init];
    [self.jsContextManage registerRidgeWithRidgeType:SLJSContextManageType_UIWebview jsServer:@protocol(SLJSApi) nativeImp:nativeApi];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"success");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error");
}
@end

@implementation NSObject (hb_uiwebViewDelegator)

- (void)webView:(id)unuse didCreateJavaScriptContext:(JSContext *)ctx forFrame:(id)frame {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidCreateContextNotification" object:ctx];
}
@end
