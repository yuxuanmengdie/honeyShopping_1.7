//
//  HSCommodityTableViewCell.m
//  honestShopping
//
//  Created by zhang on 2018/2/27.
//  Copyright © 2018年 张国俗. All rights reserved.
//

#import "HSCommodityTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HSQcodeTipView.h"
#import "HSSuyuanDetailViewController.h"

@implementation HSCommodityTableViewCell
{
	HSCommodtyItemModel *_itemModel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	_qcodeImg.userInteractionEnabled = YES;
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qcodeDetail:)];
	[_qcodeImg addGestureRecognizer:tapGesture];
	

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/// 设置数据源
- (void)setData:(HSCommodtyItemModel *)itemModel{
	_itemModel = itemModel;
	_titleLabel.text = [NSString stringWithFormat:@"%@ %@",[HSPublic controlNullString:itemModel.title],[HSPublic controlNullString:itemModel.standard]];
	if ([self labelLines:_titleLabel] > 1){
		_infoLabel.numberOfLines = 2;
	} else{
		_infoLabel.numberOfLines = 3;
	}
	
	_descLabel.text = [HSPublic controlNullString:itemModel.goods_addr];
	_infoLabel.text = [NSString stringWithFormat:@"溯源分类：%@ %@ %@ %@ %@ %@ %@",[HSPublic controlNullString:itemModel.goods_source.source_name],[HSPublic controlNullString:itemModel.goods_source.goods_source_1],[HSPublic controlNullString:itemModel.goods_source.goods_source_2],[HSPublic controlNullString:itemModel.goods_source.goods_source_3],[HSPublic controlNullString:itemModel.goods_source.goods_source_4],[HSPublic controlNullString:itemModel.goods_source.goods_source_5],[HSPublic controlNullString:itemModel.goods_source.goods_source_6]];
	
	_priceLabel.font = [UIFont boldSystemFontOfSize:16];
	_priceLabel.text = [NSString stringWithFormat:@"￥%@",[HSPublic controlNullString:itemModel.price]];
	_priceLabel.textColor = [UIColor redColor];
	
	[_leftImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageHeaderURL,itemModel.img]] placeholderImage:kPlaceholderImage];
	//[_qcodeImg setQcodeURL:itemModel.qrcode_url withSize:_qcodeImg.bounds.size.width];
}

- (NSUInteger)labelLines:(UILabel *)label{
	CGRect rect = [label.text boundingRectWithSize:CGSizeMake(label.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: label.font} context:nil];
	
	CGSize textSize = [label.text sizeWithAttributes:@{NSFontAttributeName : label.font}];
	return (NSUInteger)(rect.size.height / textSize.height);
}

- (void)qcodeDetail:(id)sender{
	
	HSQcodeTipView *tipView = [[HSQcodeTipView alloc] initWithQcodeURL:_itemModel.qrcode_url];
	typeof(self) wself = self;
	tipView.detailBlock = ^(){
		
		if (wself.suyuanDetailBlock) {
			wself.suyuanDetailBlock(wself->_itemModel);
		}
		
	};
	
	[tipView show];
}

@end
