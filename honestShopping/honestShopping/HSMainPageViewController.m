//
//  HSMainPageViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-3-16.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSMainPageViewController.h"
#import "HSHomeViewController.h"
#import "HSCommodityViewController.h"
#import "HSCommodityDetailViewController.h"
#import "HSSanpinViewController.h"
#import "HSSearchViewController.h"
#import "HSDFGViewController.h"
#import "HSDFGDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "HSSuyuanDetailViewController.h"

#import "HSCommodityCategaryCollectionViewCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "FFScrollView.h"
#import "HSContentCollectionViewCell.h"

#import "HSCategariesModel.h"
#import "HSBannerModel.h"
#import "HSItemPageModel.h"
#import "HSCommodtyItemModel.h"
#import "HSSearchListItemModel.h"

@interface HSMainPageViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UISearchBarDelegate>
{
    /// 类别数组
    NSArray *_categariesArray;
    
    /// 保存不同类别的item
    NSMutableDictionary *_cateItemsDataDic;
    
    /// 选中的类别
    NSIndexPath *_selectedCategary;
    
    /// 三品一标
    HSSanpinViewController *_sanpinViewController;
	
	/// 地方馆
	HSDFGViewController *_dfgViewController;
    
    /// 首页 热销
    HSHomeViewController *_homeViewController;
    
    /// 顶部滚动高度约束
    NSLayoutConstraint *_ffScrollViewHeightConstraint;
	
	NSArray *_searchList;
    
}

@property (weak, nonatomic) IBOutlet UICollectionView *topCategariesCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;

@end

@implementation HSMainPageViewController

static NSString *const kCategariesCollectionViewCellIdentifier = @"CommodityCellIdentifier";

static NSString *const kContentCollectionViewIdentifier = @"contentCollectionViewIdentifier";

static const int kContentViewTag = 1000;

static const int kCateCollectionViewHei = 85;

static const int kcateCellWidth = 70;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [self setUpNavBar];
    
    [_topCategariesCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HSCommodityCategaryCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCategariesCollectionViewCellIdentifier];
    _topCategariesCollectionView.delegate = self;
    _topCategariesCollectionView.dataSource = self;
    
    
    [_contentCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HSContentCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kContentCollectionViewIdentifier];
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    _contentCollectionView.pagingEnabled = YES;
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.showsVerticalScrollIndicator = NO;
   
    _cateItemsDataDic = [[NSMutableDictionary alloc] init];
    _selectedCategary = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _sanpinViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HSSanpinViewController class])];
    _homeViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HSHomeViewController class])];
	_dfgViewController = [[HSDFGViewController alloc] init];
    
    [self getCommofityCategaries:nil];
	[self searchListDataRequest];
	
	//self.hidesBottomBarWhenPushed = YES;
	
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.translucent = YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = kAPPTintColor;
    self.navigationController.navigationBar.translucent = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
	
}

#pragma mark -
#pragma mark 导航栏
- (void)setUpNavBar
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    imgView.image = [UIImage imageNamed:@"icon_navLeft70x30"];
    [imgView sizeToFit];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:imgView];
    self.navigationItem.leftBarButtonItem = leftItem;

    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame)-imgView.image.size.width-60, 30)]; //
    searchBar.showsCancelButton = NO;
    searchBar.delegate = self;
    searchBar.placeholder = @"诚信品牌，放心选购";
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    self.navigationItem.rightBarButtonItem = barItem;
    
}


- (void)setViewControllers:(NSArray *)viewControllers
{
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.view superview] == self.view) {
            [obj.view removeFromSuperview];
        }

        if ([obj parentViewController] == self) {
            [obj willMoveToParentViewController:nil];
            [obj removeFromParentViewController];

        }
        
    }];
    
    _viewControllers = viewControllers;
    
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        
            [self addChildViewController:obj];
            [obj didMoveToParentViewController:self];
    }];

}

- (void)commodityViewControllersAddChild:(NSUInteger)num
{
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    
    for (int j= 0; j<num; j++) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HSCommodityViewController *commodityViewController = [storyboard instantiateViewControllerWithIdentifier:@"commodityViewController"];
        
        HSCategariesModel *cateModel = _categariesArray[j];
		commodityViewController.cateID = cateModel.id;
        [tmp addObject:commodityViewController];

    }
     [self setViewControllers:tmp];
}

- (void)sanpinLayout
{
    
    UIView *commodityView = _sanpinViewController.view;
    [self.view addSubview:commodityView];
    commodityView.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *vfl1 = @"H:|[commodityView]|";
    NSString *vfl2 = @"V:[_topCategariesCollectionView][commodityView]|";
    NSDictionary *dic = NSDictionaryOfVariableBindings(_topCategariesCollectionView,commodityView,self.view);
    NSArray *arr1 = [NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:nil views:dic];
    NSArray *arr2 = [NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:nil views:dic];
    [self.view addConstraints:arr1];
    [self.view addConstraints:arr2];
    
    commodityView.hidden = YES;
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


#pragma  mark collectionView dataSource and delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count =_categariesArray.count == 0 ? _categariesArray.count : _categariesArray.count;
    return count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HSCategariesModel *model = nil;
//    if (indexPath.row < _categariesArray.count + 1 && indexPath.row > 0) {
//        model = _categariesArray[indexPath.row-1];
//    }
	model = _categariesArray[indexPath.row];
    
    if (collectionView == _contentCollectionView) {
        
        HSContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kContentCollectionViewIdentifier forIndexPath:indexPath];
        
        if (indexPath.row == 0) { // 热销
            UIView *subView = [cell.contentView viewWithTag:kContentViewTag];
            if (subView != nil ) {
                [subView removeFromSuperview];
            }
            UIView *sView = _homeViewController.view;
            sView.tag = kContentViewTag;
            sView.frame =cell.contentView.bounds;
            [cell.contentView addSubview:sView];
            
            ///push 到商品详情
            __weak typeof(self) wself = self;
            _homeViewController.cellSelectedBlock = ^(HSCommodtyItemModel *itemModel){
                UIStoryboard *storyBorad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                HSCommodityDetailViewController *detailVC = [storyBorad instantiateViewControllerWithIdentifier:NSStringFromClass([HSCommodityDetailViewController class])];
                //detailVC.hidesBottomBarWhenPushed = YES;
                detailVC.itemModel = itemModel;
                [wself.navigationController pushViewController:detailVC animated:YES];
            };

        }
        else if (indexPath.row == _categariesArray.count-1) { /// 地方馆
            
            UIView *subView = [cell.contentView viewWithTag:kContentViewTag];
            if (subView != nil ) {
                [subView removeFromSuperview];
            }
            UIView *sView =  _dfgViewController.view;
            sView.tag = kContentViewTag;
            sView.frame =cell.contentView.bounds;
            [cell.contentView addSubview:sView];
            ///push 到商品详情
            __weak typeof(self) wself = self;
            _dfgViewController.cellSelectedBlock = ^(HSDFGModel *itemModel){
                
                //__strong typeof(wself) swself = wself;
				HSDFGDetailViewController *detailVC = [[HSDFGDetailViewController alloc] init];
                detailVC.model = itemModel;
				detailVC.hidesBottomBarWhenPushed = true;
                [wself.navigationController pushViewController:detailVC animated:YES];
            };

        }
        else
        {
            
           // HSCommodityViewController *commodityVC = _viewControllers[indexPath.row-1];
			HSCommodityViewController *commodityVC = _viewControllers[indexPath.row];
            UIView *subView = [cell.contentView viewWithTag:kContentViewTag];
            if (subView != nil ) {
                [subView removeFromSuperview];
            }
            UIView *sView = commodityVC.view;
            sView.tag = kContentViewTag;
            sView.frame =cell.contentView.bounds;
            [cell.contentView addSubview:sView];
            
            ///push 到商品详情
            __weak typeof(self) wself = self;
            commodityVC.cellSelectedBlock = ^(HSCommodtyItemModel *itemModel){
                UIStoryboard *storyBorad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                HSCommodityDetailViewController *detailVC = [storyBorad instantiateViewControllerWithIdentifier:NSStringFromClass([HSCommodityDetailViewController class])];
                //detailVC.hidesBottomBarWhenPushed = YES;
                detailVC.itemModel = itemModel;
                [wself.navigationController pushViewController:detailVC animated:YES];
            };
			commodityVC.suyuanDetailBlock = ^(HSCommodtyItemModel *itemModel){
				UIStoryboard *storyBorad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
				HSSuyuanDetailViewController *detailVC = [storyBorad instantiateViewControllerWithIdentifier:NSStringFromClass([HSSuyuanDetailViewController class])];
				detailVC.itemModel = itemModel;
				detailVC.hidesBottomBarWhenPushed = true;
				[wself.navigationController pushViewController:detailVC animated:YES];
				//[detailVC setInfo:itemModel];
			};
            
        }
        
        return cell;
    }
    else
    {
        
        HSCommodityCategaryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCategariesCollectionViewCellIdentifier forIndexPath:indexPath];
        
        if ([indexPath isEqual:_selectedCategary]) {
            [cell changeTitleColorAndFont:YES];
        }
        else
        {
            [cell changeTitleColorAndFont:NO];
        }
        
        if (indexPath.row == 0) {
			cell.categaryTitleLabel.text = model.name;//@"热销";
			[cell.cateImgView sd_setImageWithURL:[NSURL URLWithString:model.item_img]];
        }
        else if (indexPath.row == _categariesArray.count + 1) {
            cell.categaryTitleLabel.text = @"三品一标";
        }
        else
        {
            cell.categaryTitleLabel.text = model.name;
			[cell.cateImgView sd_setImageWithURL:[NSURL URLWithString:model.item_img]];
        }
        
        return cell;
    }
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _contentCollectionView) {
        return NO;
    }
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_selectedCategary isEqual:indexPath]) {
        return;
    }
    NSIndexPath *tmp = _selectedCategary;
    _selectedCategary = indexPath;
    [collectionView reloadItemsAtIndexPaths:@[tmp]];
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    [collectionView scrollToItemAtIndexPath:_selectedCategary atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    // 是否相邻
    BOOL isNear = fabs(tmp.row - indexPath.row) == 1 ? YES : NO;
    [_contentCollectionView scrollToItemAtIndexPath:_selectedCategary atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:isNear];
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _contentCollectionView) {
        
        NSLog(@"");
        return _contentCollectionView.frame.size;
    }
    
    return CGSizeMake(70, kCateCollectionViewHei);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _contentCollectionView) {
        
      
        int page = _contentCollectionView.contentOffset.x / CGRectGetWidth(_contentCollectionView.frame);
        
          NSLog(@"%d",page);
        NSIndexPath *index = [NSIndexPath indexPathForRow:page inSection:0];
        if ([index isEqual:_selectedCategary]) {
            return;
        }
        
        [_topCategariesCollectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        NSIndexPath *tmp = _selectedCategary;
        _selectedCategary = index;
        
        [_topCategariesCollectionView reloadItemsAtIndexPaths:@[tmp,index]];
        
        }
}

#pragma mark -
#pragma mark
- (void)reloadRequestData
{
    [super reloadRequestData];
    [self getCommofityCategaries:nil];
}

#pragma mark -
#pragma mark 获取数据

- (void)getCommofityCategaries:(NSString *)key
{
    [self showNetLoadingView];
   
    NSDictionary *parametersDic = @{@"key":[HSPublic md5Str:[HSPublic getIPAddress:YES]]};
    
    [self.httpRequestOperationManager POST:kGetCateURL parameters:[HSPublic apiPostParas:parametersDic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self showReqeustFailedMsg];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        NSString *str = (NSString *)operation.responseString;
		NSLog(@"kGetCateURL!!!!%@",str);
        if (str.length <= 1) {
            [self hiddenMsg];
            [self getCommofityCategaries:key];
            return ;
        }
        NSString *result = [str substringFromIndex:1];
        
        NSData *data =  [result dataUsingEncoding:NSUTF8StringEncoding];
        if (data == nil) {
            [self hiddenMsg];
            [self getCommofityCategaries:key];
            return ;
        }
        [self hiddenMsg];
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
		
        if ([json isKindOfClass:[NSArray class]] && jsonError == nil) {
            
            NSArray *jsonArray = (NSArray *)json;
            
            NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
			
            [jsonArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                
                HSCategariesModel *model = [[HSCategariesModel alloc] initWithDictionary:obj error:nil];
				[tmpArray addObject:model];
				/*
                if (![model.name isEqualToString:@"热销"]) { ///去除热销
                    [tmpArray addObject:model];
                }
				 */
				
				if ([model.name isEqualToString:@"地方馆"]) {
					_dfgViewController.cid = model.id;
				}
    
            }];
			
			CALayer *TopBorder = [CALayer layer];
			TopBorder.frame = CGRectMake(0.0f,_topCategariesCollectionView.frame.size.height-0.5f, kcateCellWidth*jsonArray.count, 0.5f);
			TopBorder.backgroundColor =kAPPTintColor.CGColor;
			[_topCategariesCollectionView.layer addSublayer:TopBorder];
			
            _categariesArray = tmpArray;
            [self commodityViewControllersAddChild:tmpArray.count];//去除热销和地方馆
            [_topCategariesCollectionView reloadData];
            [_contentCollectionView reloadData];
        }
    }];

}

#pragma mark -
#pragma mark  搜索地域信息列表(搜索栏目条件)
- (void)searchListDataRequest
{

	NSDictionary *parametersDic = @{kPostJsonKey:[HSPublic md5Str:[HSPublic getIPAddress:YES]],
									};
	// 142346261  123456
	
	[self.httpRequestOperationManager POST:kGetSearchListAddrURL parameters:[HSPublic apiPostParas:parametersDic] success:^(AFHTTPRequestOperation *operation, id responseObject) { /// 失败
		NSLog(@"success\n%@",operation.responseString);
		
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"%s failed\n%@",__func__,operation.responseString);
		
		if (operation.responseData == nil) {
			
			return ;
		}
		NSError *jsonError = nil;
		id json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&jsonError];
		if (jsonError == nil && [json isKindOfClass:[NSArray class]]) {
			
			NSArray *jsonArr = (NSArray *)json;
			NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithCapacity:jsonArr.count];
			
			[jsonArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
				HSSearchListItemModel *model = [[HSSearchListItemModel alloc] initWithDictionary:obj error:nil];
				[tmpArr addObject:model];
			}];
			_searchList = tmpArr;
			
		}
	}];
	
}

#pragma mark - 
#pragma mark searchBar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"%s",__func__);
	UIStoryboard *storyBorad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	HSSearchViewController *detailVC = [storyBorad instantiateViewControllerWithIdentifier:NSStringFromClass([HSSearchViewController class])];
	detailVC.searchList = _searchList;
	[self.navigationController pushViewController:detailVC animated:YES];
    //[self pushViewControllerWithIdentifer:NSStringFromClass([HSSearchViewController class])];
    return NO;
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
   
}

//test
- (void)testAES {
    
    return;
    
    
    
    NSDictionary *parametersDic = @{@"uid":@18430,
                          @"orderId":@"201608120941453167A",
                          @"price":@"200",
                          @"sessionCode":@"3D99DAE4-FA4A-E1D3-B101-BF3BD6517CB9",
                          @"key":@"f528764d624db129b32c21fbca0cb8d6"
                          };
    
    
    [self.httpRequestOperationManager POST:kUpdateOrderNextURL/*kGetCateURL"http://wx.jshuabo.com:9013/index.php?g=api&m=Item&a=getCate"*/ parameters:[HSPublic apiPostParas:parametersDic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self showReqeustFailedMsg];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *str = (NSString *)operation.responseString;
         NSLog(@"success!!!!!: %@", str);
    }];

}

- (void)resetCate{
	NSIndexPath *tmp = _selectedCategary;

	_selectedCategary = [NSIndexPath indexPathForRow:0 inSection:0];;
	[_topCategariesCollectionView reloadItemsAtIndexPaths:@[tmp]];
	[_topCategariesCollectionView reloadItemsAtIndexPaths:@[_selectedCategary]];
	
	[_topCategariesCollectionView scrollToItemAtIndexPath:_selectedCategary atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
	// 是否相邻
	BOOL isNear = fabs(tmp.row - _selectedCategary.row) == 1 ? YES : NO;
	[_contentCollectionView scrollToItemAtIndexPath:_selectedCategary atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:isNear];
	
}

@end
