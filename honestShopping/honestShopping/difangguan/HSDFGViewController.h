//
//  HSDFGViewController.h
//  honestShopping
//
//  Created by zhang on 2018/3/19.
//  Copyright © 2018年 张国俗. All rights reserved.
//

#import "HSBaseViewController.h"
#import "HSDFGModel.h"

typedef void(^HSDFGCollectionCellSelectedBlock)(HSDFGModel *model);

@interface HSDFGViewController : HSBaseViewController


@property (copy, nonatomic) NSString *cid;

/// 点击单个cell的block
@property (nonatomic, copy) HSDFGCollectionCellSelectedBlock cellSelectedBlock;

@end
