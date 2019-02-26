//
//  UINavigationController+pop.m
//  MyDeallocTool
//
//  Created by 太极华青协同办公 on 2019/2/19.
//  Copyright © 2019年 太极华青协同办公. All rights reserved.
//

#import "UINavigationController+pop.h"
#import <objc/runtime.h>

@implementation UINavigationController (pop)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self lyc_methodSwizzleOrigalSEL:@selector(popViewControllerAnimated:) customSEL:@selector(lyc_popViewControllerAnimated:)];
    });
}

+ (void)lyc_methodSwizzleOrigalSEL:(SEL)origalSEL customSEL:(SEL)customSEL
{
    Method origalMethod = class_getInstanceMethod([self class], origalSEL);
    Method customMethod = class_getInstanceMethod([self class], customSEL);
    method_exchangeImplementations(origalMethod, customMethod);
}

- (UIViewController *)lyc_popViewControllerAnimated:(BOOL)animated
{
    UIViewController *popVc = [self lyc_popViewControllerAnimated:animated];
    extern char *popFlag;
    objc_setAssociatedObject(popVc, popFlag, @(YES), OBJC_ASSOCIATION_ASSIGN);
    return popVc;
}


@end
