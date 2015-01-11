//
//  _MHImageBrowserImageCellPrivate.h
//  MHImageBrowser
//
//  Created by Martin Hering on 11.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import "MHImageBrowserImageCell.h"

@class _MHImageBrowserCacheManager;

@interface MHImageBrowserImageCell (PrivateAPI)
@property (nonatomic, assign) NSUInteger thumbnailSize;
@property (nonatomic, strong) _MHImageBrowserCacheManager* cacheManager;
@end
