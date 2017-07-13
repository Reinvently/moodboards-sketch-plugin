//
//  RSPButton.m
//  SketchPlugin
//
//  Created by aboyko on 5/22/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import "RSPButton.h"

@interface RSPButton ()

@property(strong) NSImage *normalStateImage;
@property(strong) NSImage *disabledStateImage;

@end

@implementation RSPButton

- (void)awakeFromNib {
    NSButtonCell *cell = self.cell;
    cell.imageDimsWhenDisabled = NO;
    self.normalStateImage = self.image;
    self.disabledStateImage = self.alternateImage;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];

    if (self.disabledStateImage == nil) {
        self.alphaValue = enabled ? 1.0 : 0.6;
    } else {
        self.image = enabled ? self.normalStateImage : self.disabledStateImage;
    }
}
@end
