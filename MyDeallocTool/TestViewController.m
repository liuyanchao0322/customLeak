//
//  TestViewController.m
//  MyDeallocTool
//
//  Created by 太极华青协同办公 on 2019/2/19.
//  Copyright © 2019年 太极华青协同办公. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()
/** <#注释#> */
@property (nonatomic, copy) void (^myBlock)(void);
/** <#注释#> */
@property (nonatomic, copy) NSString *name;


@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myBlock = ^{
        NSLog(@"-- %@", self.name);
    };
}


@end
