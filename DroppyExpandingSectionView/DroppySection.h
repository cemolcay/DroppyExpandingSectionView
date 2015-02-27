//
//  DroppySection.h
//  DroppyExpandingSectionView
//
//  Created by Cem Olcay on 22/10/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol DroppySectionDelegate;


@interface UIView (Droppy)

- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)w;
- (CGFloat)h;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setW:(CGFloat)w;
- (void)setH:(CGFloat)h;

- (void)moveYBy:(CGFloat)yAmount;
- (void)rotateYFrom:(CGFloat)from to:(CGFloat)to;
- (void)alphaFrom:(CGFloat)from to:(CGFloat)to;

- (void)moveYBy:(CGFloat)yAmount duration:(NSTimeInterval)duration complication:(void(^)(BOOL finished))complate;
- (void)rotateYFrom:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration complication:(void(^)(BOOL finished))complate;
- (void)alphaFrom:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration complication:(void(^)(BOOL finished))complate;

@end


@interface DroppySection : UIView

@property (nonatomic, weak) id<DroppySectionDelegate> delegate;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray *views;

@property (nonatomic, strong) UIImageView *disclosureImageView;

@property (nonatomic, assign, getter=isExpanding) BOOL expanding;
@property (nonatomic, assign, getter=isExpanded) BOOL expanded;

@property (nonatomic, assign) CGFloat contentHeight;    //height sum of views
@property (nonatomic, assign) CGFloat headerHeight;     //header height
@property (nonatomic, assign) CGFloat totalHeight;      //content+header

@property (nonatomic, assign) CGFloat padding;          //padding between section items


- (CGFloat)currentHeight;                               //if expanded return total else return header height

- (void)expand;
- (void)collapse;

- (void)moveY:(CGFloat)y;

- (void)addView:(UIView *)view;

- (instancetype)initWithHeaderView:(UIView *)headerView index:(NSInteger)index andPadding:(CGFloat)padding;

@end


@protocol DroppySectionDelegate <NSObject>

- (void)didExpandDroppySection:(DroppySection *)droppySection;
- (void)didCollapseDroppySection:(DroppySection *)droppySection;

@end