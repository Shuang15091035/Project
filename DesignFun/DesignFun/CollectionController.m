//
//  CollectionController.m
//  DesignFun
//
//  Created by qianfeng on 15/10/24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CollectionController.h"
#import "DFPictureModel.h"
#import "OneImageCell.h"
#import "LeftImageCell.h"
#import "RightImageCell.h"
#import "DFPictureDetailController.h"
#import "DBManager.h"

#define TableViewHeight height(self.view.frame)

@interface CollectionController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) BOOL isRefreshing;
@property (nonatomic) BOOL isLoadingMore;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *deleteButton;
@end

@implementation CollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    [self createTableView];
    [self createNavigationRightBtn];
}
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithArray:[[DBManager shareInstance] quaryAllData]];
    }
    return _dataSource;
}
- (void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0 , screentWidth(), TableViewHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"OneImageCell" bundle:nil] forCellReuseIdentifier:@"OneImageCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftImageCell" bundle:nil] forCellReuseIdentifier:@"LeftImageCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RightImageCell" bundle:nil] forCellReuseIdentifier:@"RightImageCell"];
    
    [self.view addSubview: self.tableView];
        
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DFImage *image = self.dataSource[indexPath.row];
    
    if([image.imgSum integerValue] == 3 && indexPath.row %2 == 0 && indexPath.row%4 != 0){
        LeftImageCell *leftCell = [tableView dequeueReusableCellWithIdentifier:@"LeftImageCell" forIndexPath:indexPath];
        [leftCell updateOneCellData:image];
        return leftCell;
    }else if([image.imgSum integerValue] == 3){
        RightImageCell *rightCell = [tableView dequeueReusableCellWithIdentifier:@"RightImageCell" forIndexPath:indexPath];
        [rightCell updateOneCellData:image];
        return rightCell;
    }
    OneImageCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"OneImageCell" forIndexPath:indexPath];
    [oneCell updateOneCellData:image];
    
    return oneCell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 250;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!tableView.editing) {
        DFImage *image = self.dataSource[indexPath.row];
        DFPictureDetailController *pictureController = [[DFPictureDetailController alloc]init];
        pictureController.titleName = image.title;
        pictureController.pageId = image.id;
        pictureController.dfImage = image;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:pictureController animated:YES];
    }
        
}
- (void)createNavigationRightBtn{

    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.deleteButton.frame = CGRectMake(0, 0, 44, 44);
    
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    
    [self.deleteButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.deleteButton]animated:YES];
    
    self.navigationItem.title = [NSString stringWithFormat:@"收藏列表(%ld)", (long)self.dataSource.count];
    
    _tableView.editing = NO;
}
- (void)chooseAction:(UIButton *)button {
    
    if (self.dataSource.count != 0) {
        if (!_tableView.editing) {
            
            _tableView.allowsMultipleSelectionDuringEditing = YES;
            
            [_tableView setEditing:YES animated:YES];
            
            [self.deleteButton setTitle:@"确定" forState:UIControlStateNormal];
            
        } else {
            
            NSArray *indexPaths = [_tableView indexPathsForSelectedRows];
            
            indexPaths = [indexPaths sortedArrayUsingSelector:@selector(compare:)];
            
            for (NSInteger i = indexPaths.count - 1; i >= 0; i--) {
                
                
                id model = self.dataSource[[indexPaths[i] row]];
                
                if ([[DBManager shareInstance] deleteDataWithModel:model]) {
                    
                    [self.dataSource removeObject:model];
                }
                
            }
            
            [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
            
            self.navigationItem.title = [NSString stringWithFormat:@"收藏列表(%ld)", (long)self.dataSource.count];
            
            _tableView.allowsMultipleSelectionDuringEditing = NO;
            
            [_tableView setEditing:NO animated:YES];
            
            [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        }

    }else{
        [IanAlert alertError:@"暂无收藏" length:1.0];
    }
    
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
