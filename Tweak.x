#import <UIKit/UIKit.h>
#import "FLEXManager.h"

@interface UIWindow (PrivatePrisonFLEX)
@property (nonatomic, strong) UILongPressGestureRecognizer *prisonFLEXLongPress;
@end

@interface PrisonFLEX : NSObject
+ (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer;
@end

@implementation PrisonFLEX
+ (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;

    FLEXManager *manager = [FLEXManager sharedManager];
    if (!manager.isHidden)
        return;

    UIWindow *window = (UIWindow *)gestureRecognizer.view;
    UIWindowScene *scene = window.windowScene;
    scene ? [manager showExplorerFromScene:scene] : [manager showExplorer];
}
@end

static UILongPressGestureRecognizer *RegisterLongPressGesture(UIWindow *window, NSUInteger fingers) {
    UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:[PrisonFLEX class] action:@selector(handleLongPress:)];
    longPress.numberOfTouchesRequired = fingers;
    [window addGestureRecognizer:longPress];
    return longPress;
}

%hook UIWindow
%property (nonatomic, strong) UILongPressGestureRecognizer *prisonFLEXLongPress;
- (void)becomeKeyWindow {
    %orig();
    if (!self.prisonFLEXLongPress &&
        ![self isKindOfClass:%c(FLEXWindow)]) {
        self.prisonFLEXLongPress = RegisterLongPressGesture(self, 3);
    }
}
- (void)resignKeyWindow {
    UILongPressGestureRecognizer *longPress = self.prisonFLEXLongPress;
    if (longPress) {
        [self removeGestureRecognizer:longPress];
        self.prisonFLEXLongPress = nil;
    }
    %orig();
}
%end
