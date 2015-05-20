//
//  PhotoBroswerVC.m
//  CorePhotoBroswer
//
//  Created by 成林 on 15/5/4.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "PhotoBroswerVC.h"
#import "PhotoBroswerLayout.h"
#import "PhotoItemView.h"
#import "UIView+Extend.h"
#import "UIImage+Extend.h"
#import "PBConst.h"
#import "CoreSVP.h"
#import "CoreArchive.h"
#import "PBScrollView.h"
#import "CALayer+Transition.h"



@interface PhotoBroswerVC ()<UIScrollViewDelegate>


/** 外部操作控制器 */
@property (nonatomic,weak) UIViewController *handleVC;


/** 类型 */
@property (nonatomic,assign) PhotoBroswerVCType type;


/** scrollView */
@property (weak, nonatomic) IBOutlet PBScrollView *scrollView;


/** 顶部条管理视图 */
@property (weak, nonatomic) IBOutlet UIView *topBarView;


/** 顶部label */
@property (weak, nonatomic) IBOutlet UILabel *topBarLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarHeightC;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewRightMarginC;




/** 相册数组 */
@property (nonatomic,strong) NSArray *photoModels;

/** 总页数 */
@property (nonatomic,assign) NSUInteger pageCount;

/** page */
@property (nonatomic,assign) NSUInteger page;


/** 上一个页码 */
@property (nonatomic,assign) NSUInteger lastPage;


/** 初始显示的index */
@property (nonatomic,assign) NSUInteger index;


/** 可重用集合 */
@property (nonatomic,strong) NSMutableSet *reusablePhotoItemViewSetM;

/** 显示中视图字典 */
@property (nonatomic,strong) NSMutableDictionary *visiblePhotoItemViewDictM;

/** 要显示的下一页 */
@property (nonatomic,assign) NSUInteger nextPage;

/** drag时的page */
@property (nonatomic,assign) NSUInteger dragPage;

/** 当前显示中的itemView */
@property (nonatomic,weak) PhotoItemView *currentItemView;

@end

@implementation PhotoBroswerVC


+(void)show:(UIViewController *)handleVC type:(PhotoBroswerVCType)type index:(NSUInteger)index photoModelBlock:(NSArray *(^)())photoModelBlock{
    
    //取出相册数组
    NSArray *photoModels = photoModelBlock();
    
    if(photoModels == nil || photoModels.count == 0) return;
    
    NSString *result= [PhotoModel check:photoModels type:type];
    
    if(result !=nil){
        NSLog(@"%@",result);
        return;
    }
    
    
    
    PhotoBroswerVC *pbVC = [[self alloc] init];
    
    if(index >= photoModels.count){
        NSLog(@"错误：index越界！");
        return;
    }
    
    //记录
    pbVC.index = index;
    
    pbVC.photoModels = photoModels;
    
    //记录
    pbVC.type =type;
    
    pbVC.handleVC = handleVC;
    
    //展示
    [pbVC show];
}


/** 真正展示 */
-(void)show{
    
    switch (_type) {
        case PhotoBroswerVCTypePush://push
            
            [self pushPhotoVC];
            
            break;
        case PhotoBroswerVCTypeModal://modal
            
            [self modalPhotoVC];
            
            break;
            
        case PhotoBroswerVCTypeTransition://transition
            
            [self transitionPhotoVC];
            
            break;
            
        case PhotoBroswerVCTypeZoom://zoom
            
            [self zoomPhotoVC];
            
            break;
            
        default:
            break;
    }
}


/** push */
-(void)pushPhotoVC{
    
    [_handleVC.navigationController pushViewController:self animated:YES];
}


/** modal */
-(void)modalPhotoVC{
    
    [_handleVC presentViewController:self animated:YES completion:nil];
}


/** transition */
-(void)transitionPhotoVC{
    [_handleVC.navigationController pushViewController:self animated:NO];
    [_handleVC.navigationController.view.layer transitionWithAnimType:TransitionAnimTypeRamdom subType:TransitionSubtypesFromRamdom curve:TransitionCurveRamdom duration:2.0f];
}


/** zoom */
-(void)zoomPhotoVC{
    
    
    //拿到window
    UIWindow *window = _handleVC.view.window;
    
    if(window == nil){
        
        NSLog(@"错误：窗口为空！");
        return;
    }
    
    PhotoModel *photoModel = self.photoModels[self.index];
    
    photoModel.sourceImageView.hidden = YES;
    
    self.view.frame=[UIScreen mainScreen].bounds;
    
    //添加视图
    [window addSubview:self.view];
    
    //添加子控制器
    [_handleVC addChildViewController:self];
    
    self.topBarView.alpha=0;
    
    [UIView animateWithDuration:.25f animations:^{
        self.topBarView.alpha=1;
    } completion:^(BOOL finished) {
        photoModel.sourceImageView.hidden = NO;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.view.backgroundColor = [UIColor blackColor];
    });
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //控制器准备
    [self vcPrepare];
}




-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}



/*
 *  控制器准备
 */
-(void)vcPrepare{
    
    //去除自动处理
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //每页准备
    [self pagesPrepare];
    
    //间距
    _scrollViewRightMarginC.constant = - PBMargin;
}



/** 每页准备 */
-(void)pagesPrepare{

    __block CGRect frame = [UIScreen mainScreen].bounds;
    
    CGFloat widthEachPage = frame.size.width + PBMargin;

    //展示页码对应的页面
    [self showWithPage:self.index];
    
    //设置contentSize
    self.scrollView.contentSize = CGSizeMake(widthEachPage * self.photoModels.count, 0);

    self.scrollView.index = _index;
}



/*
 *  展示页码对应的页面
 */
-(void)showWithPage:(NSUInteger)page{
    
    //如果对应页码对应的视图正在显示中，就不用再显示了
    if([self.visiblePhotoItemViewDictM objectForKey:@(page)] != nil) return;
    
    //取出重用photoItemView
    PhotoItemView *photoItemView = [self dequeReusablePhotoItemView];
    
    if(photoItemView == nil){//没有取到
        
        //重新创建
        photoItemView = [PhotoItemView viewFromXIB];
    }
    
    NSLog(@"%p",&photoItemView);
    
    //数据覆盖
    photoItemView.ItemViewSingleTapBlock = ^(){
        [self singleTap];
    };
    
    //到这里，photoItemView一定有值，而且一定显示为当前页
    //加入到当前显示中的字典
    [self.visiblePhotoItemViewDictM setObject:photoItemView forKey:@(page)];
    
    //传递数据
    //设置页标
    photoItemView.pageIndex = page;
    photoItemView.type = self.type;
    photoItemView.photoModel = self.photoModels[page];

    [self.scrollView addSubview:photoItemView];
    
    //    [UIView animateWithDuration:.01 animations:^{
    photoItemView.alpha=1;
    //    }];
    
    //这里有一个奇怪的重影bug，必须这样解决

//    photoItemView.hidden=YES;
//    [UIView animateWithDuration:.01 animations:^{
//        photoItemView.alpha=1;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            photoItemView.hidden=NO;
//        });
//    
//    }];
}




-(void)singleTap{
    
    CGFloat h = _topBarView.frame.size.height;
    
    BOOL show = _topBarView.tag == 0;
    
    _topBarView.tag = show?1:0;
    
    _topBarHeightC.constant = show?-h:0;
    
    [UIView animateWithDuration:.25f animations:^{
        
        [_topBarView setNeedsLayout];
        [_topBarView layoutIfNeeded];
    }];
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        
        if([subView isKindOfClass:[PhotoItemView class]]){
            
            PhotoItemView *itemView = (PhotoItemView *)subView;
            
            [itemView handleBotoomView];
        }
    }];
}




/*
 *  scrollView代理方法区
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSUInteger page = [self pageCalWithScrollView:scrollView];
    
    //记录dragPage
    if(self.dragPage == 0) self.dragPage = page;
    
    self.page = page;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    CGFloat pageOffsetX = self.dragPage * scrollView.bounds.size.width;
    
    
    if(offsetX > pageOffsetX){//正在向左滑动，展示右边的页面
        
        if(page >= self.pageCount - 1) return;
        
        self.nextPage = page + 1;
        
    }else if(offsetX < pageOffsetX){//正在向右滑动，展示左边的页面
        
        if(page == 0) return;
        
        self.nextPage = page - 1;
    }
}




-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSUInteger page = [self pageCalWithScrollView:scrollView];
    
    [self reuserAndVisibleHandle:page];
}



-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //重围
    self.dragPage = 0;
}



-(void)reuserAndVisibleHandle:(NSUInteger)page{
    
    //遍历可视视图字典，除了page之外的所有视图全部移除，并加入重用集合
    [self.visiblePhotoItemViewDictM enumerateKeysAndObjectsUsingBlock:^(NSValue *key, PhotoItemView *photoItemView, BOOL *stop) {
        
        if(![key isEqualToValue:@(page)]){
            
            photoItemView.zoomScale=1;
            
            photoItemView.alpha=0;
            
            [self.reusablePhotoItemViewSetM addObject:photoItemView];
            
            [self.visiblePhotoItemViewDictM removeObjectForKey:key];
        }
    }];
}






-(NSUInteger)pageCalWithScrollView:(UIScrollView *)scrollView{
    
    NSUInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width + .5f;
    
    return page;
}






-(void)setPhotoModels:(NSArray *)photoModels{
    
    _photoModels = photoModels;
    
    self.pageCount = photoModels.count;
    
    //设置源frame标记，以获得动画效果
    PhotoModel *sourcePhotoModel= photoModels[_index];
    sourcePhotoModel.isFromSourceFrame = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //初始化页码信息
        self.page = _index;
    });
}



-(void)setPage:(NSUInteger)page{
    
    if(_page !=0 && _page == page) return;
    
    _lastPage = page;
    
    _page = page;
    
    //设置标题
    NSString *text = [NSString stringWithFormat:@"%@ / %@", @(page + 1) , @(self.pageCount)];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        self.topBarLabel.text = text;
        [self.topBarLabel setNeedsLayout];
        [self.topBarLabel layoutIfNeeded];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //显示对应的页面
        [self showWithPage:page];
        
        //获取当前显示中的photoItemView
        self.currentItemView = [self.visiblePhotoItemViewDictM objectForKey:@(self.page)];
    });
}






-(UIStatusBarStyle)preferredStatusBarStyle{
 
    return UIStatusBarStyleLightContent;
}


- (IBAction)leftBtnClick:(id)sender {
    
    [self dismiss];
}

- (IBAction)rightBtnClick:(id)sender {
    
    //取出itemView
    PhotoItemView *itemView = self.currentItemView;
    
    //取出对应模型
    PhotoModel *itemModel = (PhotoModel *)self.photoModels[self.page];
    
    if(!itemView.hasImage){
        [CoreSVP showSVPWithType:CoreSVPTypeError Msg:@"无图片数据" duration:1.0f allowEdit:NO beginBlock:nil completeBlock:nil];
        return;
    }
    
    //读取缓存
    if([itemModel read]){//已经保存过本地
        
        [CoreSVP showSVPWithType:CoreSVPTypeInfo Msg:@"图片已存" duration:1.0f allowEdit:NO beginBlock:nil completeBlock:nil];
    }else{
        
        //展示提示框
        [CoreSVP showSVPWithType:CoreSVPTypeLoadingInterface Msg:@"保存中" duration:0 allowEdit:NO beginBlock:nil completeBlock:nil];
        
        [itemView save:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [CoreSVP showSVPWithType:CoreSVPTypeSuccess Msg:@"保存成功" duration:1.0f allowEdit:NO beginBlock:nil completeBlock:nil];
                
                //保存记录
                [itemModel save];
            });
            
            
        } failBlock:^{
            
            [CoreSVP showSVPWithType:CoreSVPTypeError Msg:@"保存失败" duration:1.0f allowEdit:NO beginBlock:nil completeBlock:nil];
        }];
    }
}


-(void)setIndex:(NSUInteger)index{
    _index = index ;
}



/** 取出可重用照片视图 */
-(PhotoItemView *)dequeReusablePhotoItemView{
    
    PhotoItemView *photoItemView = [self.reusablePhotoItemViewSetM anyObject];
    
    if(photoItemView != nil){
        
        //从可重用集合中移除
        [self.reusablePhotoItemViewSetM removeObject:photoItemView];
        
        [photoItemView reset];
    }
    
    return photoItemView;
}





/** 可重用集合 */
-(NSMutableSet *)reusablePhotoItemViewSetM{
    
    if(_reusablePhotoItemViewSetM ==nil){
        _reusablePhotoItemViewSetM =[NSMutableSet set];
    }
    
    return _reusablePhotoItemViewSetM;
}


/** 显示中视图字典 */
-(NSMutableDictionary *)visiblePhotoItemViewDictM{
    
    if(_visiblePhotoItemViewDictM == nil){
        
        _visiblePhotoItemViewDictM = [NSMutableDictionary dictionary];
    }
    
    return _visiblePhotoItemViewDictM;
}


-(void)setNextPage:(NSUInteger)nextPage{
    
    if(_nextPage == nextPage) return;
    
    _nextPage = nextPage;
    
    [self showWithPage:nextPage];
}




-(void)dismiss{
    
    
    
    switch (_type) {
        case PhotoBroswerVCTypePush://push

            [self.navigationController popViewControllerAnimated:YES];
            break;
        case PhotoBroswerVCTypeModal://modal
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        case PhotoBroswerVCTypeTransition://transition
            
            [_handleVC.navigationController.view.layer transitionWithAnimType:TransitionAnimTypeRamdom subType:TransitionSubtypesFromRamdom curve:TransitionCurveRamdom duration:2.0f];
            [self.navigationController popViewControllerAnimated:NO];
            break;
            
        case PhotoBroswerVCTypeZoom://zoom
        {
            self.view.backgroundColor = [UIColor clearColor];
            
            if(self.currentItemView.zoomScale>1){
                
                self.currentItemView.zoomScale=1;
                self.view.userInteractionEnabled = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.view.userInteractionEnabled = YES;
                    [self zoomOut];
                });
                
            }else{
                
                [self zoomOut];
            }
        }

            break;
            
        default:
            break;
    }
}


-(void)zoomOut{
    
    [UIView animateWithDuration:.4f animations:^{
        self.topBarView.alpha=0;
    }];
    
    
    PhotoModel *photoModel = self.photoModels[self.page];
    
    CGRect sourceF = photoModel.sourceFrame;
    
    //检查sourceF是否在屏幕里面
    CGRect screenF =[UIScreen mainScreen].bounds;
    
    BOOL isInScreen = CGRectIntersectsRect(sourceF, screenF);
    
    if(self.currentItemView == nil) isInScreen = NO;
    
    if(isInScreen){
        
        NSLog(@"currentItemView:%@",self.currentItemView);
        
        [self.currentItemView zoomDismiss:^{
            
            [self zoomOutHandle];
        }];
        
    }else{
        
        [UIView animateWithDuration:.5f animations:^{
            
            self.view.transform= CGAffineTransformMakeScale(1.2, 1.2);
            self.view.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [self zoomOutHandle];
        }];
    }
}


-(void)zoomOutHandle{
    
    _handleVC =nil;
    
    self.photoModels = nil;
    
    //移除视图
    [self.view removeFromSuperview];
    
    self.view = nil;
    
    //移除
    [self removeFromParentViewController];
}


@end
