//
//  MHImageBrowserImageCell.h
//  MHImageBrowser
//
//  Created by Martin Hering on 01.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import <JNWCollectionView/JNWCollectionView.h>

@interface MHImageBrowserImageCell : JNWCollectionViewCell

+ (Class) placeholderViewClass;

@property (nonatomic, strong) id objectValue;

@end
