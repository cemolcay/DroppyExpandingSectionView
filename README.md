DroppyExpandingSectionView
==========================

Instead of using UITableView or UICollectionView use this for
expand/collapse behaviour.
Implementation higly mimics UICollectionView. Its more easy because
just waits the headers and their expanding items which are any UIView
type object

Demo
----

![alt tag](https://raw.githubusercontent.com/cemolcay/DroppyExpandingSectionView/master/demo.gif)

Usage
-----

Copy & Paste the folder DroppyExpandingSectionView to your project. <br>
Import the DroppyExpandingSectionView.h/m files into your view controller. <br>
Add <DroppyExpandingSectionViewDataSource> to your view controller. <br>

    // create and droppy
    DroppyExpandingSectionView *droppy = [[DroppyExpandingSectionView alloc] initWithFrame:self.view.frame];
    [droppy setDroppyDataSource:self];
    [self.view addSubview:droppy];


DroppyExpandingSectionViewDataSource
------------------------------------

    - (NSInteger)numberOfSectionsInDroppyExpandingSectionView:(DroppyExpandingSectionView *)droppy;
    
How many sections do your view have ?
    
    
    - (NSInteger)droppyExpandingSectionView:(DroppyExpandingSectionView *)droppy numberOfViewsInSection:(NSInteger)section;
    
How many items does your sections have ?
    
    - (UIView *)droppyExpandingSectionView:(DroppyExpandingSectionView *)droppy sectionHeaderViewAtSection:(NSInteger)section;
    
The view will presenting as section item
    
    - (UIView *)droppyExpandingSectionView:(DroppyExpandingSectionView *)droppy viewForSection:(NSInteger)section atIndex:(NSInteger)index;

The view presenting as item of that section

    

    - (CGFloat)paddingBetweenSectionsInDroppyExpandingSectionView:(DroppyExpandingSectionView *)droppy;  // default 10
    
The padding value between your sections.<br>
Default is 10px.

    
    - (CGFloat)paddingBetweenViewsInDroppyExpandingSectionView:(DroppyExpandingSectionView *)droppy;     // default 10
    

The padding value between items in section. <br>
Default is 10px.
