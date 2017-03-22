//
//  TMImageZoom.h
//
//  Created by Thomas Maw on 23/11/16.
//  Copyright © 2016 Thomas Maw. All rights reserved.
//

#import "TMImageZoom.h"

static  TMImageZoom* tmImageZoom;
@implementation TMImageZoom {
    UIImageView *currentImageView;
    UIImageView *hostImageView;
    BOOL isAnimatingReset;
    CGPoint firstCenterPoint;
    CGRect startingRect;
    
    BOOL isHandlingGesture;
}

#pragma mark - Methods
-(void) gestureStateChanged:(id)gesture withZoomImageView:(UIImageView*)imageView {
    
    // Insure user is passing correct UIPinchGestureRecognizer class.
    if (![gesture isKindOfClass:[UIPinchGestureRecognizer class]]) {
        NSLog(@"(TMImageZoom): Must be using a UIPinchGestureRecognizer, currently you're using a: %@",[gesture class]);
        return;
    }
    
    UIPinchGestureRecognizer *theGesture = gesture;
    
    // Prevent animation issues if currently animating reset.
    if (isAnimatingReset) {
        return;
    }
    
    // Reset zoom if state = UIGestureRecognizerStateEnded
    if (theGesture.state == UIGestureRecognizerStateEnded || theGesture.state == UIGestureRecognizerStateCancelled || theGesture.state == UIGestureRecognizerStateFailed) {
        [self resetImageZoom];
        return;
    }
    
    // Ignore other views trying to start zoom if already zooming with another view
    if (isHandlingGesture && hostImageView != imageView) {
        NSLog(@"(TMImageZoom): 'gestureStateChanged:' ignored since this imageView isnt being tracked");
        return;
    }
    
    // Start handling gestures if state = UIGestureRecognizerStateBegan and not already handling gestures.
    if (!isHandlingGesture && theGesture.state == UIGestureRecognizerStateBegan) {
        isHandlingGesture = YES;
        
        // Set Host ImageView
        hostImageView = imageView;
        imageView.hidden = YES;
        
        // Convert local point to window coordinates
        CGPoint point = [imageView convertPoint:imageView.frame.origin toView:nil];
        startingRect = CGRectMake(point.x, point.y, imageView.frame.size.width, imageView.frame.size.height);
        
        // Post Notification
        [[NSNotificationCenter defaultCenter] postNotificationName:TMImageZoom_Started_Zoom_Notification object:nil];
        
        // Get current window and set starting vars
        UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
        firstCenterPoint = [theGesture locationInView:currentWindow];
        
        // Init zoom ImageView
        currentImageView = [[UIImageView alloc] initWithImage:imageView.image];
        currentImageView.contentMode = imageView.contentMode;
        [currentImageView setFrame:startingRect];
        [currentWindow addSubview:currentImageView];
    }
    
    // Reset if user removes a finger (Since center calculation would cause image to jump to finger as center. Maybe this could be improved later)
    if (theGesture.numberOfTouches < 2) {
        [self resetImageZoom];
        return;
    }
    
    // Update scale & center
    if (theGesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"gesture.scale = %f", theGesture.scale);
        
        // Calculate new image scale.
        CGFloat currentScale = currentImageView.frame.size.width / startingRect.size.width;
        CGFloat newScale = currentScale * theGesture.scale;
        [currentImageView setFrame:CGRectMake(currentImageView.frame.origin.x, currentImageView.frame.origin.y, startingRect.size.width*newScale, startingRect.size.height*newScale)];
        
        // Calculate new center
        UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
        int centerXDif = firstCenterPoint.x-[theGesture locationInView:currentWindow].x;
        int centerYDif = firstCenterPoint.y-[theGesture locationInView:currentWindow].y;
        currentImageView.center = CGPointMake((startingRect.origin.x+(startingRect.size.width/2))-centerXDif, (startingRect.origin.y+(startingRect.size.height/2))-centerYDif);
        
        // Reset gesture scale
        theGesture.scale = 1;
    }
}

-(void) resetImageZoom {
    // If not already animating
    if (isAnimatingReset || !isHandlingGesture) {
        return;
    }
    
    // Prevent further scale/center updates
    isAnimatingReset = YES;
    
    // Animate image zoom reset and post zoom ended notification
    [UIView animateWithDuration:0.2 animations:^{
        currentImageView.frame = startingRect;
    } completion:^(BOOL finished) {
        [currentImageView removeFromSuperview];
        currentImageView = nil;
        hostImageView.hidden = NO;
        hostImageView = nil;
        startingRect = CGRectZero;
        firstCenterPoint = CGPointZero;
        isHandlingGesture = NO;
        isAnimatingReset = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:TMImageZoom_Ended_Zoom_Notification object:nil];
    }];
}

#pragma mark - Properties

-(BOOL) isHandlingGesture {
    return isHandlingGesture;
}

#pragma mark - Shared Instance
+(TMImageZoom *) shared
{
    if(!tmImageZoom)
    {
        tmImageZoom = [[TMImageZoom alloc]init];
    }
    return tmImageZoom;
    
}
@end
