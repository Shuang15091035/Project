//
//  RootViewController.m
//  DesignFun
//
//  Created by qianfeng on 15/10/7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MilitaryViewController.h"

#import "DeatilTableViewController.h"

#define TableViewH height(self.view.frame)-49-50-64

@interface MilitaryViewController ()<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    UIScrollView *_maxScrollView;
    UIView *_scorllVHead;
    NSArray *_btnNameArray;
    NSInteger _isSelectedButton;
    NSArray *_tableviewUrl;
    NSMutableArray *_scrollViewArray;
    
    NSMutableArray *_VCArr;
    NSMutableArray *_buttonArray;
}
@end

@implementation MilitaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _VCArr = [NSMutableArray array];
    _buttonArray = [NSMutableArray array];
    _btnNameArray = @[@"推荐",@"热点",@"军事",@"历史",@"环球"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTopTitleButton];
    [self maxScrollView];
   
    
    DeatilTableViewController *testVC = _VCArr[0];
    
    [testVC fetchAppData];
}
#pragma mark - 创建头部标题按钮
- (void)creatTopTitleButton{
    
    _scorllVHead = [[UIView alloc]initWithFrame:CGRectMake(0, 64, screentWidth(), 50)];
    _scorllVHead.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scorllVHead];
    CGFloat buttonW = (width(self.view.frame)/5.0);
    for (int i = 0; i < _btnNameArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 200+i;
        CGFloat buttonH = 40;
        CGFloat buttonY = (_scorllVHead.height - buttonH)/2;
        button.frame = CGRectMake((buttonW)*i,buttonY, buttonW, buttonH);
        [button setTitle:[NSString stringWithFormat:@"%@",_btnNameArray[i]] forState:UIControlStateNormal];
        [self selectedButtonState:button];
        [button addTarget:self action:@selector(isSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0){
            button.selected = YES;
            [self selectedButtonState:button];
        }
        [_buttonArray addObject:button];
        [_scorllVHead addSubview:button];
    }
    
}
#pragma mark - 设置选中是按钮的状态
- (void)selectedButtonState:(UIButton *)button{
    if (button.selected) {
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _isSelectedButton = button.tag;
    }else{
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
}
#pragma mark - 判断选中的标题按钮
- (void)isSelectedButton:(UIButton *)button{
    NSInteger index = button.tag;
    if (index != _isSelectedButton) {
        UIButton *btn = (UIButton *)[_scorllVHead viewWithTag:_isSelectedButton];
        btn.selected = NO;
        [self selectedButtonState:btn];
        button.selected = YES;
        [self selectedButtonState:button];
        
        _maxScrollView.contentOffset = CGPointMake(width(_maxScrollView.frame)*(_isSelectedButton-200), 0);
        [self test:_maxScrollView];
    }
}

#pragma mark - 创建底部最大的滚动视图

- (void)maxScrollView{
    
    _maxScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, maxY(_scorllVHead), CGRectGetWidth(self.view.frame), TableViewH)];
    _maxScrollView.contentSize = CGSizeMake(width(self.view.frame)*5, TableViewH);
    _maxScrollView.delegate = self;
    _maxScrollView.bounces  = NO;
    _maxScrollView.tag = 1000;
    _maxScrollView.pagingEnabled = YES;
    _maxScrollView.showsHorizontalScrollIndicator = NO;
    _maxScrollView.contentOffset = CGPointZero;
    [self.view addSubview:_maxScrollView];
    
    for (int index = 0; index < _btnNameArray.count; index++) {
        DeatilTableViewController *testVC = [[DeatilTableViewController alloc] init];
        testVC.view.frame = CGRectMake(index*screentWidth(), 0, screentWidth(), TableViewH);
        testVC.viewController = self;
        testVC.testList = [NSString stringWithFormat:@"%d",index+1];
        testVC.view.backgroundColor = [UIColor whiteColor];
        [_VCArr addObject:testVC];
        
        [_maxScrollView addSubview:testVC.view];
    }
}

#pragma mark -
#pragma mark UIScrollView 代理

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self test:scrollView];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self test:scrollView];
}

- (void)test:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/screentWidth();
    [self isSelectedButton:_buttonArray[index]];
    DeatilTableViewController *testVC = _VCArr[index];
    if (testVC.dataSource.count == 0) {
        [testVC fetchAppData];
    }
}
@end
