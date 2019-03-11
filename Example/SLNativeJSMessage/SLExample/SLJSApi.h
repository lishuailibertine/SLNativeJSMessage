//
//  SLJSApi.h
//  SLNativeJSMessage
//
//  Created by Touker on 2018/4/25.
//  Copyright © 2018年 lishuailibertine. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SLJSApiBase <NSObject>
@required;
- (void)helloWorld;
@end
@protocol SLJSApi <SLJSApiBase>
@required;
- (void)helloWorldA;
@end

