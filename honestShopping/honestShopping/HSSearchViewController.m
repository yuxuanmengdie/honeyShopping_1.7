//
//  HSSearchViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-5-2.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSSearchViewController.h"
#import "HSSearchResultModel.h"
#import "HSCommodityViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "HSCommodityCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "HSCommodityDetailViewController.h"
#import "HSCommodityTableViewCell.h"
#import "UIView+HSLayout.h"
#import "HSSearchListItemModel.h"
#import "HSSuyuanDetailViewController.h"


@interface HSSearchViewController ()<UISearchBarDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
CHTCollectionViewDelegateWaterfallLayout,
UITableViewDelegate,
UITableViewDataSource,
UIPickerViewDelegate,
UIPickerViewDataSource>
{
    UISearchBar *_searchBar;
    
    HSSearchResultModel *_resultModel;
    
    NSString *_lastSearchText;
    
    NSArray *_searchArray;
    
    HSCommodityCollectionViewCell *_sizeCell;
	
	UIButton *_aidBtn;
	
	NSString *_aid;
	
	UIPickerView *_pickView;
	
	UIView *_bcView;
}

@property (weak, nonatomic) IBOutlet UICollectionView *searchCollectionView;

@property (strong, nonatomic) UITableView *searchTableView;


//@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
//
//@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation HSSearchViewController

static NSString *const kCommodityCellIndentifier = @"CommodityCellIndentifier";

static const int kSizeNum = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self searchBarSetUp];
	
    //[self searchCollectViewLayout];
    [self setNavBarRightBarWithTitle:@"    " action:nil];
	
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
	
	HSSearchListItemModel *model = [[HSSearchListItemModel alloc] init];
	model.id = @"";
	model.name = @"全部";
	
	if (!_searchList) {
		NSArray *tmp = @[model];
		_searchList = tmp;
	}else{
		NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray:_searchList];
		[tmp insertObject:model atIndex:0];
		_searchList = tmp;
	};
	
	[self pickViewInit];
}


- (void)pickViewInit{
	UIView *bcView = [[UIView alloc] initWithFrame:CGRectZero];
	bcView.backgroundColor = [UIColor blackColor];
	bcView.alpha = 0.6;
	[self.view addSubview:bcView];
	[self.view HS_edgeFillWithSubView:bcView];
	
	
	UIPickerView *pickView = [[UIPickerView alloc]initWithFrame:self.view.frame];
	pickView.backgroundColor = [UIColor whiteColor];
	//pickView.alpha = 0.9;
	pickView.delegate = self;
	pickView.dataSource = self;
	[self.view addSubview:pickView];
	pickView.translatesAutoresizingMaskIntoConstraints = NO;
	NSDictionary *views = NSDictionaryOfVariableBindings(pickView);
	NSString *heightVfl = @"V:[pickView(240)]-0-|";
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:nil views:views]];
	NSString *widthVfl = @"H:|-0-[pickView]-0-|";
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:nil views:views]];
	pickView.hidden = YES;
	bcView.hidden = YES;
	
	_pickView = pickView;
	_bcView = bcView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_searchBar becomeFirstResponder];
}


- (void)searchCollectViewLayout
{
    [_searchCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HSCommodityCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCommodityCellIndentifier];
        _searchCollectionView.dataSource = self;
    _searchCollectionView.delegate = self;
    
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.headerHeight = 0;
    layout.footerHeight = 0;
    layout.minimumColumnSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.columnCount = 2;
    _searchCollectionView.collectionViewLayout = layout;

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
	btn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
	_aidBtn = btn;
	[btn setTitleColor:kAPPTintColor forState:UIControlStateNormal];
	[btn setImage:[UIImage imageNamed:@"select_down"] forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(aidSelect:) forControlEvents:UIControlEventTouchUpInside];
	btn.titleLabel.font = [UIFont systemFontOfSize:14];
	[btn setTitle:@"全部" forState:UIControlStateNormal];
	
	_pickView.hidden = true;
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
	NSString *heightVfl = @"V:|-0-[searchBar]-0-|";
	[main HS_HeightWithConstant:30];
	[searchBar HS_HeightWithConstant:30];
	//[main addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:nil views:views]];
	//self.navigationItem.titleView = main;
	//[main HS_edgeFillWithSubView:btn];
	main.layer.masksToBounds = YES;
	main.layer.cornerRadius = 5;
	self.navigationItem.titleView = main;
	[btn layoutIfNeeded];
	_aidBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 32, 0, -32);
	_aidBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 16);
}

-(void)aidSelect:(id)sender{
	[_searchBar resignFirstResponder];
	_pickView.hidden = NO;
	_bcView.hidden = NO;
	[self.view bringSubviewToFront:_bcView];
	[self.view bringSubviewToFront:_pickView];
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
									kPostJsonAid:[HSPublic controlNullString:_aid]
                                    };
	
	if (!_aid) {
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
                __weak typeof(self) wself = self;
                [_searchTableView addLegendFooterWithRefreshingBlock:^{
                    __strong typeof(wself) swself = wself;
                    [swself searchRequest:swself->_lastSearchText page:(int)(swself->_searchArray.count/kSizeNum) + 1 size:kSizeNum isMore:YES];
                }];
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

#pragma mark -
#pragma  mark pickerView dataSource and delegate
// 返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

// 返回每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return _searchList.count;
};

// 返回每行的标题
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	HSSearchListItemModel *model = _searchList[row];
	return model.name;
}

// 选中行显示在label上
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	HSSearchListItemModel *model = _searchList[row];
	_aid = model.id;
	[_aidBtn setTitle:model.name forState:UIControlStateNormal];
	[_aidBtn layoutIfNeeded];
	_aidBtn.imageEdgeInsets = UIEdgeInsetsMake(0, _aidBtn.titleLabel.frame.size.width + 2.5, 0, -_aidBtn.titleLabel.frame.size.width - 2.5);
	_aidBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_aidBtn.currentImage.size.width, 0, _aidBtn.currentImage.size.width);
	_pickView.hidden = true;
	_bcView.hidden = true;
}


#pragma mark -
#pragma  mark collectionView dataSource and delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_searchArray.count == 0) {
        [self placeViewWithImgName:@"search_no_content" text:@"没有搜索内容"];
    }
    else
    {
        [self removePlaceView];
    }
    
    return _searchArray.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HSCommodityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommodityCellIndentifier forIndexPath:indexPath];
    HSCommodtyItemModel *itemModel = _searchArray[indexPath.row];
    //    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageHeaderURL,itemModel.img]]];
    cell.imgView.image = nil;
    [cell dataSetUpWithModel:itemModel];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageHeaderURL,itemModel.img]] placeholderImage:kPlaceholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            // do something with image
            
            NSValue *imgSize =  [NSValue valueWithCGSize:image.size];
            NSDictionary *dic = [self.imageSizeDic objectForKey:[self keyFromIndex:indexPath]];
            if (dic != nil ) {
                NSURL *imgURL = dic[kImageURLKey];
                NSValue *sizeValue = dic[kImageSizeKey];
                if ([imgURL isEqual:imageURL] && [sizeValue isEqual:imgSize]) {
                    return ;
                }
            }
            
            NSDictionary *tmpDic = @{kImageSizeKey:imgSize,
                                     kImageURLKey:imageURL};
            
            [self.imageSizeDic setObject:tmpDic forKey:[self keyFromIndex:indexPath]];
            if (collectionView.dataSource != nil) {
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        }

    }];
        
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HSCommodtyItemModel *itemModel = _searchArray[indexPath.row];
    if (_sizeCell == nil) {
        _sizeCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HSCommodityCollectionViewCell class]) owner:nil options:nil] firstObject];//;[[HSCommodityCollectionViewCell alloc] init];
    }
    
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)collectionView.collectionViewLayout;
    CGRect rect = collectionView.bounds;
    rect.size.width -= layout.minimumColumnSpacing*(layout.columnCount-1) + layout.sectionInset.left + layout.sectionInset.right;
    rect.size.width /= 2.0;
    rect.size.height = INT16_MAX;
    _sizeCell.contentView.bounds = rect;
    _sizeCell.contentView.frame = rect;
    //    [_sizeCell.imgView  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageHeaderURL,itemModel.img]]];
    _sizeCell.titlelabel.preferredMaxLayoutWidth = rect.size.width-16;
    //    _sizeCell.priceLabel.preferredMaxLayoutWidth = 80;
    //    _sizeCell.oldPricelabel.preferredMaxLayoutWidth = 40;
    [_sizeCell dataSetUpWithModel:itemModel];
    [_sizeCell.contentView updateConstraintsIfNeeded];
    [_sizeCell.contentView layoutIfNeeded];
    
    CGSize size = [_sizeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    size.width = rect.size.width;
    NSDictionary *dic = [self.imageSizeDic objectForKey:[self keyFromIndex:indexPath]];
    if (dic != nil) {
        NSValue *sizeValue = dic[kImageSizeKey];
        CGSize imgSize = [sizeValue CGSizeValue];
        CGFloat hei = imgSize.width == 0 ? 0 :(((float)imgSize.height/imgSize.width)*rect.size.width);
        //        NSLog(@"imgsize = %@ hei=%f",NSStringFromCGSize(imgSize),hei);
        size.height += hei;
    }
    
    //    NSLog(@"rect=%@ %@", NSStringFromCGRect(rect),NSStringFromCGSize(size));
    return size;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    HSCommodtyItemModel *itemModel = _searchArray[indexPath.row];
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HSCommodityDetailViewController *detailVC = [board instantiateViewControllerWithIdentifier:NSStringFromClass([HSCommodityDetailViewController class])];
    detailVC.itemModel = itemModel;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_searchBar resignFirstResponder];
}
@end
