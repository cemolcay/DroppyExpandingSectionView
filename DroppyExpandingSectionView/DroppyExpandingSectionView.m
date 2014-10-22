//
//  DroppyExpandingSectionView.m
//  DroppyExpandingSectionView
//
//  Created by Cem Olcay on 22/10/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

#import "DroppyExpandingSectionView.h"


#pragma mark - DroppyExpandingSectionView

@interface DroppyExpandingSectionView ()

@property (nonatomic, strong) NSMutableArray *sections;

@property (nonatomic, assign) CGFloat sectionPadding;
@property (nonatomic, assign) CGFloat sectionViewPadding;

@end

@implementation DroppyExpandingSectionView


#pragma mark Lifecycle 

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.contentSize = CGSizeMake([self w], self.sectionPadding);
    }
    return self;
}


#pragma mark Expand/Collapse

- (void)expandSection:(NSInteger)section {
    [(DroppySection *)[self.sections objectAtIndex:section] expand];
}

- (void)collapseSection:(NSInteger)section {
    [(DroppySection *)[self.sections objectAtIndex:section] collapse];
}


#pragma mark DroppySectionDelegate

- (void)didExpandDroppySection:(DroppySection *)droppySection {
    CGFloat moveAmount = [droppySection contentHeight];
    
    for (NSInteger i = droppySection.index+1; i < self.sections.count; i++) {
        [(DroppySection *)[self.sections objectAtIndex:i] moveY:moveAmount];
    }
    
    [self updateContentSize];
    
    CGFloat sectionY = [droppySection.headerView y];
    CGFloat bottom = self.contentSize.height - [self h];
    [self setContentOffset:CGPointMake(self.contentOffset.x, MIN(sectionY, MAX(bottom, 0))) animated:YES];
}

- (void)didCollapseDroppySection:(DroppySection *)droppySection {
    CGFloat moveAmount = [droppySection contentHeight];
    
    for (NSInteger i = droppySection.index+1; i < self.sections.count; i++) {
        [(DroppySection *)[self.sections objectAtIndex:i] moveY:-moveAmount];
    }
    
    [self updateContentSize];
}

#pragma mark DataSource

- (void)reloadData {

    // Loop Sections
    self.sections = [[NSMutableArray alloc] init];
    NSInteger sectionCount = [self.droppyDataSource numberOfSectionsInDroppyExpandingSectionView:self];
    for (int section = 0; section < sectionCount; section++) {
        
        // Create Droppy Section
        UIView *sectionHeaderView = [self.droppyDataSource droppyExpandingSectionView:self sectionHeaderViewAtSection:section];
        [sectionHeaderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTapped:)]];
        
        DroppySection *droppySection = [[DroppySection alloc] initWithHeaderView:sectionHeaderView index:section andPadding:self.sectionViewPadding];
        [droppySection setDelegate:self];
        
        // Create Section Views
        NSInteger viewsCount = [self.droppyDataSource droppyExpandingSectionView:self numberOfViewsInSection:section];
        for (int index = 0; index < viewsCount; index++) {
            UIView *sectionView = [self.droppyDataSource droppyExpandingSectionView:self viewForSection:section atIndex:index];
            [droppySection addView:sectionView];
        }
        
        [self addDroppySection:droppySection];
    }
}

- (void)addDroppySection:(DroppySection *)droppySection {
    UIView *view = [droppySection headerView];
    [view setY:[self currentHeight]];
    [self addSubview:view];
    
    [self.sections addObject:droppySection];
    [self updateContentSize];
}


#pragma mark Utils

- (void)updateContentSize {
    CGFloat height = self.sectionPadding;
    
    for (int i = 0; i < self.sections.count; i++) {
        DroppySection *section = (DroppySection *)[self.sections objectAtIndex:i];
        height += section.currentHeight + self.sectionPadding;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self setContentSize:CGSizeMake([self w], height)];
    }];
}

- (CGFloat)currentHeight {
    return self.contentSize.height;
}


#pragma mark Properties

- (CGFloat)sectionPadding {
    if ([self.droppyDataSource respondsToSelector:@selector(paddingBetweenSectionsInDroppyExpandingSectionView:)]) {
        return [self.droppyDataSource paddingBetweenSectionsInDroppyExpandingSectionView:self];
    } else {
        return 10;
    }
}

- (CGFloat)sectionViewPadding {
    if ([self.droppyDataSource respondsToSelector:@selector(paddingBetweenViewsInDroppyExpandingSectionView:)]) {
        return [self.droppyDataSource paddingBetweenViewsInDroppyExpandingSectionView:self];
    } else {
        return 10;
    }
}

- (void)setDroppyDataSource:(id<DroppyExpandingSectionViewDataSource>)droppyDataSource {
    _droppyDataSource = droppyDataSource;
    [self reloadData];
}

@end
