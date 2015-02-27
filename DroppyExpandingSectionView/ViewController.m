//
//  ViewController.m
//  DroppyExpandingSectionView
//
//  Created by Cem Olcay on 22/10/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

#import "ViewController.h"
#import "DroppyExpandingSectionView.h"


@interface ViewController () <DroppyExpandingSectionViewDataSource>

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController


#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
    
    DroppyExpandingSectionView *droppy = [[DroppyExpandingSectionView alloc] initWithFrame:self.view.frame];
    [droppy setDroppyDataSource:self];
    [self.view addSubview:droppy];
}

#pragma mark View Creation

- (void)setupDataSource {
    
    // create section 1
    UIView *sectionHeader1 = [self sectionHeaderViewWithTitle:@"First Section"];
    
    // create section 1 expanding views
    NSMutableArray *sectionViews1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        UIView *sectionView = [self sectionViewWithTitle:[NSString stringWithFormat:@"Section 1 - Item %d", i]];
        [sectionViews1 addObject:sectionView];
    }
    
    
    // create section 2
    UIView *sectionHeader2 = [self sectionHeaderViewWithTitle:@"Second Section"];
    
    // create section 2 expanding views
    NSMutableArray *sectionViews2 = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        UIView *sectionView = [self sectionViewWithTitle:[NSString stringWithFormat:@"Section 2 - Item %d", i]];
        [sectionViews2 addObject:sectionView];
    }
    
    
    // create section 3
    UIView *sectionHeader3 = [self sectionHeaderViewWithTitle:@"Third Section"];
    
    // create section 3 expanding views
    NSMutableArray *sectionViews3 = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        UIView *sectionView = [self sectionViewWithTitle:[NSString stringWithFormat:@"Section 3 - Item %d", i]];
        [sectionViews3 addObject:sectionView];
    }
    
    
    // create section 4
    UIView *sectionHeader4 = [self sectionHeaderViewWithTitle:@"forth Section"];
    
    // create section 3 expanding views
    NSMutableArray *sectionViews4 = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        UIView *sectionView = [self sectionViewWithTitle:[NSString stringWithFormat:@"Section 4 - Item %d", i]];
        [sectionViews4 addObject:sectionView];
    }
    
    
    //Create Data Source JSON style Dictionary
    self.dataSource = @[@{@"header":sectionHeader1, @"items":sectionViews1},
                        @{@"header":sectionHeader2, @"items":sectionViews2},
                        @{@"header":sectionHeader3, @"items":sectionViews3},
                        @{@"header":sectionHeader4, @"items":sectionViews4}];
}


- (UILabel *)sectionHeaderViewWithTitle:(NSString *)title {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [self.view w] - 20, 50)];
    [lbl setText:title];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:25]];
    [lbl setBackgroundColor:[UIColor darkGrayColor]];
    
    return lbl;
}

- (UILabel *)sectionViewWithTitle:(NSString *)title {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [self.view w] - 40, 20 + arc4random()%100)];
    [lbl setText:title];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setTextColor:[UIColor blackColor]];
    [lbl setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:25]];
    [lbl setBackgroundColor:[self randomColor]];
    
    [lbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)]];
    [lbl setUserInteractionEnabled:YES];
    
    return lbl;
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)didTap: (UITapGestureRecognizer *)tap {
    UILabel *label = (UILabel *)tap.view;
    NSLog(@"%@ didTap", label.text);
}

#pragma mark - DroppyExpandingSectionViewDataSource

- (NSInteger)numberOfSectionsInDroppyExpandingSectionView:(DroppyExpandingSectionView *)droppy {
    return self.dataSource.count;
}

- (NSInteger)droppyExpandingSectionView:(DroppyExpandingSectionView *)droppy numberOfViewsInSection:(NSInteger)section {
    NSDictionary *sectionObject = [self.dataSource objectAtIndex:section];
    NSArray *sectionViews = (NSArray *)sectionObject[@"items"];
    return sectionViews.count;
}

- (UIView *)droppyExpandingSectionView:(DroppyExpandingSectionView *)droppy sectionHeaderViewAtSection:(NSInteger)section {
    NSDictionary *sectionObject = [self.dataSource objectAtIndex:section];
    UIView *sectionHeader = sectionObject[@"header"];
    return sectionHeader;
}

- (UIView *)droppyExpandingSectionView:(DroppyExpandingSectionView *)droppy viewForSection:(NSInteger)section atIndex:(NSInteger)index {
    NSDictionary *sectionObject = [self.dataSource objectAtIndex:section];
    NSArray *sectionViews = (NSArray *)sectionObject[@"items"];
    UIView *sectionView = (UIView *)[sectionViews objectAtIndex:index];
    return sectionView;
}

- (CGFloat)paddingBetweenSectionsInDroppyExpandingSectionView:(DroppyExpandingSectionView *)droppy {
    return 20;
}

- (CGFloat)paddingBetweenViewsInDroppyExpandingSectionView:(DroppyExpandingSectionView *)droppy {
    return 10;
}


@end
