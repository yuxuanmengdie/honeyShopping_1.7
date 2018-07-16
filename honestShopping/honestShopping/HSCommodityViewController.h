//
//  HSCommodityViewController.h
//  honestShopping
//
//  Created by 张国俗 on 15-3-23.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSCommodtyItemModel.h"

typedef void(^HSCommodityCollectionCellSelectedBlock)(HSCommodtyItemModel *itemModel);
typedef void(^HSCommoditySuyuanDetailBlock)(HSCommodtyItemModel *itemModel);

@interface HSCommodityViewController : HSBaseViewController

/// 是否显示banner
@property (assign, nonatomic) BOOL isShowBanner;

/// 类别的id
@property (assign, nonatomic) NSString *cateID;

/// 地方馆的id
@property (assign, nonatomic) NSString *aid;


/// 设置数据源
- (void)setItemsData:(NSArray *)itemsData;


/// 设置banner数据源
- (void)setBannerModels:(NSArray *)images;

/// 点击单个cell的block
@property (nonatomic, copy) HSCommodityCollectionCellSelectedBlock cellSelectedBlock;
@property (nonatomic, copy) HSCommoditySuyuanDetailBlock suyuanDetailBlock;


@end
