//
//  HSHomeAdModel.h
//  honestShopping
//
//  Created by zhang on 2018/3/15.
//  Copyright © 2018年 张国俗. All rights reserved.
//

#import "JSONModel.h"

@interface HSHomeAdModel : JSONModel

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *board_id;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *extimg;
@property (copy, nonatomic) NSString *extval;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *start_time;
@property (copy, nonatomic) NSString *end_time;
@property (copy, nonatomic) NSString *clicks;
@property (copy, nonatomic) NSString *add_time;
@property (copy, nonatomic) NSString *ordid;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *is_app;


@end

/*
 [
 {
 "id": "417",
 "board_id": "125",
 "type": "image",
 "name": "\u9996\u9875\u5f39\u51fa\u5c42",
 "url": "",
 "content": "1712\/14\/5a31d8a297f77.png",
 "extimg": "",
 "extval": "",
 "desc": "",
 "start_time": "1513180800",
 "end_time": "1734105600",
 "clicks": "0",
 "add_time": "0",
 "ordid": "255",
 "status": "1",
 "is_app": "1"
 }
 ]
 
 */

