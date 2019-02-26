//
//  ViewController.m
//  MyDeallocTool
//
//  Created by 太极华青协同办公 on 2019/2/19.
//  Copyright © 2019年 太极华青协同办公. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    TestViewController *testVc = [[TestViewController alloc] init];
    [self.navigationController pushViewController:testVc animated:YES];
}

@end
