//
//  LBpopView.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/23.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBpopView.h"
#import "AppDelegate.h"
#import "DkeyModel.h"
@interface LBpopView()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *view_userContact;
    UITableView *tableViewT;
    UILabel *lblT;
    UIView *headView;
}
@end
@implementation LBpopView

- (void)viewDidLayoutSubviews{
    if ([tableViewT respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableViewT setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([tableViewT respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableViewT setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=RGBACOLOR(0, 0, 0, 0.4);
        UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame=frame;
        [closeBtn addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        view_userContact=[[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-270)/2, -300, 270, 256)];
        view_userContact.clipsToBounds=YES;
        [self addSubview:view_userContact];
        view_userContact.backgroundColor=[UIColor clearColor];
        view_userContact.layer.masksToBounds = YES;
        view_userContact.layer.cornerRadius =10;
        [view_userContact setBackgroundColor:[UIColor colorWithRGB:0xeef0f2]];
        //table
        tableViewT=[[UITableView alloc]initWithFrame:view_userContact.bounds style:UITableViewStylePlain];
        [tableViewT setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        tableViewT.delegate=self;
        tableViewT.dataSource = self;
        tableViewT.backgroundColor=[UIColor clearColor];
        [view_userContact addSubview:tableViewT];
    }
    return self;
}
#pragma mark-----------取消按钮-------------
-(void)closeButtonClicked{
    [self hidden];
}
#pragma mark tableView
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!headView) {
        headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, view_userContact.width, 44)];
        headView.backgroundColor=COLOR_TOP;
        lblT=[[UILabel alloc]initWithFrame:CGRectMake(headView.left, 12, headView.width, 20)];
        lblT.backgroundColor=[UIColor clearColor];
        lblT.textAlignment=NSTextAlignmentCenter;
        lblT.textColor=[UIColor whiteColor];
        lblT.font=Font(18);
        [headView addSubview:lblT];
    }
    lblT.text=self.popTitle;
    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.popArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NoticeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ([[self.popArray objectAtIndex:indexPath.row] isKindOfClass:[DkeyModel class]]) {
        DkeyModel *dekyModel=[self.popArray objectAtIndex:indexPath.row];
        cell.textLabel.text=dekyModel.dval;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate getIndexRow:(int)indexPath.row warranty:self.popType];
    [self hidden];
}

#pragma mark------------显示视图------------------
- (void)show
{
    float tempF=(self.popArray.count) * 35+44;
    if (self.popArray.count>10) {
        tempF=10*35.0;
    }
    float tempY=tempF>(SCREEN_HEIGHT-100)?(SCREEN_HEIGHT-100):tempF;
    view_userContact.height=tempY;
    view_userContact.centerX=SCREEN_WIDTH/2.0;
    [tableViewT reloadData];
//    if (self.popArray.count && self.selectRowIndex<self.popArray.count) {
//        [tableViewT selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectRowIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
//    }
    [[AppDelegate Share].window addSubview:self];
    //[[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:self];
    self.hidden = NO;
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 1.0f;
                         [view_userContact setFrame:CGRectMake(view_userContact.left, (SCREEN_HEIGHT-view_userContact.height)/2+20, view_userContact.width, view_userContact.height)];
                         
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:0
                                          animations:^{
                                              [view_userContact setFrame:CGRectMake(view_userContact.left, (SCREEN_HEIGHT-view_userContact.height)/2, view_userContact.width, view_userContact.height)];
                                          }
                                          completion:nil];
                     }];
}
#pragma mark------------隐藏显示------------------
- (void)hidden
{
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:0
                     animations:^{
                         [view_userContact setFrame:CGRectMake(view_userContact.left, (SCREEN_HEIGHT-view_userContact.height)/2+20, view_userContact.width, view_userContact.height)];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              [view_userContact setFrame:CGRectMake(view_userContact.left, -view_userContact.height, view_userContact.width,view_userContact.height)];
                                              self.alpha = 0.0;
                                          }
                                          completion:^(BOOL finished) {
                                              self.hidden = YES;
                                              
                                          }];
                     }];
}

@end
