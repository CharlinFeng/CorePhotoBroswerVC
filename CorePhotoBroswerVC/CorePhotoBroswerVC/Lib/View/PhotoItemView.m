//
//  PhotoItemView.m
//  CorePhotoBroswerVC
//
//  Created by 冯成林 on 15/5/5.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "PhotoItemView.h"
#import "UIView+Extend.h"
#import "UIView+PBExtend.h"
#import "PBPGView.h"
#import "PBBlurImageView.h"
#import "PBConst.h"
#import "UIImage+Extend.h"
#import "UIImageView+SD.h"




@interface PhotoItemView ()<UIScrollViewDelegate>{
    CGFloat _zoomScale;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet PBPGView *progressView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMarginC;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMarginC;

@property (weak, nonatomic) IBOutlet UIView *bgView;



/** view的单击 */
@property (nonatomic,strong) UITapGestureRecognizer *tap_single_viewGesture;

/** view的单击 */
@property (nonatomic,strong) UITapGestureRecognizer *tap_double_viewGesture;

/** imageView的双击 */
@property (nonatomic,strong) UITapGestureRecognizer *tap_double_imageViewGesture;

/** 旋转手势 */
@property (nonatomic,strong) UIRotationGestureRecognizer *rotaGesture;










/** 双击放大 */
@property (nonatomic,assign) BOOL isDoubleClickZoom;


@end


@implementation PhotoItemView


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    //数据准备
    [self dataPrepare];
    
    //添加手势
    [self addGestureRecognizer:self.tap_single_viewGesture];
    [self addGestureRecognizer:self.tap_double_viewGesture];
    [self addGestureRecognizer:self.tap_double_imageViewGesture];
}

-(void)setPhotoModel:(PhotoModel *)photoModel{
    
    _photoModel = photoModel;
    
    if(photoModel == nil) return;
    
    //数据准备
    [self dataPrepare];
}

/*
 *  数据准备
 */
-(void)dataPrepare{
    
    if(self.photoModel == nil) return;
    
    BOOL isNetWorkShow = _photoModel.image == nil;
    
    if(isNetWorkShow){//网络请求
        
        //创建imageView
        UIImage *image = [UIImage phImageWithSize:[UIScreen mainScreen].bounds.size zoom:.3f];
        
        self.photoImageView.image = image;
        
        if(image == nil) return;
        
        [self.photoImageView imageWithUrlStr:_photoModel.image_HD_U phImage:image progressBlock:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            _progressView.hidden = NO;
            
            CGFloat progress = receivedSize /((CGFloat)expectedSize);
            
            _progressView.progress = progress;
            
        } completedBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            self.hasImage = image !=nil;
            
            if(image!=nil && _progressView.progress <1.0f) {
                _progressView.progress = 1.0f;
            }
        }];
    }else{
        
        self.photoImageView.image = _photoModel.image;
        
        //标记
        self.hasImage = YES;
    }

    self.scrollView.contentSize = self.photoImageView.frame.size;

    
    self.photoImageView.frame = self.photoModel.sourceFrame;
    
    if(self.photoModel.isFromSourceFrame && self.type == PhotoBroswerVCTypeZoom){
        
        self.bgView.alpha = 0;
        
        CGFloat timeInterval = .52f;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:timeInterval-.3f animations:^{
                self.bgView.alpha = 1;
                self.bgView.backgroundColor = [UIColor blackColor];
            }];
        });
        
        [UIView animateWithDuration:timeInterval delay:0 usingSpringWithDamping:.52f initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.photoImageView.frame = self.photoImageView.calF;
            
        } completion:nil];
        
        //删除标记
        self.photoModel.isFromSourceFrame = NO;
        
    }else{
       self.photoImageView.frame = self.photoImageView.calF; 
    }


    //标题
    _titleLabel.text = _photoModel.title;
    _descLabel.text = _photoModel.desc;
}



-(PhotoImageView *)photoImageView{
    
    if(_photoImageView == nil){
        
        _photoImageView = [[PhotoImageView alloc] init];
        
        _photoImageView.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:_photoImageView];
    }
    
    return _photoImageView;
}








/*
 *  事件处理
 */
/*
 *  view单击
 */
-(void)tap_single_viewTap:(UITapGestureRecognizer *)tap{
    [self tap_view];
}

/*
 *  view双击
 */
-(void)tap_double_viewTap:(UITapGestureRecognizer *)tap{
    [self tap_view];
}

-(void)tap_view{
    if(_ItemViewSingleTapBlock != nil) _ItemViewSingleTapBlock();
}


/*
 *  imageView双击
 */
-(void)tap_double_imageViewTap:(UITapGestureRecognizer *)tap{
    
    if(!self.hasImage) return;
    
    //标记
    self.isDoubleClickZoom = YES;
    
    CGFloat zoomScale = self.scrollView.zoomScale;
    
    if(zoomScale<=1.0f){
        
        CGPoint loc = [tap locationInView:tap.view];
        
        CGFloat wh =1;
        
        CGRect rect = [UIView frameWithW:wh h:wh center:loc];
        
        [self.scrollView zoomToRect:rect animated:YES];
    }else{
        [self.scrollView setZoomScale:1.0f animated:YES];
    }
}



/*
 *  旋转手势
 */
-(void)rota:(UIRotationGestureRecognizer *)rotaGesture{
    
    NSLog(@"旋转");
    self.photoImageView.transform = CGAffineTransformRotate(rotaGesture.view.transform, rotaGesture.rotation);
    rotaGesture.rotation = 0;
}





/*
 *  处理bottomView
 */
-(void)handleBotoomView{
    
    CGFloat h = _bottomView.frame.size.height;
    
    BOOL show = _bottomView.tag == 0;
    
    _bottomView.tag = show?1:0;
    
    _bottomMarginC.constant = show?-h:0;
    
    [UIView animateWithDuration:.25f animations:^{
        
        [_bottomView setNeedsLayout];
        [_bottomView layoutIfNeeded];
    }];
    
}









/*
 *  代理方法区
 */
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.photoImageView;
}





-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    if(scrollView.zoomScale <=1) scrollView.zoomScale = 1.0f;
    
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;

    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
    [self.photoImageView setCenter:CGPointMake(xcenter, ycenter)];
}



/** 懒加载 */

/*
 *  view单击
 */
-(UITapGestureRecognizer *)tap_single_viewGesture{
    
    if(_tap_single_viewGesture == nil){
        
        _tap_single_viewGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_single_viewTap:)];
        [_tap_single_viewGesture requireGestureRecognizerToFail:self.tap_double_imageViewGesture];
        [_tap_single_viewGesture requireGestureRecognizerToFail:self.tap_double_viewGesture];
    }
    
    return _tap_single_viewGesture;
}




/*
 *  view双击
 */
-(UITapGestureRecognizer *)tap_double_viewGesture{
    
    if(_tap_double_viewGesture == nil){
        
        _tap_double_viewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_double_viewTap:)];
        [_tap_double_viewGesture requireGestureRecognizerToFail:self.tap_double_imageViewGesture];
        _tap_double_viewGesture.numberOfTapsRequired = 2;
    }
    
    return _tap_double_viewGesture;
}





/*
 *  imageView单击
 */
-(UITapGestureRecognizer *)tap_double_imageViewGesture{
    
    if(_tap_double_imageViewGesture == nil){
        
        _tap_double_imageViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_double_imageViewTap:)];
        _tap_double_imageViewGesture.numberOfTapsRequired = 2;
    }
    
    return _tap_double_imageViewGesture;
}



/*
 *  保存图片及回调
 */
-(void)save:(void(^)())ItemImageSaveCompleteBlock failBlock:(void(^)())failBlock{
    
    if(self.photoImageView.image == nil){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(failBlock != nil) failBlock();
        });
        return;
    }

    [self.photoImageView.image savedPhotosAlbum:ItemImageSaveCompleteBlock failBlock:failBlock];
}


-(UIRotationGestureRecognizer *)rotaGesture{
    
    if(_rotaGesture==nil){
        
        _rotaGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rota:)];
    }
    
    return _rotaGesture;
}



/*
 *  重置
 */
-(void)reset{
    
    //缩放比例
    self.scrollView.zoomScale = 1.0f;
    
    //默认无图
    self.hasImage = NO;
    self.photoImageView.frame=CGRectZero;
}


-(CGRect)itemImageViewFrame{
    
    return self.photoImageView.frame;
}



-(void)zoomDismiss:(void(^)())compeletionBlock{
    
    //隐藏图片
    self.photoModel.sourceImageView.hidden = YES;
    
    [UIView animateWithDuration:.4f animations:^{
        
        self.bgView.alpha=0;
        
        self.bottomView.alpha=0;
    }];
    
    
    [UIView animateWithDuration:.5f delay:0 usingSpringWithDamping:.6f initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.photoImageView.contentMode = self.photoModel.sourceImageView.contentMode;
        self.photoImageView.frame = self.photoModel.sourceFrame;
        self.photoImageView.clipsToBounds = YES;
    } completion:^(BOOL finished) {
        
        //显示图片
        self.photoModel.sourceImageView.hidden = NO;
        
        if(finished && compeletionBlock!=nil) compeletionBlock();
    }];
}



-(CGFloat)zoomScale{
    return self.scrollView.zoomScale;
}

-(void)setZoomScale:(CGFloat)zoomScale{
    _zoomScale = zoomScale;
    [self.scrollView setZoomScale:zoomScale animated:YES];
}



@end
