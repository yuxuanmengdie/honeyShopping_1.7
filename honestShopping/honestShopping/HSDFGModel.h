//
//  HSDFGModel.h
//  honestShopping
//
//  Created by zhang on 2018/3/19.
//  Copyright © 2018年 张国俗. All rights reserved.
//

#import "JSONModel.h"

@interface HSDFGModel : JSONModel

@property (copy, nonatomic) NSString *aid;
@property (copy, nonatomic) NSString *addr_url_img;
@property (copy, nonatomic) NSString *cid;
@property (copy, nonatomic) NSString *name;

@end

/*
 [{"aid":"12","name":"\u5357\u4eac","addr_url_img":"1803\/09\/nanjing.jpg","cid":""},{"aid":"13","name":"\u9547\u6c5f","addr_url_img":"1803\/09\/zhenjiang.jpg","cid":""},{"aid":"14","name":"\u626c\u5dde","addr_url_img":"1803\/09\/yangzhou.jpg","cid":""},{"aid":"15","name":"\u82cf\u5dde","addr_url_img":"1803\/09\/suzhou.jpg","cid":""},{"aid":"16","name":"\u65e0\u9521","addr_url_img":"1803\/09\/wuxi.jpg","cid":""},{"aid":"17","name":"\u5e38\u5dde","addr_url_img":"1803\/09\/changzhou.jpg","cid":""},{"aid":"18","name":"\u6cf0\u5dde","addr_url_img":"1803\/09\/taizhou.jpg","cid":""},{"aid":"19","name":"\u5357\u901a","addr_url_img":"1803\/09\/nantong.jpg","cid":""},{"aid":"20","name":"\u76d0\u57ce","addr_url_img":"1803\/09\/yancheng.jpg","cid":""},{"aid":"21","name":"\u6dee\u5b89","addr_url_img":"1803\/09\/huaian.jpg","cid":""},{"aid":"22","name":"\u5bbf\u8fc1","addr_url_img":"1803\/09\/suqian.jpg","cid":""},{"aid":"23","name":"\u5f90\u5dde","addr_url_img":"1803\/09\/xuzhou.jpg","cid":""},{"aid":"24","name":"\u8fde\u4e91\u6e2f","addr_url_img":"1803\/09\/lianyungang.jpg","cid":""}]
 
 */
