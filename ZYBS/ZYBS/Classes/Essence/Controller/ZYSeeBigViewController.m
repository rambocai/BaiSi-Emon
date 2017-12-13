//
//  ZYSeeBigViewController.m
//  ZYBS
//
//  Created by 竹雨 on 2017/7/13.
//  Copyright © 2017年 竹雨. All rights reserved.
//

#import "ZYSeeBigViewController.h"
#import "ZYTopic.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>

#import <Photos/Photos.h> // iOS9开始推荐

@interface ZYSeeBigViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation ZYSeeBigViewController

// 相簿名称
static NSString * ZYAssetCollectionTitle = @"百思";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.frame = [UIScreen mainScreen].bounds;
    [self.view insertSubview:scrollView atIndex:0];
    
    //scrollView.backgroundColor = [UIColor redColor];
    //scrollView.frame = self.view.bounds;
    //scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    // imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    //[imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return; // 图片下载失败
        self.saveButton.enabled = YES;
    }];
    [scrollView addSubview:imageView];
    
    imageView.zy_width = scrollView.zy_width;
    imageView.zy_height = self.topic.height * imageView.zy_width / self.topic.width;
    imageView.zy_x = 0;
    
    if (imageView.zy_height >= scrollView.zy_height) { // 图片高度超过整个屏幕
        imageView.zy_y = 0;
        // 滚动范围
        scrollView.contentSize = CGSizeMake(0, imageView.zy_height);
    } else { // 居中显示
        imageView.zy_centerY = scrollView.zy_height * 0.5;
    }
    self.imageView = imageView;
    
    // 缩放比例
    CGFloat scale =  self.topic.width / imageView.zy_width;
    if (scale > 1.0) {
        scrollView.maximumZoomScale = scale;
    }
    
    // Do any additional setup after loading the view from its nib.
}

// 返回一个scrollView的子控件进行缩放
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存图片到相册
- (IBAction)save {
    //UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    /*
     PHAuthorizationStatusNotDetermined,     用户还没有做出选择
     PHAuthorizationStatusDenied,            用户拒绝当前应用访问相册(用户当初点击了"不允许")
     PHAuthorizationStatusAuthorized         用户允许当前应用访问相册(用户当初点击了"好")
     PHAuthorizationStatusRestricted,        因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
     */
    // 0.判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) {
        // 家长控制
        [SVProgressHUD showErrorWithStatus:@"因为系统原因, 无法访问相册"];
    } else if (status == PHAuthorizationStatusDenied) {
        // 用户当初点击了"不允许"
        ZYLog(@"提醒用户去[设置-隐私-照片-xxx]打开访问开关");
    } else if (status == PHAuthorizationStatusAuthorized) {
        // 用户当初点击了"好"
        [self saveImage];
    } else if (status == PHAuthorizationStatusNotDetermined) {
        // 用户还没有做出选择
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                // 用户同意访问
                [self saveImage];
            }
        }];
    }
}



/*
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    ZYLogFunc;
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"图片保存失败!"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"图片保存成功!"];
    }
}
*/

/*
- (void)saveImage {
    
    // PHAsset : 一个资源, 比如一张图片\一段视频
    // PHAssetCollection : 一个相簿
    
    // PHAssetCollection的标识, 利用这个标识可以找到对应的PHAssetCollection对象(相簿对象)
    __block NSString *assetCollectionLocalIdentifier = nil;
    // PHAsset的标识, 利用这个标识可以找到对应的PHAsset对象(图片对象)
    __block NSString *assetLocalIdentifier = nil;
    // 如果想对"相册"进行修改(增删改), 那么修改代码必须放在[PHPhotoLibrary sharedPhotoLibrary]的performChanges方法的block中
    
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 1.保存到"相机胶卷"中
        // 创建图片的请求
        assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success == NO) {
            ZYLog(@"保存[图片]到[相机胶卷]中失败!失败信息-%@", error);
            return;
        }
        // 获得曾经创建过的相簿
        PHAssetCollection *createdAssetCollection = [self createdAssetCollection];
        if (createdAssetCollection) {
            // 曾经创建过相簿
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                // 3.添加"相机胶卷"中的图片到"相簿"中
                // 获得图片
                PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
                // 添加图片到相簿中的请求
                PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
                // 添加图片到相簿
                [request addAssets:@[asset]];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success == NO) {
                    ZYLog(@"添加[图片]到[相簿]失败!失败信息-%@", error);
                } else {
                    ZYLog(@"成功添加[图片]到[相簿]!");
                }
            }];
        } else {
            // 2.创建"相簿"
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                // 创建相簿的请求
                assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:ZYAssetCollectionTitle].placeholderForCreatedAssetCollection.localIdentifier;
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success == NO) {
                    ZYLog(@"保存相簿失败!失败信息-%@", error);
                    return;
                }
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    // 3.添加"相机胶卷"中的图片到"相簿"中
                    // 获得相簿
                    PHAssetCollection *assetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
                    // 获得图片
                    PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
                    // 添加图片到相簿中的请求
                    PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                    // 添加图片到相簿
                    [request addAssets:@[asset]];
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    if (success == NO) {
                        ZYLog(@"添加[图片]到[相簿]失败!失败信息-%@", error);
                    } else {
                        ZYLog(@"成功添加[图片]到[相簿]!");
                    }
                }];
            }];
        }
    }];
}
// 获取曾经创建过的相簿
- (PHAssetCollection *)createdAssetCollection {
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:ZYAssetCollectionTitle]) {
            return assetCollection;
        }
    }
    return nil;
}
*/

#pragma mark - 优化

- (void)saveImage {
    
    // PHAsset的标识,(图片对象)
    __block NSString *assetLocalIdentifier = nil;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 1.保存到"相机胶卷"中
        // 创建图片的请求
        assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success == NO) {
            [self showError:@"保存图片失败!"];
            return;
        }
        
        // 2.获取"相簿"
        PHAssetCollection *createdAssetCollection = [self createdAssetCollection];
        if (createdAssetCollection == nil) {
            [self showError:@"创建相簿失败!"];
            return;
        }
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            // 3.添加"相机胶卷"中的图片到"相簿"中
            // 获得图片
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
            // 添加图片到相簿中的请求
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
            // 添加图片到相簿
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success == NO) {
                [self showError:@"保存图片失败!"];;
            } else {
                [self showSuccess:@"保存图片成功!"];;
            }
        }];
    }];
}

// 获取相簿
- (PHAssetCollection *)createdAssetCollection {
    // 从已存在相簿中查找这个应用对应的相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:ZYAssetCollectionTitle]) {
            return assetCollection;
        }
    }
    // 没有找到对应的相簿, 得创建新的相簿
    // 错误信息
    NSError *error = nil;
    
    __block NSString *assetCollectionLocalIdentifier = nil;
    // 2.创建"相簿"
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 创建相簿的请求
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:ZYAssetCollectionTitle].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    // 如果有错误信息
    if (error) return nil;
    // 获得刚才创建的相簿
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
}


- (void)showSuccess:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:text];
    });
}

- (void)showError:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:text];
    });
}


@end
