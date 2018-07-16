//
//  HSCategariesModel.h
//  honestShopping
//
//  Created by 张国俗 on 15-3-27.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "JSONModel.h"
/// 商品类别名称
@interface HSCategariesModel : JSONModel

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *tags;
@property (copy, nonatomic) NSString *pid;
@property (copy, nonatomic) NSString *spid;
@property (copy, nonatomic) NSString *img;
@property (copy, nonatomic) NSString *fcolor;
@property (copy, nonatomic) NSString *remark;
@property (copy, nonatomic) NSString *add_time;
@property (copy, nonatomic) NSString *items;
@property (copy, nonatomic) NSString *likes;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *ordid;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *is_index;
@property (copy, nonatomic) NSString *is_default;
@property (copy, nonatomic) NSString *seo_title;
@property (copy, nonatomic) NSString *seo_keys;
@property (copy, nonatomic) NSString *seo_desc;
@property (copy, nonatomic) NSString *item_img;

@end

/*
 {
 "id": "351",
 "name": "果蔬",
 "tags": "",
 "pid": "0",
 "spid": "0",
 "img": "",
 "fcolor": "",
 "remark": "",
 "add_time": "0",
 "items": "0",
 "likes": "0",
 "type": "0",
 "ordid": "3",
 "status": "1",
 "is_index": "1",
 "is_default": "0",
 "seo_title": "",
 "seo_keys": "",
 "seo_desc": "",
 "item_img": "http:\/\/221.226.28.43:9012\/data\/upload\/item_cate\/5a5eb360d8ed7_thumb.jpeg"
 },
*/

