//
//  WebViewController.m
//  PhenixNews
//
//  Created by qianfeng on 15/9/27.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WebViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "CellModel.h"
#import "UIView+Common.h"
#import <UIImageView+WebCache.h>
#import "HeadDefine.h"
#import "ShareModle.h"
#import "CommentCell.h"

@interface WebViewController()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>{
   
    AFHTTPRequestOperationManager *_manager;
    CellModel *_cellModel;
    ShareModle *_shareModel;
    UITableView *_tableView;
    UIWebView *_webView;
    NSMutableString *_shareNameString;
}
@end

@implementation WebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"军事";
    _shareNameString = [NSMutableString string];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initRequestManager];
    [self prepareLoadData:NO];
}
#pragma mark - 创建网络请求管理对象
- (void)initRequestManager {
    if (_manager == nil) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
}
#pragma mark --请求数据
- (void)prepareLoadData:(BOOL)isMore{
    [self loadingData:_urlStr isMore:isMore];
    [self loadingData:[NSString stringWithFormat:ShareURL,_aid] isMore:NO];
}
#pragma mark - 下载数据
- (void)loadingData:(NSString *)url isMore:(BOOL)isMore{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([url isEqualToString: _urlStr]) {
             _cellModel = [[CellModel alloc]initWithData:responseObject error:nil];
            [self createWebview];

        }else if ([url  isEqualToString:[NSString stringWithFormat:ShareURL,_aid]]){
        _shareModel = [[ShareModle alloc]initWithData:responseObject error:nil];
        }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
#pragma mark - 创建tableView
- (void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, width(self.view.frame),height(self.view.frame)-64-20) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
#pragma mark - 设置tableView的分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}
#pragma mark - 设置tableView的行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1 ) {
        return _cellModel.aboutNews.count;
    }else if(section == 2)
    {
        return _shareModel.hotcommentList.count;
    }
    return 1;
}
#pragma mark - 设置tableViewcell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        static NSString *identifier = @"webContentCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell.contentView addSubview:_webView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){

        static NSString *identifier = @"hotSpotCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        AboutNews *aboutNews = _cellModel.aboutNews[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.text = aboutNews.title;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2){
        CommentCell *commentCell = [CommentCell cellWithTableviewCell:tableView];
        commentCell.sharModel = _shareModel.hotcommentList[indexPath.row];
        commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return commentCell;
    }
    return nil;
}
#pragma mark - 选中那个某行cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        

        WebViewController *webvc = [WebViewController new];
        
        AboutNews *aboutNews = _cellModel.aboutNews[indexPath.row];
        webvc.urlStr = [NSString stringWithFormat:cellUrl,(long)[aboutNews.aboutId integerValue]];
        [self.navigationController  pushViewController:webvc animated:YES];
    }
}
#pragma mark - 创建webView
- (void)createWebview{
     _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, width(self.view.frame), 800)];
    [_webView scalesPageToFit];
    _webView.delegate = self;
    _webView.userInteractionEnabled = NO;
    [_webView loadHTMLString:_cellModel.webContent baseURL:nil];
    NSLog(@"%@",_cellModel.webContent);
    [self creatTableView];

}
#pragma mark - webview数据加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGRect frame = webView.frame;
    frame.size.width = width(self.view.frame);
    frame.size.height = 1;
    webView.frame = frame;
    frame.size.height = webView.scrollView.contentSize.height;
    webView.frame = frame;
    [_tableView reloadData];
}
#pragma  mark - 设置分区头部的视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [self creatTableViewHeadView];
    }else if (section == 1){
        return [self creatSectionTwoHeadView];
    }else if (section == 2){
        return [self creatSectionThreeHeadView];
    }
    return [UIView new];
}
#pragma mark - 设置分区头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 100;
    }else if (section == 1){
        return 25;
    }else if (section == 2){
        return 25;
    }
    return 0;
}
#pragma mark - 设置每个分区的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return _webView.height;
    }else if (indexPath.section == 1) {
        return 30;
    }else if (indexPath.section == 2){
        ShareHotcommentList *shareHotComment = _shareModel.hotcommentList[indexPath.row];
        CGFloat titleLableH = [self sizeWithText:shareHotComment.content font:[UIFont fontWithName:@"Arial" size:15] maxSize:CGSizeMake(width(self.view.frame)-20, MAXFLOAT)].height;
        return 80 + titleLableH;
    }
    return 0;
}
#pragma  mark - 设置分区尾部的视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
#pragma  mark - 设置分区尾部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
#pragma  mark - section一头部的view
- (UIView *)creatTableViewHeadView{
     CGFloat margin = 10;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(margin, 0, width(self.view.frame), 100)];

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(margin, margin, 50, 50)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_cellModel.authorIconUrl]];
    [headView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(maxX(imageView)+margin, margin, width(self.view.frame)-width(imageView.frame)-2*margin, 60)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = _cellModel.title;
    [headView addSubview:titleLabel];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin, maxY(imageView)+margin, 200, 20)];
    nameLabel.text = _cellModel.authorNickName;
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor blueColor];
    [headView addSubview:nameLabel];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(maxX(self.view)-80, maxY(imageView)+margin, 80, 20)];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.text = [self timeFormatted:[_cellModel.publishTime intValue]];
    [headView addSubview:timeLabel];
    
    return headView;
}
#pragma mark - section二头部的view
- (UIView *)creatSectionTwoHeadView{
    CGFloat margin = 10;
    CGFloat sectionW = 75;
    UIView *sectionTwoView = [[UIView alloc]initWithFrame:CGRectMake(margin, 0, sectionW, 25)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin, 0, sectionW, 20)];
    titleLabel.text = @"热门推荐";
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sectionTwoView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(margin, 25, sectionW-10, 1)];
    lineView.backgroundColor = [UIColor blueColor];
    [sectionTwoView addSubview:lineView];
    
    return sectionTwoView;
}
#pragma mark - section三头部的view
- (UIView *)creatSectionThreeHeadView{
    CGFloat margin = 10;
    CGFloat sectionW = 75;
    UIView *sectionThreeView = [[UIView alloc]initWithFrame:CGRectMake(margin, 0, sectionW, 25)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin, 0, sectionW, 20)];
    titleLabel.text = @"最新评论";
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sectionThreeView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(margin, 25, sectionW-10, 1)];
    lineView.backgroundColor = [UIColor blueColor];
    [sectionThreeView addSubview:lineView];
    
    return sectionThreeView;
}
#pragma  mark - section三尾部的view
- (UIView *)createSectionThreeFooterView{
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, width(self.view.frame), 40);
    [moreButton setTitle:@"查看更多评论"forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
    moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    return moreButton;
}
#pragma mark - section四头部的view
- (UIView *)createSectionFourheadView{

    CGFloat margin = 10;
    CGFloat sectionW = width(self.view.frame);
    UIView *sectionFourView = [[UIView alloc]initWithFrame:CGRectMake(margin, 0, sectionW, 25)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin, 0, sectionW, 20)];
    titleLabel.text = [NSString stringWithFormat:@"分享过的军迷(共有%@个军迷分享)",_shareModel.share_num];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sectionFourView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(margin, 25, sectionW-10, 1)];
    lineView.backgroundColor = [UIColor blueColor];
    [sectionFourView addSubview:lineView];
    
    return sectionFourView;
}
#pragma mark - 计算文字的尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
#pragma mark - 秒转化为日期
- (NSString *)timeFormatted:(int)totalSeconds
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:totalSeconds];
    NSString*confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}
@end
