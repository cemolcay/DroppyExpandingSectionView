//
//  DroppyExpandingSectionView.h
//  DroppyExpandingSectionView
//
//  Created by Cem Olcay on 22/10/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DroppySection.h"


@protocol DroppyExpandingSectionViewDataSource;


@interface DroppyExpandingSectionView : UIScrollView <DroppySectionDelegate>

@property (nonatomic, weak) id<DroppyExpandingSectionViewDataSource> droppyDataSource;

- (void)expandSection:(NSInteger)section;
- (void)collapseSection:(NSInteger)section;

- (void)reloadData;

@end


@protocol DroppyExpandingSectionViewDataSource <NSObject>

@required

- (NSInteger)numberOfSectionsInDroppyExpandingSectionView:(DroppyExpandingSectionView *)droppy;
- (NSInteger)droppyExpandingSectionView:(DroppyExpandingSectionView *)droppy numberOfViewsInSection:(NSInteger)section;

- (UIView *)droppyExpandingSectionView:(DroppyExpandingSectionView *)droppy sectionHeaderViewAtSection:(NSInteger)section;
- (UIView *)droppyExpandingSectionView:(DroppyExpandingSectionView *)droppy viewForSection:(NSInteger)section atIndex:(NSInteger)index;


@optional

- (CGFloat)paddingBetweenSectionsInDroppyExpandingSectionView:(DroppyExpandingSectionView *)droppy;  // default 10
- (CGFloat)paddingBetweenViewsInDroppyExpandingSectionView:(DroppyExpandingSectionView *)droppy;     // default 10

@end
