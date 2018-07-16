//
//  HSQcodeImageView.h
//  honestShopping
//
//  Created by zhang on 2018/3/1.
//  Copyright © 2018年 张国俗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQcodeImageView : UIImageView

//设置二维码url和大小
- (void)setQcodeURL:(NSString *)url withSize:(CGFloat) size;

@end
