//
//  GegionCell.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/19.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "GegionCell.h"
@interface GegionCell()
@property (nonatomic,strong)UILabel *title_lb;//
@property (nonatomic,strong)UILabel *subtitle_lb;
@end


@implementation GegionCell
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
    return self;
}
-(void)setGegionModel:(GegionModel *)gegionModel
{
    _gegionModel=gegionModel;
    NSMutableString *titleStr=[NSMutableString string];
    NSString *statusStr=@"";
//    if ([gegionModel.status intValue]==1) {//待处理
//        statusStr =@"（待处理）";
//    }else if ([gegionModel.status intValue]==2){//待审核
//        statusStr =@"（待审核）";
//    }else if ([gegionModel.status intValue]==3){//已完成
//        statusStr =@"（已处理）";
//    }
    [titleStr appendString:statusStr];
    [titleStr appendString:gegionModel.title];
    NSMutableAttributedString *titleAttStr=[[NSMutableAttributedString alloc]initWithString:titleStr];
    [titleAttStr addAttribute:NSForegroundColorAttributeName value:[gegionModel.status intValue]==1?[UIColor redColor]:[gegionModel.status intValue]==2?[UIColor colorWithRGB:0x228fff]:[UIColor blackColor] range:NSMakeRange(0,statusStr.length)];
    title_lb.attributedText=titleAttStr;
    CGSize contentSize =[titleStr boundingRectWithSize:CGSizeMake(title_lb.width, 500) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:title_lb.font} context:nil].size;
    title_lb.height=title_lb.height>contentSize.height?title_lb.height:contentSize.height;
    subtitle_lb.top=title_lb.bottom;
    subtitle_lb.text=[NSString stringWithFormat:@"%@（来源：%@）",gegionModel.ctime, gegionModel.sendorname];
    self.contentView.height=subtitle_lb.bottom;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
