//
//  HSExpressViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-11-21.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSExpressViewController.h"
#import "HSExpressTableViewCell.h"
#import "HSExpressModel.h"
#import "UIView+HSLayout.h"

@interface HSExpressViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIWebView *_webView;
    
    HSExpressTableViewCell *_holderCell;
	
	UITableView *_tableView;
	
	HSExpressModel *_data;
}

@end

//查询间隔时间
const NSTimeInterval kSepInterval = 2*60*60;

@implementation HSExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self webViewInit];
	self.title = @"物流信息";
	
	_tableView  = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	_tableView.translatesAutoresizingMaskIntoConstraints = NO;
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	id topGuide = self.topLayoutGuide;
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide][_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView,topGuide)]];
	_tableView.tableFooterView = [UIView new];
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSExpressTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSExpressTableViewCell class])];
	[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
	

	
	if ([self isNewQuery:_orderId]) {
		[self expressQurey:_orderId];
	} else{
		NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
		NSDictionary *info = [ud objectForKey:_orderId];
		NSDictionary *data = info[@"data"];
		
		_data = [[HSExpressModel alloc] initWithDictionary:(NSDictionary *)data error:(NSError *__autoreleasing *)nil];
		[_tableView reloadData];
		if (![_data.status isEqualToString:@"0"]) {
			UIView *view =  [UIView new];
			UILabel *label = [[UILabel alloc] init];
			label.text = _data.msg;
			label.font = [UIFont systemFontOfSize:14];
			label.textColor = [UIColor darkGrayColor];
			[view addSubview:label];
			[view HS_centerXWithSubView:label];
			[view HS_dispacingWithFisrtView:label fistatt:NSLayoutAttributeTop secondView:view secondAtt:NSLayoutAttributeTop constant:8];
			_tableView.tableFooterView = view;
			[self showHudWithText:_data.msg];
		}
	}
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isNewQuery:(NSString *)orderId{
	NSDate *date = [NSDate date];
	NSTimeInterval time = [date timeIntervalSince1970];
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	NSDictionary *info = [ud objectForKey:orderId];
	
//	NSLog(@"time = %f",time);
//	NSLog(@"date = %f",[info[@"date"] floatValue]);
	
	if (!info || ([info[@"date"] floatValue] + kSepInterval) < time) {
		return true;
	}
	
	return false;
}

- (void)webViewInit {
    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    //_webView.delegate = self;
    [self.view addSubview:_webView];
    
    id topGuide = self.topLayoutGuide;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide][_webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView,topGuide)]];
    NSURL *url = [NSURL URLWithString:@"http://m.kuaidi100.com/index_all.html?type=quanfengkuaidi&postid=123456"];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //[_webView loadRequest:request];
	
	
}

- (void)expressQurey:(NSString *)orderId{
	[self showNetLoadingView];
	//462587770684
	[self.httpRequestOperationManager.requestSerializer setValue:[NSString  stringWithFormat:@"APPCODE %@",  kExpressAppCode] forHTTPHeaderField:@"Authorization"];
	[self.httpRequestOperationManager GET:[NSString stringWithFormat:@"%@?no=%@",kExpressURL,orderId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) { ///
		
		[self hiddenMsg];
		HSExpressModel *model = [[HSExpressModel alloc] initWithDictionary:(NSDictionary *)responseObject error:(NSError *__autoreleasing *)nil];
		NSLog(@"111");
		dispatch_async(dispatch_get_main_queue(), ^{
			_data = model;
			
			NSDate *date = [NSDate date];
			NSTimeInterval time = [date timeIntervalSince1970];
			NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
			NSDictionary *info = @{
								   @"date":[NSNumber numberWithFloat:time],
								   @"data":responseObject,
								   };
			[ud setObject:info forKey:orderId];
			[ud synchronize];
			
			if (![_data.status isEqualToString:@"0"]) {
				UIView *view =  [UIView new];
				UILabel *label = [[UILabel alloc] init];
				label.text = _data.msg;
				label.font = [UIFont systemFontOfSize:14];
				label.textColor = [UIColor darkGrayColor];
				[view addSubview:label];
				[view HS_centerXWithSubView:label];
				[view HS_dispacingWithFisrtView:label fistatt:NSLayoutAttributeTop secondView:view secondAtt:NSLayoutAttributeTop constant:8];
				_tableView.tableFooterView = view;
				[self showHudWithText:_data.msg];
			} else {
				[_tableView reloadData];
			}
			
		});
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"%s failed\n%@",__func__,operation.responseString);
		[self hiddenMsg];
		if (operation.responseData == nil) {
			return ;
		}
		NSError *jsonError = nil;
		id json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&jsonError];
		
		if (jsonError == nil && [json isKindOfClass:[NSDictionary class]]) {
			HSExpressModel *model = [[HSExpressModel alloc] initWithDictionary:(NSDictionary *)json error:(NSError *__autoreleasing *)nil];
			dispatch_async(dispatch_get_main_queue(), ^{
				_data = model;
				NSDate *date = [NSDate date];
				NSTimeInterval time = [date timeIntervalSince1970];
				NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
				NSDictionary *info = @{
									   @"date":[NSNumber numberWithFloat:time],
									   @"data":json,
									   };
				[ud setObject:info forKey:orderId];
				[ud synchronize];
				
				if (![_data.status isEqualToString:@"0"]) {
					UIView *view =  [UIView new];
					UILabel *label = [[UILabel alloc] init];
					label.text = _data.msg;
					label.font = [UIFont systemFontOfSize:14];
					label.textColor = [UIColor darkGrayColor];
					[view addSubview:label];
					[view HS_centerXWithSubView:label];
					[view HS_dispacingWithFisrtView:label fistatt:NSLayoutAttributeTop secondView:view secondAtt:NSLayoutAttributeTop constant:8];
					_tableView.tableFooterView = view;
					[self showHudWithText:_data.msg];
				} else {
					[_tableView reloadData];
				}
				
			});
			
		}
		
		
	}];

	
}

#pragma mark - tableview dataSource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.result.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	HSExpressTableViewCell *cell = (HSExpressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSExpressTableViewCell class])];
	
//	if (cell == nil){
//		cell = [[HSExpressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HSExpressTableViewCell"];
//	}
//
	NSArray *list = _data.result.list;
	HSExpressListItemModel *item = list[indexPath.row];
	[cell lastedStatus:(indexPath.row == 0)];
	cell.expressTitle.text = item.status;
	cell.timeLabel.text = item.time;
//cell.progressView.backgroundColor = [UIColor greenColor];
	//cell.sep
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
