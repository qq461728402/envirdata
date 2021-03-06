//
//  ACell.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/17.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "ACell.h"

@interface ACell()
@property (nonatomic,strong)UILabel *aname;//区域名称
@property (nonatomic,strong)UIButton *folding;//折叠按钮
@end
@implementation ACell
@synthesize aname,folding;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        aname =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCALE(250), SCALE(40))];
        aname.font=BoldFont(15);
        aname.adjustsFontSizeToFitWidth=YES;
        aname.textColor=[UIColor colorWithRGB:0x404040];
        [self.contentView addSubview:aname];
        
        folding =[UIButton buttonWithType:UIButtonTypeCustom];
        folding.frame=CGRectMake(0, 0, 50, SCALE(40));
        folding.imageEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
        folding.right=SCREEN_WIDTH;
        [folding addTarget:self action:@selector(touchUpOrDown:) forControlEvents:UIControlEventTouchUpInside];
        self.contentView.height=aname.bottom;
        [self.contentView addSubview:folding];
    }
    return  self;
}
-(void)setTaskTreeModel:(TaskTreeModel *)taskTreeModel
{
    _taskTreeModel=taskTreeModel;
    aname.left=SCALE(15)+taskTreeModel.creatLevle*SCALE(20);
    aname.text=taskTreeModel.name;
    if (taskTreeModel.chlidren.count>0) {
        NSLog(@"%@========",aname.text);
        folding.hidden=NO;
        if (taskTreeModel.isExpanded==YES) {
            [folding setImage:PNGIMAGE(@"down_up") forState:UIControlStateNormal];
        }else{
            [folding setImage:PNGIMAGE(@"up_down") forState:UIControlStateNormal];
        }
    }else{
        folding.hidden=YES;
    }
}
-(void)touchUpOrDown:(UIButton*)sender{
    if (self.delegate) {
        [self.delegate selectUpOrDown:_taskTreeModel];
    }
}
-(void)setIsChoose:(BOOL)isChoose
{
    _isChoose=isChoose;
    if (isChoose==YES) {
        folding.hidden=YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
