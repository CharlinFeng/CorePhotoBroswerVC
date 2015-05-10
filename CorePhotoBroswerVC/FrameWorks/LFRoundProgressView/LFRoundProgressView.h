//
//  LFRoundProgressView.h
//  LFRoundProgressView
//
//  Created by Matej Bukovinski on 2.4.09. detail see MBProgressHUD
//  Version 1.0
//  modified by shiqiang on 14/1/3.
//

#import <UIKit/UIKit.h>

#ifndef MB_STRONG
#if __has_feature(objc_arc)
    #define MB_STRONG strong
#else
    #define MB_STRONG retain
#endif
#endif

/**
 * A progress view for showing definite progress by filling up a circle (pie chart).
 */
@interface LFRoundProgressView : UIView

/**
 * Progress (0.0 to 1.0)
 */
@property (nonatomic, assign) float progress;

/**
 * Indicator progress color.
 * Defaults to white [UIColor whiteColor]
 */
@property (nonatomic, MB_STRONG) UIColor *progressTintColor UI_APPEARANCE_SELECTOR;

/**
 * Defaults as white [UIColor whiteColor]
 * NO = annular. progressBackgroundColor is affect.
 */
@property (nonatomic, MB_STRONG) UIColor *progressBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 * Indicator background (non-progress) color.
 * Defaults to translucent white (alpha 0.1)
 */
@property (nonatomic, MB_STRONG) UIColor *backgroundTintColor UI_APPEARANCE_SELECTOR;


/*
 * show or hide text percent in center(e.g 68%) - NO = hide or YES = show. Defaults to hide.
 */
@property (nonatomic, assign) BOOL percentShow;// Can not use BOOL with UI_APPEARANCE_SELECTOR :-(

/**
 *  default is [UIColor whiteColor]
 */
@property (nonatomic, MB_STRONG) UIColor *percentLabelTextColor UI_APPEARANCE_SELECTOR;
/**
 *  default is [UIFont boldSystemFontOfSize:12.f]
 */
@property (nonatomic, MB_STRONG) UIFont *percentLabelFont UI_APPEARANCE_SELECTOR;


/*
 * Display mode - NO = round or YES = annular. Defaults to annular.
 */
@property (nonatomic, assign) BOOL annular;// Can not use BOOL with UI_APPEARANCE_SELECTOR :-(

/*
 * YES = annular. annularLineCapStyle is affect.
 */
@property (nonatomic, assign) CGLineCap annularLineCapStyle UI_APPEARANCE_SELECTOR;

/**
 * Progress (0.0 to 8.0) default 4.0f
 */
@property (nonatomic, assign) CGFloat annularLineWith UI_APPEARANCE_SELECTOR;



@end
