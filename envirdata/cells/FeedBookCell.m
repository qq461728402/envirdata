//
//  FeedBookCell.m
//  envirdata
//
//  Created by 熊佳佳 on 18/8/10.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "FeedBookCell.h"
@interface FeedBookCell()
@property (nonatomic,strong)UIImageView *selectBox;
@property (nonatomic,strong)UILabel *valuelb;
@end

@implementation FeedBookCell
@synthesize selectBox,valuelb;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        selectBox =[[UIImageView alloc]initWithFrame:CGRectMake(8, 14, 16, 16)];
        [self.contentView addSubview:selectBox];
        valuelb =[[UILabel alloc]initWithFrame:CGRectMake(selectBox.right+8, 0,SCREEN_WIDTH-selectBox.right+16, 44)];
        valuelb.font=Font(13);
        valuelb.numberOfLines=0;
        [self.contentView addSubview:valuelb];
        self.contentView.height=44;
    }
    return  self;
}
-(void)setFeedBackModel:(FeedBackModel *)feedBackModel{
    _feedBackModel=feedBackModel;
    if (feedBackModel.isselect==YES) {
        [selectBox setImage:PNGIMAGE(@"select")];
    }else{
        [selectBox setImage:PNGIMAGE(@"no_select")];
    }
    valuelb.text=feedBackModel.dval;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
