//
//  DFCommunityController.m
//  DesignFun
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "DFPictureController.h"
#import "DFPictureModel.h"
#import "OneImageCell.h"
#import "LeftImageCell.h"
#import "RightImageCell.h"
#import "DFPictureDetailController.h"

#define TableViewHeight height(self.view.frame)-49-64

@interface DFPictureController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) BOOL isRefreshing;
@property (nonatomic) BOOL isLoadingMore;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation DFPictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTableView];
    [self fetchAppData];
}
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)createTableView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screentWidth(), TableViewHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OneImageCell" bundle:nil] forCellReuseIdentifier:@"OneImageCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftImageCell" bundle:nil] forCellReuseIdentifier:@"LeftImageCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RightImageCell" bundle:nil] forCellReuseIdentifier:@"RightImageCell"];
    
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
        weakSelf.page = 1;
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
    
    return [NSString stringWithFormat:DFPictureURl,(long)self.page];
}

#pragma mark -
#pragma makr - 解析数据
- (void)parseRespondData:(id)responseObject {
    DFPictureModel *pictureModel = [[DFPictureModel alloc]initWithData:responseObject error:nil];
    [self.dataSource addObjectsFromArray:pictureModel.imglist];
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
    
    DFImage *image = self.dataSource[indexPath.row];
    
    if([image.imgSum integerValue] == 3){
        if (indexPath.row %2 == 0 && indexPath.row%4 != 0) {
            LeftImageCell *leftCell = [tableView dequeueReusableCellWithIdentifier:@"LeftImageCell" forIndexPath:indexPath];
            [leftCell updateOneCellData:image];
            return leftCell;
        }else{
            RightImageCell *rightCell = [tableView dequeueReusableCellWithIdentifier:@"RightImageCell" forIndexPath:indexPath];
            [rightCell updateOneCellData:image];
            return rightCell;
        }
    }
    OneImageCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"OneImageCell" forIndexPath:indexPath];
    [oneCell updateOneCellData:image];
    return oneCell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 250;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    DFImage *image = self.dataSource[indexPath.row];
    DFPictureDetailController *pictureController = [[DFPictureDetailController alloc]init];
    pictureController.titleName = image.title;
    pictureController.pageId = image.id;
    pictureController.dfImage = image;
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:pictureController animated:YES];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
@end




