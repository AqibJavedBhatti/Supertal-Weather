//
//  viewExtensions.swift
//  Supertal Weather
//
//  Created by Aqib Javed on 20/03/2024.
//

import Foundation
import UIKit


private var vBorderColour: UIColor = UIColor.white
private var vCornerRadius: CGFloat = 0.0
private var vBorderWidth: CGFloat = 0.0
private var vMasksToBounds: Bool = true
private var vMakeCircle: Bool = false
var isStopBlinking : Bool = false
extension UIView {
    
    func pinEdgesToSuperView() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func setCardView(view : UIView){
        view.layer.cornerRadius = 5.0
        view.layer.borderColor  =  UIColor.clear.cgColor
        view.layer.borderWidth = 5.0
        view.layer.shadowOpacity = 0.5
        view.layer.shadowColor =  UIColor.lightGray.cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width:5, height: 5)
        view.layer.masksToBounds = true
    }
    
    func setGradientBackground(view : UIView)  {
        let colorTop =  UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.7).cgColor
        let colorBottom = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.7).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds

        view.layer.insertSublayer(gradientLayer, at:0)
    }
    func zoomIn(duration: TimeInterval = 0.2) {
          self.isHidden = false
          self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
          UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
              self.transform = CGAffineTransform.identity
          }) { (animationCompleted: Bool) -> Void in
          }
      }
    
    func zoomInLight(duration: TimeInterval = 0.2) {
          self.isHidden = false
          self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
          UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
              self.transform = CGAffineTransform.identity
          }) { (animationCompleted: Bool) -> Void in
          }
      }
    
    func zoomOut(duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }) { (animationCompleted: Bool) -> Void in
              self.isHidden = true
        }
    }
    
    func Blinking(duration: TimeInterval = 1.8) {
        let alpha = self.alpha
        if alpha == 1.0 {
            self.alpha = 1.0
        }else{
            self.alpha = 0.6
        }

        UIView.animate(withDuration: duration, delay: 1.0, options: [.curveLinear], animations: { () -> Void in
            if alpha == 1.0 {
                self.alpha = 0.6
            }else{
                self.alpha = 1.0
            }
        }) { (animationCompleted: Bool) -> Void in
            if !isStopBlinking {
                self.Blinking()
//                self.bouncingAnimation()
            }
        }
    }

    func bouncingAnimation() {
        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.8)
        UIView.animate(withDuration: 1.7,delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 4.0,options: .allowUserInteraction,animations: {
            [weak self] in
            self?.transform = .identity
            }, completion: nil)
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return vCornerRadius
        }
        set {
            layer.cornerRadius = newValue
            vCornerRadius = newValue
            self.setNeedsLayout()

        }
    }

    func showLoading() {
//        DispatchQueue.main.async {
//            let hud = MBProgressHUD.showAdded(to: self, animated: true)
//            hud.contentColor = UIColor.init(hexColor: "FFFFFF")
//            //          hud.bezelView.color = UIColor.init(hex: "252525")
//            hud.bezelView.color = UIColor.clear
//            hud.backgroundColor = UIColor.black.withAlphaComponent(0.4)
//            hud.bezelView.style = .solidColor
//            hud.label.text = ""
//            hud.mode = .indeterminate
//        }
    }
    
    func showLoadingWithProgress(_ progress:Int) {
//        DispatchQueue.main.async {
//            let hud = MBProgressHUD.showAdded(to: self, animated: true)
//            hud.contentColor = UIColor.init(hexColor: "FFFFFF")
//            //          hud.bezelView.color = UIColor.init(hex: "252525")
//            hud.bezelView.color = UIColor.clear
//            hud.backgroundColor = UIColor.black.withAlphaComponent(0.4)
//            hud.bezelView.style = .solidColor
//            hud.label.text = "\(progress)% Upload"
//            hud.mode = .indeterminate
//        }
    }

    func hideLoading() {
//        DispatchQueue.main.async {
//            MBProgressHUD.hide(for: self, animated: true)
//        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return vBorderWidth
        }
        set {
            layer.borderWidth = newValue
            vBorderWidth = newValue
            self.setNeedsLayout()

        }
    }

    @IBInspectable var masksToBounds: Bool {
        get {
            return vMasksToBounds
        }
        set {
            layer.masksToBounds = newValue
            vMasksToBounds = newValue
            self.setNeedsLayout()

        }
    }

    @IBInspectable var borderColor: UIColor {
        get{

            return vBorderColour
        }
        set {

            layer.borderColor = newValue.cgColor
            vBorderColour = newValue
            self.setNeedsLayout()

        }
    }

    @IBInspectable var makeCircle: Bool {
        get{

            return vMakeCircle
        }
        set {

            if newValue  {
                cornerRadius = frame.size.width / 2
                masksToBounds = true
            }
            else    {
                cornerRadius = vCornerRadius
                masksToBounds = vMakeCircle
            }
            vMakeCircle = newValue
            self.setNeedsLayout()

        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
            self.setNeedsLayout()
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            self.setNeedsLayout()
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            self.setNeedsLayout()
        }
    }

    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
                self.setNeedsLayout()
            }
        }
    }

    func centerInSuperview() {
        self.centerHorizontallyInSuperview()
        self.centerVerticallyInSuperview()
        self.setNeedsLayout()
    }

    func equalAndCenterToSupper() {

        self.centerHorizontallyInSuperview()
        self.centerVerticallyInSuperview()
        leadingInSuperview()
        trailingInSuperview()
        topInSuperview()
        bottomInSuperview()
        self.setNeedsLayout()
    }

    func centerHorizontallyInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.superview, attribute: .centerX, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }

    func centerVerticallyInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }
    func leadingInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute:.leadingMargin, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }
    func trailingInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute:.trailingMargin, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }
    func topInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute:.topMargin, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }
    func bottomInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute:.bottomMargin, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }

    class func fromNib<T : UIView>() -> T {

        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
   
    func roundCornersNew(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    

}



public extension UIView {
    
    func shake(count : Float? = nil,for duration : TimeInterval? = nil,withTanslation translation : Float? = nil) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        animation.repeatCount = count ?? 2
        animation.duration = (duration ?? 0.5)/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation ?? -5
        layer.add(animation, forKey: "shake")
    }
}

extension UIView{
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor , horizontalMode : Bool = false , diagonalMode : Bool = false){
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.frame = self.bounds
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
        print(gradientLayer.frame)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
@IBDesignable
public class Gradient: UIView {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }

}
extension UIView {
    
    func addTopRoundedCornerToView(targetView:UIView?, desiredCurve:CGFloat?)
    {
        let offset:CGFloat =  targetView!.frame.width/desiredCurve!
        let bounds: CGRect = targetView!.bounds
        
        //Top side curve
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y+bounds.size.height / 2, width: bounds.size.width, height: bounds.size.height / 2)
        
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        
        //Top side curve
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        // Create the shape layer and set its path
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        
        // Set the newly created shape layer as the mask for the view's layer
        targetView!.layer.mask = maskLayer
    }
    
    func setTopCurve(){
        let offset = CGFloat(self.frame.size.height/4)
        let bounds = self.bounds
        let rectBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y + bounds.size.height/2  , width:  bounds.size.width, height: bounds.size.height / 2)
        
        let rectPath = UIBezierPath(rect: rectBounds)
        
        let ovalBounds = CGRect(x: bounds.origin.x , y: bounds.origin.y - offset / 2, width: bounds.size.width + offset, height: bounds.size.height)
        let ovalPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        self.layer.mask = maskLayer
    }
    
    func addBottomRoundedCornerToView(targetView:UIView?, desiredCurve:CGFloat?)
    {
        let offset:CGFloat =  targetView!.frame.width/desiredCurve!
        let bounds: CGRect = targetView!.bounds
        
        //Bottom side curve
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height / 2)
        
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        
        //Bottom side curve
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        // Create the shape layer and set its path
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        
        // Set the newly created shape layer as the mask for the view's layer
        targetView!.layer.mask = maskLayer
    }
    
    func setBottomCurve(){
        let offset = CGFloat(self.frame.size.height/4)
        let bounds = self.bounds
        
        let rectBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y  , width:  bounds.size.width, height: bounds.size.height / 2)
        let rectPath = UIBezierPath(rect: rectBounds)
        let ovalBounds = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        
        let ovalPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        self.layer.mask = maskLayer
    }
}

extension StringProtocol {
    var double: Double? { Double(self) }
    var float: Float? { Float(self) }
    var integer: Int? { Int(self) }
}
