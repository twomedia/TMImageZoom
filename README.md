# TMImageZoom
Easily add zoom functionality similar to Instagram

<img src="preview.gif" width="226" height="402" />

## Getting Started

Adding TMImageZoom is quick and easy:

1. Add the TMImageZoom.h & TMImageZoom.m files to your project.
2. Import TMImageZoom.h

### Installing

Start by adding a UIPinchGestureRecognizer to the view you would like to receive touches and create a pinch: method
```
UIPinchGestureRecognizer *pinchZoom = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
pinchZoom.delegate = self;
[self addGestureRecognizer:pinchZoom];

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    
}
```

Then inside the pinch: method, use the shared instance of TMImageZoom and call the gestureStateChanged: method. We will pass the gesture as well as the UIImageView we would like to zoom.
```
- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    [[TMImageZoom shared] gestureStateChanged:gesture withZoomImageView:imageView];
}
```

And that’s it! You can now pinch zoom the image just like Instagram!

## FAQ

“How do I know if the user is currently zooming the image?”
```
[[TMImageZoom shared] isHandlingGesture]
```

“How can I manually end the zoom?”
```
[[TMImageZoom shared] resetImageZoom]
```

“Do I need to call resetImageZoom: everytime to reset the zoom?”
```
A: No, this is called automatically when the user ends the gesture.
```

“Is there anyway I can know when the user starts and ends the zoom?”
```
A: Yes, we post two notifications when the user begins and ends zooming:
TMImageZoom_Started_Zoom_Notification
TMImageZoom_Ended_Zoom_Notification
```

“Does this support CollectionViews and TableViews?”
```
A: Yes, although you will need to manually override touches so the user can’t tap other cells/buttons while zooming. This can be achieved by checking the isHandlingGesture boolean.
```

“Can you zoom multiple ImageViews at once?”
```
A: This is possible but only if you don’t use the shared instance and just initialise TMImageZoom yourself. Currently with the shared instance we block any gestures that get received if it isn’t the current view being zoomed. (This resets everytime the zoom is reset)
```

### Known Issues

None at this stage, I’ll actively monitor issues if they arise.

## Authors

* **Thomas Maw** - https://github.com/twomedia

## License

> Copyright (c) 2009-2016: Thomas Maw
>
> Permission is hereby granted, free of charge, to any person obtaining
> a copy of this software and associated documentation files (the
> "Software"), to deal in the Software without restriction, including
> without limitation the rights to use, copy, modify, merge, publish,
> distribute, sublicense, and/or sell copies of the Software, and to
> permit persons to whom the Software is furnished to do so, subject to
> the following conditions:
>
> The above copyright notice and this permission notice shall be
> included in all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
> LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
> OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
> WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
