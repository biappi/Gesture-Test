//
//  GestureWindow.m
//  Gesturetest
//
//  Created by Antonio "Willy" Malara on 30/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GestureWindow.h"

@implementation GestureWindow

- (id)initWithFrame:(CGRect)f;
{
	if ((self = [super initWithFrame:f]) == nil)
		return nil;
	
	gestureTouches = [[NSMutableArray alloc] initWithCapacity:20];
	self.clearsContextBeforeDrawing = YES;
	
	return self;
}

void drawStroke(CGContextRef c, NSArray * gesture)
{
	CGMutablePathRef pa = CGPathCreateMutable();
	
	BOOL first = YES;
	
	for (NSValue * v in gesture)
	{
		CGPoint p;
		[v getValue:&p];
		
		if (first == YES)
		{
			CGPathMoveToPoint(pa, nil, p.x, p.y);
			first = NO;
		} else {
			CGPathAddLineToPoint(pa, nil,  p.x, p.y);
		}
	}
	
	CGContextAddPath(c, pa);
	CGContextStrokePath(c);
}

- (void)drawRect:(CGRect)rect;
{
	CGFloat co[] = {1, 1, 1, 1};
	CGFloat gr[] = {0, 1, 0, 1};
	CGContextRef c = UIGraphicsGetCurrentContext();

	CGFloat b[] = {0, 0, 0, 1};
	CGContextSetFillColor(c, b);
	CGContextFillRect(c, rect);
	
	if (firstGesturePoints != nil)
	{
		CGContextSetStrokeColor(c, gr);
		drawStroke(c, firstGesturePoints);		
	}
	
	CGContextSetStrokeColor(c, co);
	drawStroke(c, gestureTouches);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
	[gestureTouches release];
	gestureTouches = [[NSMutableArray alloc] initWithCapacity:20];
	
	[gestureTouches addObject:[NSValue valueWithCGPoint:[[touches anyObject] locationInView:self]]];
	[self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint p = [[touches anyObject] locationInView:self];
	
	[gestureTouches addObject:[NSValue valueWithCGPoint:p]];
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint p = [[touches anyObject] locationInView:self];
	[gestureTouches addObject:[NSValue valueWithCGPoint:p]];
	
	[self setNeedsDisplay];
	
	if (firstGesture == nil)
		[self learnGesture];
	else
		[self recognizeGesture];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)recognizeGesture;
{
	stroke_t * stroke = stroke_alloc([gestureTouches count]);
	
	for (NSValue * v in gestureTouches)
	{
		CGPoint p;
		[v getValue:&p];

		stroke_add_point(stroke, p.x, p.y);
	}
	stroke_finish(stroke);
	
	double s = stroke_compare(stroke, firstGesture, nil, nil);

	if (s < 0.2)
	{
		double score = MAX(1.0 - 2.5 * s, 0.0);
		if (score > 0.7)
		{
			UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"Gesture Recognized" message:[NSString stringWithFormat:@"Score: %f", score] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
			[av show];
			[av release];
		}
	}
	
	NSLog(@"%f", s);
	
	stroke_free(stroke);
}

- (void)learnGesture;
{
	firstGesturePoints = [[NSArray arrayWithArray:gestureTouches] retain];
	firstGesture       = stroke_alloc([gestureTouches count]);
	
	for (NSValue * v in gestureTouches)
	{
		CGPoint p;
		[v getValue:&p];
		
		stroke_add_point(firstGesture, p.x, p.y);
	}
	stroke_finish(firstGesture);
}

@end
