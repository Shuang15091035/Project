
//
//  CommunityDetailController.m
//  DesignFun
//
//  Created by qianfeng on 15/10/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CommunityDetailController.h"
#import "CommunityDetailModel.h"
#import "CommunityAllCommentModel.h"
#import "CommunityDetailCell.h"

@interface CommunityDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) BOOL isRefreshing;
@property (nonatomic) BOOL isLoadingMore;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger list;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *allCommentArr;
@end

@implementation CommunityDetailController{
    BOOL EXEONCE;
}

- (NSMutableArray *)dataSource{

    if (!_dataSource) {
        _dataSource = [NSMutableArray array ];
    }
    return _dataSource;
}
- (NSMutableArray *)allCommentArr{
    if (!_allCommentArr) {
        _allCommentArr = [NSMutableArray array ];
    }
    return _allCommentArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTableView];
    [self loadingDataFromNetWork];
    [self loadingCommentFromNetWork];
}
- (void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, screentWidth(), screenHeight()-10) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[CommunityDetailCell class] forCellReuseIdentifier:@"CommunityDetailCell"];
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
        weakSelf.list = 1;
        weakSelf.page = 0;
        [weakSelf loadingDataFromNetWork];
    }];
    self.tableView.header = headRefresh;
    
    MJRefreshAutoNormalFooter *footerRefresh = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.isLoadingMore) {
            return ;
        }
        weakSelf.isLoadingMore = YES;
        weakSelf.list++;
        [weakSelf loadingCommentFromNetWork];
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
#pragma mark - networking
- (NSString *)composeRequestUrl {
    return [NSString stringWithFormat:CommentDetailUrl,self.detailId,self.detailFid,self.page];
}
- (NSString *)composeAllCommentURl{
    return [NSString stringWithFormat:CommunityAllCommentUrl,self.detailId,self.detailFid,self.list];
}
#pragma mark -
#pragma makr - 解析数据

- (void)parseRespondCommentData:(id)responseObject {
    CommunityAllCommentModel *allCommentModel = [[CommunityAllCommentModel alloc]initWithData:responseObject error:nil];
    
    [self.dataSource addObjectsFromArray:allCommentModel.commentList];
}
- (void)parseRespondData:(id)responseObject {
    CommunityDetailModel *commentDetailModel = [[CommunityDetailModel alloc]initWithData:responseObject error:nil];
    [self.allCommentArr addObject:commentDetailModel];
    
}


#pragma mark -
#pragma mark - 下载数据

#pragma mark - 加载更多评论
- (void)loadingCommentFromNetWork{

    NSString *url = [self composeAllCommentURl];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.list == 0) {
            [self.dataSource removeAllObjects];
        }
        [self parseRespondCommentData:responseObject];
        
        if (self.dataSource.count == 0) {
            [IanAlert alertError:@"暂无评论" length:1.0];
        }
        
        [self.tableView reloadData];
        [self endRefresh];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

}
#pragma mark - 加载头部的数据
- (void)loadingDataFromNetWork {
    NSString *url = [self composeRequestUrl];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self parseRespondData:responseObject];
        
        self.tableView.tableHeaderView = [self tableviewHeadViewWead];
        
        [self endRefresh];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (UIView *)tableviewHeadViewWead{
    CommunityDetailModel *commentDetailModel = [self.allCommentArr firstObject];
    UIView *headView = [UIView new];
    CGFloat margin = 10;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(margin, margin, 40, 40)];
    imageView.layer.cornerRadius = 10;
    imageView.clipsToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:commentDetailModel.userImg]];
    [headView addSubview:imageView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor blueColor];
    titleLabel.text = commentDetailModel.author;
    titleLabel.frame = CGRectMake(maxX(imageView)+margin, midY(imageView)-10, 200, 20);
    [headView addSubview:titleLabel];
    
    CGFloat contentLabelH = [commentDetailModel.webContent sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(screentWidth()-20, MAXFLOAT)].height;
    UILabel *contentLabel = [UILabel new];
    contentLabel.frame = CGRectMake(margin, maxY(imageView), screentWidth()-20, contentLabelH);
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.text = commentDetailModel.webContent;
    [headView addSubview:contentLabel];
    
    headView.frame = CGRectMake(0, 0, screentWidth()- 2*margin, contentLabelH + 20+ height(imageView.frame));
    headView.backgroundColor = [UIColor whiteColor];
    
    return headView;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
       return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CommunityDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"CommunityDetailCell"];
    detailCell.selectionStyle =  UITableViewCellSelectionStyleNone;
    detailCell.detailModel = self.dataSource[indexPath.row];

    return detailCell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *sectionOneTitle = [UILabel new];
    sectionOneTitle.backgroundColor = [UIColor lightGrayColor];
    sectionOneTitle.font = [UIFont systemFontOfSize:16];
    sectionOneTitle.text = @"全部评论" ;
    return sectionOneTitle;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailHotComment *detailHot = self.dataSource[indexPath.row];

    CGFloat contentH = [detailHot.content sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(screentWidth()-20,MAXFLOAT)].height;
    return 90 + contentH;
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
