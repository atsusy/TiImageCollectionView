//
//  JpMsmcImagecollectionviewImageCollectionView.m
//  tiimagecollectionview
//
//  Created by KATAOKA,Atsushi on 2012/09/23.
//
//

#import "JpMsmcImagecollectionviewImageCollectionView.h"
#import "JpMsmcImagecollectionviewGridViewCell.h"

@implementation JpMsmcImagecollectionviewImageCollectionView

- (UIImage *)resizedImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height
{
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height),
                                               NO,
                                               [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh); // 高品質リサイズ

    [image drawInRect:CGRectMake(0.0, 0.0, width, height)];

    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return resizedImage;
}

- (void)initializeState
{
    [super initializeState];
    
    cellSize = CGSizeMake(96.0, 64.0);
    cellPadding = CGSizeZero;
    
    NSString *defaultPhoto = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"modules/ui/images/photoDefault.png"];
    placeHolder = [[self resizedImage:[UIImage imageWithContentsOfFile:defaultPhoto]
                                width:32.0
                               height:26.0] retain];
    selectionGlowColor = [[UIColor clearColor] retain];
    selectionGlowRadius = 6.0;
}

- (AQGridView *)gridView
{
    if (!gridView) {
        CGRect r = CGRectMake(0.0,
                              0.0,
                              self.frame.size.width,
                              self.frame.size.height);
        gridView = [[AQGridView alloc] initWithFrame:r];
        gridView.delegate = self;
        gridView.dataSource = self;
        
        [self addSubview:gridView];
        [gridView reloadData];
    }
    return gridView;
}

- (void)setImages_:(id)newImages
{
    ENSURE_UI_THREAD_1_ARG(newImages);
    ENSURE_ARRAY(newImages);
    
    RELEASE_TO_NIL(images);
    images = [newImages retain];
    
    [[self gridView] reloadData];
}

- (void)setHeaderView_:(id)headerView
{
    ENSURE_UI_THREAD_1_ARG(headerView);
    
    [[self gridView] setGridHeaderView:[headerView view]];
}

- (void)setFooterView_:(id)footerView
{
    ENSURE_UI_THREAD_1_ARG(footerView);
    
    [[self gridView] setGridFooterView:[footerView view]];
}

- (void)setCellSize_:(id)newCellSize
{
    ENSURE_UI_THREAD_1_ARG(newCellSize);
    ENSURE_SINGLE_ARG(newCellSize, NSDictionary);
        
    CGFloat w = [[newCellSize valueForKey:@"width"] floatValue];
    CGFloat h = [[newCellSize valueForKey:@"height"] floatValue];
    cellSize = CGSizeMake(w, h);
    
    [[self gridView] reloadData];
}

- (void)setCellPadding_:(id)newCellPadding
{
    ENSURE_UI_THREAD_1_ARG(newCellPadding);
    ENSURE_SINGLE_ARG(newCellPadding, NSDictionary);
    
    CGFloat x = [[newCellPadding valueForKey:@"x"] floatValue];
    CGFloat y = [[newCellPadding valueForKey:@"y"] floatValue];
    cellPadding = CGSizeMake(x, y);
    
    [[self gridView] reloadData];    
}

- (void)setLeftContentInset_:(id)leftContentInset
{
    ENSURE_UI_THREAD_1_ARG(leftContentInset);
    ENSURE_SINGLE_ARG(leftContentInset, NSNumber);

    [[self gridView] setLeftContentInset:[leftContentInset floatValue]];
}

- (void)setRightContentInset_:(id)rightContentInset
{
    ENSURE_UI_THREAD_1_ARG(rightContentInset);
    ENSURE_SINGLE_ARG(rightContentInset, NSNumber);
    
    [[self gridView] setRightContentInset:[rightContentInset floatValue]];
}

- (void)setPlaceHolder_:(id)newPlaceHolder
{
    ENSURE_UI_THREAD_1_ARG(newPlaceHolder);
    
    RELEASE_TO_NIL(placeHolder);
    placeHolder = [[TiUtils image:newPlaceHolder proxy:self.proxy] retain];
}

- (void)setSelectionGlowColor_:(id)newSelectionGlowColor
{
    ENSURE_UI_THREAD_1_ARG(newSelectionGlowColor);
    
    RELEASE_TO_NIL(selectionGlowColor);
    selectionGlowColor = [[[TiUtils colorValue:newSelectionGlowColor] color] retain];
}

- (void)setSelectionGlowRadius_:(id)newSelectionGlowRadius
{
    ENSURE_UI_THREAD_1_ARG(newSelectionGlowRadius);
    ENSURE_SINGLE_ARG(newSelectionGlowRadius, NSNumber);
    
    selectionGlowRadius = [newSelectionGlowRadius floatValue];    
}

#pragma mark -
#pragma mark Memory managements

- (void)dealloc
{
    RELEASE_TO_NIL(gridView);
    RELEASE_TO_NIL(images);
    RELEASE_TO_NIL(placeHolder);
    RELEASE_TO_NIL(selectionGlowColor);
    
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycles

- (void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    [[self gridView] setFrame:frame];
    NSLog(@"[DEBUG] frameSizeChanged / origin:(%f,%f) size:(%f,%f)",
          frame.origin.x,
          frame.origin.y,
          frame.size.width,
          frame.size.height);
}

#pragma mark -
#pragma mark AQGridView - data source

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)aGridView
{
    return [images count];
}

- (AQGridViewCell *)gridView:(AQGridView *)aGridView cellForItemAtIndex:(NSUInteger)index
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    JpMsmcImagecollectionviewGridViewCell *cell =
    (JpMsmcImagecollectionviewGridViewCell *)[aGridView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[JpMsmcImagecollectionviewGridViewCell alloc] initWithFrame:CGRectMake((cellSize.width - cellPadding.width * 2.0) /2.0,
                                                                                       (cellSize.height - cellPadding.height * 2.0) / 2.0,
                                                                                       cellSize.width - cellPadding.width * 2.0,
                                                                                       cellSize.height - cellPadding.height * 2.0)
                                                            reuseIdentifier:CellIdentifier
                                                           placeholderImage:placeHolder];
    }
    cell.url = [[images objectAtIndex:index] valueForKey:@"url"];
    cell.selectionGlowColor = selectionGlowColor;
    cell.selectionGlowShadowRadius = selectionGlowRadius;
    
    return cell;
}

- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)aGridView
{
    return cellSize;
}

#pragma mark -
#pragma mark AQGridView - delegate

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    if([self.proxy _hasListeners:@"selected"])
    {
        [self.proxy fireEvent:@"selected" withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      [images objectAtIndex:index], @"item",
                                                      nil]
        ];
    }
}

#pragma mark -
#pragma mark UIScrollView - delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([self.proxy _hasListeners:@"scroll"])
    {
        NSDictionary *contentSize = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                     [NSNumber numberWithFloat:scrollView.contentSize.width], @"width",
                                     [NSNumber numberWithFloat:scrollView.contentSize.height], @"height",
                                     nil] autorelease];
        
        TiPoint *contentOffset = [[[TiPoint alloc] initWithPoint:scrollView.contentOffset] autorelease];
        
        [self.proxy fireEvent:@"scroll" withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    contentOffset, @"contentOffset",
                                                    contentSize, @"contentSize",
                                                    nil]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if([self.proxy _hasListeners:@"scrollEnd"])
    {
        NSDictionary *contentSize = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                      [NSNumber numberWithFloat:scrollView.contentSize.width], @"width",
                                      [NSNumber numberWithFloat:scrollView.contentSize.height], @"height",
                                      nil] autorelease];
        
        TiPoint *contentOffset = [[[TiPoint alloc] initWithPoint:scrollView.contentOffset] autorelease];

        [self.proxy fireEvent:@"scrollEnd" withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       contentOffset, @"contentOffset",
                                                       contentSize, @"contentSize",
                                                       nil]];
    }
}

@end
