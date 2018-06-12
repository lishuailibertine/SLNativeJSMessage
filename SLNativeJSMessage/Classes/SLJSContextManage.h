//
//  SLJSContextManage.h
//  Pods-SLNativeJSMessage_Example
//
//  Created by Touker on 2018/4/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef NS_ENUM(NSInteger, SLJSContextManageType) {
    SLJSContextManageType_UIWebview =1,//
    SLJSContextManageType_WKWebview =2,//
};
@interface SLJSContextManage : NSObject
#pragma mark --js上下文管理基类(仅适用于WKWebview)
- (instancetype)initContextManageWithUserController:(WKUserContentController *)userController;
#pragma mark --js上下文管理基类(仅适用于UIWebview)
- (instancetype)initContextManageWithWebview:(UIWebView *)webview;

#pragma mark --上下文注册接口
/**
 * jsApi:提供给h5用的接口
 * nativeImp:原生针对js接口实现(对象)
 */
- (void)registerRidgeWithRidgeType:(SLJSContextManageType)jsContextManageType jsServer:(Protocol *)jsServer nativeImp:(id)nativeImp;
@end
