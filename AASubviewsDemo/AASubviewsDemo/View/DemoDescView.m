//
//  DemoDescView.m
//  AASubviewsDemo
//
//  Created by qiuhaodong on 2017/12/19.
//  Copyright © 2017年 qiuhaodong. All rights reserved.
//
//  https://github.com/qhd/AASubviews
//

#import "DemoDescView.h"

@interface DemoDescView ()

@property (weak, nonatomic) IBOutlet UIButton *openButton;

@end


@implementation DemoDescView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.openButton setTitle:@"展开" forState:UIControlStateNormal];
    [self.openButton setTitle:@"收起" forState:UIControlStateSelected];
}

- (IBAction)clickOpenButton:(UIButton *)button {
    button.selected = !button.selected;
    
    CGRect frame = self.frame;
    frame.size.height = (button.selected ? 450 : 150);
    self.frame = frame;
}

@end
