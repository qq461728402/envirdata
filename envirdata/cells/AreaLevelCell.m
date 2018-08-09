//
//  AreaLevelCell.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/13.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "AreaLevelCell.h"

@interface AreaLevelCell()
@property (nonatomic,strong)UILabel *namelb;
@property (nonatomic,strong)UILabel *aqilb;
@property (nonatomic,strong)UILabel *pm25lb;
@property (nonatomic,strong)UILabel *pm10lb;
@property (nonatomic,strong)UILabel *solb;
@property (nonatomic,strong)UILabel *nolb;
@property (nonatomic,strong)UILabel *colb;
@property (nonatomic,strong)UILabel *o3lb;

@end
@implementation AreaLevelCell
@synthesize namelb,aqilb,pm25lb,pm10lb,solb,nolb,colb,o3lb;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        namelb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, SCALE(35))];
        namelb.font=Font(14);
        namelb.textAlignment=NSTextAlignmentCenter;
        namelb.adjustsFontSizeToFitWidth=YES;
        [self.contentView addSubview:namelb];
    
        float itemW =(SCREEN_WIDTH-namelb.right)/7.0;
        aqilb =[[UILabel alloc]initWithFrame:CGRectMake(namelb.right, SCALE(5), itemW-SCALE(5), SCALE(25))];
        aqilb.centerX=itemW/2.0+namelb.right;
        aqilb.font=Font(14*SCREEN_WIDTH/375.0);
        ViewRadius(aqilb, 4);
        aqilb.textAlignment=NSTextAlignmentCenter;
        aqilb.adjustsFontSizeToFitWidth=YES;
        [self.contentView addSubview:aqilb];
        
        pm25lb =[[UILabel alloc]initWithFrame:CGRectMake(namelb.right+itemW, namelb.top, itemW, namelb.height)];
        pm25lb.font=Font(14*SCREEN_WIDTH/375.0);
        pm25lb.textAlignment=NSTextAlignmentCenter;
        pm25lb.adjustsFontSizeToFitWidth=YES;
        [self.contentView addSubview:pm25lb];
        
        
        pm10lb =[[UILabel alloc]initWithFrame:CGRectMake(pm25lb.right, namelb.top, itemW, namelb.height)];
        pm10lb.font=Font(14*SCREEN_WIDTH/375.0);
        pm10lb.textAlignment=NSTextAlignmentCenter;
        pm10lb.adjustsFontSizeToFitWidth=YES;
        [self.contentView addSubview:pm10lb];
        
        solb =[[UILabel alloc]initWithFrame:CGRectMake(pm10lb.right, namelb.top, itemW, namelb.height)];
        solb.font=Font(14*SCREEN_WIDTH/375.0);
        solb.textAlignment=NSTextAlignmentCenter;
        solb.adjustsFontSizeToFitWidth=YES;
        [self.contentView addSubview:solb];
        
        
        nolb =[[UILabel alloc]initWithFrame:CGRectMake(solb.right, namelb.top, itemW, namelb.height)];
        nolb.font=Font(14*SCREEN_WIDTH/375.0);
        nolb.textAlignment=NSTextAlignmentCenter;
        nolb.adjustsFontSizeToFitWidth=YES;
        [self.contentView addSubview:nolb];
        
        colb =[[UILabel alloc]initWithFrame:CGRectMake(nolb.right, namelb.top, itemW, namelb.height)];
        colb.font=Font(14*SCREEN_WIDTH/375.0);
        colb.textAlignment=NSTextAlignmentCenter;
        colb.adjustsFontSizeToFitWidth=YES;
        [self.contentView addSubview:colb];
        
        o3lb =[[UILabel alloc]initWithFrame:CGRectMake(colb.right, namelb.top, itemW, namelb.height)];
        o3lb.font=Font(14*SCREEN_WIDTH/375.0);
        o3lb.textAlignment=NSTextAlignmentCenter;
        o3lb.adjustsFontSizeToFitWidth=YES;
        [self.contentView addSubview:o3lb];
        
        self.contentView.height=namelb.bottom;
    }
    return self;
}
-(void)setAreaLevelModel:(AreaLevelModel *)areaLevelModel
{
    _areaLevelModel=areaLevelModel;
    if (self.isTime==YES) {
        namelb.text=[NSString stringWithFormat:@"%@",areaLevelModel.showtime];
    }else{
        namelb.text=[NSString stringWithFormat:@"%@",areaLevelModel.name];
    }
    aqilb.text=[NSString stringWithFormat:@"%@",areaLevelModel.aqi];
    int level = [ConfigObj getLevelByAQI:[areaLevelModel.aqi doubleValue]];
    [aqilb setBackgroundColor:[ConfigObj getColorByLevel:level]];
    pm25lb.text=[NSString stringWithFormat:@"%@",areaLevelModel.pm25];
    pm10lb.text=[NSString stringWithFormat:@"%@",areaLevelModel.pm10];
    solb.text=[NSString stringWithFormat:@"%@",areaLevelModel.so2];
    nolb.text=[NSString stringWithFormat:@"%@",areaLevelModel.no2];
    colb.text=[NSString stringWithFormat:@"%@",areaLevelModel.co];
    o3lb.text=[NSString stringWithFormat:@"%@",areaLevelModel.o3];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
