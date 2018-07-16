//
//  HSCommodityTableViewCell.h
//  honestShopping
//
//  Created by zhang on 2018/2/27.
//  Copyright © 2018年 张国俗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSCommodtyItemModel.h"
#import "HSQcodeImageView.h"

typedef void(^HSQcodeDetailBlock)(NSString *url); //点击二维码
typedef void(^HSCommodityTableViewSuyuanDetailBlock)(HSCommodtyItemModel *model); //溯源详情

@interface HSCommodityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImg;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet HSQcodeImageView *qcodeImg;

/// 二维码
@property (nonatomic, copy) HSQcodeDetailBlock qcodeDetailBlock;

@property (nonatomic, copy) HSCommodityTableViewSuyuanDetailBlock suyuanDetailBlock;

/// 设置数据源
- (void)setData:(HSCommodtyItemModel *)itemModel;

@end
