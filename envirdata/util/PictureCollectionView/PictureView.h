//
//  PictureView.h
//  SZMobileSchool
//
//  Created by 熊佳佳 on 16/9/13.
//  Copyright © 2016年 dctrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYQAssetPickerController.h"
@protocol PictureViewDelegate <NSObject>
-(void)addUIImagePicker:(UIImagePickerController *)picker;
-(void)addPicker:(ZYQAssetPickerController *)picker;
@end
@interface PictureView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate>
@property (nonatomic,strong)NSMutableArray *pictureAry;//图片数组
@property (nonatomic,assign)BOOL isUpPicture;//是不是增加图片
@property (nonatomic,strong)UICollectionView *pictureCollectonView;
@property (nonatomic,assign)CGSize marksize;
@property (nonatomic, assign) id <PictureViewDelegate> delegate;
-(id)initWithFrame:(CGRect)frame pictureAry:(NSMutableArray*)pictureAry1 size:(CGSize)marksize1 isUpPic:(BOOL)isUpPicture1;


@end
