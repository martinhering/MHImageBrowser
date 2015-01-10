//
//  MHImageBrowserImageCell.h
//  MHImageBrowser
//
//  Created by Martin Hering on 01.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import <JNWCollectionView/JNWCollectionView.h>
#import "MHImageBrowserTypes.h"

@interface MHImageBrowserImageCell : JNWCollectionViewCell

+ (Class) placeholderViewClass;

@property (nonatomic, strong) id<MHImageBrowserImageItem> itemValue;
@property (nonatomic, assign) MHImageBrowserCellStyle style;

- (void) asyncRedraw;

@end
