//
//  ReportCell.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/20.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "ReportCell.h"
@interface ReportCell()
@property (nonatomic,strong)UILabel *title_lb;//
@property (nonatomic,strong)UILabel *subtitle_lb;
@end
@implementation ReportCell
@synthesize title_lb,subtitle_lb;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        title_lb =[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), SCALE(8), SCREEN_WIDTH-SCALE(16), 21)];
        title_lb.font=Font(15);
        title_lb.numberOfLines=0;
        title_lb.textColor=[UIColor colorWithRGB:0x404040];
        [self.contentView addSubview:title_lb];
        
        subtitle_lb =[[UILabel alloc]initWithFrame:CGRectMake(title_lb.left, title_lb.bottom, title_lb.width, 18)];
        subtitle_lb.font=Font(13);
        subtitle_lb.textColor=[UIColor colorWithRGB:0xcccccc];
        [self.contentView addSubview:subtitle_lb];
    }
    return self;
}
-(void)setReportModel:(ReportModel *)reportModel
{
    _reportModel=reportModel;
    title_lb.text=reportModel.name;
    CGSize connentSize =[title_lb.text boundingRectWithSize:CGSizeMake(title_lb.width, 500) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:title_lb.font} context:nil].size;
    title_lb.height=title_lb.height>connentSize.height?title_lb.height:connentSize.height;
    subtitle_lb.top=title_lb.bottom;
    subtitle_lb.text=reportModel.time;
    self.contentView.height=subtitle_lb.bottom+SCALE(8);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
