//
//  AASubviews.m
//  AASubviews
//
//  Created by qiuhaodong on 2017/12/18.
//  Copyright © 2017年 qiuhaodong. All rights reserved.
//
//  https://github.com/qhd/AASubviews
//

#import "AASubviews.h"
#import <objc/runtime.h>

#ifdef DEBUG
#define AALog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define AALog(format, ...)
#endif




/*
 This is the observer who observes the height change
 */
@interface AAObserver : NSObject

@property (weak, nonatomic) UIView *superview;

@property (strong, nonatomic) NSArray *subviews;

@end




/*
 UIView category
 */
@interface UIView (AASubviews)

// Observer (for superview use)
@property (readonly, strong, nonatomic) AAObserver *aaObserver;

// Used to mark whether the subview has been observed (for subview use)
@property (assign, nonatomic) BOOL aaIsBeObserved;

@end




@implementation AAObserver

- (void)dealloc {
    AALog(@"AAObserver dealloc");
    for (UIView *sub in self.subviews) {
        if (sub.aaIsBeObserved) {
            [sub removeObserver:self forKeyPath:@"frame"];
            [sub removeObserver:self forKeyPath:@"hidden"];
            sub.aaIsBeObserved = NO;
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        CGRect newFrame = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
        CGRect oldFrame = [[change objectForKey:NSKeyValueChangeOldKey] CGRectValue];
        if (newFrame.size.height != oldFrame.size.height) {
            AALog(@"%@ change height", NSStringFromClass([object class]));
            [AASubviews superview:self.superview subviews:self.subviews];
        }
    } else if ([keyPath isEqualToString:@"hidden"]) {
        BOOL newHidden = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        BOOL oldHidden = [[change objectForKey:NSKeyValueChangeOldKey] boolValue];
        if (newHidden != oldHidden) {
            AALog(@"%@ hidden is %@", NSStringFromClass([object class]), (newHidden ? @"YES" : @"NO"));
            [AASubviews superview:self.superview subviews:self.subviews];
        }
    }
}

@end




@implementation UIView (AASubviews)

- (AAObserver *)aaObserver {
    AAObserver *target = objc_getAssociatedObject(self, @selector(aaObserver));
    if (target == nil) {
        target = [[AAObserver alloc] init];
        target.superview = self;
        objc_setAssociatedObject(self, @selector(aaObserver), target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return target;
}

- (BOOL)aaIsBeObserved {
    NSNumber *n = objc_getAssociatedObject(self, @selector(aaIsBeObserved));
    return [n boolValue];
}

- (void)setAaIsBeObserved:(BOOL)aaIsBeObserved {
    NSNumber *n = [NSNumber numberWithBool:aaIsBeObserved];
    objc_setAssociatedObject(self,  @selector(aaIsBeObserved), n, OBJC_ASSOCIATION_ASSIGN);
}

@end




@implementation AASubviews

+ (void)superview:(UIView *)superview subviews:(NSArray *)subviews {
    // Remove all existing subviews
    for (UIView *orginSub in superview.subviews) {
        if (orginSub.aaIsBeObserved) {
            [orginSub removeObserver:[superview aaObserver] forKeyPath:@"frame"];
            [orginSub removeObserver:[superview aaObserver] forKeyPath:@"hidden"];
            orginSub.aaIsBeObserved = NO;
        }
        [orginSub removeFromSuperview];
    }
    
    // Layout from top to bottom
    CGFloat y = 0;
    for (UIView *sub in subviews) {
        if (![superview.subviews containsObject:sub]) {
            [superview addSubview:sub];
        }
        
        sub.frame = CGRectMake(sub.frame.origin.x, y, CGRectGetWidth(superview.frame), sub.frame.size.height);
        
        if (!sub.hidden) {
            y = CGRectGetMaxY(sub.frame);
        }
    }
    
    // Change the height of the superview
    if ([superview isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *)superview setContentSize:CGSizeMake(superview.frame.size.width, y)];
    } else {
        superview.frame = CGRectMake(superview.frame.origin.x, superview.frame.origin.y, superview.frame.size.width, y);
    }
    
    // Listen to the subview frame or hidden value change
    for (UIView *sub in subviews) {
        if (!sub.aaIsBeObserved) {
            NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
            [sub addObserver:superview.aaObserver forKeyPath:@"frame" options:options context:nil];
            [sub addObserver:superview.aaObserver forKeyPath:@"hidden" options:options context:nil];
            sub.aaIsBeObserved = YES;
        }
    }
    superview.aaObserver.subviews = subviews;
}

@end
