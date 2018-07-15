//
//  HistoryViolationCell.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/15.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "HistoryViolationCell.h"
@interface HistoryViolationCell()
@property (nonatomic,strong)UILabel *time_lb;//时间
@property (nonatomic,strong)UILabel *type_name;//类型
@end
@implementation HistoryViolationCell
@synthesize time_lb,type_name;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        time_lb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(10), 0, SCALE(190), SCALE(40))];
        time_lb.textColor=[UIColor colorWithRGB:0x2e4057];
        time_lb.font=Font(14);
        time_lb.adjustsFontSizeToFitWidth=YES;
        [self.contentView  addSubview:time_lb];
        type_name =[[UILabel alloc]initWithFrame:CGRectMake(time_lb.right, 0, SCREEN_WIDTH-time_lb.right-SCALE(10), time_lb.height)];
        type_name.textColor=COLOR_TOP;
        type_name.font=Font(14);
        type_name.textAlignment=NSTextAlignmentRight;
        type_name.adjustsFontSizeToFitWidth=YES;
        [self.contentView  addSubview:type_name];
        self.contentView.height=type_name.bottom;
    }
    return  self;
}
-(void)setHistroyViolation:(HistoryViolationPictureModel *)histroyViolation
{
    _histroyViolation=histroyViolation;
    time_lb.text=histroyViolation.time;
    type_name.text=histroyViolation.typename;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
