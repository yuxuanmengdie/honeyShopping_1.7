//
//  HSMainPageViewController.h
//  honestShopping
//
//  Created by 张国俗 on 15-3-16.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSMainPageViewController : HSBaseViewController

@property (strong, nonatomic) NSArray *viewControllers;

//重置到首页热销
- (void)resetCate;

@end
