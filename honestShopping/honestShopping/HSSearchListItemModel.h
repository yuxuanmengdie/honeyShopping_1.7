//
//  HSSearchListItemModel.h
//  honestShopping
//
//  Created by zhang on 2018/4/2.
//  Copyright © 2018年 张国俗. All rights reserved.
//

#import "JSONModel.h"

@interface HSSearchListItemModel : JSONModel

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *orderid;
@property (copy, nonatomic) NSString *areaid;
@property (copy, nonatomic) NSString *flag;
@property (copy, nonatomic) NSString *areaflag;
@property (copy, nonatomic) NSString *imgurl;
@property (copy, nonatomic) NSString *imgurl2;


@end

/*
 [{"id":"12","name":"\u5357\u4eac","orderid":"1","areaid":"10","flag":"1","areaflag":"2","imgurl":"1803\/09\/nanjing.jpg","imgurl2":null},{"id":"13","name":"\u9547\u6c5f","orderid":"2","areaid":"10","flag":"1","areaflag":"2","imgurl":"1803\/09\/zhenjiang.jpg","imgurl2":null},{"id":"14","name":"\u626c\u5dde","orderid":"3","areaid":"10","flag":"1","areaflag":"2","imgurl":"1803\/09\/yangzhou.jpg","imgurl2":null},{"id":"15","name":"\u82cf\u5dde","orderid":"4","areaid":"10","flag":"1","areaflag":"2","imgurl":"1803\/09\/suzhou.jpg","imgurl2":null},{"id":"16","name":"\u65e0\u9521","orderid":"5","areaid":"10","flag":"1","areaflag":"2","imgurl":"1803\/09\/wuxi.jpg","imgurl2":null},{"id":"17","name":"\u5e38\u5dde","orderid":"6","areaid":"10","flag":"1","areaflag":"2","imgurl":"1803\/09\/changzhou.jpg","imgurl2":null},{"id":"18","name":"\u6cf0\u5dde","orderid":"7","areaid":"10","flag":"1","areaflag":"2","imgurl":"1803\/09\/taizhou.jpg","imgurl2":null},{"id":"19","name":"\u5357\u901a","orderid":"8","areaid":"10","flag":"1","areaflag":"2","imgurl":"1803\/09\/nantong.jpg","imgurl2":null},{"id":"20","name":"\u76d0\u57ce","orderid":"9","areaid":"10","flag":"1","areaflag":"2","imgurl":"1803\/09\/yancheng.jpg","imgurl2":null},{"id":"21","name":"\u6dee\u5b89","orderid":"10","areaid":"10","flag":"1","areaflag":"2","imgurl":"1803\/09\/huaian.jpg","imgurl2":null},{"id":"22","name":"\u5bbf\u8fc1","orderid":"11","areaid":"10","flag":"1","areaflag":"2","imgurl":"1803\/09\/suqian.jpg","imgurl2":null},{"id":"23","name":"\u5f90\u5dde","orderid":"12","areaid":"10","flag":"1","areaflag":"2","imgurl":"1803\/09\/xuzhou.jpg","imgurl2":null},{"id":"24","name":"\u8fde\u4e91\u6e2f","orderid":"13","areaid":"10","flag":"1","areaflag":"2","imgurl":"1803\/09\/lianyungang.jpg","imgurl2":null}]
 */
