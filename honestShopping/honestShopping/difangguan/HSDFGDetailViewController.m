//
//  HSDFGDetailViewController.m
//  honestShopping
//
//  Created by zhang on 2018/3/19.
//  Copyright © 2018年 张国俗. All rights reserved.
//

#import "HSDFGDetailViewController.h"
#import "HSCommodityViewController.h"
#import "HSCommodityDetailViewController.h"
#import "HSSuyuanDetailViewController.h"
#import "HSSearchResultModel.h"
#import "HSCommodityTableViewCell.h"
#import "HSItemPageModel.h"
 #import "MJRefresh.h"

#import "UIView+HSLayout.h"

@interface HSDFGDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource,
	UISearchBarDelegate
>{
	UISearchBar *_searchBar;
	
	HSSearchResultModel *_resultModel;
	
	NSString *_lastSearchText;
	
	NSArray *_searchArray;
	HSCommodityViewController *_commodityVC;
	
	 UITableView *_searchTableView;
}

@end

static const int kSizeNum = 10;

@implementation HSDFGDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self searchBarSetUp];
    // Do any additional setup after loading the view.
	_searchTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[self.view addSubview:_searchTableView];
	[_searchTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSCommodityTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSCommodityTableViewCell class])];
	[_searchTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
	
	_searchTableView.translatesAutoresizingMaskIntoConstraints = NO;
	NSDictionary *views = NSDictionaryOfVariableBindings(_searchTableView);
	NSString *heightVfl = @"V:|-0-[_searchTableView]-0-|";
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:nil views:views]];
	NSString *widthVfl = @"H:|-0-[_searchTableView]-0-|";
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:nil views:views]];
	_searchTableView.delegate = self;
	_searchTableView.dataSource = self;
	_searchTableView.tableFooterView = [[UIView alloc] init];
	__weak typeof(self) wself = self;
	[_searchTableView addLegendFooterWithRefreshingBlock:^{
		__strong typeof(wself) swself = wself;
		[swself searchRequest:swself->_lastSearchText page:(int)(swself->_searchArray.count/kSizeNum) + 1 size:kSizeNum isMore:YES];
	}];
	
	[self dataRequestWithWithCid:_model.cid size:1000 key: [HSPublic md5Str:[HSPublic getIPAddress:YES]] page:1];
	return;
	
	
//	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//	_commodityVC = [storyboard instantiateViewControllerWithIdentifier:@"commodityViewController"];
//	_commodityVC.cateID = _model.cid;
//	_commodityVC.aid = _model.aid;
//	self.title = _model.name;
//	[self addChildViewController:_commodityVC];
//	[_commodityVC didMoveToParentViewController:self];
//	[self.view addSubview:_commodityVC.view];
//	[self.view HS_edgeFillWithSubView:_commodityVC.view];
//	 __weak typeof(self) wself = self;
//	_commodityVC.cellSelectedBlock = ^(HSCommodtyItemModel *itemModel){
//		UIStoryboard *storyBorad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//		HSCommodityDetailViewController *detailVC = [storyBorad instantiateViewControllerWithIdentifier:NSStringFromClass([HSCommodityDetailViewController class])];
//		//detailVC.hidesBottomBarWhenPushed = YES;
//		detailVC.itemModel = itemModel;
//		[wself.navigationController pushViewController:detailVC animated:YES];
//	};
//	_commodityVC.suyuanDetailBlock = ^(HSCommodtyItemModel *itemModel){
//		UIStoryboard *storyBorad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//		HSSuyuanDetailViewController *detailVC = [storyBorad instantiateViewControllerWithIdentifier:NSStringFromClass([HSSuyuanDetailViewController class])];
//		detailVC.itemModel = itemModel;
//		[wself.navigationController pushViewController:detailVC animated:YES];
//		//[detailVC setInfo:itemModel];
//	};
//	//self.parentViewController.tabBarController.tabBar.hidden = YES;
//	self.navigationController.parentViewController.tabBarController.tabBar.hidden = YES;
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
#pragma mark  获取数据

- (void)dataRequestWithWithCid:(NSString *)cid size:(NSUInteger)size key:(NSString *)key page:(NSUInteger)page
{
	NSDictionary *parametersDic = @{kPostJsonKey:key,
									kPostJsonCid:cid,
									kPostJsonAid:[HSPublic controlNullString:_model.aid],
									kPostJsonSize:[NSNumber numberWithInteger:size],
									kPostJsonPage:[NSNumber numberWithInteger:page]};
	
	[self.httpRequestOperationManager POST:kGetItemsByCateURL parameters:[HSPublic apiPostParas:parametersDic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"JSON: %@/n %@", responseObject,[HSPublic dictionaryToJson:parametersDic]);
		[_searchTableView.footer endRefreshing];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		[_searchTableView.footer endRefreshing];
		NSString *str = (NSString *)operation.responseString;
		
		NSData *data =  [str dataUsingEncoding:NSUTF8StringEncoding];
		if (data == nil) {
			return ;
		}
		NSError *jsonError = nil;
		id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
		//        NSLog(@"!!!!%@",json);
		
		if ([json isKindOfClass:[NSDictionary class]] && jsonError == nil) {
			
			NSDictionary *jsonDic = (NSDictionary *)json;
			HSItemPageModel *pageModel = [[HSItemPageModel alloc] initWithDictionary:jsonDic error:nil];
			
			
				if ([pageModel.item_list count] > 0) {
					
					_searchArray = pageModel.item_list;
					
				}
				
			
			
			//[_commdityTableView reloadData];
			[_searchTableView reloadData];
			/// 防止请求完了 防止多次请求最后一次 后台数据增加后重置
			if (pageModel != nil && [pageModel.total intValue] <= _searchArray.count) {
				[_searchTableView.footer noticeNoMoreData];
			}
			else
			{
				[_searchTableView.footer resetNoMoreData];
			}
			
		}
		
	}];
	
}

#pragma mark -
#pragma mark  搜索框
- (void)searchBarSetUp
{
	UISearchBar *searchBar = [[UISearchBar alloc] init];
	//UITextField *searchBar = [[UITextField alloc] init];
	//searchBar.tintColor = kAPPTintColor;
	//searchBar.frame = CGRectMake(0, 0,1000, 24);
	searchBar.delegate = self;
	searchBar.returnKeyType = UIReturnKeySearch;
	searchBar.placeholder = @"输入关键字";
	UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
	[searchField setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
	_searchBar = searchBar;
	//self.navigationItem.titleView = searchBar;
	//searchBar.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"kdeviceToken"];
	
	UIView *main = [[UIView alloc] initWithFrame:CGRectZero];
	main.backgroundColor = [UIColor whiteColor];
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[btn setTitleColor:kAPPTintColor forState:UIControlStateNormal];
	
	
	btn.titleLabel.font = [UIFont systemFontOfSize:14];
	[btn setTitle:_model.name forState:UIControlStateNormal];
	
	
	btn.tag = 901;
	[main addSubview:btn];
	[main addSubview:searchBar];
	btn.translatesAutoresizingMaskIntoConstraints = NO;
	searchBar.translatesAutoresizingMaskIntoConstraints = NO;
	[main HS_centerYWithSubView:btn];
	[main HS_centerYWithSubView:searchBar];
	//[main HS_alignWithFirstView:btn secondView:main layoutAttribute:NSLayoutAttributeLeading constat:5];
	//[main HS_alignWithFirstView:searchBar secondView:main layoutAttribute:NSLayoutAttributeTrailing constat:0];
	//[main HS_dispacingWithFisrtView:btn fistatt:NSLayoutAttributeTrailing secondView:searchBar secondAtt:NSLayoutAttributeLeading constant:5];
	[searchBar HS_widthWithConstant:200];
	
	NSDictionary *views = NSDictionaryOfVariableBindings(btn,searchBar);
	NSString *widthVfl = @"H:|-8-[btn]-0-[searchBar]-8-|";
	[main addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:nil views:views]];

	[main HS_HeightWithConstant:30];
	[searchBar HS_HeightWithConstant:30];
	//[main addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:nil views:views]];
	//self.navigationItem.titleView = main;
	//[main HS_edgeFillWithSubView:btn];
	main.layer.masksToBounds = YES;
	main.layer.cornerRadius = 5;
	self.navigationItem.titleView = main;
	[btn layoutIfNeeded];
	
}




#pragma mark -
#pragma mark searchDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
	if (_searchBar.text.length < 1) {
		[self showHudWithText:@"关键字不能为空"];
		return;
	}
	
	_lastSearchText = _searchBar.text;
	[self searchRequest:_searchBar.text page:1 size:kSizeNum isMore:NO];
	
}

#pragma mark -
#pragma mark  搜索接口
- (void)searchRequest:(NSString *)keyWord page:(int)page size:(int)size isMore:(BOOL)isMore
{
	[self showhudLoadingWithText:nil isDimBackground:YES];
	NSDictionary *parametersDic = @{kPostJsonKey:[HSPublic md5Str:[HSPublic getIPAddress:YES]],
									kPostJsonPage:[NSNumber numberWithInt:page],
									kPostJsonSize:[NSNumber numberWithInt:size],
									kPostJsonKeyWord:keyWord,
									kPostJsonAid:[HSPublic controlNullString: _model.aid]
									};
	
	if (!_model.aid) {
		parametersDic = @{kPostJsonKey:[HSPublic md5Str:[HSPublic getIPAddress:YES]],
						  kPostJsonPage:[NSNumber numberWithInt:page],
						  kPostJsonSize:[NSNumber numberWithInt:size],
						  kPostJsonKeyWord:keyWord,
						  };
	}
	// 142346261  123456
	
	[self.httpRequestOperationManager POST:kGetSearchListURL parameters:[HSPublic apiPostParas:parametersDic] success:^(AFHTTPRequestOperation *operation, id responseObject) { /// 失败
		NSLog(@"success\n%@",operation.responseString);
		[self hiddenHudLoading];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"%s failed\n%@",__func__,operation.responseString);
		[self hiddenHudLoading];
		if (operation.responseData == nil) {
			[self showHudWithText:@"搜索失败"];
			return ;
		}
		NSError *jsonError = nil;
		id json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&jsonError];
		if (jsonError == nil && [json isKindOfClass:[NSDictionary class]]) {
			
			NSDictionary *tmpDic = (NSDictionary *)json;
			
			_resultModel = [[HSSearchResultModel alloc] initWithDictionary:tmpDic error:nil];
			if (page < _resultModel.totalPage.intValue) { /// 还可以上拉更多
				
			}
			else
			{
				[_searchTableView.footer noticeNoMoreData];
			}
			
			if (!isMore) { /// 不是加载更多
				_searchArray = _resultModel.item_list;
			}
			else
			{
				NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray:_searchArray];
				[tmp addObjectsFromArray:_resultModel.item_list];
				_searchArray = tmp;
			}
			
			[_searchTableView reloadData];
			
			
		}
	}];
	
}

#pragma mark-
#pragma mark tableView DataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (_searchArray.count == 0) {
		[self placeViewWithImgName:@"search_no_content" text:@"没有搜索内容"];
	}
	else
	{
		[self removePlaceView];
	}
	
	return _searchArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	HSCommodityTableViewCell *cell = (HSCommodityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSCommodityTableViewCell class])];
	
	if (cell == nil){
		cell = [[HSCommodityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HSCommodityTableViewCell"];
	}
	HSCommodtyItemModel *model = [_searchArray objectAtIndex:indexPath.row];
	[cell setData:model];
	typeof(self) wself = self;
	cell.suyuanDetailBlock = ^(HSCommodtyItemModel *itemModel){
		UIStoryboard *storyBorad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		HSSuyuanDetailViewController *detailVC = [storyBorad instantiateViewControllerWithIdentifier:NSStringFromClass([HSSuyuanDetailViewController class])];
		detailVC.itemModel = itemModel;
		detailVC.hidesBottomBarWhenPushed = true;
		[wself.navigationController pushViewController:detailVC animated:YES];
	};
	return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	HSCommodtyItemModel *itemModel = _searchArray[indexPath.row];
	
	UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	HSCommodityDetailViewController *detailVC = [board instantiateViewControllerWithIdentifier:NSStringFromClass([HSCommodityDetailViewController class])];
	detailVC.itemModel = itemModel;
	[self.navigationController pushViewController:detailVC animated:YES];
	
}


@end
