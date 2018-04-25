//
//  SLJSContextManage.h
//  Pods-SLNativeJSMessage_Example
//
//  Created by Touker on 2018/4/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SLJSContextManage : NSObject

- (instancetype)initContextManage:(UIWebView *)webview;;
- (void)captureJSContextBrige:(Protocol *)jsServer nativeImp:(id)nativeImp;
@end
