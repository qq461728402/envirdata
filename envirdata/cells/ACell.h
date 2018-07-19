//
//  ACell.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/17.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskTreeModel.h"
@protocol ACellDelegate;

@interface ACell : UITableViewCell
@property (nonatomic,strong)TaskTreeModel *taskTreeModel;
@property (nonatomic,assign)id<ACellDelegate> delegate;
@property (nonatomic,assign)BOOL isChoose;
@end

@protocol ACellDelegate <NSObject>
-(void)selectUpOrDown:(TaskTreeModel*)taskTreeModel;
@end
