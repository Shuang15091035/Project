//
//  DFPictureController.m
//  DesignFun
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "DFCommunityController.h"
#import "SquareController.h"
#import "HotController.h"
#import "CircleController.h"

@interface DFCommunityController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *scrollHead;
@property (nonatomic, strong) UIScrollView *maxScrollView;
@property (nonatomic, strong) NSArray *btnNameArray;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, assign) NSInteger selectedButtonTag;
@property (nonatomic, strong) NSMutableArray *vCArr;
@property (nonatomic, strong) NSArray *typeList;
@end

@implementation DFCommunityController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    [self creatTopTitleButton];
    [self createMaxScrollView];
    
    SquareController *squareController = self.vCArr[0];
    [squareController fetchAppData];
}
- (NSMutableArray *)vCArr{
    if (!_vCArr) {
        _vCArr = [NSMutableArray array];
    }
    return _vCArr;
}
- (NSArray *)btnNameArray{

    if (!_btnNameArray) {
        _btnNameArray = @[@"广场",@"最热",@"圈子"];
    }
    return _btnNameArray;
}
- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}
- (NSArray *)typeList{
    if (!_typeList) {
        _typeList = @[DFSquareURL,DFHotURl,DFCircleURL];
    }
    return _typeList;
}
#pragma mark - 创建头部标题按钮
- (void)creatTopTitleButton{
    
    self.scrollHead = [[UIView alloc]initWithFrame:CGRectMake(0, 64, screentWidth(), 50)];
    self.scrollHead.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollHead];
    CGFloat buttonW = (width(self.view.frame)/self.btnNameArray.count);
    for (int i = 0; i < _btnNameArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 200+i;
        CGFloat buttonH = 40;
        CGFloat buttonY = (self.scrollHead.height - buttonH)/2;
        button.frame = CGRectMake((buttonW)*i,buttonY, buttonW, buttonH);
        [button setTitle:[NSString stringWithFormat:@"%@",_btnNameArray[i]] forState:UIControlStateNormal];
        [self selectedButtonState:button];
        [button addTarget:self action:@selector(isSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0){
            button.selected = YES;
            [self selectedButtonState:button];
        }
        [self.btnArray addObject:button];
        [self.scrollHead addSubview:button];
    }
    
}

#pragma mark - 设置选中是按钮的状态
- (void)selectedButtonState:(UIButton *)button{
    if (button.selected) {
        
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.selectedButtonTag = button.tag;
    }else{
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
}
#pragma mark - 判断选中的标题按钮
- (void)isSelectedButton:(UIButton *)button{
    NSInteger index = button.tag;
    if (index != self.selectedButtonTag) {
        UIButton *btn = (UIButton *)[self.scrollHead viewWithTag:self.selectedButtonTag];
        btn.selected = NO;
        [self selectedButtonState:btn];
        button.selected = YES;
        [self selectedButtonState:button];
        
        self.maxScrollView.contentOffset = CGPointMake(width(_maxScrollView.frame)*(self.selectedButtonTag-200), 0);
        [self test:_maxScrollView];
    }
}

#pragma mark - 创建底部最大的滚动视图

- (void)createMaxScrollView{
    
    self.maxScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64+50, CGRectGetWidth(self.view.frame), TableViewH)];
    self.maxScrollView.contentSize = CGSizeMake(width(self.view.frame)*self.btnNameArray.count, TableViewH);
    self.maxScrollView.delegate = self;
    self.maxScrollView.bounces  = NO;
    self.maxScrollView.pagingEnabled = YES;
    self.maxScrollView.showsHorizontalScrollIndicator = NO;
    self.maxScrollView.contentOffset = CGPointZero;
    [self.view addSubview:self.maxScrollView];
    
    
    SquareController *squareVC = [[SquareController alloc] init];
    squareVC.view.frame = CGRectMake(0, 0, screentWidth(), TableViewH);
    squareVC.viewController = self;
    squareVC.typeName = [NSString stringWithFormat:@"%@",self.typeList[0]];
    [self.vCArr addObject:squareVC];
    [self.maxScrollView addSubview:squareVC.view];
    
    HotController *hotVC = [[HotController alloc] init];
    hotVC.view.frame = CGRectMake(screentWidth(), 0, screentWidth(), TableViewH);
    hotVC.viewController = self;
    hotVC.typeName = [NSString stringWithFormat:@"%@",self.typeList[1]];
    [self.vCArr addObject:hotVC];
    [self.maxScrollView addSubview:hotVC.view];
    
    CircleController *circleVC = [[CircleController alloc] init];
    circleVC.view.frame = CGRectMake(2*screentWidth(), 0, screentWidth(), TableViewH);
    circleVC.viewController = self;
    circleVC.typeName = [NSString stringWithFormat:@"%@",self.typeList[2]];
    [self.vCArr addObject:circleVC];
    [self.maxScrollView addSubview:circleVC.view];
    
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
    [self isSelectedButton:self.btnArray[index]];
    
    switch (index) {
        case 0:
        {
            SquareController *squreVC = self.vCArr[0];
                if (squreVC.dataSource.count == 0) {
                    [squreVC fetchAppData];
                }
        }
            break;
        case 1:
        {
            HotController *hotVC = self.vCArr[1];
            if (hotVC.dataSource.count == 0) {
                [hotVC fetchAppData];
            }
        }
            break;
        case 2:
        {
            CircleController *circleVC = self.vCArr[index];
            if (circleVC.dataSource.count == 0) {
                [circleVC fetchAppData];
            }
        }
            break;
            
        default:
            break;
    }
    
}
@end
