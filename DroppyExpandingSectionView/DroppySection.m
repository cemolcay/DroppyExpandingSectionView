//
//  DroppySection.m
//  DroppyExpandingSectionView
//
//  Created by Cem Olcay on 22/10/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

#import "DroppySection.h"


#define SpringDamping   0.5
#define SpringVelocity  0.1
#define Duration        0.5

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))


#pragma mark - DroppyView

@implementation UIView (Droppy)


#pragma mark Getters

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)w {
    return self.frame.size.width;
}

- (CGFloat)h {
    return self.frame.size.height;
}


#pragma mark Setters

- (void)setX:(CGFloat)x {
    [self setFrame:(CGRect){{x, [self y]}, {[self w], [self h]}}];
}

- (void)setY:(CGFloat)y {
    [self setFrame:(CGRect){{[self x], y}, {[self w], [self h]}}];
}

- (void)setW:(CGFloat)w {
    [self setFrame:(CGRect){{[self x], [self y]}, {w, [self h]}}];
}

- (void)setH:(CGFloat)h {
    [self setFrame:(CGRect){{[self x], [self y]}, {[self w], h}}];
}

- (void)setRotationY:(CGFloat)y {
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -1000.0;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, DEGREES_TO_RADIANS(y), 1.0f, 0.0f, 0.0f);
    
    self.layer.transform = rotationAndPerspectiveTransform;
}

- (void)addH:(CGFloat)h {
    [self setH:[self h] + h];
}

#pragma mark Custom Animations

- (void)moveYBy:(CGFloat)yAmount duration:(NSTimeInterval)duration complication:(void(^)(BOOL finished))complate {
    [self animate:^{
        [self setY:[self y] + yAmount];
    } duration:duration
     complication:complate];
}

- (void)rotateYFrom:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration complication:(void(^)(BOOL finished))complate {
    [self setRotationY:from];
    [self animate:^{
        [self setRotationY:to];
    } duration:duration
     complication:complate];
}

- (void)alphaFrom:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration complication:(void(^)(BOOL finished))complate {
    [self setAlpha:from];
    [UIView animateWithDuration:duration animations:^{
        [self setAlpha:to];
    } completion:complate];
}


#pragma mark Makro Duration Animations

- (void)moveYBy:(CGFloat)yAmount {
    [self animate:^{
        [self setY:[self y] + yAmount];
    }];
}

- (void)rotateYFrom:(CGFloat)from to:(CGFloat)to {
    [self setRotationY:from];
    [self animate:^{
        [self setRotationY:to];
    }];
}

- (void)alphaFrom:(CGFloat)from to:(CGFloat)to {
    [self setAlpha:from];
    [UIView animateWithDuration:Duration animations:^{
        [self setAlpha:to];
    }];
}


#pragma mark Animation Utils

- (void)animate:(void(^)())animations {
    [UIView animateWithDuration:Duration delay:0 usingSpringWithDamping:SpringDamping initialSpringVelocity:SpringVelocity options:kNilOptions animations:animations completion:nil];
}

- (void)animate:(void(^)())animations duration:(NSTimeInterval)duration complication:(void(^)(BOOL))complate {
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:SpringDamping initialSpringVelocity:SpringVelocity options:kNilOptions animations:animations completion:complate];
}

@end


@implementation DroppySection

- (instancetype)initWithHeaderView:(UIView *)headerView index:(NSInteger)index andPadding:(CGFloat)padding {
    if ((self = [super init])) {
        self.headerView = headerView;
        self.index = index;
        self.padding = padding;
        
        self.views = [[NSMutableArray alloc] init];
        self.expanded = NO;
        self.expanding = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTapped:)];
        [headerView addGestureRecognizer:tap];
        [headerView setUserInteractionEnabled:YES];
    }
    return self;
}


- (void)sectionTapped:(UITapGestureRecognizer *)tap {
    self.expanding = YES;
    self.expanded = !self.expanded;
    
    if (self.isExpanded) {
        [self expand];
    } else {
        [self collapse];
    }
}


- (void)addView:(UIView *)view {
    
    if (!self.contentView) {
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, [self.headerView h], [self.headerView w], self.padding)];
        [self.headerView addSubview:self.contentView];
    }
    
    [view setY:0];
    [view setHidden:YES];
    
    [self.contentView addH:[view h] + self.padding];
    [self.contentView addSubview:view];
    
    [self.views addObject:view];
}


- (void)expand {
    
    [self.delegate didExpandDroppySection:self];
    
    CGFloat moveAmount = self.padding;
    for (int i = 0; i < self.views.count; i++) {
        UIView *view = [self.views objectAtIndex:i];
        [view setHidden:NO];
        [view alphaFrom:0.5 to:1];
        [view moveYBy:moveAmount];
        
        moveAmount += [view h] + self.padding;
    }
}

- (void)collapse {
    
    [self.delegate didCollapseDroppySection:self];

    CGFloat moveAmount = self.padding;
    for (int i = 0; i < self.views.count; i++) {
        UIView *view = [self.views objectAtIndex:i];
        
        [view alphaFrom:0.5 to:0];
        [view moveYBy:-moveAmount];
        
        moveAmount += [view h] + self.padding;
    }
}

- (void)moveY:(CGFloat)y {
    [self.headerView moveYBy:y];
}

#pragma mark Properties

- (CGFloat)currentHeight {
    if (self.isExpanded) {
        return [self totalHeight];
    } else {
        return [self headerHeight];
    }
}

- (CGFloat)contentHeight {
    return [self.contentView h];
}

- (CGFloat)headerHeight {
    return [self.headerView h];
}

- (CGFloat)totalHeight {
    return self.headerHeight + self.contentHeight;
}


@end
