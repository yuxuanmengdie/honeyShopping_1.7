//
//  HSQcodeImageView.m
//  honestShopping
//
//  Created by zhang on 2018/3/1.
//  Copyright © 2018年 张国俗. All rights reserved.
//

#import "HSQcodeImageView.h"
#import <CoreImage/CoreImage.h>

@implementation HSQcodeImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setQcodeURL:(NSString *)url withSize:(CGFloat) size{
	// 1. 创建一个二维码滤镜实例(CIFilter)
	CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
	// 滤镜恢复默认设置
	[filter setDefaults];
	
	// 2. 给滤镜添加数据
	NSString *string = url;
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
	// 使用KVC的方式给filter赋值
	[filter setValue:data forKeyPath:@"inputMessage"];
	
	// 3. 生成二维码
	CIImage *image = [filter outputImage];
	
	// 4. 显示二维码
	
	 self.image = [self createNonInterpolatedUIImageFormCIImage:image withSize:size];
	
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
	
	CGRect extent = CGRectIntegral(image.extent);
	CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
	
	// 1.创建bitmap;
	size_t width = CGRectGetWidth(extent) * scale;
	size_t height = CGRectGetHeight(extent) * scale;
	CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
	CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
	CIContext *context = [CIContext contextWithOptions:nil];
	CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
	CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
	CGContextScaleCTM(bitmapRef, scale, scale);
	CGContextDrawImage(bitmapRef, extent, bitmapImage);
	
	// 2.保存bitmap到图片
	CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
	CGContextRelease(bitmapRef);
	CGImageRelease(bitmapImage);
	return [UIImage imageWithCGImage:scaledImage];
}



@end
