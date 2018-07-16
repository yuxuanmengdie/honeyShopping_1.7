//
//  HSOrderTableViewCell.m
//  honestShopping
//
//  Created by 张国俗 on 15-5-25.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSOrderTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation HSOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
	[super awakeFromNib];
    _priceLabel.textColor = [UIColor redColor];
    _stateLabel.textColor = kAppYellowColor;
	// 设置圆角的大小
	_expressBtn.layer.cornerRadius = 15;
	[_expressBtn.layer setMasksToBounds:YES];
	_expressBtn.layer.borderColor = kAPPTintColor.CGColor;
	_expressBtn.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)expressDetail:(id)sender {
	if (self.detailBolok) {
		self.detailBolok();
	}
}


- (void)setupWithModel:(HSOrderModel *)orderModel
{
    [_commodityImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageHeaderURL,[HSPublic controlNullString:orderModel.img]]] placeholderImage:kPlaceholderImage];
    
    _orderIDLabel.text = [HSPublic controlNullString:orderModel.orderId];
    _timeLabel.text = [HSPublic controlNullString:[HSPublic dateFormWithTimeDou:[orderModel.add_time doubleValue]]];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@元",[HSPublic controlNullString:orderModel.order_sumPrice] ];
    _stateLabel.text = [HSPublic controlNullString:[HSPublic orderStatusStrWithState:orderModel.status]];
	
	//1.代付款 2.待发货 3.待收获 4.完成 5。关闭
	if ([orderModel.status isEqualToString:@"1"] || [orderModel.status isEqualToString:@"5"]){
		_stateLabel.hidden = NO;
		_expressBtn.hidden = YES;
	} else {
		_stateLabel.hidden = YES;
		_expressBtn.hidden = NO;
	}
}
@end
