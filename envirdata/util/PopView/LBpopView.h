//
//  LBpopView.h
//  dtgh
//
//  Created by 熊佳佳 on 15/11/23.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LBpopDelegate<NSObject>
-(void)getIndexRow:(int)indexrow warranty:(id)warranty;
@end
@interface LBpopView : UIView
@property(nonatomic,strong)NSArray *popArray;
@property(nonatomic,strong)NSString *popType;
@property(assign,nonatomic)NSInteger selectRowIndex;
@property(nonatomic,strong)NSString *popTitle;
@property(nonatomic,retain)id<LBpopDelegate> delegate;
- (id)initWithFrame:(CGRect)frame;
- (void)show;
- (void)hidden;
@end
