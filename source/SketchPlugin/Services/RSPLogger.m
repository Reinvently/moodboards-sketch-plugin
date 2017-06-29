//
// Created by Boyko Andrey on 3/25/17.
// Copyright (c) 2017 Reinvently. All rights reserved.
//

#import "RSPLogger.h"

NS_ASSUME_NONNULL_BEGIN
@implementation RSPLogger
- (void)iterateObjects:(id)object {
    if ([object isKindOfClass:NSArray.class]) {
        [self appendToMyTextView:NSLocalizedString(@"Array:",@"")];
        for (id item in object) {
            [self iterateObjects:item];
        }
        [self appendToMyTextView:NSLocalizedString(@"End Array",@"")];
        return;
    }
    if ([object isKindOfClass:NSDictionary.class]) {
        [self appendToMyTextView:NSLocalizedString(@"Dictionary:",@"")];
        for (id item in object) {
            [self appendToMyTextView:NSLocalizedString(@"KEY:",@"")];
            [self appendToMyTextView:item];
            [self appendToMyTextView:NSLocalizedString(@"OBJECT:",@"")];
            [self iterateObjects:object[item]];
        }
        [self appendToMyTextView:NSLocalizedString(@"End Dictionary",@"")];
        return;
    }

    [self appendToMyTextView:NSStringFromClass([object class])];
}

- (void)appendToMyTextView:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:[text stringByAppendingString:@"\n"]];
        [[self.textView textStorage] appendAttributedString:attr];
    });
}

+ (instancetype)sharedLogger {
    static RSPLogger *StaticLogger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        StaticLogger = [RSPLogger new];
    });
    return StaticLogger;
}

- (void)logMessage:(NSString *)string {
    NSLog(NSLocalizedString(@"RSPlugin %@",@""), string);
    [self appendToMyTextView:string];
}
@end
NS_ASSUME_NONNULL_END