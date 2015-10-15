//
//  MHImageBrowserView.h
//  MHImageBrowser
//
//  Created by Martin Hering on 15.10.15.
//  Copyright © 2015 Martin Hering. All rights reserved.
//

#import <JNWCollectionView/JNWCollectionView.h>
#import "MHImageBrowserTypes.h"

@interface MHImageBrowserView : JNWCollectionView

@end


@protocol MHImageBrowserViewDataSource <JNWCollectionViewDataSource>
@required
@optional
- (NSDragOperation) imageBrowserView:(MHImageBrowserView *)imageBrowserView validateDrop:(id<NSDraggingInfo>)info proposedItemIndexPath:(NSIndexPath*)itemIndexPath proposedDropOperation:(MHImageBrowserViewDropOperation)operation;
- (BOOL) imageBrowserView:(MHImageBrowserView *)imageBrowserView acceptDrop:(id<NSDraggingInfo>)info itemIndexPath:(NSIndexPath*)indexPath dropOperation:(MHImageBrowserViewDropOperation)operation;
- (id<NSPasteboardWriting>) imageBrowserView:(MHImageBrowserView *)imageBrowserView pasteboardWriterForItemIndexPath:(NSIndexPath*)indexPath;
@end