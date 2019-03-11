//
//  SLJSContextManage.h
//  Pods-SLNativeJSMessage_Example
//
//  Created by lishuai on 2018/4/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
typedef NS_ENUM(NSInteger, SLJSContextManageType) {
    SLJSContextManageType_UIWebview =1,//
    SLJSContextManageType_WKWebview =2,//
};
@interface SLJSContextManage : NSObject
/**
 js上下文管理基类(仅适用于WKWebview)
 
 @param userController 通过这个对象注入脚本
 @return 返回上下文管理实例
 */
- (instancetype)initContextManageWithUserController:(WKUserContentController *)userController;
/**
 js上下文管理基类(仅适用于UIWebview)
 
 @param webview UIWebView实例
 @return 返回上下文管理实例
 */
- (instancetype)initContextManage:(UIWebView *)webview;
/**
 * jsApi:提供给h5用的接口
 * nativeImp:原生针对js接口实现(对象)
 */
- (void)captureJSContextBrigeWithType:(SLJSContextManageType)jsContextManageType jsServer:(Protocol *)jsServer nativeImp:(id)nativeImp;
@end
