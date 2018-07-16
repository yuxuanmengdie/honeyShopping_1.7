//
//  HSQcodeTipViewT.m
//  honestShopping
//
//  Created by zhang on 2018/3/12.
//  Copyright © 2018年 张国俗. All rights reserved.
//

#import "HSQcodeTipView.h"
#import "UIView+HSLayout.h"
#import "UIImageView+WebCache.h"

@implementation HSQcodeTipView


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithQcodeURL:(NSString *)url{
	if ([super init]){
		[_qcodeImg setQcodeURL:url withSize:200];
		_headView.clipsToBounds = YES;
		_headView.layer.cornerRadius = 16;
	
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self  = [super initWithFrame:frame];
	
	if (self) {
		UIView *sview = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
		[self addSubview:sview];
		[self HS_edgeFillWithSubView:sview];
	}
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self  = [super initWithCoder:aDecoder];
	
	if (self) {
		UIView *sview = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
		[self addSubview:sview];
	}
	
	return self;
}

- (CGSize)intrinsicContentSize
{
	return CGSizeMake(220, 320);
}



- (void)show{
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	UIView *bcView = [[UIView alloc] init];
	bcView.backgroundColor = [UIColor blackColor];
	bcView.alpha = 0.6;
	bcView.tag = 8001;
	[window addSubview:bcView];
	[window addSubview:self];
	//window.translatesAutoresizingMaskIntoConstraints = NO;
	[window HS_edgeFillWithSubView:bcView];
	[window HS_centerXYWithSubView:self];
}

- (IBAction)qcodeDetail:(id)sender {
	[self close:nil];
	if (self.detailBlock) {
		self.detailBlock();
	}
}

- (IBAction)close:(id)sender {
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	UIView *bcView = [window viewWithTag:8001];
	__weak typeof(self)weakSelf = self;
	[UIView animateWithDuration:0.4f animations:^{
		weakSelf.alpha = 0.0;
		bcView.alpha = 0.0;
	} completion:^(BOOL finished) {
		[bcView removeFromSuperview];
		[weakSelf removeFromSuperview];
		
	}];
}
@end
