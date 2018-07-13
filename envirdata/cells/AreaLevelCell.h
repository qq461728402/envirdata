//
//  AreaLevelCell.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/13.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaLevelModel.h"
@interface AreaLevelCell : UITableViewCell
@property (nonatomic,strong)AreaLevelModel *areaLevelModel;
@property (nonatomic,assign)BOOL isTime;
@end
