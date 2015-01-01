//
//  ImageBrowserViewController.m
//  MHImageBrowser
//
//  Created by Martin Hering on 01.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import "MHImageBrowserViewController.h"
#import <JNWCollectionView/JNWCollectionView.h>

#import "MHImageBrowserImageCell.h"

static NSString * const kImageCellIdentifier = @"ImageCellIdentifier";

@interface MHImageBrowserViewController () <JNWCollectionViewDataSource, JNWCollectionViewDelegate, JNWCollectionViewGridLayoutDelegate> {
    struct {
        unsigned int dataSourceNumberOfGroups:1;
        unsigned int dataSourceNumberOfItemsInGroup:1;
        unsigned int dataSourceItemAtIndexPath:1;
    } _flags;
}
@property (nonatomic, strong) IBOutlet JNWCollectionView* collectionView;
@property (nonatomic, strong) NSIndexPath* activeScrollCellIndexPath;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
@property (nonatomic) BOOL userScroll;
@property (nonatomic, weak) id <NSObject> scrollObserver;
@end

@implementation MHImageBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    JNWCollectionView* collectionView = [[JNWCollectionView alloc] initWithFrame:self.view.bounds];
    collectionView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    JNWCollectionViewGridLayout *gridLayout = [[JNWCollectionViewGridLayout alloc] init];
    gridLayout.delegate = self;
    gridLayout.verticalSpacing = 10.f;
    gridLayout.itemHorizontalMargin = 10.f;
    
    collectionView.collectionViewLayout = gridLayout;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.animatesSelection = NO; // (this is the default option)
    
    [collectionView registerClass:[MHImageBrowserImageCell class] forCellWithReuseIdentifier:kImageCellIdentifier];
    
    self.cellSize = NSMakeSize(100, 100);
    
    self.collectionView = collectionView;
    
    [self.view addSubview:self.collectionView];
    
    // this is not nice, better would be to have an NSScrollViewDelegate
    self.scrollObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSViewBoundsDidChangeNotification
                                                      object:self.collectionView.clipView
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      // coalesced execution for better performance
                                                      if (!self.userScroll) {
                                                          [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_updateScrollAnchor) object:nil];
                                                          [self performSelector:@selector(_updateScrollAnchor) withObject:nil afterDelay:0.05];
                                                      }
                                                  }];
    
    [self.collectionView reloadData];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.scrollObserver];
}

- (void) setDataSource:(id<MHImageBrowserViewControllerDataSource>)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        _flags.dataSourceNumberOfGroups = [dataSource respondsToSelector:@selector(numberOfGroupsInImageBrowser:)];
        _flags.dataSourceNumberOfItemsInGroup = [dataSource respondsToSelector:@selector(imageBrowser:numberOfItemsInGroup:)];
        _flags.dataSourceItemAtIndexPath = [dataSource respondsToSelector:@selector(imageBrowser:itemAtIndexPath:)];
    }
}

- (void) setCellSize:(NSSize)cellSize
{
    if (!NSEqualSizes(_cellSize, cellSize)) {
        _cellSize = cellSize;
        
        [self.collectionView.collectionViewLayout invalidateLayout];
        
        NSIndexPath* scrollIndexPath = (self.selectedIndexPath) ? self.selectedIndexPath : self.activeScrollCellIndexPath;
        if (scrollIndexPath) {
            self.userScroll = YES;
            [self.collectionView scrollToItemAtIndexPath:scrollIndexPath
                                        atScrollPosition:JNWCollectionViewScrollPositionMiddle
                                                animated:NO];
            self.userScroll = NO;
        }
    }
}

- (void) _updateScrollAnchor
{
    self.activeScrollCellIndexPath = [self _centerCellIndexPath];
}

- (NSIndexPath*) _centerCellIndexPath
{
    NSRect scrollRect = self.collectionView.documentVisibleRect;
    // don't optimize scrolling when scrolled on top edge
    if (NSMinY(scrollRect) <= 0) {
        return nil;
    }
    
    NSArray* indexPathes = [self.collectionView.collectionViewLayout indexPathsForItemsInRect:scrollRect];
    if ([indexPathes count] == 0) {
        return nil;
    }
    
    NSUInteger middleIndex = [indexPathes count]/2;
    return indexPathes[middleIndex];
}

#pragma mark Data source

- (JNWCollectionViewCell *)collectionView:(JNWCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_flags.dataSourceItemAtIndexPath) {
        id<MHImageBrowserImageItem> item = [self.dataSource imageBrowser:self itemAtIndexPath:indexPath];
        
        MHImageBrowserImageCell *cell = (MHImageBrowserImageCell *)[collectionView dequeueReusableCellWithIdentifier:kImageCellIdentifier];
        cell.objectValue = item.representation;
        return cell;
    }

    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(JNWCollectionView *)collectionView
{
    if (_flags.dataSourceNumberOfGroups) {
        return [self.dataSource numberOfGroupsInImageBrowser:self];
    }
    return 0;
}

- (NSUInteger)collectionView:(JNWCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_flags.dataSourceNumberOfItemsInGroup) {
        return [self.dataSource imageBrowser:self numberOfItemsInGroup:section];
    }
    return 0;
}

- (CGSize)sizeForItemInCollectionView:(JNWCollectionView *)collectionView {
    NSSize cellSize = self.cellSize;
    return CGSizeMake(cellSize.width, cellSize.height);
}

- (void)collectionView:(JNWCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
}

- (void)collectionView:(JNWCollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedIndexPath isEqualTo:indexPath]) {
        self.selectedIndexPath = nil;
    }
}




@end
