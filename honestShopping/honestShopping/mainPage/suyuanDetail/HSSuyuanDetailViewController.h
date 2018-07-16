//
//  HSSuyuanDetailViewController.h
//  honestShopping
//
//  Created by zhang on 2018/3/29.
//  Copyright © 2018年 张国俗. All rights reserved.
//

#import "HSBaseViewController.h"
#import "HSCommodtyItemModel.h"

@interface HSSuyuanDetailViewController : HSBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *sepView;
@property (weak, nonatomic) IBOutlet UILabel *goods_source_1;
@property (weak, nonatomic) IBOutlet UILabel *goods_source_2;
@property (weak, nonatomic) IBOutlet UILabel *goods_source_3;
@property (weak, nonatomic) IBOutlet UILabel *goods_source_4;
@property (weak, nonatomic) IBOutlet UILabel *goods_source_5;
@property (weak, nonatomic) IBOutlet UILabel *goods_source_6;

@property (strong, nonatomic) HSCommodtyItemModel *itemModel;

- (void)setInfo:(HSCommodtyItemModel *)model;

@end
