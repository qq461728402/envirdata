//
//  OnlineCell.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/14.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "OnlineCell.h"

@interface OnlineCell()
@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UILabel *utype_dvalLb;//类型
@property (nonatomic,strong)UILabel *unameLb;//站点名称
@property (nonatomic,strong)UILabel *statusLb;//状态
@end

@implementation OnlineCell
@synthesize iconImg,utype_dvalLb,unameLb,statusLb;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(SCALE(10), SCALE(10), SCALE(20), SCALE(20))];
        [iconImg setImage:PNGIMAGE(@"gk")];
        [self.contentView addSubview:iconImg];
        
        statusLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, [ConfigObj font_sizeWith:15*SCREEN_WIDTH/375.0 strLong:4], SCALE(40))];
        statusLb.right=SCREEN_WIDTH-SCALE(8);
        statusLb.font=Font(14*SCREEN_WIDTH/375.0);
        statusLb.textColor=[UIColor colorWithRGB:0x404040];
//        statusLb.adjustsFontSizeToFitWidth=YES;
        statusLb.textAlignment=NSTextAlignmentCenter;
        [self.contentView  addSubview:statusLb];
        
        utype_dvalLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, [ConfigObj font_sizeWith:15*SCREEN_WIDTH/375.0 strLong:6], statusLb.height)];
        utype_dvalLb.right=statusLb.left;
        utype_dvalLb.font=Font(14*SCREEN_WIDTH/375.0);
        utype_dvalLb.textColor=[UIColor colorWithRGB:0x404040];
        utype_dvalLb.adjustsFontSizeToFitWidth=YES;
        utype_dvalLb.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:utype_dvalLb];
    
        unameLb=[[UILabel alloc]initWithFrame:CGRectMake(iconImg.right+SCALE(5), 0, SCREEN_WIDTH-(iconImg.right+SCALE(5))-utype_dvalLb.width-statusLb.width-SCALE(8) , statusLb.height)];
        unameLb.right=utype_dvalLb.left;
        unameLb.font=Font(13);
        unameLb.adjustsFontSizeToFitWidth=YES;
        [self.contentView addSubview:unameLb];
        self.contentView.height=unameLb.bottom;
    }
    return  self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOnlineMonModel:(OnlineMonModel *)onlineMonModel
{
    _onlineMonModel=onlineMonModel;
    unameLb.text=onlineMonModel.uname;
    if ([onlineMonModel.utype intValue]==1) {//表示国控点
         unameLb.font=Font(15*SCREEN_WIDTH/375.0);
        iconImg.hidden=NO;
        utype_dvalLb.text=@"";
        statusLb.text=@"";
        unameLb.left=iconImg.right+SCALE(5);
    }else{
        utype_dvalLb.text=onlineMonModel.utype_dval;
        unameLb.font=Font(14*SCREEN_WIDTH/375.0);
        unameLb.left=iconImg.right+SCALE(10);
        iconImg.hidden=YES;
    }
    if ([onlineMonModel.status intValue]==0) {
        statusLb.textColor=COLOR_TOP;
        statusLb.text=@"正常 >";
    }else{
        statusLb.textColor=[UIColor redColor];
        statusLb.text=@"异常 >";
    }
}
@end
