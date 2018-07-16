//
//  HSDFGViewController.m
//  honestShopping
//
//  Created by zhang on 2018/3/19.
//  Copyright © 2018年 张国俗. All rights reserved.
//

#import "HSDFGViewController.h"
#import "HSDFGDetailViewController.h"

#import "UIImageView+WebCache.h"
#import "HSDFGTableViewCell.h"
#import "HSDFGModel.h"

@interface HSDFGViewController ()<UITableViewDelegate,
UITableViewDataSource>{
	NSArray *_data;
}

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation HSDFGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[self.view addSubview:_tableView];
	[_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSDFGTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSDFGTableViewCell class])];
	[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
	
	_tableView.translatesAutoresizingMaskIntoConstraints = NO;
	NSDictionary *views = NSDictionaryOfVariableBindings(_tableView);
	NSString *heightVfl = @"V:|-0-[_tableView]-0-|";
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:nil views:views]];
	NSString *widthVfl = @"H:|-0-[_tableView]-0-|";
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:nil views:views]];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.tableFooterView = [[UIView alloc] init];
	
	[self dataRequest];
	self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -
#pragma mark  获取地方馆信息
- (void)dataRequest
{
	[self showhudLoadingWithText:nil isDimBackground:YES];
	NSDictionary *parametersDic = @{kPostJsonKey:[HSPublic md5Str:[HSPublic getIPAddress:YES]],
									kPostJsonCid:self.cid
									};
	// 142346261  123456
	
	[self.httpRequestOperationManager POST:kGetItemAddrURL parameters:[HSPublic apiPostParas:parametersDic] success:^(AFHTTPRequestOperation *operation, id responseObject) { /// 失败
		NSLog(@"success\n%@",operation.responseString);
		[self hiddenHudLoading];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"%s failed\n%@",__func__,operation.responseString);
		[self hiddenHudLoading];
		if (operation.responseData == nil) {
		
			return ;
		}
		NSError *jsonError = nil;
		id json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&jsonError];
		if (jsonError == nil && [json isKindOfClass:[NSArray class]]) {
			
			NSArray *jsonArr = (NSArray *)json;
			NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithCapacity:jsonArr.count];
			
			[jsonArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
				HSDFGModel *model = [[HSDFGModel alloc] initWithDictionary:obj error:nil];
				[tmpArr addObject:model];
			}];
			_data = tmpArr;
			[_tableView reloadData];

		}
	}];
	
}


#pragma mark-
#pragma mark tableView DataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return _data.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	HSDFGTableViewCell *cell = (HSDFGTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSDFGTableViewCell class])];
	
	if (cell == nil){
		cell = [[HSDFGTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HSDFGTableViewCell"];
	}
	HSDFGModel *model = _data[indexPath.row];
	NSString *imgUrl = [NSString stringWithFormat:@"%@%@",kImageHeaderURL,model.addr_url_img];
	[cell.imagView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:kPlaceholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		if (image) {
			NSValue *imgSize =  [NSValue valueWithCGSize:image.size];
			NSDictionary *dic = [self.imageSizeDic objectForKey:imgUrl];
			if (dic != nil ) {
				NSURL *imgURL = dic[kImageURLKey];
				NSValue *sizeValue = dic[kImageSizeKey];
				if ([imgURL isEqual:imageURL] && [sizeValue isEqual:imgSize]) {
					return ;
				}
			}
			
			NSDictionary *tmpDic = @{kImageSizeKey:imgSize,
									 kImageURLKey:imageURL};
			
			[self.imageSizeDic setObject:tmpDic forKey:imgUrl];
			if (_tableView.dataSource != nil) {
				[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
			}
		}
	}];
	
	return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	HSDFGModel *model = _data[indexPath.row];
	NSString *imgUrl = [NSString stringWithFormat:@"%@%@",kImageHeaderURL,model.addr_url_img];
	NSDictionary *dic = [self.imageSizeDic objectForKey:imgUrl];
	
	if (dic != nil) {
		NSValue *sizeValue = dic[kImageSizeKey];
		CGSize size = [sizeValue CGSizeValue];
		CGFloat hei  = (float)size.height / size.width * _tableView.frame.size.width;
		return hei;
	}
	
	return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	HSDFGModel *model = _data[indexPath.row];
	if (self.cellSelectedBlock) {
		self.cellSelectedBlock(model);
	}
	
	
	

}

@end
