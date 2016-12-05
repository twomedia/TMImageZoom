//
//  TMImageZoom.h
//
//  Created by Thomas Maw on 23/11/16.
//  Copyright © 2016 Thomas Maw. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TMImageZoom_Started_Zoom_Notification @"TMImageZoom_Started_Zoom_Notification"
#define TMImageZoom_Ended_Zoom_Notification @"TMImageZoom_Ended_Zoom_Notification"

@interface TMImageZoom : NSObject

@property (readonly) BOOL isHandlingGesture;

-(void) gestureStateChanged:(id)gesture withZoomImageView:(UIImageView*)imageView;
-(void) resetImageZoom;

+(TMImageZoom*) shared;
@end
