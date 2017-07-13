//
//  NSCollectionViewDataSource.m
//  SketchPlugin
//
//  Created by Boyko Andrey on 4/10/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import "CollectionViewDataSource.h"
#import "PhotoCollectionViewItem.h"
#import "UIImageView+WebCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewDataSource ()

@property(weak) NSCollectionView *collectionView;
@end

@implementation CollectionViewDataSource

@dynamic selectedItems;
#pragma mark - Public

///
/// Initializer
/// @param collectionView
/// @return new instance
- (instancetype)initWithCollectionView:(NSCollectionView *)collectionView {
    self = [super init];
    if (self) {
        [self setUpWithCollectionView:collectionView];
    }
    return self;
}

///
/// Get/Set  items
- (void)setItems:(NSArray<id> *)items {
    _items = items;
    [self.collectionView reloadData];
}


///
/// Add items to collection view
/// @param items
- (void)addItems:(NSArray<id> *)items {
    if (items.count == 0) {
        return;
    }

    [self.collectionView performBatchUpdates:^{

        NSUInteger oldCount = _items.count;
        _items = [self.items arrayByAddingObjectsFromArray:items];

        NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
        for (NSUInteger i = oldCount; i < oldCount + items.count; i++) {
            [arrayWithIndexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }

        [self.collectionView insertItemsAtIndexPaths:[NSSet setWithArray:arrayWithIndexPaths]];
    }                      completionHandler:NULL];
}

///
/// Get selected items
- (nullable NSArray *)selectedItems {
    NSIndexSet *selectedPaths = self.collectionView.selectionIndexes;
    return [self.items objectsAtIndexes:selectedPaths];
}

#pragma mark -Helpers

- (void)setUpWithCollectionView:(NSCollectionView *)collectionView {
    self.collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
}

#pragma mark - Collection View

- (NSSet<NSIndexPath *> *)collectionView:(NSCollectionView *)collectionView shouldDeselectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    return [NSSet set];
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = NSStringFromClass(PhotoCollectionViewItem.class);
    PhotoCollectionViewItem *item = [collectionView makeItemWithIdentifier:cellId forIndexPath:indexPath];
    RSPItem *imageItem = self.items[(NSUInteger) indexPath.item];
    [item.imageView sd_setImageWithURL:imageItem.imgURL];
    return item;
}

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    [self.delegate collectionViewDataSourceDidChangeSelection:self];
}

- (void)collectionView:(NSCollectionView *)collectionView didDeselectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    [self.delegate collectionViewDataSourceDidChangeSelection:self];
}

- (void)         collectionView:(NSCollectionView *)collectionView
                willDisplayItem:(NSCollectionViewItem *)item
forRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == (self.items.count - 1)) {
        [self.delegate collectionViewDataSource:self prefetchItemFromIndex:(NSUInteger) indexPath.item];
    }
}
@end

NS_ASSUME_NONNULL_END
