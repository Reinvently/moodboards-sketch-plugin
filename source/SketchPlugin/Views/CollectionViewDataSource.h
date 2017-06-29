//
//  NSCollectionViewDataSource.h
//  SketchPlugin
//
//  Created by Boyko Andrey on 4/10/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RSPItem.h"
@protocol CollectionViewDataSourceDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewDataSource : NSObject <NSCollectionViewDataSource, NSCollectionViewDelegate>
///
/// Get/Set  items
@property(strong, nonatomic) NSArray<RSPItem*> *items;
///
/// Get selected items
@property(nullable, readonly) NSArray<RSPItem*> *selectedItems;
///
///Delegate
@property(nullable, weak) id <CollectionViewDataSourceDelegate> delegate;

///
/// Initializer
/// @param collectionView Collection view
/// @return new instance
- (instancetype)initWithCollectionView:(NSCollectionView *)collectionView;

///
/// Add items to collection view
/// @param items items
- (void)addItems:(NSArray<id> *)items;

@end

@protocol CollectionViewDataSourceDelegate
@required
///
/// Notify about fetching new items
/// @param dataSource Data Source
/// @param index Index
- (void)collectionViewDataSource:(CollectionViewDataSource *)dataSource prefetchItemFromIndex:(NSUInteger)index;

///
/// Notify about selection
/// @param dataSource Data Source
- (void)collectionViewDataSourceDidChangeSelection:(CollectionViewDataSource *)dataSource;
@end

NS_ASSUME_NONNULL_END
