//
//  PatrolCell.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/23.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "PatrolCell.h"
@interface PatrolCell()
@property (nonatomic,strong)UILabel *title_lb;//
@property (nonatomic,strong)UILabel *subtitle_lb;
@end
@implementation PatrolCell
@synthesize title_lb,subtitle_lb;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        title_lb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(5), SCALE(5), SCREEN_WIDTH-SCALE(10), 21)];
        title_lb.numberOfLines=0;
        title_lb.font=Font(15);
        [self.contentView addSubview:title_lb];
        subtitle_lb =[[UILabel alloc]initWithFrame:CGRectMake(title_lb.left, title_lb.bottom, title_lb.width, 21)];
        subtitle_lb.font=Font(13);
        subtitle_lb.textColor=[UIColor colorWithRGB:0xcccccc];
        [self.contentView addSubview:subtitle_lb];
    }
    return  self;
}
-(void)setPatrolTaskModel:(PatrolTasksModel *)patrolTaskModel{
    _patrolTaskModel=patrolTaskModel;
    title_lb.text=[patrolTaskModel.uname stringByAppendingString:patrolTaskModel.dval];
    CGSize contentSize =[title_lb.text boundingRectWithSize:CGSizeMake(title_lb.width, 500) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:title_lb.font} context:nil].size;
    title_lb.height=title_lb.height>contentSize.height?title_lb.height:contentSize.height;
    subtitle_lb.top=title_lb.bottom;
    subtitle_lb.text=[NSString stringWithFormat:@"%@",patrolTaskModel.ctime];
    self.contentView.height=subtitle_lb.bottom;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
