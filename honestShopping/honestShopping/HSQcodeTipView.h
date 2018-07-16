//
//  HSQcodeTipViewT.h
//  honestShopping
//
//  Created by zhang on 2018/3/12.
//  Copyright © 2018年 张国俗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSQcodeImageView.h"

typedef void(^HSQcodeTipViewDetailBlock)(void);

@interface HSQcodeTipView : UIView

@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet HSQcodeImageView *qcodeImg;

@property (copy, nonatomic) HSQcodeTipViewDetailBlock detailBlock;

- (IBAction)close:(id)sender;

- (instancetype)initWithQcodeURL:(NSString *)url;

- (void)show;

- (IBAction)qcodeDetail:(id)sender;


@end
