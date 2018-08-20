//
//  HistoryViolationPictureVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/15.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "HistoryViolationPictureVC.h"
#import "HistoryViolationCell.h"
#import "HistoryViolationPictureModel.h"
#import "GKPhotoBrowser.h"
#import "GKCover.h"
@interface HistoryViolationPictureVC ()<UITableViewDelegate,UITableViewDataSource,GKPhotoBrowserDelegate>
@property (nonatomic,strong)UITableView *historyviltb;
@property (nonatomic,strong)NSArray *historyvilary;
@property (nonatomic, weak) UIView *actionSheet;
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, assign) BOOL isLandspace;
@end

@implementation HistoryViolationPictureVC
@synthesize historyviltb,historyvilary;
@synthesize uid;
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    historyviltb=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    historyviltb.translatesAutoresizingMaskIntoConstraints=NO;
    historyviltb.delegate=self;
    historyviltb.dataSource=self;
    [self.view addSubview:historyviltb];
    __weak __typeof(self) weakSelf = self;//这里用一个弱引用来表示self，用于下面的Block中
    //先确定view_1的约束
    [historyviltb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(64);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left); //view_1de左，距离self.view是30px
    }];
    __unsafe_unretained __typeof(self) weakSelf1 = self;
    historyviltb.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf1 gethistoryInfo:YES];
    }];
    
    if (@available(iOS 11.0, *)) {
        historyviltb.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    historyviltb.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self gethistoryInfo:NO];
    // Do any additional setup after loading the view.
}
-(void)gethistoryInfo:(BOOL)isrefrsh{
    [self networkPost:API_GETHISTORYVIOLATIONPICTURE parameter:@{@"uid":uid} progresHudText:isrefrsh==NO?@"加载中...":nil completionBlock:^(id rep) {
        historyvilary = [HistoryViolationPictureModel mj_objectArrayWithKeyValuesArray:rep];
        [historyviltb reloadData];
        [historyviltb.mj_header endRefreshing];
    }];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
#pragma mark 此方法加上是为了适配iOS 11出现的问题

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
#pragma mark 此方法加上是为了适配iOS 11出现的问题
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return historyvilary.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height;
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NoticeCell";
    HistoryViolationCell *cell = (HistoryViolationCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[HistoryViolationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.histroyViolation=historyvilary[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HistoryViolationPictureModel *historyVio =historyvilary[indexPath.row];
    NSArray *urlAry  =[historyVio.url componentsSeparatedByString:@","];
    if (urlAry.count>0) {
        NSMutableArray *photos = [NSMutableArray new];
        [urlAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GKPhoto *photo = [GKPhoto new];
            photo.url = [NSURL URLWithString:obj];
            [photos addObject:photo];
        }];
        GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:0];
        browser.delegate=self;
        browser.showStyle = GKPhotoBrowserShowStyleNone;
        [browser showFromVC:self];
    }
}
- (void)photoBrowser:(GKPhotoBrowser *)browser longPressWithIndex:(NSInteger)index {
    NSLog(@"%@",browser.photos[index]);
    
    if (self.fromView) return;
    UIView *contentView = browser.contentView;
    
    UIView *fromView = [UIView new];
    fromView.backgroundColor = [UIColor clearColor];
    self.fromView = fromView;
     CGFloat actionSheetH = 0;
    if (self.isLandspace) {
        actionSheetH = 100;
        fromView.frame = contentView.bounds;
        [contentView addSubview:fromView];
    }else {
        actionSheetH = 100 + kSaveBottomSpace;
        fromView.frame = browser.view.bounds;
        [browser.view addSubview:fromView];
    }
    
    UIView *actionSheet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, actionSheetH)];
    actionSheet.backgroundColor = [UIColor whiteColor];
    self.actionSheet = actionSheet;
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, actionSheet.width, 50)];
    [saveBtn setTitle:@"保存图片" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn bk_addEventHandler:^(id sender) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            GKPhoto *photo =  browser.photos[index];
            UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });
    } forControlEvents:UIControlEventTouchUpInside];
    
    saveBtn.backgroundColor = [UIColor whiteColor];
    [actionSheet addSubview:saveBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, actionSheet.width, 50)];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn bk_addEventHandler:^(id sender) {
         [GKCover hideCover];
    } forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [actionSheet addSubview:cancelBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, actionSheet.width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [actionSheet addSubview:lineView];
    
    [GKCover coverFrom:fromView
           contentView:actionSheet
                 style:GKCoverStyleTranslucent
             showStyle:GKCoverShowStyleBottom
         showAnimStyle:GKCoverShowAnimStyleBottom
         hideAnimStyle:GKCoverHideAnimStyleBottom
              notClick:NO
             showBlock:nil
             hideBlock:^{
                 [self.fromView removeFromSuperview];
                 self.fromView = nil;
             }];
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"成功保存到相册"];
    }
    [GKCover hideCover];
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
