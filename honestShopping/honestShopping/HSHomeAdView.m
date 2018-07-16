//
//  HSHomeAdView.m
//  honestShopping
//
//  Created by zhang on 2018/3/13.
//  Copyright © 2018年 张国俗. All rights reserved.
//

#import "HSHomeAdView.h"
#import "UIView+HSLayout.h"
#import "UIImageView+WebCache.h"

@implementation HSHomeAdView{
	NSString *_imgUrl;
};

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithURL:(NSString *)url{
	
	return [self initWithFrame:CGRectZero url:url];
}

- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url{
	self = [super initWithFrame:frame];
	
	if (self) {
		_imgUrl = url;
		[self commitInit];
	}
	return self;
}

- (void)commitInit
{
	UIImageView *mView = [[UIImageView alloc] initWithFrame:CGRectZero];
	[mView sd_setImageWithURL:[NSURL URLWithString:_imgUrl]];
	[self addSubview:mView];
	UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
	[closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:closeBtn];

	mView.translatesAutoresizingMaskIntoConstraints = NO;
	closeBtn.translatesAutoresizingMaskIntoConstraints = NO;
	NSString *vfl1 = @"H:|[mView]|";
	NSString *vfl2 = @"V:|[mView]-20-[closeBtn]|";
	NSDictionary *dic = NSDictionaryOfVariableBindings(mView,closeBtn);
	NSArray *cons1 = [NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:nil views:dic];
	NSArray *cons2 = [NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:nil views:dic];
	[self addConstraints:cons1];
	[self addConstraints:cons2];
	[self HS_centerXWithSubView:closeBtn];
	mView.clipsToBounds = YES;
	mView.layer.cornerRadius = 16;
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
	[self HS_widthWithConstant:280];
	[self HS_HeightWithConstant:440];
}

- (void)close{
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


- (CGSize)intrinsicContentSize
{
	return CGSizeMake(220, 320);
}



@end
