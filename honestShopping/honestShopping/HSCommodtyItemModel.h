//
//  HSCommodtyItemModel.h
//  honestShopping
//
//  Created by 张国俗 on 15-3-27.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "JSONModel.h"

@protocol HSGoodsSourceModel <NSObject>


@end
/// 商品回溯信息详细 的model
@interface HSGoodsSourceModel : JSONModel

@property (copy, nonatomic) NSString *source_name;

@property (copy, nonatomic) NSString *goods_source_1;

@property (copy, nonatomic) NSString *goods_source_2;

@property (copy, nonatomic) NSString *goods_source_3;

@property (copy, nonatomic) NSString *goods_source_4;

@property (copy, nonatomic) NSString *goods_source_5;

@property (copy, nonatomic) NSString *goods_source_6;

@end


@interface HSCommodtyItemModel : JSONModel


@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *cate_id;
@property (copy, nonatomic) NSString *orig_id;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *intro;
@property (copy, nonatomic) NSString *img;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *rates;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *comments;
@property (copy, nonatomic) NSString *cmt_taobao_time;
@property (copy, nonatomic) NSString *add_time;
@property (copy, nonatomic) NSString *ordid;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *info;
@property (strong, nonatomic) NSString *tuwen; ///详细内容都是图片
@property (copy, nonatomic) NSString *news;
@property (copy, nonatomic) NSString *tuijian;
@property (copy, nonatomic) NSString *goods_stock;
@property (copy, nonatomic) NSString *buy_num;
@property (copy, nonatomic) NSString *brand;
@property (copy, nonatomic) NSString *pingyou;
@property (copy, nonatomic) NSString *kuaidi;
@property (copy, nonatomic) NSString *ems;
@property (copy, nonatomic) NSString *free;
@property (copy, nonatomic) NSString *color;
@property (copy, nonatomic) NSString *size;
@property (copy, nonatomic) NSString *maxbuy;
@property (copy, nonatomic) NSString *ischeck;
@property (copy, nonatomic) NSString *standard;
@property (copy, nonatomic) NSString *tuan;
@property (copy, nonatomic) NSString *tuan_price;
@property (copy, nonatomic) NSString *tuan_time;
@property (copy, nonatomic) NSString *maill_price;
@property (copy, nonatomic) NSString *ordernum;
@property (copy, nonatomic) NSString *likes;
@property (copy, nonatomic) NSString *imageurl;
@property (strong, nonatomic) NSArray *banner; // 顶部的轮播图
//新增回溯字段
@property (copy, nonatomic) NSString *goods_source_type;
@property (copy, nonatomic) NSString *goods_source_o;
@property (copy, nonatomic) NSString *goods_source_t;
@property (copy, nonatomic) NSString *goods_source_th;
@property (copy, nonatomic) NSString *goods_source_f;
@property (copy, nonatomic) NSString *goods_source_fi;
@property (copy, nonatomic) NSString *goods_source_s;
@property (copy, nonatomic) NSString *goods_addr;
@property (copy, nonatomic) NSString *qrcode_url;
@property (strong, nonatomic) HSGoodsSourceModel *goods_source;

@end




/*



 "id":"155",
 "cate_id":"352",
 "orig_id":"0",
 "title":"\u5f52\u6765\u516e\u7ea2\u82b1\u9999\u7c73",
 "intro":"\u65b0\u534e\u793e\u4e3a\u519c\u670d\u52a1\u8bda\u4fe1\u5e73\u53f0\u4e3a\u4f60\u8bda\u610f\u63a8\u8350\r\n",
 "img":"1407\/01\/53b23b659d5e3.png",
 "price":"200.00",
 "rates":"0.00",
 "type":"1",
 "comments":"0",
 "cmt_taobao_time":"0",
 "add_time":"1404189543",
 "ordid":"255",
 "status":"1",
 "info":"",
 "news":"0",
 "tuwen":[
 ".\/data\/upload\/editer\/image\/2014\/10\/31\/545330876fae1.png",
 ".\/data\/upload\/editer\/image\/2014\/10\/31\/54533087cc847.png",
 ".\/data\/upload\/editer\/image\/2014\/10\/31\/5453308843b6b.png",
 ".\/data\/upload\/editer\/image\/2014\/10\/31\/54533088b63d2.png",
 ".\/data\/upload\/editer\/image\/2014\/10\/31\/54533089be4d7.png",
 ".\/data\/upload\/editer\/image\/2014\/10\/31\/54533089eed3d.png",
 ".\/data\/upload\/editer\/image\/2014\/10\/31\/5453308ac2003.png",
 ".\/data\/upload\/editer\/image\/2014\/10\/31\/5453308bb29ea.jpg"
 ],
 "tuijian":"0",
 "goods_stock":"1000",
 "buy_num":"12",
 "brand":"2",
 "pingyou":"0.00",
 "kuaidi":"0.00",
 "ems":"0.00",
 "free":"1",
 "color":null,
 "size":null,
 "maxbuy":"10",
 "ischeck":"2",
 "standard":"10\u65a4\/\u888b",
 "tuan":"0",
 "tuan_price":"0.00",
 "tuan_time":"0",
 "maill_price":"0",
 "ordernum":"70",
 "likes":"1813",
 
 },
 
 {
 "id": "527",
 "cate_id": "351",
 "orig_id": "0",
 "title": "\u5eb7\u5b8f\u751f\u7269 \u674f\u9c8d\u83c7 10kg\/\u7bb1",
 "intro": "",
 "img": "1701\/03\/586b5162a4230_m.jpg",
 "price": "75.00",
 "rates": "0.00",
 "type": "1",
 "comments": "0",
 "cmt_taobao_time": "0",
 "add_time": "1483428195",
 "ordid": "255",
 "status": "1",
 "info": "",
 "tuwen": "<img src=\".\/data\/upload\/editer\/image\/2017\/01\/03\/586b4fcf0475e.jpg\" alt=\"\" \/><br \/>\r\n<img src=\".\/data\/upload\/editer\/image\/2017\/01\/03\/586b4fcf6d8d7.jpg\" alt=\"\" \/><br \/>\r\n<img src=\".\/data\/upload\/editer\/image\/2017\/01\/03\/586b4fd00ba8a.jpg\" alt=\"\" \/><br \/>\r\n<img src=\".\/data\/upload\/editer\/image\/2017\/01\/03\/586b5043b8e96.jpg\" alt=\"\" \/><br \/>",
 "news": "0",
 "tuijian": "0",
 "goods_stock": "1000",
 "buy_num": "0",
 "brand": "71",
 "pingyou": "0.00",
 "kuaidi": "0.00",
 "ems": "0.00",
 "free": "1",
 "color": null,
 "size": null,
 "maxbuy": "50",
 "ischeck": "2",
 "standard": "2.5KG\/x4\/\u76d2",
 "tuan": "0",
 "tuan_price": "0.00",
 "tuan_time": "0",
 "maill_price": "0",
 "ordernum": "505",
 "likes": "0",
 "goods_source_type": "1",
 "goods_source_o": "\u8054\u82ef\u83ca\u8102+\u82e6\u53c2\u78b1",
 "goods_source_t": "1\u514b",
 "goods_source_th": "\u52a0\u6c34\u7a00\u91ca\u55b7\u96fe",
 "goods_source_f": "\u52a0\u6c34\u7a00\u91ca\u55b7\u96fe",
 "goods_source_fi": "2016\u5e746\u670825\u65e5",
 "goods_source_s": "2",
 "goods_addr": "\u82cf\u5dde\u9986",
 "qrcode_url": "http:\/\/221.226.28.43:9012\/index.php?g=api_test&m=Item&a=getSourceItemId&id=527",
 "goods_source": {
 "source_name": "\u79cd\u690d\u4e1a\u4ea7\u54c1",
 "goods_source_1": "\u519c\u836f\u540d\u79f0(\u89c4\u683c) :\u8054\u82ef\u83ca\u8102+\u82e6\u53c2\u78b1",
 "goods_source_2": "\u9632\u6cbb\u5bf9\u8c61 :1\u514b",
 "goods_source_3": "\u6bcf\u6b21\u7528\u91cf :\u52a0\u6c34\u7a00\u91ca\u55b7\u96fe",
 "goods_source_4": "\u4f7f\u7528\u65b9\u6cd5 :\u52a0\u6c34\u7a00\u91ca\u55b7\u96fe",
 "goods_source_5": "\u4f7f\u7528\u65f6\u95f4:2016\u5e746\u670825\u65e5",
 "goods_source_6": "\u5b89\u5168\u95f4\u9694\u671f(\u5929):2"
 },
 "banner":[
 "1410\/31\/545330b1ebc41.png",
 "1410\/31\/545330b0ec708.png"
 ]
 },
*/
