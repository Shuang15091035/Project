//
//  TestTableViewController.m
//  DesignFun
//
//  Created by qianfeng on 15/10/7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "DeatilTableViewController.h"
#import "MilitaryModel.h"
#import "ImageTableViewCell.h"
#import "MilitaryTableViewCell.h"
#import "TextTableViewCell.h"
#import "CacheManager.h"
#import "AutoScrollView.h"

@interface DeatilTableViewController (){
    
}

@property (nonatomic,copy) NSArray *picsListArr;

@property (nonatomic) NSMutableArray *photoArr;

@property (nonatomic) BOOL isRefreshing;
@property (nonatomic) BOOL isLoadingMore;

@end

@implementation DeatilTableViewController


- (id)init {
    if (self = [super init]) {
        [self refreshData:self.tableView];
        self.page = 0;
        self.dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.photoArr = [NSMutableArray array];
}

//#pragma mark - 刷新数据
- (void)refreshData:(UITableView *)tableview{
    __weak typeof(self)weakSelf = self;
    MJRefreshNormalHeader *headRefresh = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.page = 0;
        [weakSelf fetchAppDataFromNetwork];
    }];
    [self.tableView setHeader:headRefresh];
    
    MJRefreshAutoNormalFooter *footerRefresh = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.isLoadingMore) {
            return ;
        }
        weakSelf.isLoadingMore = YES;
        weakSelf.page++;
        [weakSelf fetchAppDataFromNetwork];
    }];
    self.tableView.footer = footerRefresh;
}

/**
 *  结束刷新
 */
- (void)endRefresh {
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.tableView.header endRefreshing];
    }
    if (self.isLoadingMore) {
        self.isLoadingMore = NO;
        [self.tableView.footer endRefreshing];
    }
}

- (void)createAutoScrollView {
    NSMutableArray *array = [NSMutableArray array];
    for (int index = 0; index < self.picsListArr.count; index++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        PicsList *picsList = self.picsListArr[index];
        [array addObject:[NSString stringWithFormat:cellUrl,(long)[picsList.picsId integerValue]]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:picsList.img] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.photoArr addObject:imageView.image];
            if (self.photoArr.count == self.picsListArr.count) {
                AutoScrollView *autoScrollView =[[AutoScrollView alloc] initWithFrame:CGRectMake(0, 0, screentWidth(), screentWidth()/2.0) imageArray:self.photoArr];
                autoScrollView.viewController = self.viewController;
                autoScrollView.urlArr         = array;
                
                self.tableView.tableHeaderView = autoScrollView;
            }
        }];
    }
}

#pragma mark -
#pragma mark 缓存

- (void)fetchAppData
{
    //首先从本地缓存中读取，如果没有缓存或者缓存实效，再从网络上抓取数据
//    [CacheManager clearDisk];
    if (![self fetchAppDataFromLocal]) {
        [self fetchAppDataFromNetwork];
    }
}

- (BOOL)fetchAppDataFromLocal
{
    if ([CacheManager isCacheDataInvalid:[self composeRequestUrl]]) {
        id respondData = [CacheManager readDataAtUrl:[self composeRequestUrl]];
        [self parseRespondData:respondData];
        [self.tableView reloadData];
        return YES;
    }
    return NO;
}


#pragma mark - networking

- (NSString *)composeRequestUrl {
    return [NSString stringWithFormat:COMMENT_DESIGNFUN_URL,self.testList,(long)self.page];
}

- (void)parseRespondData:(id)responseObject {
    MilitaryModel *militaryModel = [[MilitaryModel alloc]initWithData:responseObject error:nil];
    [self.dataSource addObjectsFromArray:militaryModel.newsList];
    if (militaryModel.picsList.count != 0) {
        self.picsListArr = militaryModel.picsList;
        [self createAutoScrollView];
    }
}

#pragma mark - 下载数据
- (void)fetchAppDataFromNetwork {
     NSString *url = [self composeRequestUrl];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (self.page == 0) {
                [self.dataSource removeAllObjects];
                [self.photoArr removeAllObjects];
                [CacheManager saveData:responseObject atUrl:[self composeRequestUrl]];
            }
            [self parseRespondData:responseObject];
            [self.tableView reloadData];
            [self endRefresh];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self endRefresh];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![[self.dataSource[indexPath.row] picOne]isEqualToString:@""] && [[self.dataSource[indexPath.row] picTwo]isEqualToString:@""] && [[self.dataSource[indexPath.row] picThr]isEqualToString:@""]) {
        MilitaryTableViewCell *cell = [MilitaryTableViewCell cellWithTableviewCell:tableView];
        cell.newsListModel = self.dataSource[indexPath.row];
        return cell;
    }else if (![[self.dataSource[indexPath.row] picOne]isEqualToString:@""] && ![[self.dataSource[indexPath.row] picTwo]isEqualToString:@""] && ![[self.dataSource[indexPath.row] picThr]isEqualToString:@""]){
        ImageTableViewCell *imageCell = [ImageTableViewCell cellWithTableviewCell:tableView];
        imageCell.newsListModel = self.dataSource[indexPath.row];
        return imageCell;
    }
    TextTableViewCell *textCell = [TextTableViewCell cellWithTableviewCell:tableView];
    textCell.newsListModel = self.dataSource[indexPath.row];
    
    return textCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![[self.dataSource[indexPath.row] picOne]isEqualToString:@""] && [[self.dataSource[indexPath.row] picTwo]isEqualToString:@""] && [[self.dataSource[indexPath.row] picThr]isEqualToString:@""]) {
        return 80;
    }else if (![[self.dataSource[indexPath.row] picOne]isEqualToString:@""] && ![[self.dataSource[indexPath.row] picTwo]isEqualToString:@""] && ![[self.dataSource[indexPath.row] picThr]isEqualToString:@""]){

        return 120;
    }
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    WebViewController *webViewController = [WebViewController new];
    NewsList *newsList = _dataSource[indexPath.row];
    webViewController.urlStr = [NSString stringWithFormat:cellUrl,(long)[newsList.newsId integerValue]];
    webViewController.aid = newsList.newsId;
    [self.viewController.navigationController pushViewController:webViewController animated:YES];
    
}

@end
