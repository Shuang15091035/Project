//
//  SquareController.m
//  DesignFun
//
//  Created by qianfeng on 15/10/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "SquareController.h"
#import "SquareCell.h"
#import "SquareModle.h"
#import "CommunityDetailController.h"

@interface SquareController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) BOOL isRefreshing;
@property (nonatomic) BOOL isLoadingMore;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation SquareController

- (instancetype)init{
    self = [super init];
    if (self) {
        _dataSource = [NSMutableArray array];
        self.page = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self createTableView];
}
- (void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screentWidth(), TableViewH) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[SquareCell class] forCellReuseIdentifier:@"Square"];
    [self.view addSubview: self.tableView];
    [self refreshData:self.tableView];
}

#pragma mark -
#pragma mark - 刷新数据
- (void)refreshData:(UITableView *)tableview{
    __weak typeof(self)weakSelf = self;
    MJRefreshNormalHeader *headRefresh = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.page = 0;
        [weakSelf loadingDataFromNetWork];
    }];
    self.tableView.header = headRefresh;
    
    MJRefreshAutoNormalFooter *footerRefresh = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.isLoadingMore) {
            return ;
        }
        weakSelf.isLoadingMore = YES;
        weakSelf.page++;
        [weakSelf loadingDataFromNetWork];
    }];
    self.tableView.footer = footerRefresh;
}

#pragma mark -
#pragma mark - 结束刷新

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
#pragma mark -
#pragma mark 缓存

- (void)fetchAppData
{
    //首先从本地缓存中读取，如果没有缓存或者缓存实效，再从网络上抓取数据
    //        [CacheManager clearDisk];
    if (![self fetchAppDataFromLocal]) {
        [self loadingDataFromNetWork];
    }
}

#pragma mark -
#pragma mark - 本地获取数据
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


#pragma mark -
#pragma mark - networking
- (NSString *)composeRequestUrl {
    return [NSString stringWithFormat:self.typeName,(long)self.page];
}

#pragma mark -
#pragma makr - 解析数据
- (void)parseRespondData:(id)responseObject {
    SquareModle *squareModel = [[SquareModle alloc]initWithData:responseObject error:nil];
    [self.dataSource addObjectsFromArray:squareModel.newsList];
}

#pragma mark -
#pragma mark - 下载数据
- (void)loadingDataFromNetWork {
    NSString *url = [self composeRequestUrl];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.page == 0) {
            [self.dataSource removeAllObjects];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SquareCell *squareCell = [tableView dequeueReusableCellWithIdentifier:@"Square" forIndexPath:indexPath];
    [squareCell updateDataSquareCell:self.dataSource[indexPath.row]];
    return squareCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SquareNews *squareNew = self.dataSource[indexPath.row];
    
    CGFloat contentLabelH = [squareNew.title sizeWithFont:[UIFont boldSystemFontOfSize:15] maxSize:CGSizeMake(screentWidth()-20, MAXFLOAT)].height;
    
    CGFloat contentH = [squareNew.newsAbstract sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(screentWidth()-20, MAXFLOAT)].height;
    return contentH + contentLabelH + 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SquareNews *squareNew = self.dataSource[indexPath.row];
    CommunityDetailController *communityDetail = [[CommunityDetailController alloc]init];
    communityDetail.detailId = squareNew.tid;
    communityDetail.detailFid = squareNew.fid;
    communityDetail.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:communityDetail animated:YES];
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

@end
