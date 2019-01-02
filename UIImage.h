//
//  Header.h
//  ImageFinder
//
//  Created by Yannis on 1/24/15.
//
//

#ifndef ImageFinder_UIImage_h
#define ImageFinder_UIImage_h
#endif

@interface UIImage : NSObject <NSSecureCoding> {
    void *_imageRef;
    double _scale;
    struct {
        unsigned int named : 1;
        unsigned int imageOrientation : 3;
        unsigned int cached : 1;
        unsigned int hasPattern : 1;
        unsigned int isCIImage : 1;
        unsigned int renderingMode : 2;
        unsigned int suppressesAccessibilityHairlineThickening : 1;
        unsigned int hasDecompressionInfo : 1;
    } _imageFlags;
    struct UIEdgeInsets {
        double top;
        double left;
        double bottom;
        double right;
    } _alignmentRectInsets;
}

@property(readonly) double _gkScale;
@property(readonly) struct CGImage { }* _gkCGImage;
@property(readonly) long long _gkImageOrientation;
@property(readonly) long long leftCapWidth;
@property(readonly) long long topCapHeight;
@property(readonly) struct CGSize { double x1; double x2; } size;
@property(readonly) struct CGImage* CGImage;
@property(readonly) long long imageOrientation;
@property(readonly) double scale;
@property(readonly) NSArray * images;
@property(readonly) double duration;
@property(readonly) struct UIEdgeInsets { double x1; double x2; double x3; double x4; } capInsets;
@property(readonly) long long resizingMode;
@property(readonly) long long renderingMode;

+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(double)arg3;
+ (id)imageWithContentsOfFile:(id)arg1;
+ (id)imageWithCGImage:(struct CGImage*)arg1;
+ (id)_iconForResourceProxy:(id)arg1 format:(int)arg2;
+ (void)initialize;
+ (bool)supportsSecureCoding;
+ (struct CGSize)_legibilityImageSizeForSize:(struct CGSize)arg1 style:(long long)arg2;
+ (id)_cachedImageForKey:(id)arg1 fromBlock:(id)arg2;
+ (id)_tintedImageForSize:(struct CGSize)arg1 withTint:(id)arg2 effectsImage:(id)arg3 maskImage:(id)arg4 style:(int)arg5;
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2;
+ (id)_iconForResourceProxy:(id)arg1 variant:(int)arg2 variantsScale:(double)arg3;
+ (int)_iconVariantForUIApplicationIconFormat:(int)arg1 scale:(double*)arg2;
+ (long long)_idiomDefinedByPath:(id)arg1;
+ (unsigned long long)_scaleDefinedByPath:(id)arg1;
+ (id)imageAtPath:(id)arg1;
+ (id)_deviceSpecificImageNamed:(id)arg1 inBundle:(id)arg2;
+ (id)_deviceSpecificImageNamed:(id)arg1;
+ (id)imageWithContentsOfCPBitmapFile:(id)arg1 flags:(int)arg2;
+ (id)imageFromAlbumArtData:(id)arg1 height:(int)arg2 width:(int)arg3 bytesPerRow:(int)arg4 cache:(bool)arg5;
+ (id)_defaultBackgroundGradient;
+ (id)imageNamed:(id)arg1 inBundle:(id)arg2;
+ (id)_backgroundGradientWithStartColor:(id)arg1 andEndColor:(id)arg2;
+ (id)_kitImageNamed:(id)arg1 withTrait:(id)arg2;
+ (id)animatedImageNamed:(id)arg1 duration:(double)arg2;
+ (id)imageWithCIImage:(id)arg1 scale:(double)arg2 orientation:(long long)arg3;
+ (id)imageWithCIImage:(id)arg1;
+ (id)imageWithData:(id)arg1 scale:(double)arg2;
+ (id)imageWithData:(id)arg1;
+ (id)_imageNamed:(id)arg1 withTrait:(id)arg2;
+ (id)imageNamed:(id)arg1;
+ (id)imageNamed:(id)arg1 inBundle:(id)arg2 compatibleWithTraitCollection:(id)arg3;
+ (void)_flushCache:(id)arg1;
+ (id)animatedImageWithImages:(id)arg1 duration:(double)arg2;
+ (id)imageWithCGImage:(struct CGImage *)arg1 scale:(double)arg2 orientation:(long long)arg3;
+ (void)_flushSharedImageCache;
+ (id)kitImageNamed:(id)arg1;
+ (id)abImageNamed:(id)arg1;
+ (id)ab_tintedImageNamed:(id)arg1 withTint:(id)arg2;
+ (id)ab_imageNamed:(id)arg1;
+ (void)_gkloadRemoteImageForURL:(id)arg1 queue:(id)arg2 withCompletionHandler:(id)arg3;
+ (id)_gkImageWithRawData:(id)arg1 size:(struct CGSize)arg2 scale:(double)arg3 rowBytes:(unsigned long long)arg4 bitmapInfo:(unsigned int)arg5;
+ (id)_gkImageWithCGImage:(struct CGImage *)arg1 scale:(double)arg2 orientation:(long long)arg3;
+ (id)_mapkit_imageNamed:(id)arg1;
+ (id)tpImageNamed:(id)arg1 inBundle:(id)arg2;
+ (bool)isSizeSwappedForImageOrientation:(long long)arg1;
+ (id)socialFrameworkImageNamed:(id)arg1;
+ (id)imageWithPKImage:(id)arg1;
+ (id)blj_imageNamed:(id)arg1;

@end