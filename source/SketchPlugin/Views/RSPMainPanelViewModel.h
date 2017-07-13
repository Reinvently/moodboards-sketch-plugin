//
//  RSPSearchRequest.h
//  SketchPlugin
//
//  Created by Boyko Andrey on 5/7/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionViewDataSource.h"
#import "Config.h"

///
/// Artboards types
typedef NS_ENUM(NSUInteger, RSPArtboardGridType) {
    RSPArtboardGridTypeSmall = 0,
    RSPArtboardGridTypeMedium = 1,
    RSPArtboardGridTypeBig = 2,
    RSPArtboardGridTypeDefault = RSPArtboardGridTypeSmall
};

NS_ASSUME_NONNULL_BEGIN

@interface RSPMainPanelViewModel : NSObject

@property(strong, readonly) CollectionViewDataSource *dataSource;
///
/// Search query
@property(copy) NSString *query;
///
/// Artboard type
@property RSPArtboardGridType artboardGridType;

/// Initializer
/// @param collectionView - collection view
/// @param delegate prefetching delegate
/// @return new instance
- (instancetype)initWithCollectionView:(NSCollectionView *)collectionView delegate:(id <CollectionViewDataSourceDelegate>)delegate;

///
/// Modify model view for loading next page
/// @return instance
- (instancetype)nextPage;

///
/// Reset page
/// @return instance
- (instancetype)resetPage;

///
/// Check if pages is reset
/// @return isResetPage
- (BOOL)isResetPage;

///
/// Current page for searching
/// @return page
- (NSUInteger)page;

///
/// @return Artboard size type
- (CGSize)artboardGridSize;

///
/// @return Hint text for artboard label
- (NSString *)artboardGridHintText;

///
/// @return Can generate
- (BOOL)isGenerateArtboardEnabled;

///
/// @return Can search
- (BOOL)isSearchImagesEnabled;

///
/// @return moodboard config
- (RSPMoodboardConfig)moodboardConfig;

///
/// @param type of artboard grid
/// @return state for button
- (NSCellStateValue)buttonStateForArtboardType:(RSPArtboardGridType)type;
@end

NS_ASSUME_NONNULL_END
