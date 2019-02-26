//
//  UIViewController+Dealloc.m
//  MyDeallocTool
//
//  Created by 太极华青协同办公 on 2019/2/19.
//  Copyright © 2019年 太极华青协同办公. All rights reserved.
//

#import "UIViewController+Dealloc.h"
#import <objc/runtime.h>

const char *popFlag;

@implementation UIViewController (Dealloc)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self lyc_swizzleControllerOrigalSEL:@selector(viewWillAppear:) customSEL:@selector(lyc_viewWillAppear:)];
        [self lyc_swizzleControllerOrigalSEL:@selector(viewWillDisappear:) customSEL:@selector(lyc_viewWillDisappear:)];
    });
}

+ (void)lyc_swizzleControllerOrigalSEL:(SEL)origalSEL customSEL:(SEL)customSEL
{
    Method origalMethod = class_getInstanceMethod([self class], origalSEL);
    Method customMethod = class_getInstanceMethod([self class], customSEL);
//    class_addMethod([self class], <#SEL  _Nonnull name#>, <#IMP  _Nonnull imp#>, <#const char * _Nullable types#>)
    BOOL didAddMethod = class_addMethod([self class],
                                        origalSEL,
                                        method_getImplementation(customMethod),
                                        method_getTypeEncoding(customMethod));
    
    if (didAddMethod) {
        class_replaceMethod([self class],
                            customSEL,
                            method_getImplementation(origalMethod),
                            method_getTypeEncoding(origalMethod));
    } else {
        method_exchangeImplementations(origalMethod, customMethod);
    }
}

- (void)lyc_viewWillAppear:(BOOL)animated
{
    [self lyc_viewWillAppear:animated];
    objc_setAssociatedObject(self, popFlag, @(NO), OBJC_ASSOCIATION_ASSIGN);
}

- (void)lyc_viewWillDisappear:(BOOL)animated
{
    [self lyc_viewWillDisappear:animated];
    BOOL flag = [objc_getAssociatedObject(self, popFlag) boolValue];
    if (flag) {
        [self customDealloc];
    }
}

#pragma mark - 核心就是延迟访问这个控制器,如果他不为空,那么就代表存在内存问题， nil就代表释放了
- (void)customDealloc
{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf showDealloc];
    });
}

- (void)showDealloc{
    
    NSLog(@"没释放的控制器%@", NSStringFromClass([self class]));
}

@end
