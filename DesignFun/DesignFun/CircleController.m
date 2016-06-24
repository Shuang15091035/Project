//
//  CircleController.m
//  DesignFun
//
//  Created by qianfeng on 15/10/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CircleController.h"
#import "CircleModel.h"
#import "CircleCell.h"
#import "CircleDetailController.h"

@interface CircleController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) BOOL isRefreshing;
@property (nonatomic) BOOL isLoadingMore;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableIndexSet *indexSet;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@end

@implementation CircleController

- (instancetype)init{
    self = [super init];
    if (self) {
    _dataSource = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
}
- (NSMutableArray *)sectionArray{
    if (_sectionArray == nil) {
        _sectionArray = [NSMutableArray array ];
    }
    return _sectionArray;
}
- (NSMutableIndexSet *)indexSet{
    if (_indexSet == nil) {
        _indexSet = [NSMutableIndexSet indexSet];
    }
    return _indexSet;
}
- (void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screentWidth(), TableViewH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CircleCell" bundle:nil] forCellReuseIdentifier:@"circleCell"];
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
        [weakSelf loadingDataFromNetWork];
    }];
    self.tableView.header = headRefresh;
}

#pragma mark -
#pragma mark - 结束刷新

- (void)endRefresh {
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.tableView.header endRefreshing];
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
    return self.typeName;
}

#pragma mark -
#pragma makr - 解析数据
- (void)parseRespondData:(id)responseObject {
    CircleModel *circleModel = [[CircleModel alloc]initWithData:responseObject error:nil];
    [self.dataSource addObjectsFromArray:circleModel.list];
   
    for (CircleList *list in circleModel.list) {
        [self.indexSet addIndex:[list.groupid integerValue]];
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.indexSet.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    [self.indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSMutableArray *array1 = [NSMutableArray array];
        for (CircleList *list in self.dataSource) {
            if (idx == [list.groupid integerValue]) {
                [array1 addObject:list];
            }
        }
        [self.sectionArray addObject:array1];
    }];
    
    return [self.sectionArray[section] count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleCell *circleCell = [tableView dequeueReusableCellWithIdentifier:@"circleCell"];
    circleCell.circleList = self.sectionArray[indexPath.section][indexPath.row];
   
    return circleCell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    CircleList *list = [self.sectionArray[section] firstObject];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screentWidth(), 40)];
    label.backgroundColor = [UIColor lightGrayColor];
    label.text = list.groupname;
     return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CircleList *circleList = self.sectionArray[indexPath.section][indexPath.row];
    CircleDetailController *detailController = [CircleDetailController new];
    detailController.page = 0;
    detailController.fid = circleList.id;
    detailController.order = circleList.groupid;
    detailController.viewController = self.viewController;
    detailController.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:detailController animated:YES];
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
