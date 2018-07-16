//
//  HSCommodityCategaryCollectionViewCell.m
//  honestShopping
//
//  Created by 张国俗 on 15-3-17.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSCommodityCategaryCollectionViewCell.h"

@implementation HSCommodityCategaryCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
	[super awakeFromNib];
	_cateImgView.layer.cornerRadius = 25;
	_cateImgView.layer.masksToBounds = YES;
}


- (void)changeTitleColorAndFont:(BOOL)isSelected
{
    [UIView animateWithDuration:0.3 animations:^{
    
        
        if (isSelected) {//选中状态
            _categaryTitleLabel.font = [UIFont systemFontOfSize:14];
            _categaryTitleLabel.textColor = kAPPTintColor;
			_sepView.backgroundColor = kAPPTintColor;
        }
        else // 没选择
        {
            _categaryTitleLabel.font = [UIFont systemFontOfSize:14];
            _categaryTitleLabel.textColor = kAppYellowColor;
			_sepView.backgroundColor = [UIColor clearColor];
        }

    }];
}

@end
