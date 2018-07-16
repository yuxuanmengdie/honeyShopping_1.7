//
//  HSExpressModel.h
//  honestShopping
//
//  Created by 张国俗 on 15-12-29.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "JSONModel.h"

@protocol HSExpressResultModel <NSObject>

@end

@protocol HSExpressListItemModel <NSObject>

@end

@interface HSExpressResultModel : JSONModel

@property (copy, nonatomic)NSString *number;
@property (copy, nonatomic)NSString *type;
@property (copy, nonatomic)NSString *deliverystatus;/* 1.在途中 2.正在派件 3.已签收 4.派送失败 */
@property (copy, nonatomic)NSString *issign;/* 1.是否签收 */
@property (copy, nonatomic)NSString *expSite;
@property (copy, nonatomic)NSString *expPhone;
@property (strong, nonatomic)NSArray <HSExpressListItemModel>*list;

@end

@interface HSExpressModel : JSONModel

@property (copy, nonatomic)NSString *msg;
@property (copy, nonatomic)NSString *status;
@property (strong, nonatomic)HSExpressResultModel *result;

@end


@interface HSExpressListItemModel : JSONModel

@property (copy, nonatomic)NSString *time;
@property (copy, nonatomic)NSString *status;
@end

/*
 
 {
 msg = ok;
 result =     {
 deliverystatus = 3;
 expName = "\U4e2d\U901a\U5feb\U9012";
 expPhone = 95311;
 expSite = "www.zto.com";
 issign = 1;
 list =         (
 {
 status = "[\U91cd\U5e86\U5e02]  \U5feb\U4ef6\U5df2\U5728 [\U91cd\U5e86\U74a7\U5c71] \U7b7e\U6536,\U7b7e\U6536\U4eba: \U62cd\U7167\U7b7e\U6536, \U611f\U8c22\U4f7f\U7528\U4e2d\U901a\U5feb\U9012,\U671f\U5f85\U518d\U6b21\U4e3a\U60a8\U670d\U52a1!";
 time = "2017-11-11 18:31:23";
 },
 {
 status = "[\U91cd\U5e86\U5e02]  [\U91cd\U5e86\U74a7\U5c71] \U7684\U6e29\U6cc9\U738b\U5fd7\U5174(13678462816) \U6b63\U5728\U7b2c1\U6b21\U6d3e\U4ef6, \U8bf7\U4fdd\U6301\U7535\U8bdd\U7545\U901a,\U5e76\U8010\U5fc3\U7b49\U5f85";
 time = "2017-11-11 14:00:33";
 },
 {
 status = "[\U91cd\U5e86\U5e02]  \U5feb\U4ef6\U5230\U8fbe [\U91cd\U5e86\U74a7\U5c71]";
 time = "2017-11-11 13:50:53";
 },
 {
 status = "[\U91cd\U5e86\U5e02]  \U5feb\U4ef6\U79bb\U5f00 [\U91cd\U5e86] \U53d1\U5f80 [\U91cd\U5e86\U74a7\U5c71]";
 time = "2017-11-11 05:33:05";
 },
 {
 status = "[\U91cd\U5e86\U5e02]  \U5feb\U4ef6\U5230\U8fbe [\U91cd\U5e86]";
 time = "2017-11-11 05:10:37";
 },
 {
 status = "[\U6df1\U5733\U5e02]  \U5feb\U4ef6\U79bb\U5f00 [\U6df1\U5733\U4e2d\U5fc3] \U53d1\U5f80 [\U91cd\U5e86]";
 time = "2017-11-10 00:51:09";
 },
 {
 status = "[\U6df1\U5733\U5e02]  \U5feb\U4ef6\U5230\U8fbe [\U6df1\U5733\U4e2d\U5fc3]";
 time = "2017-11-10 00:47:58";
 },
 {
 status = "[\U6df1\U5733\U5e02]  \U5feb\U4ef6\U79bb\U5f00 [\U798f\U7530\U534e\U5f3a] \U53d1\U5f80 [\U91cd\U5e86]";
 time = "2017-11-09 22:48:38";
 },
 {
 status = "[\U6df1\U5733\U5e02]  [\U798f\U7530\U534e\U5f3a] \U7684 \U5c0f\U83dc (13000000000) \U5df2\U6536\U4ef6";
 time = "2017-11-09 20:53:07";
 }
 );
 number = 462587770684;
 type = zto;
 };
 status = 0;
 }
 */
