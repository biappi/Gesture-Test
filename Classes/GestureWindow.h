//
//  GestureWindow.h
//  Gesturetest
//
//  Created by Antonio "Willy" Malara on 30/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "stroke.h"

@interface GestureWindow : UIWindow
{
	NSMutableArray * gestureTouches;

	stroke_t       * firstGesture;
	NSArray        * firstGesturePoints;
}

- (void)recognizeGesture;
- (void)learnGesture;

@end
