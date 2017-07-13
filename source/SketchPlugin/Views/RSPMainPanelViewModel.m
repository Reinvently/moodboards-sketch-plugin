//
//  RSPSearchRequest.m
//  SketchPlugin
//
//  Created by Boyko Andrey on 5/7/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import "RSPMainPanelViewModel.h"
#import "Macros.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSPMainPanelViewModel ()

@property NSUInteger page;
@property(strong) CollectionViewDataSource *dataSource;
@end

@implementation RSPMainPanelViewModel

/// Initializer
/// @param collectionView - collection view
/// @param delegate prefetching delegate
/// @return new instance
- (instancetype)initWithCollectionView:(NSCollectionView *)collectionView delegate:(id <CollectionViewDataSourceDelegate>)delegate {
    self = [super init];
    if (self) {
        self.query = @"";
        self.artboardGridType = RSPArtboardGridTypeDefault;
        [self resetPage];

        //Set up data source
        self.dataSource = [[CollectionViewDataSource alloc] initWithCollectionView:collectionView];
        self.dataSource.delegate = delegate;

    }
    return self;
}

///
/// Modify model view for loading next page
/// @return instance
- (instancetype)nextPage {
    self.page = self.page + 1;
    return self;
}

///
/// Reset page
/// @return instance
- (instancetype)resetPage {
    self.page = 1;
    return self;
}

///
/// Check if pages is reset
/// @return isResetPage
- (BOOL)isResetPage {
    return self.page == 1;
}

///
/// @return Artboard size type
- (CGSize)artboardGridSize {
    CGSize const artboardGridSizes[3] = {
            [RSPArtboardGridTypeSmall] = {.width = 4, .height = 5},
            [RSPArtboardGridTypeMedium] = {.width = 5, .height = 6},
            [RSPArtboardGridTypeBig] = {.width = 6, .height = 7},
    };

    return artboardGridSizes[self.artboardGridType];
}

///
/// @return moodboard config
- (RSPMoodboardConfig)moodboardConfig {
    RSPMoodboardConfig config = defaultMoodboardConfig();
    config.artboardGridSize = self.artboardGridSize;
    return config;
}

///
/// @return Hint text for artboard label
- (NSString *)artboardGridHintText {
    int columns = (int) self.artboardGridSize.width;
    int rows = (int) self.artboardGridSize.height;
    return [NSString stringWithFormat:RSPLocalizedString(@"%i columns x %i rows"), columns, rows];
}

///
/// @return Can generate
- (BOOL)isGenerateArtboardEnabled {
    return (self.dataSource.selectedItems.count > 0);
}

///
/// @return Can search
- (BOOL)isSearchImagesEnabled {
    return (self.query.length > 0);
}

///
/// @param type of artboard grid
/// @return state for button
- (NSCellStateValue)buttonStateForArtboardType:(RSPArtboardGridType)type {
    return (type == self.artboardGridType) ? NSOnState : NSOffState;
}
@end

NS_ASSUME_NONNULL_END
