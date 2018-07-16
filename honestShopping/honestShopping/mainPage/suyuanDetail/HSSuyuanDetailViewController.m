//
//  HSSuyuanDetailViewController.m
//  honestShopping
//
//  Created by zhang on 2018/3/29.
//  Copyright © 2018年 张国俗. All rights reserved.
//

#import "HSSuyuanDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface HSSuyuanDetailViewController ()

@end

@implementation HSSuyuanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.title = @"溯源详情";
	_sepView.backgroundColor = kAPPTintColor;
	[self setInfo:_itemModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInfo:(HSCommodtyItemModel *)itemModel {
	
	_titleLabel.text = [NSString stringWithFormat:@"%@",[HSPublic controlNullString:itemModel.title]];
	[_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageHeaderURL,itemModel.img]] placeholderImage:kPlaceholderImage];
	_goods_source_1.text = [HSPublic controlNullString:itemModel.goods_source.goods_source_1];
	_goods_source_2.text = [HSPublic controlNullString:itemModel.goods_source.goods_source_2];
	_goods_source_3.text = [HSPublic controlNullString:itemModel.goods_source.goods_source_3];
	_goods_source_4.text = [HSPublic controlNullString:itemModel.goods_source.goods_source_4];
	_goods_source_5.text = [HSPublic controlNullString:itemModel.goods_source.goods_source_5];
	_goods_source_6.text = [HSPublic controlNullString:itemModel.goods_source.goods_source_6];
	
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
