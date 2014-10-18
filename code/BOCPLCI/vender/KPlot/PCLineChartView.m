/**
 * Copyright (c) 2011 Muh Hon Cheng
 * Created by honcheng on 28/4/11.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining 
 * a copy of this software and associated documentation files (the 
 * "Software"), to deal in the Software without restriction, including 
 * without limitation the rights to use, copy, modify, merge, publish, 
 * distribute, sublicense, and/or sell copies of the Software, and to 
 * permit persons to whom the Software is furnished to do so, subject 
 * to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be 
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT 
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR 
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT 
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
 * IN CONNECTION WITH THE SOFTWARE OR 
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * @author 		Muh Hon Cheng <honcheng@gmail.com>
 * @copyright	2011	Muh Hon Cheng
 * @version
 * 
 */

#import "PCLineChartView.h"

@implementation PCLineChartViewComponent

- (id)init
{
    self = [super init];
    if (self)
    {
        _labelFormat = @"%.1f%%";
    }
    return self;
}

@end

@implementation PCLineChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor clearColor]];
        _interval = 20;
		_maxValue = 0;
		_minValue = 100;
//        _autoscaleYAxis = YES;
		_yLabelFont = [UIFont boldSystemFontOfSize:10];
		_xLabelFont = [UIFont boldSystemFontOfSize:10];
		_valueLabelFont = [UIFont systemFontOfSize:10];
		_legendFont = [UIFont systemFontOfSize:10];
        _numYIntervals = 5;
        _numXIntervals = 1;
		
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    CGContextSetRGBFillColor(ctx, 0.2f, 0.2f, 0.2f, 1.0f);
    
    
    for (PCLineChartViewComponent *component in self.components) {
        for (int x_axis_index=0; x_axis_index<[component.points count]; x_axis_index++){
            id object = [component.points objectAtIndex:x_axis_index];
            if (object!=[NSNull null] && object)
            {
                float value = [object floatValue];
                if (_minValue > value) {
                    _minValue = value;
                }
                if (_maxValue < value) {
                    _maxValue = value;
                }
            }
        }
    }
    _interval = (_maxValue - _minValue) / 5.0;
    
    int n_div;
    int power;
    float scale_min, scale_max, div_height;
    float top_margin = 35;
    float bottom_margin = 25;
	float x_label_height = 20;
	
    if (self.autoscaleYAxis) {
        scale_min = 0.0;
        power = floor(log10(self.maxValue/5)); 
        float increment = self.maxValue / (5 * pow(10,power));
        increment = (increment <= 5) ? ceil(increment) : 10;
        increment = increment * pow(10,power);
        scale_max = 5 * increment;
        self.interval = scale_max / self.numYIntervals;
    } else {
        scale_min = self.minValue;
        scale_max = self.maxValue;
    }
    n_div = (scale_max-scale_min)/self.interval + 1;
    div_height = (self.frame.size.height-top_margin-bottom_margin-x_label_height)/(n_div-1);
    
    for (int i=0; i<n_div; i++)
    {
        float y_axis = scale_max - i*self.interval;        
        int y = top_margin + div_height*i;
        CGRect textFrame = CGRectMake(0,y-8,25,20);

        NSString *formatString = [NSString stringWithFormat:@"%%.%if", 2];
        NSString *text = [NSString stringWithFormat:formatString, y_axis];
        
        [text drawInRect:textFrame 
				withFont:self.yLabelFont 
		   lineBreakMode:UILineBreakModeWordWrap 
			   alignment:UITextAlignmentRight];
		
		// These are "grid" lines
        CGContextSetLineWidth(ctx, 0.5);
        if (i == n_div - 1) {
            CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
        } else {
            CGContextSetRGBStrokeColor(ctx, 0.4f, 0.4f, 0.4f, 0.3f);
        }
        CGContextMoveToPoint(ctx, 30, y);
        CGContextAddLineToPoint(ctx, self.frame.size.width-30, y);
        CGContextStrokePath(ctx);
    }
    
    float margin = 30;
    float div_width;
    if ([self.xLabels count] == 1)
    {
        div_width = 0;
    }
    else
    {
        div_width = (self.frame.size.width-2*margin)/([self.xLabels count]-1);
    }
    
    for (NSUInteger i=0; i<[self.xLabels count]; i++)
    {
        if (i % self.numXIntervals == 1 || self.numXIntervals==1) {
            int x = (int) (margin + div_width * i);
            NSString *x_label = [NSString stringWithFormat:@"%@", [self.xLabels objectAtIndex:i]];

            CGContextSelectFont(ctx, [self.xLabelFont.fontName UTF8String], self.xLabelFont.pointSize, kCGEncodingMacRoman);
            CGContextSetTextMatrix(ctx, CGAffineTransformRotate(CGAffineTransformMakeScale(1.0, -1.0), -M_PI_4));
            CGContextSetTextDrawingMode(ctx, kCGTextFill);
            CGContextShowTextAtPoint(ctx, x - 5,  div_height * n_div + 10, [x_label UTF8String], [x_label length]);
                        
            // These are "grid" lines
            CGContextSetLineWidth(ctx, 0.5);
            if (i == 0) {
                CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
            } else {
                CGContextSetRGBStrokeColor(ctx, 0.4f, 0.4f, 0.4f, 0.3f);
            }
            CGContextMoveToPoint(ctx, x, top_margin);
            CGContextAddLineToPoint(ctx, x, div_height * n_div + 2);
            CGContextStrokePath(ctx);
        };

    }
        
    float circle_diameter = 2;
    float circle_stroke_width = 2;
    float line_width = 0.5;
	
    for (PCLineChartViewComponent *component in self.components)
    {
        int last_x = 0;
        int last_y = 0;
        
        if (!component.colour)
        {
            component.colour = PCColorBlue;
        }
		
		for (int x_axis_index=0; x_axis_index<[component.points count]; x_axis_index++)
        {
            id object = [component.points objectAtIndex:x_axis_index];
			
			
            if (object!=[NSNull null] && object)
            {
                float value = [object floatValue];

				CGContextSetStrokeColorWithColor(ctx, [component.colour CGColor]);
                CGContextSetLineWidth(ctx, circle_stroke_width);
                
                int x = margin + div_width*x_axis_index;
                int y = top_margin + (scale_max-value)/self.interval*div_height;

                CGRect circleRect = CGRectMake(x-circle_diameter/2, y-circle_diameter/2, circle_diameter,circle_diameter);
                CGContextStrokeEllipseInRect(ctx, circleRect);
                
				CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
                
                NSLog(@"%@",object);
                
                NSString *valueString = [NSString stringWithFormat:@"%@",object];
                
                [valueString drawInRect:CGRectMake(x-circle_diameter/2 + 5, y-circle_diameter/2 - 6, 200, 20)
                               withFont:_legendFont
                          lineBreakMode:UILineBreakModeWordWrap
                              alignment:UITextAlignmentLeft];
                
                if (last_x!=0 && last_y!=0)
                {
                    float distance = sqrt( pow(x-last_x, 2) + pow(y-last_y,2) );
                    float last_x1 = last_x + (circle_diameter/2) / distance * (x-last_x);
                    float last_y1 = last_y + (circle_diameter/2) / distance * (y-last_y);
                    float x1 = x - (circle_diameter/2) / distance * (x-last_x);
                    float y1 = y - (circle_diameter/2) / distance * (y-last_y);
                    
                    CGContextSetLineWidth(ctx, line_width);
                    CGContextMoveToPoint(ctx, last_x1, last_y1);
                    CGContextAddLineToPoint(ctx, x1, y1);
                    CGContextStrokePath(ctx);
                }
                
                last_x = x;
                last_y = y;
            }
            
        }
    }

}


@end
