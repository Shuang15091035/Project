//
//  DFPictureDetailController.m
//  DesignFun
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "DFPictureDetailController.h"
#import "PictureDetailModel.h"
#import "PictureDetailCollectionCell.h"
#import "KxMenu.h"
#import "DBManager.h"

#define DFDetailUrl @"http://api.wap.miercn.com/api/2.0.3/pic_arc.php?plat=android&proct=mierapp&versioncode=20150807&apiCode=4&id=%@"

@interface DFPictureDetailController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIPopoverPresentationControllerDelegate>{
    NSIndexPath *path;
}

@property (nonatomic) BOOL isRefreshing;
@property (nonatomic) BOOL isLoadingMore;
@property (nonatomic, strong)UICollectionView *collection;
@property (nonatomic, strong)NSMutableArray *imageData;
@property (nonatomic, strong)NSMutableArray *descData;
@property (nonatomic, strong)UITextView *contentLable;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic,strong) UIImageView *contentImageView;
@end

@implementation DFPictureDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationRightItem];
    [self createBottomView];
    [self createCollectionView];
    [self loadingDataFromNetWork];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(click:) name:@"Click" object:nil];
}

//- (void)click:(NSNotification *)notifi {
//    
//    BOOL isClick = [notifi.userInfo[@"bool"] boolValue];
//    
//    if (isClick) {
//        self.titleLabel.hidden = YES;
//        self.contentLable.hidden =  YES;
//        self.view.backgroundColor = [UIColor blackColor];
//    } else {
//        self.titleLabel.hidden = NO;
//        self.contentLable.hidden = NO;
//        self.view.backgroundColor = [UIColor whiteColor];
//    }
//}

//- (void)dealloc {
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

- (void)createNavigationRightItem{

    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 44, 64);
    [rightBtn setTitle:@"菜单" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
- (void)rightItemClick:(UIButton *)rightItem{

    NSArray *menuItems = @[[KxMenuItem menuItem:@"收藏"
                                          image:[UIImage imageNamed:@"unLove"]
                                         target:self
                                         action:@selector(pushMenuItemLove:)]
                           ];
    
    [KxMenu showMenuInView:self.navigationController.view fromRect:rightItem.frame menuItems:menuItems];
    
}
- (void)pushMenuItemLove:(id)sender{
    
    if ([[DBManager shareInstance] insertDataWithModel:self.dfImage]) {
        [IanAlert alertSuccess:@"收藏成功" length:2.0];
    }else{
        [IanAlert alertError:@"收藏失败" length:2.0];
    }
    
}
#pragma mark - 协议方法
//如果要想在iPhone上也能弹出泡泡的样式必须要实现下面协议的方法
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}
- (NSMutableArray *)imageData{
    if (_imageData == nil) {
        _imageData = [NSMutableArray array];
    }
    return _imageData;
}
- (NSMutableArray *)descData{
    if (!_descData) {
        _descData = [NSMutableArray array];
    }
    return _descData;
}
- (void)createCollectionView{

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(screentWidth(), screenHeight()/2);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screentWidth(), screenHeight()/2) collectionViewLayout:flowLayout];
    collectionView.center = self.view.center;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
    [collectionView registerNib:[UINib nibWithNibName:@"PictureDetailCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"PictureDetailCollectionCell"];
    
    [self.view addSubview:collectionView];
    self.collection = collectionView;
}
#pragma mark -
#pragma mark - 结束刷新

- (void)endRefresh {
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.collection.header endRefreshing];
    }
    if (self.isLoadingMore) {
        self.isLoadingMore = NO;
        [self.collection.footer endRefreshing];
    }
}

#pragma mark -
#pragma mark - networking
- (NSString *)composeRequestUrl {
    return [NSString stringWithFormat:DFDetailUrl,self.pageId];
}

#pragma mark -
#pragma makr - 解析数据
- (void)parseRespondData:(id)responseObject {
    PictureDetailModel *detailModel = [[PictureDetailModel alloc]initWithData:responseObject error:nil];
    [self.imageData addObjectsFromArray:detailModel.imgurls];
    [self.descData addObjectsFromArray:detailModel.desc];
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
        [self parseRespondData:responseObject];
        [self.collection reloadData];
        [self endRefresh];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PictureDetailCollectionCell *pictureCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PictureDetailCollectionCell" forIndexPath:indexPath];
    [pictureCell updataPictureDetailCollecionCell:self.imageData[indexPath.row] content:self.descData[indexPath.row]];
    path = indexPath;
    pictureCell.block = ^(BOOL isClick,UIImageView *imageView) {
        if (isClick) {
            self.bottomView.hidden = isClick;
            self.collection.alpha = 0.0f;
//            self.view.backgroundColor = [UIColor blackColor];
            _contentImageView = [UIImageView new];
            [self.view addSubview:_contentImageView];
            _contentImageView.hidden = NO;
             _contentImageView.userInteractionEnabled = YES;
            _contentImageView.frame = imageView.frame;
            _contentImageView.center = self.view.center;
            [_contentImageView sd_setImageWithURL:self.imageData[indexPath.row] placeholderImage:nil];
            UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(pictureRotation:)];
            UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGesture:)];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
            [_contentImageView addGestureRecognizer:tapGesture];
            [_contentImageView addGestureRecognizer:pinchGesture];
            [_contentImageView addGestureRecognizer:rotationGesture];
            
        } else {
            self.bottomView.hidden = isClick;
            self.collection.alpha = 1.0f;
            self.view.backgroundColor = [UIColor whiteColor];
        }
    };
    [self createContentView:indexPath];
    return pictureCell;
}
- (void)tapGesture:(UITapGestureRecognizer *)tapGesture {
    self.bottomView.hidden = NO;
    self.collection.alpha = 1.0f;
    _contentImageView.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)pictureRotation:(UIRotationGestureRecognizer *)rotationGesture{
    rotationGesture.view.transform = CGAffineTransformRotate(rotationGesture.view.transform, rotationGesture.rotation);
         rotationGesture.rotation = 0.0;
}
- (void)pinchGesture:(UIPinchGestureRecognizer *)pinchGesture{
    CGFloat scale = pinchGesture.scale;
     pinchGesture.view.transform = CGAffineTransformScale(pinchGesture.view.transform, scale, scale); //在已缩放大小基础下进行累加变化；区别于：使用 CGAffineTransformMakeScale 方法就是在原大小基础下进行变化
     pinchGesture.scale = 1.0;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [_contentImageView sd_setImageWithURL:self.imageData[path.row] placeholderImage:nil];
}
- (void)createBottomView{
    self.bottomView = [UIView new];
    self.titleLabel = [UILabel new];
    self.contentLable = [UITextView new];
}
- (void)createContentView:(NSIndexPath *)indexPath{
    
    self.bottomView.frame = CGRectMake(0, maxY(self.collection), screentWidth(), screenHeight()-maxY(self.collection));
    
    self.titleLabel.frame = CGRectMake(0, 0, screentWidth(), 20);
    self.titleLabel.text = [NSString stringWithFormat:@"%d/%d %@",(int)indexPath.row+1,(int)self.imageData.count,self.titleName];
    [self.bottomView addSubview:self.titleLabel];
    
    self.contentLable.font = [UIFont systemFontOfSize:15];
    self.contentLable.editable = NO;
    CGFloat contentLabelX = 0;
    CGFloat contentLabelY = 20;
    CGFloat contentlabelW = screentWidth();
    CGFloat contentLabelH = height(self.bottomView.frame)-maxY(self.titleLabel);
    self.contentLable.frame = CGRectMake(contentLabelX, contentLabelY, contentlabelW, contentLabelH);
    self.contentLable.text = self.descData[indexPath.row];
    
    [self.bottomView addSubview:self.contentLable];
    
    [self.view addSubview:self.bottomView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
