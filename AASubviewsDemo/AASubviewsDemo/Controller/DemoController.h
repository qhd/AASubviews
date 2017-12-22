//
//  DemoController.h
//  AASubviewsDemo
//
//  Created by qiuhaodong on 2017/12/19.
//  Copyright © 2017年 qiuhaodong. All rights reserved.
//
//  https://github.com/qhd/AASubviews
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DemoType) {
    DemoTypeHotel = 0,
    DemoTypeShop = 1,
};

@interface DemoController : UIViewController

- (instancetype)initWithType:(DemoType)type;

@end

