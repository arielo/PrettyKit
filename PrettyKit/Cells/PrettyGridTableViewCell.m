//
//  PrettyGridTableViewCell.m
//  PrettyExample
//
//  Created by Víctor on 12/03/12.

// Copyright (c) 2012 Victor Pena Placer (@vicpenap)
// http://www.victorpena.es/
// 
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


#import "PrettyGridTableViewCell.h"
#import "PrettyDrawing.h"

#define label_margin 2
#define SEGMENTED_CONTROL_BLUE_TOP_BORDER_COLOR [UIColor colorWithHex:0x5398d9]
#define SEGMENTED_CONTROL_BLUE_GRADIENT_START_COLOR [UIColor colorWithHex:0x4994d8]
#define SEGMENTED_CONTROL_BLUE_GRADIENT_END_COLOR [UIColor colorWithHex:0x2e78cb]
#define SEGMENTED_CONTROL_BLUE_BOTTOM_BORDER_COLOR [UIColor colorWithHex:0x2e78cb]

#define SEGMENTED_CONTROL_PRESSED_BLUE_TOP_BORDER_COLOR [UIColor colorWithHex:0x1d4b85]
#define SEGMENTED_CONTROL_PRESSED_BLUE_GRADIENT_START_COLOR [UIColor colorWithHex:0x2c73cc]
#define SEGMENTED_CONTROL_PRESSED_BLUE_GRADIENT_END_COLOR [UIColor colorWithHex:0x4d95db]
#define SEGMENTED_CONTROL_PRESSED_BLUE_BOTTOM_BORDER_COLOR [UIColor colorWithHex:0x4d95db]

#define SEGMENTED_CONTROL_GREEN_TOP_BORDER_COLOR [UIColor colorWithHex:0x60bc90]
#define SEGMENTED_CONTROL_GREEN_GRADIENT_START_COLOR [UIColor colorWithHex:0x58b889]
#define SEGMENTED_CONTROL_GREEN_GRADIENT_END_COLOR [UIColor colorWithHex:0x399f68]
#define SEGMENTED_CONTROL_GREEN_BOTTOM_BORDER_COLOR [UIColor colorWithHex:0x399f68]

#define SEGMENTED_CONTROL_PRESSED_GREEN_TOP_BORDER_COLOR [UIColor colorWithHex:0x266b46]
#define SEGMENTED_CONTROL_PRESSED_GREEN_GRADIENT_START_COLOR [UIColor colorWithHex:0x339660]
#define SEGMENTED_CONTROL_PRESSED_GREEN_GRADIENT_END_COLOR [UIColor colorWithHex:0x5cbe8d]
#define SEGMENTED_CONTROL_PRESSED_GREEN_BOTTOM_BORDER_COLOR [UIColor colorWithHex:0x5cbe8d]

@interface PrettyGridSubview : UIButton {
    BOOL _gradientVisible;
}

@property (nonatomic, retain) PrettyGridTableViewCell *cell;
@property (nonatomic, assign) int selectedSegment;
@property (nonatomic, readonly) CGFloat segmentWidth;

- (void) selectIndex:(int)index;
- (void) deselectAnimated:(BOOL)animated completion:(void (^)(void))block;

@end


@implementation PrettyGridSubview
@synthesize cell, selectedSegment;

- (void) dealloc 
{
    self.cell = nil;
    
    [super dealloc];
}

- (CGFloat) segmentWidth 
{
    float width = self.frame.size.width - 4/self.cell.numberOfElements;
    return width / self.cell.numberOfElements;
}

// draws vertical separator
- (void) drawLineAtX:(float)x inRect:(CGRect)rect 
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx); 
    
    CGContextMoveToPoint(ctx, x, CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, x, CGRectGetMaxY(rect));
    
    CGContextSetStrokeColorWithColor(ctx, self.cell.customSeparatorColor.CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

- (UIFont *) fontFromLabel:(UILabel *)label 
{
    UIFont *font = label.font;
    
    
    /* If the font hasn't been changed, the first time it's accessed the font
     size isn't set, so we have to "guess" it. */
    if (!font.pointSize) 
    {
        if (label == self.cell.textLabel) 
        {
            font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        }
        
        else if (label == self.cell.detailTextLabel) 
        {
            float fontSize = 0;
            switch (self.cell->_style) 
            {
                case UITableViewCellStyleSubtitle:
                    fontSize = 15;
                    break;
                case UITableViewCellStyleValue1:
                case UITableViewCellStyleValue2:
                    fontSize = [UIFont labelFontSize];
                default:
                    break;
            }
            font = [UIFont systemFontOfSize:fontSize];
        }
    }
    
    return font;
}

- (CGSize) drawText:(NSString *)text basedOnLabel:(UILabel *)label inRect:(CGRect)rect showAsSelected:(BOOL)selected 
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);

    UIFont *font = [self fontFromLabel:label];
    
    if (!self.cell.shadowOnlyOnSelected || selected) 
    {
        CGContextSetShadowWithColor(ctx, label.shadowOffset, 1, label.shadowColor.CGColor);
    }
    
    if (selected && self.cell.elementSelectionStyle != UITableViewCellSelectionStyleNone)
    {
        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    }
    else {
        CGContextSetFillColorWithColor(ctx, label.textColor.CGColor);
    }
    
    CGSize textSize = [text drawInRect:rect
                              withFont:font
                         lineBreakMode:UILineBreakModeTailTruncation 
                             alignment:self.cell.textAlignment];

    CGContextRestoreGState(ctx);
  
    return textSize;
}

- (void) drawSelectionGradientInRect:(CGRect)rect 
{
    [PrettyDrawing drawGradient:rect fromColor:SEGMENTED_CONTROL_PRESSED_GREEN_GRADIENT_START_COLOR toColor:SEGMENTED_CONTROL_PRESSED_GREEN_GRADIENT_END_COLOR];
    
    [PrettyDrawing drawGradient:CGRectMake(160, 0, 160, 44) fromColor:SEGMENTED_CONTROL_BLUE_GRADIENT_START_COLOR toColor:SEGMENTED_CONTROL_BLUE_GRADIENT_END_COLOR];
}

- (void) drawGreenGradientInRect:(CGRect)rect
{
    rect = CGRectMake(159, 0, 170, 44);
    [PrettyDrawing drawGradient:CGRectMake(159, 0, 170, 44) fromColor:SEGMENTED_CONTROL_PRESSED_GREEN_GRADIENT_START_COLOR toColor:SEGMENTED_CONTROL_PRESSED_GREEN_GRADIENT_END_COLOR];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathRef roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(159, -1, rect.size.width-1, 1) cornerRadius:self.layer.cornerRadius].CGPath;
    
    // inner shadow
    CGContextAddPath(context, roundedRect);
    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, 1), 1, [UIColor colorWithWhite:0 alpha:0.4].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.4].CGColor);
    CGContextStrokePath(context);
    
    CGRect leftShadowRect = CGRectMake(rect.origin.x, 0, 0.5, 44);
    CGRect rightShadowRect = CGRectMake(self.bounds.size.width, 0, 0.5, 44);
    
    CGPathRef leftRectPath = [UIBezierPath bezierPathWithRect:leftShadowRect].CGPath;
    CGPathRef rightRectPath = [UIBezierPath bezierPathWithRect:rightShadowRect].CGPath;
    
    // left shadow
    CGContextAddPath(context, leftRectPath);
    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, 1), 1, [UIColor colorWithWhite:0 alpha:0.4].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.4].CGColor);
    CGContextStrokePath(context);
    
    // right shadow
    CGContextAddPath(context, rightRectPath);
    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, 1), 1, [UIColor colorWithWhite:0 alpha:0.4].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.4].CGColor);
    CGContextStrokePath(context);
}

- (void) drawBlueGradientInRect:(CGRect)rect
{
    rect = CGRectMake(0, 0, rect.size.width, 44);
    [PrettyDrawing drawGradient:rect fromColor:
     SEGMENTED_CONTROL_PRESSED_BLUE_GRADIENT_START_COLOR
                        toColor:SEGMENTED_CONTROL_PRESSED_BLUE_GRADIENT_END_COLOR];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathRef roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, -1, rect.size.width-1, 1) cornerRadius:self.layer.cornerRadius].CGPath;
    
    // inner shadow
    CGContextAddPath(context, roundedRect);
    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, 1), 1, [UIColor colorWithWhite:0 alpha:0.4].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.4].CGColor);
    CGContextStrokePath(context);
    
    CGRect leftShadowRect = CGRectMake(0, 0, 0.5, 44);
    CGRect rightShadowRect = CGRectMake(rect.size.width - 1, 0, 0.5, 44);
    
    CGPathRef leftRectPath = [UIBezierPath bezierPathWithRect:leftShadowRect].CGPath;
    CGPathRef rightRectPath = [UIBezierPath bezierPathWithRect:rightShadowRect].CGPath;
    
    // left shadow
    CGContextAddPath(context, leftRectPath);
    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, 1), 1, [UIColor colorWithWhite:0 alpha:0.4].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.4].CGColor);
    CGContextStrokePath(context);
    
    // right shadow
    CGContextAddPath(context, rightRectPath);
    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, 1), 1, [UIColor colorWithWhite:0 alpha:0.4].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.4].CGColor);
    CGContextStrokePath(context);
    
}

- (CGSize) detailTextSizeAtIndex:(int)i width:(float)width rect:(CGRect)rect
{
    NSString *detailText = [self.cell detailTextAtIndex:i];
    
    CGSize detailTextSize;
    detailTextSize = [detailText sizeWithFont:[self fontFromLabel:self.cell.detailTextLabel] 
                            constrainedToSize:CGSizeMake(width, rect.size.height)
                                lineBreakMode:UILineBreakModeTailTruncation];
    
    return detailTextSize;
}

- (CGSize) textSizeAtIndex:(int)i width:(float)width rect:(CGRect)rect
{
    CGSize textSize = CGSizeZero;     
    CGSize detailTextSize = CGSizeZero;
    
    NSString *text = [self.cell textAtIndex:i];
    NSString *detailText = [self.cell detailTextAtIndex:i];

    if (detailText) {
        detailTextSize = [self detailTextSizeAtIndex:i width:width rect:rect];
    }
    
    textSize = [text sizeWithFont:[self fontFromLabel:self.cell.textLabel] 
                constrainedToSize:CGSizeMake(width, rect.size.height - detailTextSize.height - label_margin*2)
                    lineBreakMode:UILineBreakModeTailTruncation];

    return textSize;
}


- (void) drawTextsAtIndex:(int)i width:(float)width rect:(CGRect)rect span:(float)x selected:(BOOL)selected
{
    CGSize textSize = [self textSizeAtIndex:i width:width rect:rect];     
    CGSize detailTextSize = [self detailTextSizeAtIndex:i width:width rect:rect];
    
    NSString *text = [self.cell textAtIndex:i];
    NSString *detailText = [self.cell detailTextAtIndex:i];
    
    if (text) 
    {
        CGRect textRect;
        float y = CGRectGetMaxY(rect) - textSize.height;
        if (detailTextSize.height != 0) {
            y -= detailTextSize.height;
        }
        y = y / 2;
        textRect = CGRectMake(x, y, width, textSize.height);

        textSize = [self drawText:text
                     basedOnLabel:self.cell.textLabel
                           inRect:textRect showAsSelected:selected];
    }
    
    if (detailText) 
    {                
        float y = CGRectGetMaxY(rect) - detailTextSize.height - label_margin;
        [self drawText:detailText
          basedOnLabel:self.cell.detailTextLabel 
                inRect:CGRectMake(x, y, width, detailTextSize.height) showAsSelected:selected];
    }
}

- (void) drawBackground:(CGRect)rect
{
    if (rect.origin.x == 0)
    {
        [PrettyDrawing drawGradient:CGRectMake(0, 0, 159, 44) fromColor:SEGMENTED_CONTROL_BLUE_GRADIENT_START_COLOR toColor:SEGMENTED_CONTROL_BLUE_GRADIENT_END_COLOR];
    }else {
        [PrettyDrawing drawGradient:CGRectMake(159, 0, 170, 44) fromColor:SEGMENTED_CONTROL_GREEN_GRADIENT_START_COLOR toColor:SEGMENTED_CONTROL_GREEN_GRADIENT_END_COLOR];
    }
    if ([[self.imageView subviews] count] < 2)
    {
        UIImageView *phoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segmented_control_phone-icon_white.png"]];
        phoneImageView.opaque = YES;
        UIImageView *messageImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"messagesTab.png"]];
        phoneImageView.frame = CGRectMake(190, 6, 30, 30);
        messageImageView.frame = CGRectMake(30, 6, 35, 35);
        messageImageView.opaque = YES;
        [self.imageView addSubview:phoneImageView];
        [self.imageView addSubview:messageImageView];
    }
    
}

- (void) drawRect:(CGRect)rect
{
    
    [self drawBackground:rect];
    
    UIImageView *phoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segmented_control_phone-icon_white.png"]];
    phoneImageView.opaque = YES;
    UIImageView *messageImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"messagesTab.png"]];
    phoneImageView.frame = CGRectMake(220, 6, 30, 30);
    messageImageView.frame = CGRectMake(60, 6, 35, 35);
    messageImageView.opaque = YES;
    [self addSubview:phoneImageView];
    [self addSubview:messageImageView];
    
    float width = self.segmentWidth;
    float x = 0;
    
    for (int i = 0; i < self.cell.numberOfElements; i++)
    {
        BOOL selected = self.selectedSegment == i;
        if (self.selectedSegment == 1) {
            //[self drawBackground:CGRectMake(0, 0, 160.0f, 44)];
            [self drawGreenGradientInRect:CGRectMake(160.0f, CGRectGetMinY(rect), 160.0f, 44)];
            
        }
        
        if (self.selectedSegment == 0) {
            [self drawBackground:CGRectMake(160.0f, 0, 160.0f, 44)];
            [self drawBlueGradientInRect:CGRectMake(0.0f, CGRectGetMinY(rect), 159.0f, 44)];
        }
        
        if (selected && self.cell.elementSelectionStyle != UITableViewCellSelectionStyleNone)
        {
            float selectionWidth = width;
            if (i == self.cell.numberOfElements-1) // last element
            {
                selectionWidth += 10; // just to make sure it covers all the surface
            }
            _gradientVisible = YES;
            //[self drawSelectionGradientInRect:CGRectMake(x, CGRectGetMinY(rect), selectionWidth, CGRectGetMaxY(rect))];
        }
        x += width;
    }
}

- (UIImage *) renderSelectionImage 
{
    // http://stackoverflow.com/questions/4965036/uigraphicsgetimagefromcurrentimagecontext-retina-resolution
    UIGraphicsBeginImageContextWithOptions(self.frame.size,YES,0.0f);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void) unselectAndRefresh 
{
    self.selectedSegment = -1;
    [self setNeedsDisplay];
}

- (void) deselectAnimated:(BOOL)animated completion:(void (^)(void))block
{
    UIImageView *imageView = nil;
    
    if (animated) 
    {
        UIImage *image = [self renderSelectionImage];
        
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.alpha = 1;
        
        [self addSubview:imageView];
    }    
    
    float delay = 0.05;
    if (!animated) 
    {
        delay = 0.10;
    }
    [self performSelector:@selector(unselectAndRefresh) withObject:nil afterDelay:delay];
    
    if (animated) 
    {
        [UIView animateWithDuration:0.6
                              delay:0.05
                            options:UIViewAnimationOptionShowHideTransitionViews
                         animations:^{
                             imageView.alpha = 0;
                         } 
                         completion:^(BOOL finished) {
                             [imageView removeFromSuperview];
                             [imageView release]; 
                             if (block) {
                                 block();
                             }
                         }];
    }
}

- (void) hardDeselect
{
    [self deselectAnimated:NO completion:nil];
}

- (void) selectIndex:(int)index
{
    self.selectedSegment = index;
    [self setNeedsDisplay];
}



- (void) selectedButton:(id)sender event:(UIEvent *)event
{
    float width = self.segmentWidth;
    UITouch *touch = [[event touchesForView:self] anyObject];
    
    for (int i = 0; i < self.cell.numberOfElements; i++) 
    {
        if ([touch locationInView:self].x < width) {
            [self selectIndex:i];
            return;
        }
        width += self.segmentWidth;
    }
}


- (void) fireButtonAction:(id)sender event:(UIEvent *)event
{
    if (self.selectedSegment != -1 && self.cell.actionBlock != nil) 
    {
        self.cell.actionBlock(self.cell->_currentIndexPath, self.selectedSegment);
    }
}

- (id) init 
{
    if (self = [super init]) 
    {
        self.selectedSegment = -1;
        self.contentMode = UIViewContentModeRedraw;
        
        [self addTarget:self action:@selector(selectedButton:event:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(hardDeselect) forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside | UIControlEventTouchUpOutside];        
        [self addTarget:self action:@selector(fireButtonAction:event:) forControlEvents:UIControlEventTouchUpInside];           
    }
    
    return self;
}

- (UIColor *) backgroundColor 
{
    return self.cell.backgroundColor;
}

@end



@implementation PrettyGridTableViewCell
@synthesize numberOfElements, elementSelectionStyle, textAlignment, actionBlock;
@synthesize shadowOnlyOnSelected;

- (void) dealloc 
{
    if (_texts != nil) {
        [_texts release];
        _texts = nil;
    }
    if (_detailTexts != nil) {
        [_detailTexts release];
        _detailTexts = nil;
    }
    if (_currentIndexPath != nil) {
        [_currentIndexPath release];
        _currentIndexPath = nil;
    }
    
    
    [super dealloc];
}

- (void) initVars 
{
    if (_texts != nil) {
        [_texts release];
    }
    if (_detailTexts != nil) {
        [_detailTexts release];
    }
    _texts = [[NSMutableDictionary alloc] init];
    _detailTexts = [[NSMutableDictionary alloc] init];
    
    PrettyGridSubview *subview = (PrettyGridSubview *)self.customView;
    subview.selectedSegment = -1;
}


- (void) customPrepareForReuse 
{
    [self.customView setNeedsDisplay];
}

- (void) prepareForReuse 
{
    [super prepareForReuse];
    
    [self customPrepareForReuse];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        _style = style;
        PrettyGridSubview *subview = [[PrettyGridSubview alloc] init];
        subview.cell = self;
        self.customView = subview;
        [subview release];
        
        self.elementSelectionStyle = UITableViewCellSelectionStyleBlue;
        self.textAlignment = UITextAlignmentCenter;
        [self initVars];
    }
    return self;
}

- (NSArray *) sortDictionary:(NSDictionary *)dictionary 
{
    NSMutableArray *sortedArray = [NSMutableArray array];
    
    for (int i = 0; i < self.numberOfElements; i++) 
    {
        NSNumber *index = [NSNumber numberWithInt:i];
        id object = [dictionary objectForKey:index];
        if (object != nil) {
            [sortedArray addObject:object];
        }
    }
    
    return sortedArray;
}

- (NSArray *) texts 
{
    return [self sortDictionary:_texts];
}

- (NSArray *) detailTexts 
{
    return [self sortDictionary:_detailTexts];
}


- (void) setText:(NSString *)text atIndex:(int)iindex 
{
    NSNumber *index = [NSNumber numberWithInt:iindex];
    
    [_texts setObject:text forKey:index];
}

- (NSString *)textAtIndex:(int)iindex 
{
    NSNumber *index = [NSNumber numberWithInt:iindex];
    
    return [_texts objectForKey:index];
}

- (void) setDetailText:(NSString *)detailText atIndex:(int)iindex 
{
    NSNumber *index = [NSNumber numberWithInt:iindex];
    
    [_detailTexts setObject:detailText forKey:index];
}


- (NSString *)detailTextAtIndex:(int)iindex 
{
    NSNumber *index = [NSNumber numberWithInt:iindex];
    
    return [_detailTexts objectForKey:index];
}


- (void) setNumberOfElements:(int)elements 
{
    numberOfElements = elements;
    
    [self initVars];
}

- (void) prepareForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath 
{
    [super prepareForTableView:tableView indexPath:indexPath];
    
    if (_currentIndexPath != nil) {
        [_currentIndexPath release];
    }
    _currentIndexPath = [indexPath retain];
}

- (void) selectIndex:(int)index 
{
    PrettyGridSubview *subview = (PrettyGridSubview *)self.customView;
    
    [subview selectIndex:index];
}

- (void) deselectAnimated:(BOOL)animated 
{
    [self deselectAnimated:animated completion:nil];
}

- (void) deselectAnimated:(BOOL)animated completion:(void (^) (void))block
{
    PrettyGridSubview *subview = (PrettyGridSubview *)self.customView;
    
    [subview deselectAnimated:animated completion:block];
}



@end
