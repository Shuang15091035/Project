//
//  SettingViewController.m
//  DesignFun
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "SettingViewController.h"
#import "CacheManager.h"
#import "CollectionController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>{

    UITableView *_tableView;
}
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTabelView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden= NO;
    [_tableView reloadData];
    
}
- (void)createTabelView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screentWidth(), screenHeight()) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIImageView *imageVeiw = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screentWidth(), screenHeight()/2-50)];
    imageVeiw.image = [UIImage imageNamed:@"setting"];
    _tableView.tableHeaderView = imageVeiw;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"settingcell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (indexPath.row==0) {
        cell.textLabel.text = @"清除缓存";
        cell.detailTextLabel.text =  [NSString stringWithFormat:@"%.2fMB",[CacheManager cacheSize]];
    }
    if (indexPath.row==1) {
        cell.textLabel.text = @"收藏";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        [CacheManager clearDisk];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text =  [NSString stringWithFormat:@"%.2fMB",[CacheManager cacheSize]];
    }else if (indexPath.row == 1){
        CollectionController *collection = [CollectionController new];
        [self.navigationController pushViewController:collection animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}

@end
