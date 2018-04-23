//
//  SLViewController.m
//  SLNativeJSMessage
//
//  Created by lishuailibertine on 04/23/2018.
//  Copyright (c) 2018 lishuailibertine. All rights reserved.
//

#import "SLViewController.h"

@interface SLViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *slWebView;

@end

@implementation SLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *sourceStr =[[NSBundle bundleForClass:[self class]] pathForResource:@"test" ofType:@"bundle"];
    NSString *path =[NSString stringWithFormat:@"%@/Test.html",sourceStr];
    [self.slWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
	// Do any additional setup after loading the view, typically from a nib.
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
