//
//  PictureView.m
//  SZMobileSchool
//
//  Created by 熊佳佳 on 16/9/13.
//  Copyright © 2016年 dctrain. All rights reserved.
//

#import "PictureView.h"
#import "ImgCell.h"
#import "AddImageCell.h"

@implementation PictureView
@synthesize pictureCollectonView,pictureAry,isUpPicture,marksize;
-(id)initWithFrame:(CGRect)frame pictureAry:(NSMutableArray*)pictureAry1 size:(CGSize)marksize1 isUpPic:(BOOL)isUpPicture1
{
    self=[super initWithFrame:frame];
    if (self) {
        marksize = marksize1;
        isUpPicture=isUpPicture1;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize =marksize;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0; //上下的间距 可以设置0看下效果
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
        if (isUpPicture==YES) {
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        }
        pictureAry=[[NSMutableArray alloc]initWithArray:pictureAry1];
        int row=frame.size.width/marksize.width;
        float hight=marksize.height*([pictureAry count]/row+([pictureAry count]%row==0?0:1));
        pictureCollectonView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,hight>marksize.height?hight:marksize.height) collectionViewLayout:layout];
        [pictureCollectonView registerClass:[ImgCell class]forCellWithReuseIdentifier:@"ImgCell"];
        [pictureCollectonView registerClass:[AddImageCell class] forCellWithReuseIdentifier:@"AddImageCell"];
        pictureCollectonView.backgroundColor = [UIColor clearColor];
        pictureCollectonView.delegate = self;
        pictureCollectonView.dataSource = self;
        [self addSubview:pictureCollectonView];
        self.height=pictureCollectonView.bottom;
    }
    return self;
}
#pragma mark - collectionView 调用方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (isUpPicture==YES) {
        return pictureAry.count +1;
    }
    else
    {
        return pictureAry.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == pictureAry.count) {
        static NSString *addItem = @"AddImageCell";
        AddImageCell *addItemCell = [collectionView dequeueReusableCellWithReuseIdentifier:addItem forIndexPath:indexPath];
        addItemCell.addImageView.centerX=addItemCell.contentView.centerX;
        addItemCell.addImageView.centerY=addItemCell.contentView.centerY;
        return addItemCell;
    } else
    {
        static NSString *identify = @"ImgCell";
        ImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        cell.imageView.width=marksize.width-10;
        cell.imageView.height=marksize.height-10;
        cell.imageView.centerX=cell.contentView.centerX;
        cell.imageView.centerY=cell.contentView.centerY;
        if ([pictureAry[indexPath.row] isKindOfClass:[UIImage class]]) {
            cell.imageView.image = pictureAry[indexPath.row];
        }else
        {
            NSString *imageurl=pictureAry[indexPath.row];
            [cell.imageView setImageWithURL:[NSURL URLWithString:imageurl] placeholder:PNGIMAGE(@"列表缺省图")];
        }
        cell.cancelBtn.tag=indexPath.row;
        if (isUpPicture) {
            cell.cancelBtn.hidden=NO;
            [cell.cancelBtn addTarget:self action:@selector(cancelImge:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            cell.cancelBtn.hidden=YES;
        }
        return cell;
    }
}
//用代理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == pictureAry.count) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机选择", @"拍照", nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [sheet showInView:self.window];
    }else
    {
        if (isUpPicture!=YES) {
            NSMutableArray *urlAry = [[NSMutableArray alloc]initWithArray:pictureAry];
            NSMutableArray *photos =[[NSMutableArray alloc]init];
            [urlAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GKPhoto *photo = [GKPhoto new];
                photo.url = [NSURL URLWithString:obj];
                [photos addObject:photo];
            }];
            GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:indexPath.row];
            browser.delegate=self;
            browser.showStyle = GKPhotoBrowserShowStyleNone;
            if (_vself) {
                [browser showFromVC:_vself];
            }
        }
    }
}
#pragma mark-------------取消图片------------
-(void)cancelImge:(UIButton*)sender
{
    UIAlertView *alert=[UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"删除图片" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            if (pictureAry.count>sender.tag) {
                [pictureAry removeObjectAtIndex:sender.tag];
                [pictureCollectonView reloadData];
            }
        }
    }];
    [alert show];
}
#pragma mark - 相册、相机调用方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self localPhoto];
        
    }else if (buttonIndex == 1)
    {
        [self takePhoto];
    }
    else{
        NSLog(@"模拟无效,请真机测试");
    }
}
//开始拍照
-(void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        picker.navigationBar.tintColor = [UIColor whiteColor];
        [self.delegate addUIImagePicker:picker];
    }else{
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
//打开相册，可以多选
-(void)localPhoto{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc]init];
    picker.maximumNumberOfSelection = 10;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.navigationBar.tintColor = [UIColor whiteColor];
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary *bindings){
        if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration]doubleValue];
            return duration >= 3;
        }else{
            return  YES;
        }
    }];
    [self.delegate addPicker:picker];
}
/*
 得到选中的图片
 */
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for ( ALAsset *asset in assets) {
        [pictureAry  addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
        [pictureCollectonView reloadData];
    }
    [pictureCollectonView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:pictureAry.count inSection:0]
                                 atScrollPosition:UICollectionViewScrollPositionNone
                                         animated:NO];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    
    }];
}
//选择某张照片之后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if([type isEqualToString:@"public.image"]){
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        [pictureAry  addObject:image];
        [pictureCollectonView reloadData];
        [pictureCollectonView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:pictureAry.count inSection:0]
                                     atScrollPosition:UICollectionViewScrollPositionNone
                                             animated:NO];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
    
    }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoBrowser:(GKPhotoBrowser *)browser longPressWithIndex:(NSInteger)index {
    NSLog(@"%@",browser.photos[index]);
    if (self.fromView) return;
    UIView *contentView = browser.contentView;
    UIView *fromView = [UIView new];
    fromView.backgroundColor = [UIColor clearColor];
    self.fromView = fromView;
    CGFloat actionSheetH = 0;
    if (self.isLandspace) {
        actionSheetH = 100;
        fromView.frame = contentView.bounds;
        [contentView addSubview:fromView];
    }else {
        actionSheetH = 100 + kSaveBottomSpace;
        fromView.frame = browser.view.bounds;
        [browser.view addSubview:fromView];
    }
    
    UIView *actionSheet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, actionSheetH)];
    actionSheet.backgroundColor = [UIColor whiteColor];
    self.actionSheet = actionSheet;
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, actionSheet.width, 50)];
    [saveBtn setTitle:@"保存图片" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn bk_addEventHandler:^(id sender) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            GKPhoto *photo =  browser.photos[index];
            UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });
    } forControlEvents:UIControlEventTouchUpInside];
    
    saveBtn.backgroundColor = [UIColor whiteColor];
    [actionSheet addSubview:saveBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, actionSheet.width, 50)];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn bk_addEventHandler:^(id sender) {
        [GKCover hideCover];
    } forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [actionSheet addSubview:cancelBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, actionSheet.width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [actionSheet addSubview:lineView];
    
    [GKCover coverFrom:fromView
           contentView:actionSheet
                 style:GKCoverStyleTranslucent
             showStyle:GKCoverShowStyleBottom
         showAnimStyle:GKCoverShowAnimStyleBottom
         hideAnimStyle:GKCoverHideAnimStyleBottom
              notClick:NO
             showBlock:nil
             hideBlock:^{
                 [self.fromView removeFromSuperview];
                 self.fromView = nil;
             }];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"成功保存到相册"];
    }
    [GKCover hideCover];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
