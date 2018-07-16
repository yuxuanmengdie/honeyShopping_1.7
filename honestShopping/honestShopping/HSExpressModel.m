//
//  HSExpressModel.m
//  honestShopping
//
//  Created by 张国俗 on 15-12-29.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSExpressModel.h"

@implementation HSExpressModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
	return YES;
}

@end


@implementation HSExpressResultModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
	return YES;
}
@end

@implementation HSExpressListItemModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
	return YES;
}
@end
