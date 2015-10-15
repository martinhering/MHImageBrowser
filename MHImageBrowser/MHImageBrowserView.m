//
//  MHImageBrowserView.m
//  MHImageBrowser
//
//  Created by Martin Hering on 15.10.15.
//  Copyright © 2015 Martin Hering. All rights reserved.
//

#import "MHImageBrowserView.h"
#import "_MHImageBrowserImageCell.h"

@interface MHImageBrowserView () <NSDraggingSource>
@property (nonatomic, strong) NSDraggingSession *draggingSession;
@end

@implementation MHImageBrowserView {
    BOOL _dataSourceImplementsValidateDrop;
    BOOL _dataSourceImplementsAcceptDrop;
    BOOL _dataSourceImplementsPasteboardWriterForItem;
}

- (void)setDataSource:(id<JNWCollectionViewDataSource>)dataSource
{
    [super setDataSource:dataSource];

    _dataSourceImplementsValidateDrop = [dataSource respondsToSelector:@selector(imageBrowserView:validateDrop:proposedItemIndexPath:proposedDropOperation:)];
    _dataSourceImplementsAcceptDrop = [dataSource respondsToSelector:@selector(imageBrowserView:acceptDrop:itemIndexPath:dropOperation:)];
    _dataSourceImplementsPasteboardWriterForItem = [dataSource respondsToSelector:@selector(imageBrowserView:pasteboardWriterForItemIndexPath:)];
}

#pragma mark - NSDraggingSource

- (void)setDropRow:(NSInteger)row dropOperation:(MHImageBrowserViewDropOperation)operation {

}

- (void) mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
}

- (void) mouseDragged:(NSEvent *)theEvent
{
    [super mouseDragged:theEvent];

    if (!self.draggingSession)
    {
        if (!_dataSourceImplementsPasteboardWriterForItem) {
            return;
        }

        if (self.indexPathsForSelectedItems.count == 0) {
            return;
        }

        NSMutableArray* draggingItems = [[NSMutableArray alloc] init];
        for(NSIndexPath* indexPath in self.indexPathsForSelectedItems)
        {
            MHImageBrowserImageCell* cell = (MHImageBrowserImageCell*)[self cellForItemAtIndexPath:indexPath];
            if (!cell) continue;

            id<NSPasteboardWriting> pasteboardWriter = [(id<MHImageBrowserViewDataSource>)self.dataSource imageBrowserView:self pasteboardWriterForItemIndexPath:indexPath];
            if (!pasteboardWriter) {
                continue;
            }
            NSDraggingItem *dragItem = [[NSDraggingItem alloc] initWithPasteboardWriter:pasteboardWriter];
            dragItem.draggingFrame = [self convertRect:cell.bounds fromView:cell];
            dragItem.imageComponentsProvider = ^() {
                return cell.draggingImageComponents;
            };
            [draggingItems addObject:dragItem];
        }

        NSDraggingSession *draggingSession = [self beginDraggingSessionWithItems:draggingItems event:theEvent source:self];
        draggingSession.animatesToStartingPositionsOnCancelOrFail = YES;
        draggingSession.draggingFormation = NSDraggingFormationNone;
        self.draggingSession = draggingSession;
    }
}

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    return NSDragOperationMove;
}
/*
 - (void)draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint
 {
 NSLog(@"%s", __func__);
 }

 - (void)draggingSession:(NSDraggingSession *)session movedToPoint:(NSPoint)screenPoint
 {
 NSLog(@"%s", __func__);
 }
 */
- (void)draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation
{
    self.draggingSession = nil;
}

@end
