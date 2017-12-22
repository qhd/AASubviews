//
//  DemoBaseView.m
//  AASubviewsDemo
//
//  Created by qiuhaodong on 2017/12/19.
//  Copyright © 2017年 qiuhaodong. All rights reserved.
//
//  https://github.com/qhd/AASubviews
//

#import "DemoBaseView.h"

@implementation DemoBaseView

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

+ (instancetype)createViewFromXib {
    NSString *xibName = NSStringFromClass(self);
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil];
    if ([topLevelObjects count] <= 0) {
        return nil;
    }
    return [topLevelObjects objectAtIndex:0];
}

@end
