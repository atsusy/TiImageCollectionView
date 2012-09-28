//
//  JpMsmcImagecollectionviewGridViewCell.m
//  tiimagecollectionview
//
//  Created by KATAOKA,Atsushi on 2012/09/23.
//
//

#import "JpMsmcImagecollectionviewGridViewCell.h"
#import "UIImageView+WebCache.h"
#import "TiUtils.h"

@implementation JpMsmcImagecollectionviewGridViewCell
@synthesize url;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)aReuseIdentifier placeholderImage:(UIImage *)aPlaceholderImage
{
    self = [super initWithFrame:frame reuseIdentifier:aReuseIdentifier];
    if (!self){
        return nil;
    }
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageContentView = [[UIView alloc] initWithFrame:CGRectZero];
    
    placeholderImage = aPlaceholderImage;
    
    [imageContentView addSubview:imageView];
    [imageContentView setClipsToBounds:YES];
    
    [self.contentView addSubview:imageContentView];
    
    [imageView release];
    [imageContentView release];
    
    return self;
}

- (CALayer *)glowSelectionLayer
{
    return self.contentView.layer;
}

- (NSString *)url
{
    return url;
}

- (void)setUrl:(NSString *)anURL
{
    RELEASE_TO_NIL(url);
    url = [anURL retain];
    
    NSString *encoded = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];    
    [imageView setImageWithURL:[NSURL URLWithString:encoded]
              placeholderImage:placeholderImage
                       success:^(UIImage *image, BOOL cached){
                           [self setNeedsLayout];
                       }
                       failure:^(NSError *error){
                       
                       }];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize imageSize = imageView.image.size;
    CGRect frame = imageView.frame;
    CGRect bounds = self.contentView.bounds;

    imageContentView.frame = self.contentView.frame;
    
    if ((imageSize.width <= bounds.size.width) &&
        (imageSize.height <= bounds.size.height)){
        imageView.frame = CGRectMake((bounds.size.width - imageSize.width) / 2.0,
                                     (bounds.size.height - imageSize.height) / 2.0,
                                     imageSize.width,
                                     imageSize.height);
        return;
    }

    // scale it down to fit
    CGFloat hRatio = bounds.size.width / imageSize.width;
    CGFloat vRatio = bounds.size.height / imageSize.height;
    CGFloat ratio = MAX(hRatio, vRatio);
    
    frame.size.width = floorf(imageSize.width * ratio);
    frame.size.height = floorf(imageSize.height * ratio);
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
    frame.origin.y = floorf((bounds.size.height - frame.size.height) * 0.5);
    imageView.frame = frame;
}

- (void)dealloc
{
    RELEASE_TO_NIL(placeholderImage);
    RELEASE_TO_NIL(url);

    [super dealloc];
}

@end
