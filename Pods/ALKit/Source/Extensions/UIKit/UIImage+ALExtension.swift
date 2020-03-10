//
//                            Open Your Mind!
//
//                  .-~~~~~~~~~-._       _.-~~~~~~~~~-.
//              __.'              ~.   .~              `.__
//            .'//                  \./                  \\`.
//          .'//                     |                     \\`.
//        .'// .-~"""""""~~~~-._     |     _,-~~~~"""""""~-. \\`.
//      .'//.-"                 `-.  |  .-'                 "-.\\`.
//    .'//______.============-..   \ | /   ..-============.______\\`.
//  .'______________________________\|/______________________________`.
//
//  UIImage+ALExtension.swift
//  ALAppCodesSwift
//
//  Created by Alirio-Lau on 2019/12/1.
//  Copyright © 2019 com.alirio.lau.www. All rights reserved.
//

import UIKit
import Accelerate

public extension UIImage {

  convenience init(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) {
    UIGraphicsBeginImageContextWithOptions(size, false, 1)

    defer { UIGraphicsEndImageContext() }

    color.setFill()
    UIRectFill(CGRect(origin: .zero, size: size))

    guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
      self.init()
      return
    }

    self.init(cgImage: aCgImage)
  }

  convenience init?(base64String: String, scale: CGFloat = 1.0) {
    guard let data = Data(base64Encoded: base64String) else { return nil }
    self.init(data: data, scale: scale)
  }

  convenience init?(url: URL, scale: CGFloat = 1.0) throws {
    let data = try Data(contentsOf: url)
    self.init(data: data, scale: scale)
  }

}

// MARK: - Properties

public extension ALWrapper where Base == UIImage {

  var bytesSize: Int {
    return base.jpegData(compressionQuality: 1)?.count ?? 0
  }

  var kilobytesSize: Int {
    return (base.jpegData(compressionQuality: 1)?.count ?? 0) / 1024
  }

  var original: UIImage {
    return base.withRenderingMode(.alwaysOriginal)
  }

  var template: UIImage {
    return base.withRenderingMode(.alwaysTemplate)
  }

}

// MARK: - Methods

public extension ALWrapper where Base == UIImage {

  func hasAlpha() -> Bool {
    guard let cgImage = base.cgImage else {
      return false
    }

    let alpha: CGImageAlphaInfo = cgImage.alphaInfo
    return (alpha == .first || alpha == .last || alpha == .premultipliedFirst || alpha == .premultipliedLast)
  }

  func removeAlpha() -> UIImage {
    guard hasAlpha(), let cgImage = base.cgImage else {
      return base
    }

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    guard let mainViewContentContext = CGContext(data: nil, width: Int(base.size.width), height: Int(base.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue) else {
      return base
    }

    mainViewContentContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))
    guard let mainViewContentBitmapContext = mainViewContentContext.makeImage() else {
      return base
    }

    let newImage = UIImage(cgImage: mainViewContentBitmapContext)

    return newImage
  }

  func fillAlpha(color: UIColor = UIColor.white) -> UIImage {
    let imageRect = CGRect(origin: .zero, size: base.size)

    let cgColor = color.cgColor

    UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.main.scale)
    guard let context: CGContext = UIGraphicsGetCurrentContext() else {
      UIGraphicsEndImageContext()
      return base
    }
    context.setFillColor(cgColor)
    context.fill(imageRect)
    base.draw(in: imageRect)

    guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
      UIGraphicsEndImageContext()
      return base
    }
    UIGraphicsEndImageContext()

    return newImage
  }

  func compressed(quality: CGFloat = 0.5) -> UIImage? {
    guard let data = base.jpegData(compressionQuality: quality) else { return nil }
    return UIImage(data: data)
  }

  /// Compressed UIImage data from original UIImage.
  ///
  /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
  /// - Returns: optional Data (if applicable).
  func compressedData(quality: CGFloat = 0.5) -> Data? {
    return base.jpegData(compressionQuality: quality)
  }

  func cropped(to rect: CGRect) -> UIImage {
    guard rect.size.width <= base.size.width && rect.size.height <= base.size.height else { return base }
    guard let image = base.cgImage?.cropping(to: CGRect(x: rect.origin.x * base.scale, y: rect.origin.y * base.scale, width: rect.size.width * base.scale, height: rect.size.height * base.scale)) else {
      return base
    }
    return UIImage(cgImage: image, scale: base.scale, orientation: base.imageOrientation)
  }

  func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
    let scale = toHeight / base.size.height
    let newWidth = base.size.width * scale
    UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, base.scale)
    base.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }

  func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
    let scale = toWidth / base.size.width
    let newHeight = base.size.height * scale
    UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, base.scale)
    base.draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }

  func scale(to size: CGSize) -> UIImage {
    let sourceImage = base

    let targetWidth = size.width
    let targetHeight = size.height

    let scaledWidth = targetWidth
    let scaledHeight = targetHeight

    let thumbnailPoint = CGPoint(x: 0.0, y: 0.0)

    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)

    var thumbnailRect = CGRect.zero
    thumbnailRect.origin = thumbnailPoint
    thumbnailRect.size.width = scaledWidth
    thumbnailRect.size.height = scaledHeight

    sourceImage.draw(in: thumbnailRect)

    guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
      UIGraphicsEndImageContext()
      return base
    }
    UIGraphicsEndImageContext()

    return newImage
  }

  func flipHorizontally() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.main.scale)
    guard let context: CGContext = UIGraphicsGetCurrentContext(), let cgImage = base.cgImage else {
      UIGraphicsEndImageContext()
      return base
    }

    context.translateBy(x: 0, y: base.size.height)
    context.scaleBy(x: 1.0, y: -1.0)

    context.translateBy(x: base.size.width, y: 0)
    context.scaleBy(x: -1.0, y: 1.0)

    context.draw(cgImage, in: CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))

    guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
      UIGraphicsEndImageContext()
      return base
    }
    UIGraphicsEndImageContext()

    return newImage
  }

  func flipVertically() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.main.scale)
    guard let context: CGContext = UIGraphicsGetCurrentContext(), let cgImage = base.cgImage else {
      UIGraphicsEndImageContext()
      return base
    }

    context.translateBy(x: 0, y: 0)
    context.scaleBy(x: 1.0, y: 1.0)

    context.draw(cgImage, in: CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))

    guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
      UIGraphicsEndImageContext()
      return base
    }
    UIGraphicsEndImageContext()

    return newImage
  }

  @available(iOS 10.0, tvOS 10.0, watchOS 3.0, *)
  func rotated(by angle: Measurement<UnitAngle>) -> UIImage? {
    let radians = CGFloat(angle.converted(to: .radians).value)

    let destRect = CGRect(origin: .zero, size: base.size)
      .applying(CGAffineTransform(rotationAngle: radians))
    let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                 y: destRect.origin.y.rounded(),
                                 width: destRect.width.rounded(),
                                 height: destRect.height.rounded())

    UIGraphicsBeginImageContext(roundedDestRect.size)
    guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }

    contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
    contextRef.rotate(by: radians)

    base.draw(in: CGRect(origin: CGPoint(x: -base.size.width / 2, y: -base.size.height / 2), size: base.size))

    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }

  /// Creates a copy of the receiver rotated by the given angle (in radians).
  ///
  ///     // Rotate the image by 180°
  ///     image.rotated(by: .pi)
  ///
  /// - Parameter radians: The angle, in radians, by which to rotate the image.
  /// - Returns: A new image rotated by the given angle.
  func rotated(by radians: CGFloat) -> UIImage? {
    let destRect = CGRect(origin: .zero, size: base.size)
      .applying(CGAffineTransform(rotationAngle: radians))
    let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                 y: destRect.origin.y.rounded(),
                                 width: destRect.width.rounded(),
                                 height: destRect.height.rounded())

    UIGraphicsBeginImageContext(roundedDestRect.size)
    guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }

    contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
    contextRef.rotate(by: radians)

    base.draw(in: CGRect(origin: CGPoint(x: -base.size.width / 2, y: -base.size.height / 2), size: base.size))

    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }

  /// UIImage filled with color
  ///
  /// - Parameter color: color to fill image with.
  /// - Returns: UIImage filled with given color.
  func filled(withColor color: UIColor) -> UIImage {

    if #available(iOS 10, tvOS 10, *) {
      let format = UIGraphicsImageRendererFormat()
      format.scale = base.scale
      let renderer = UIGraphicsImageRenderer(size: base.size, format: format)
      return renderer.image { context in
        color.setFill()
        context.fill(CGRect(origin: .zero, size: base.size))
      }
    }

    UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
    color.setFill()
    guard let context = UIGraphicsGetCurrentContext() else { return base }

    context.translateBy(x: 0, y: base.size.height)
    context.scaleBy(x: 1.0, y: -1.0)
    context.setBlendMode(CGBlendMode.normal)

    let rect = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
    guard let mask = base.cgImage else { return base }
    context.clip(to: rect, mask: mask)
    context.fill(rect)

    let newImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }

  /// UIImage tinted with color
  ///
  /// - Parameters:
  ///   - color: color to tint image with.
  ///   - blendMode: how to blend the tint
  /// - Returns: UIImage tinted with given color.
  func tint(_ color: UIColor, blendMode: CGBlendMode, alpha: CGFloat = 1.0) -> UIImage {
    let drawRect = CGRect(origin: .zero, size: base.size)

    if #available(iOS 10.0, tvOS 10.0, *) {
      let format = UIGraphicsImageRendererFormat()
      format.scale = base.scale
      return UIGraphicsImageRenderer(size: base.size, format: format).image { context in
        color.setFill()
        context.fill(drawRect)
        base.draw(in: drawRect, blendMode: blendMode, alpha: alpha)
      }
    }

    UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
    defer {
      UIGraphicsEndImageContext()
    }
    let context = UIGraphicsGetCurrentContext()
    color.setFill()
    context?.fill(drawRect)
    base.draw(in: drawRect, blendMode: blendMode, alpha: alpha)
    return UIGraphicsGetImageFromCurrentImageContext()!
  }

  /// UImage with background color
  ///
  /// - Parameters:
  ///   - backgroundColor: Color to use as background color
  /// - Returns: UIImage with a background color that is visible where alpha < 1
  func withBackgroundColor(_ backgroundColor: UIColor) -> UIImage {

    if #available(iOS 10.0, tvOS 10.0, *) {
      let format = UIGraphicsImageRendererFormat()
      format.scale = base.scale
      return UIGraphicsImageRenderer(size: base.size, format: format).image { context in
        backgroundColor.setFill()
        context.fill(context.format.bounds)
        base.draw(at: .zero)
      }
    }

    UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
    defer { UIGraphicsEndImageContext() }

    backgroundColor.setFill()
    UIRectFill(CGRect(origin: .zero, size: base.size))
    base.draw(at: .zero)

    return UIGraphicsGetImageFromCurrentImageContext()!
  }

  /// UIImage with rounded corners
  ///
  /// - Parameters:
  ///   - radius: corner radius (optional), resulting image will be round if unspecified
  /// - Returns: UIImage with all corners rounded
  func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
    let maxRadius = min(base.size.width, base.size.height) / 2
    let cornerRadius: CGFloat
    if let radius = radius, radius > 0 && radius <= maxRadius {
      cornerRadius = radius
    } else {
      cornerRadius = maxRadius
    }

    UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)

    let rect = CGRect(origin: .zero, size: base.size)
    UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
    base.draw(in: rect)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }

  /// Base 64 encoded PNG data of the image.
  ///
  /// - returns: Base 64 encoded PNG data of the image as a String.
  func pngBase64String() -> String? {
    return base.pngData()?.base64EncodedString()
  }

  /// Base 64 encoded JPEG data of the image.
  ///
  /// - parameter compressionQuality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality).
  /// - returns: Base 64 encoded JPEG data of the image as a String.
  func jpegBase64String(compressionQuality: CGFloat) -> String? {
    return base.jpegData(compressionQuality: compressionQuality)?.base64EncodedString()
  }

  /// Apply a filter to the image.
  /// Full list of CIFilters [here](https://developer.apple.com/library/prerelease/content/documentation/GraphicsImaging/Reference/CoreImageFilterReference/).
  ///
  /// - Parameters:
  ///   - name: Filter name.
  ///   - parameters: Keys and values of the filter. A key example is kCIInputCenterKey.
  /// - Returns: Returns the transformed image.
  func filter(name: String, parameters: [String: Any] = [:]) -> UIImage {
    let context = CIContext(options: nil)
    guard let filter = CIFilter(name: name), let ciImage = CIImage(image: base) else {
      return base
    }

    filter.setValue(ciImage, forKey: kCIInputImageKey)

    for (key, value) in parameters {
      filter.setValue(value, forKey: key)
    }

    guard let outputImage = filter.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
      return base
    }

    let newImage = UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: base.imageOrientation)

    return newImage.al.scale(to: base.size)
  }

  /// Apply the bloom effect to the image.
  ///
  /// - Parameters:
  ///   - radius: Radius of the bloom.
  ///   - intensity: Intensity of the bloom.
  /// - Returns: Returns the transformed image.
  func bloom(radius: Float, intensity: Float) -> UIImage {
    return filter(name: "CIBloom", parameters: [kCIInputRadiusKey: radius, kCIInputIntensityKey: intensity])
  }

  /// Apply the circular wrap effect to the image.
  ///
  /// - Parameters:
  ///   - center: Vector of the distortion. Use CIVector(x: X, y: Y).
  ///   - radius: Radius of the effect.
  ///   - angle: Angle of the effect in radians.
  /// - Returns: Returns the transformed image.
  func circularWrap(center: CIVector, radius: Float, angle: Float) -> UIImage {
    return filter(name: "CICircularWrap", parameters: [kCIInputCenterKey: center, kCIInputRadiusKey: radius, kCIInputAngleKey: angle])
  }

  /// Apply the blur effect to the image.
  ///
  /// - Parameters:
  ///   - blurRadius: Blur radius.
  ///   - saturation: Saturation delta factor, leave it default (1.8) if you don't what is.
  ///   - tintColor: Blur tint color, default is nil.
  ///   - maskImage: Apply a mask image, leave it default (nil) if you don't want to mask.
  /// - Returns: Return the transformed image.
  func blur(radius blurRadius: CGFloat, saturation: CGFloat = 1.8, tintColor: UIColor? = nil, maskImage: UIImage? = nil) -> UIImage {
    guard base.size.width > 1 && base.size.height > 1, let selfCGImage = base.cgImage else {
      return base
    }

    let imageRect = CGRect(origin: CGPoint(x: 0, y: 0), size: base.size)
    var effectImage = base

    let hasBlur = Float(blurRadius) > Float.ulpOfOne
    let saturationABS = Swift.abs(saturation - 1)
    let saturationABSFloat = Float(saturationABS)
    let hasSaturationChange = saturationABSFloat > Float.ulpOfOne

    if hasBlur || hasSaturationChange {
      UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.main.scale)
      guard let effectInContext = UIGraphicsGetCurrentContext() else {
        UIGraphicsEndImageContext()
        return base
      }
      effectInContext.scaleBy(x: 1, y: -1)
      effectInContext.translateBy(x: 0, y: -base.size.height)
      effectInContext.draw(selfCGImage, in: imageRect)
      var effectInBuffer = vImage_Buffer(data: effectInContext.data, height: UInt(effectInContext.height), width: UInt(effectInContext.width), rowBytes: effectInContext.bytesPerRow)

      UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.main.scale)
      guard let effectOutContext = UIGraphicsGetCurrentContext() else {
        UIGraphicsEndImageContext()
        return base
      }
      var effectOutBuffer = vImage_Buffer(data: effectOutContext.data, height: UInt(effectOutContext.height), width: UInt(effectOutContext.width), rowBytes: effectOutContext.bytesPerRow)

      if hasBlur {
        var inputRadius = blurRadius * UIScreen.main.scale
        let sqrt2PI = CGFloat(sqrt(2 * Double.pi))
        inputRadius = inputRadius * 3.0 * sqrt2PI / 4 + 0.5
        var radius = UInt32(Darwin.floor(inputRadius))
        if radius % 2 != 1 {
          radius += 1
        }

        let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
        vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
        vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
        vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
      }

      if hasSaturationChange {
        let floatingPointSaturationMatrix = [
          0.0722 + 0.9278 * saturation, 0.0722 - 0.0722 * saturation, 0.0722 - 0.0722 * saturation, 0,
          0.7152 - 0.7152 * saturation, 0.7152 + 0.2848 * saturation, 0.7152 - 0.7152 * saturation, 0,
          0.2126 - 0.2126 * saturation, 0.2126 - 0.2126 * saturation, 0.2126 + 0.7873 * saturation, 0,
          0, 0, 0, 1
        ]

        let divisor: CGFloat = 256
        let saturationMatrix = floatingPointSaturationMatrix.map {
          return Int16(round($0 * divisor))
        }

        if hasBlur {
          vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
        } else {
          vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
        }
      }

      guard let imageContext = UIGraphicsGetImageFromCurrentImageContext() else {
        return base
      }

      effectImage = imageContext
      UIGraphicsEndImageContext()
    }

    UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.main.scale)
    guard let outputContext = UIGraphicsGetCurrentContext() else {
      UIGraphicsEndImageContext()
      return base
    }
    outputContext.scaleBy(x: 1, y: -1)
    outputContext.translateBy(x: 0, y: -base.size.height)

    outputContext.draw(selfCGImage, in: imageRect)

    if hasBlur {
      outputContext.saveGState()

      if let maskImage = maskImage, let maskCGImage = maskImage.cgImage {
        outputContext.clip(to: imageRect, mask: maskCGImage)
      } else if let effectCGImage = effectImage.cgImage {
        outputContext.draw(effectCGImage, in: imageRect)
      }

      outputContext.restoreGState()
    }

    if let tintColor = tintColor {
      outputContext.saveGState()
      outputContext.setFillColor(tintColor.cgColor)
      outputContext.fill(imageRect)
      outputContext.restoreGState()
    }

    guard let outputImage = UIGraphicsGetImageFromCurrentImageContext() else {
      UIGraphicsEndImageContext()
      return base
    }

    UIGraphicsEndImageContext()

    return outputImage
  }

  func fixOrientation() -> UIImage {
    var image = base
    if base.imageOrientation == .up {
      return image
    }
    var transform = CGAffineTransform.identity
    switch base.imageOrientation {
    case .down, .downMirrored:
      transform = transform.translatedBy(x: image.size.width, y: image.size.height)
      transform = transform.rotated(by: .pi / 2)
    case .left, .leftMirrored:
      transform = transform.translatedBy(x: image.size.width, y: 0)
      transform = transform.rotated(by: .pi / 2)
    case .right, .rightMirrored :
      transform = transform.translatedBy(x: 0, y: image.size.height)
      transform = transform.rotated(by: -.pi / 2)
    default:
      break
    }

    switch base.imageOrientation {
    case .upMirrored, .downMirrored:
      transform = transform.translatedBy(x: image.size.width,y: 0)
      transform = transform.scaledBy(x: -1, y: 1)
    case .rightMirrored, .leftMirrored:
      transform = transform.translatedBy(x: image.size.height,y: 0)
      transform = transform.scaledBy(x: -1, y: 1)
    default:
      break
    }

    let ctx = CGContext(data: nil , width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue)

    ctx!.concatenate(transform)

    switch image.imageOrientation {
    case .left, .leftMirrored, .right, .rightMirrored:
      ctx?.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
    default:
      ctx?.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    }

    let cgImage = ctx!.makeImage()
    image = UIImage(cgImage: cgImage!)
    
    return image
  }

}
