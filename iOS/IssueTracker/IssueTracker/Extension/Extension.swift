//
//  Extension.swift
//  IssueTracker
//
//  Created by eunjeong lee on 2020/10/28.
//

import UIKit

extension Array {
    subscript (safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}

extension NSObject {
    var typeName: String {
        String(describing: type(of: self))
    }
}

extension String {
    var processedBlank: String {
        self.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
    }
}

extension UICollectionView {
    
    func indexPath(with tapGestureRecognizer: UITapGestureRecognizer) -> IndexPath? {
        let point = tapGestureRecognizer.location(in: self)
        return self.indexPathForItem(at: point)
    }
}

extension UIView {
    var viewFromNib: UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: typeName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func configureNib() {
        guard let view = viewFromNib else { return }
        view.frame = bounds
        addSubview(view)
    }
}

extension UIView {
    func setConstraintToFit(at view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension UIView {
    func configureTapGesture(target: Any?, action: Selector? = nil) {
        let tapGestureRecognizer =
            UITapGestureRecognizer(target: target, action: action)
        tapGestureRecognizer.numberOfTouchesRequired = 1
        tapGestureRecognizer.isEnabled = true
        tapGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(tapGestureRecognizer)
    }
}

extension UIViewController {
    func presentAlert(title: String, message: String, allowHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let allowAction = UIAlertAction(title: Constant.확인, style: .default) { (action) in
            allowHandler?()
        }
        let cancelAction = UIAlertAction(title: Constant.취소, style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(allowAction)
        present(alert, animated: true)
    }
    
    enum Constant {
        static let 확인: String = "확인"
        static let 취소: String = "취소"
    }
}

extension UIApplication {
    static var snapshotView: UIView? {
        UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.snapshotView(
                afterScreenUpdates: true
        )
    }
}

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}

extension String {
    var color: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)

        guard let int = Scanner(string: hex).scanInt32(representation: .hexadecimal) else { return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) }

        let a, r, g, b: Int32
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }

        return UIColor(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
}

extension UIColor {
    
    var toHexString: String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
    
    static var randomColor: UIColor {
        let randomRed: CGFloat = CGFloat(drand48())
        let randomGreen: CGFloat = CGFloat(drand48())
        let randomBlue: CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
