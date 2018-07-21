//
//  PCell.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/17.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "PCell.h"
@interface PCell()
@property (nonatomic,strong)UILabel *aname;//用户名称
@property (nonatomic,strong)UIImageView *aicon;//用户logo
@property (nonatomic,strong)UILabel *dbrwnum;//待办任务条数
@property (nonatomic,strong)UIButton *rwbut;//任务
@property (nonatomic,strong)UIButton *addrwbut;//添加任务
@property (nonatomic,strong)UIButton *telbut;//打电话
@property (nonatomic,strong)UIButton *folding;//折叠按钮
@end
@implementation PCell
@synthesize aname,aicon,dbrwnum,addrwbut,telbut,folding,rwbut;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        aicon =[[UIImageView alloc]initWithFrame:CGRectMake(0, SCALE(8), SCALE(24), SCALE(24))];
        [self.contentView addSubview:aicon];
        aname =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCALE(200), SCALE(40))];
        aname.font=Font(15);
        aname.adjustsFontSizeToFitWidth=YES;
        aname.textColor=[UIColor colorWithRGB:0x404040];
        [self.contentView addSubview:aname];
        
        dbrwnum =[[UILabel alloc]initWithFrame:CGRectMake(0, SCALE(12), SCALE(16), SCALE(16))];
        dbrwnum.textColor=[UIColor whiteColor];
        dbrwnum.backgroundColor=[UIColor redColor];
        dbrwnum.font=Font(12);
        dbrwnum.textAlignment=NSTextAlignmentCenter;
        ViewRadius(dbrwnum, dbrwnum.height/2.0);
        [self.contentView addSubview:dbrwnum];
        rwbut =[UIButton buttonWithType:UIButtonTypeCustom];
        rwbut.frame=CGRectMake(0, SCALE(8), SCALE(24), SCALE(24));
        [rwbut addTarget:self action:@selector(rwSEL) forControlEvents:UIControlEventTouchUpInside];
        
        [rwbut setImage:PNGIMAGE(@"ibtn_reply") forState:UIControlStateNormal];
        [self.contentView addSubview:rwbut];
        
        addrwbut =[UIButton buttonWithType:UIButtonTypeCustom];
        addrwbut.frame=CGRectMake(0, SCALE(8), SCALE(24), SCALE(24));
        [addrwbut setImage:PNGIMAGE(@"ibtn_add") forState:UIControlStateNormal];
        [addrwbut addTarget:self action:@selector(addrwSEL) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:addrwbut];
        
        telbut =[UIButton buttonWithType:UIButtonTypeCustom];
        telbut.frame=CGRectMake(0, SCALE(8), SCALE(24), SCALE(24));
        [telbut setImage:PNGIMAGE(@"ibtn_call") forState:UIControlStateNormal];
        [telbut addTarget:self action:@selector(callphone:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:telbut];
    
        folding =[UIButton buttonWithType:UIButtonTypeCustom];
        folding.frame=CGRectMake(0, 0, SCALE(32), SCALE(40));
        folding.right=SCREEN_WIDTH-SCALE(10);
        [folding addTarget:self action:@selector(touchUpOrDown:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:folding];
        
        telbut.right=folding.left-SCALE(10);
        addrwbut.right=telbut.left-SCALE(10);
        rwbut.right=addrwbut.left-SCALE(10);
    }
    return  self;
}
-(void)setTaskTreeModel:(TaskTreeModel *)taskTreeModel
{
    _taskTreeModel=taskTreeModel;
    aicon.left=SCALE(15)+taskTreeModel.creatLevle*SCALE(20);
    aname.left=aicon.right+SCALE(5);
    aname.text=taskTreeModel.name;
    aname.width=[aname.text sizeWithAttributes:@{NSFontAttributeName:aname.font}].width>200?200:[aname.text sizeWithAttributes:@{NSFontAttributeName:aname.font}].width;
    dbrwnum.left=aname.right+SCALE(2);
    if ([taskTreeModel.todonum intValue]>0) {
        dbrwnum.hidden=NO;
        dbrwnum.text=[taskTreeModel.todonum stringValue];
    }else{
        dbrwnum.text=@"";
        dbrwnum.hidden=YES;
    }
    NSString *pstr =taskTreeModel.tid;
    NSString *uid = [pstr substringFromIndex:1];
    if ([uid isEqualToString:[[SingalObj defaultManager].userInfoModel.userid stringValue]]) {//表示自己
        telbut.hidden=YES;
        addrwbut.hidden=YES;
        rwbut.hidden=YES;
        [aicon setImage:PNGIMAGE(@"icon_myself")];
    } else{
        [aicon setImage:PNGIMAGE(@"icon_user")];
        telbut.hidden=NO;
        addrwbut.hidden=NO;
        rwbut.hidden=NO;
    }
    if (taskTreeModel.chlidren.count>0) {
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
-(void)setIsChoose:(BOOL)isChoose
{
    _isChoose=isChoose;
    if (isChoose==YES) {
        telbut.hidden=YES;
        addrwbut.hidden=YES;
        rwbut.hidden=YES;
        folding.hidden=YES;
        dbrwnum.hidden=YES;
    }
}

#pragma mark---------打电话---------
-(void)callphone:(UIButton*)sender{
    if ([self.taskTreeModel.phone isNotBlank]) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.taskTreeModel.phone];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self addSubview:callWebview];
    }
}
-(void)rwSEL{
    if (self.delegate) {
        [self.delegate pselectrw:self.taskTreeModel];
    }
}
-(void)addrwSEL{
    if (self.delegate) {
        [self.delegate pselectaddrw:self.taskTreeModel];
    }
}

-(void)touchUpOrDown:(UIButton*)sender{
    if (self.delegate) {
        [self.delegate pselectUpOrDown:_taskTreeModel];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
