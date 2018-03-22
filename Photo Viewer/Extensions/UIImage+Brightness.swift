import UIKit

extension CGImage {
    fileprivate var isDark: Bool {
        get {
            guard let imageData = self.dataProvider?.data else { return false }
            guard let ptr = CFDataGetBytePtr(imageData) else { return false }
            let length = CFDataGetLength(imageData)
            var darkPixels = 0
            var lightPixels = 0
            for i in stride(from: 0, to: length, by: 4) {
                let r = ptr[i]
                let g = ptr[i + 1]
                let b = ptr[i + 2]
                let luminance = (0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b))
                if luminance < 170 {
                    darkPixels += 1
                } else {
                    lightPixels += 1
                }
            }
            return darkPixels > lightPixels
        }
    }
}

extension UIImage {
    public var isDark: Bool {
        get {
            return self.resized.cgImage?.isDark ?? false
        }
    }

    private var resized: UIImage {
        get {
            let size = CGSize(width: 5, height: 5)
            UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
            self.draw(in: CGRect(origin: CGPoint.zero, size: size))
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return scaledImage ?? self
        }
    }
}
