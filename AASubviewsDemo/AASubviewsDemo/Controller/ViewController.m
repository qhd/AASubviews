//
//  ViewController.m
//  AASubviewsDemo
//
//  Created by qiuhaodong on 2017/12/19.
//  Copyright © 2017年 qiuhaodong. All rights reserved.
//
//  https://github.com/qhd/AASubviews
//

#import "ViewController.h"
#import "DemoController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
}

- (IBAction)clickHotelButton:(id)sender {
    DemoController *controller = [[DemoController alloc] initWithType:DemoTypeHotel];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)clickShopButton:(id)sender {
    DemoController *controller = [[DemoController alloc] initWithType:DemoTypeShop];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
