//
//  EnvChooseListVC.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/18.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChoosePerosonDelegate;

@interface EnvChooseListVC : UIViewController
@property (nonatomic,assign) id <ChoosePerosonDelegate> delegate;
@end
@protocol ChoosePerosonDelegate <NSObject>
-(void)selelctPerson:(NSString*)userId userName:(NSString*)userName;
@end
