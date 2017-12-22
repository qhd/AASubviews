//
//  DemoController.m
//  AASubviewsDemo
//
//  Created by qiuhaodong on 2017/12/19.
//  Copyright © 2017年 qiuhaodong. All rights reserved.
//
//  https://github.com/qhd/AASubviews
//

#import "DemoController.h"
#import "AASubviews.h"
#import "DemoHeaderView.h"
#import "DemoNameView.h"
#import "DemoAdView.h"
#import "DemoDescView.h"
#import "DemoCommentView.h"

#define NAVIGATION_BAR_BACKGROUND_HEIGHT  ([UIApplication sharedApplication].statusBarFrame.size.height + 44)

@interface DemoController ()

@property (assign, nonatomic) DemoType type;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end


@implementation DemoController

- (instancetype)initWithType:(DemoType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(clickRefreshButton)];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.scrollView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height - NAVIGATION_BAR_BACKGROUND_HEIGHT);
    
    [self configContentViews];
}

- (void)clickRefreshButton {
    [self configContentViews];
}

- (void)configContentViews {
    DemoHeaderView *headerView = [DemoHeaderView createViewFromXib];
    DemoNameView *nameView = [DemoNameView createViewFromXib];
    DemoAdView *adView = [DemoAdView createViewFromXib];
    DemoDescView *descView = [DemoDescView createViewFromXib];
    DemoCommentView *commentView = [DemoCommentView createViewFromXib];
    
    NSArray *subviews = nil;
    if (self.type == DemoTypeHotel) {
        subviews = @[headerView, nameView, adView, descView, commentView];
    } else {
        subviews = @[adView, nameView, descView, commentView];
    }
    
    [AASubviews superview:self.scrollView subviews:subviews];
}

@end
