//
//  PCell.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/17.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskTreeModel.h"

@protocol PCellDelegate;

@interface PCell : UITableViewCell
@property (nonatomic,strong)TaskTreeModel *taskTreeModel;
@property (nonatomic,assign)id<PCellDelegate> delegate;
@property (nonatomic,assign)BOOL isChoose;

@end
@protocol PCellDelegate <NSObject>
-(void)pselectUpOrDown:(TaskTreeModel*)taskTreeModel;
-(void)pselectrw:(TaskTreeModel*)taskTreeModel;//点击任务
-(void)pselectaddrw:(TaskTreeModel*)taskTreeModel;//发起任务
@end
