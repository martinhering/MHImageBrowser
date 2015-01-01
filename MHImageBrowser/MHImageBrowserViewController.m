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

@interface MHImageBrowserViewController () <JNWCollectionViewDataSource, JNWCollectionViewDelegate, JNWCollectionViewGridLayoutDelegate>
@property (nonatomic, strong) IBOutlet JNWCollectionView* collectionView;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSIndexPath* activeScrollCellIndexPath;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
@property (nonatomic) BOOL userScroll;
@property (nonatomic, weak) id <NSObject> scrollObserver;
@end

@implementation MHImageBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self generateImages];
    
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

- (JNWCollectionViewCell *)collectionView:(JNWCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MHImageBrowserImageCell *cell = (MHImageBrowserImageCell *)[collectionView dequeueReusableCellWithIdentifier:kImageCellIdentifier];
    cell.objectValue = self.images[indexPath.jnw_item % self.images.count];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(JNWCollectionView *)collectionView {
    return 5;
}

- (NSUInteger)collectionView:(JNWCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 500;
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
#pragma mark Image creation

// To simulate at least something realistic, this just generates some randomly tinted images so that not every
// cell has the same image.
- (void)generateImages {
    NSInteger numberOfImages = 30;
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i = 0; i < numberOfImages; i++) {
        
        // Just get a randomly-tinted template image.
        NSImage *image = [NSImage imageWithSize:CGSizeMake(150.f, 150.f) flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
            [[NSImage imageNamed:NSImageNameUser] drawInRect:dstRect fromRect:CGRectZero operation:NSCompositeSourceOver fraction:1];
            
            CGFloat hue = arc4random() % 256 / 256.0;
            CGFloat saturation = arc4random() % 128 / 256.0 + 0.5;
            CGFloat brightness = arc4random() % 128 / 256.0 + 0.5;
            NSColor *color = [NSColor colorWithCalibratedHue:hue saturation:saturation brightness:brightness alpha:1];
            
            [color set];
            NSRectFillUsingOperation(dstRect, NSCompositeDestinationAtop);
            
            return YES;
        }];
        
        [images addObject:image];
    }
    
    self.images = images.copy;
}


@end
