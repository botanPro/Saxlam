//
//  Classes.swift
//  wfbhl
//
//  Created by Botan Amedi on 23/09/2022.
//

import Foundation
import UIKit


class openCartApi{
    static var UserName = UserDefaults.standard.string(forKey: "openCartApi_userName") ?? ""
    static var key = UserDefaults.standard.string(forKey: "openCartApi_token") ?? ""
    let Labs = "https://saxlam.com/panel/upload/labs/"
    let SliderImages = "https://saxlam.com/panel/upload/slides/"
    let URL = "https://saxlam.com/panel/api/mobile_api2.php";
    let PostImages = "https://saxlam.com/panel/upload/posts/"
    let SocialImages = "https://saxlam.com/panel/upload/social/"
    let APP_TITLE = "Saxlam"
}



let API = openCartApi();
let APP_TITLE = "Saxlam"



extension UITextField{

   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
}



@IBDesignable class GradientView: UIView {
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.black

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }
}



extension UIDevice {

    var modelNamee: String {

        var systemInfo = utsname()
        uname(&systemInfo)

        let machineMirror = Mirror(reflecting: systemInfo.machine)

        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {

        case "iPod5,1":                                       return "iPod touch (5th generation)"
        case "iPod7,1":                                       return "iPod touch (6th generation)"
        case "iPod9,1":                                       return "iPod touch (7th generation)"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":           return "iPhone 4"
        case "iPhone4,1":                                     return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                        return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                        return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                        return "iPhone 5s"
        case "iPhone7,2":                                     return "iPhone 6"
        case "iPhone7,1":                                     return "iPhone 6 Plus"
        case "iPhone8,1":                                     return "iPhone 6s"
        case "iPhone8,2":                                     return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                        return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                        return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                      return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                      return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                      return "iPhone X"
        case "iPhone11,2":                                    return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                      return "iPhone XS Max"
        case "iPhone11,8":                                    return "iPhone XR"
        case "iPhone12,1":                                    return "iPhone 11"
        case "iPhone12,3":                                    return "iPhone 11 Pro"
        case "iPhone12,5":                                    return "iPhone 11 Pro Max"
        case "iPhone13,1":                                    return "iPhone 12 mini"
        case "iPhone13,2":                                    return "iPhone 12"
        case "iPhone13,3":                                    return "iPhone 12 Pro"
        case "iPhone13,4":                                    return "iPhone 12 Pro Max"
        case "iPhone14,4":                                    return "iPhone 13 mini"
        case "iPhone14,5":                                    return "iPhone 13"
        case "iPhone14,2":                                    return "iPhone 13 Pro"
        case "iPhone14,3":                                    return "iPhone 13 Pro Max"
        case "iPhone8,4":                                     return "iPhone SE"
        case "iPhone12,8":                                    return "iPhone SE (2nd generation)"
        case "iPhone14,6":                                    return "iPhone SE (3rd generation)"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":                 return "iPad (3rd generation)"
        case "iPad3,4", "iPad3,5", "iPad3,6":                 return "iPad (4th generation)"
        case "iPad6,11", "iPad6,12":                          return "iPad (5th generation)"
        case "iPad7,5", "iPad7,6":                            return "iPad (6th generation)"
        case "iPad7,11", "iPad7,12":                          return "iPad (7th generation)"
        case "iPad11,6", "iPad11,7":                          return "iPad (8th generation)"
        case "iPad12,1", "iPad12,2":                          return "iPad (9th generation)"
        case "iPad4,1", "iPad4,2", "iPad4,3":                 return "iPad Air"
        case "iPad5,3", "iPad5,4":                            return "iPad Air 2"
        case "iPad11,3", "iPad11,4":                          return "iPad Air (3rd generation)"
        case "iPad13,1", "iPad13,2":                          return "iPad Air (4th generation)"
        case "iPad13,16", "iPad13,17":                        return "iPad Air (5th generation)"
        case "iPad2,5", "iPad2,6", "iPad2,7":                 return "iPad mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":                 return "iPad mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":                 return "iPad mini 3"
        case "iPad5,1", "iPad5,2":                            return "iPad mini 4"
        case "iPad11,1", "iPad11,2":                          return "iPad mini (5th generation)"
        case "iPad14,1", "iPad14,2":                          return "iPad mini (6th generation)"
        case "iPad6,3", "iPad6,4":                            return "iPad Pro (9.7-inch)"
        case "iPad7,3", "iPad7,4":                            return "iPad Pro (10.5-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return "iPad Pro (11-inch) (1st generation)"
        case "iPad8,9", "iPad8,10":                           return "iPad Pro (11-inch) (2nd generation)"
        case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return "iPad Pro (11-inch) (3rd generation)"
        case "iPad6,7", "iPad6,8":                            return "iPad Pro (12.9-inch) (1st generation)"
        case "iPad7,1", "iPad7,2":                            return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return "iPad Pro (12.9-inch) (3rd generation)"
        case "iPad8,11", "iPad8,12":                          return "iPad Pro (12.9-inch) (4th generation)"
        case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11" :return "iPad Pro (12.9-inch) (5th generation)"
        case "AppleTV5,3":                                    return "Apple TV"
        case "AppleTV6,2":                                    return "Apple TV 4K"
        case "AudioAccessory1,1":                             return "HomePod"
        case "AudioAccessory5,1":                             return "HomePod mini"
        default:                                              return identifier
        }
    }
}


class WorkItem {

    private var pendingRequestWorkItem: DispatchWorkItem?
    
    func perform(after: TimeInterval, _ block: @escaping () -> Void) {
        // Cancel the currently pending item
        pendingRequestWorkItem?.cancel()
        
        // Wrap our request in a work item
        let requestWorkItem = DispatchWorkItem(block: block)
        
        pendingRequestWorkItem = requestWorkItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: requestWorkItem)
    }
}

extension UITextField {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}



extension UITableView {
func setEmptyView(title: String, message: String) {
    let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textColor = UIColor.black
    titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
    messageLabel.textColor = UIColor.lightGray
    messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
    emptyView.addSubview(titleLabel)
    emptyView.addSubview(messageLabel)
    titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
    messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
    messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
    messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
    titleLabel.text = title
    messageLabel.text = message
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    // The only tricky part is here:
    self.backgroundView = emptyView
}
    
    func restore() {
        self.backgroundView = nil
    }
}

extension UICollectionView {
func setEmptyView(title: String, message: String) {
    let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textColor = UIColor.black
    titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
    messageLabel.textColor = UIColor.lightGray
    messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
    emptyView.addSubview(titleLabel)
    emptyView.addSubview(messageLabel)
    titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
    messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
    messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
    messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
    titleLabel.text = title
    messageLabel.text = message
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    // The only tricky part is here:
    self.backgroundView = emptyView
}
    
    func restore() {
        self.backgroundView = nil
    }
}



class QuadPageControl: UIPageControl {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !subviews.isEmpty else { return }
        
        let spacing: CGFloat = 5
        
        let width: CGFloat = 8
        
        let height = width
        
        var total: CGFloat = 0
        
        for view in subviews {
            view.layer.cornerRadius = 2
            view.frame = CGRect(x: total, y: frame.size.height / 2 - height / 2, width: width, height: height)
            total += width + spacing
        }
        
        total -= spacing
        
        frame.origin.x = frame.origin.x + frame.size.width / 2 - total / 2
        frame.size.width = total
    }
}


class EmptyBackgroundView: UIView {

    private var topSpace: UIView!
    private var bottomSpace: UIView!
    private var imageView: UIImageView!
    private var topLabel: UILabel!
    private var bottomLabel: UILabel!

    private let topColor = #colorLiteral(red: 0.332470099, green: 0.3599726416, blue: 0.3999270044, alpha: 1)
    private let topFont = UIFont.boldSystemFont(ofSize: 13)
    private let bottomColor = UIColor.gray
    private let bottomFont = UIFont.systemFont(ofSize: 14)

    private let spacing: CGFloat = 10
    private let imageViewHeight: CGFloat = 200
    private let bottomLabelWidth: CGFloat = 300

    var didSetupConstraints = false

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    init(image: UIImage, top: String, bottom: String) {
        super.init(frame: .zero)
        setupViews()
        setupImageView(image: image)
        setupLabels(top: top, bottom: bottom)
    }

    func setupViews() {
//        topSpace = UIView.newAutoLayout()
//        bottomSpace = UIView.newAutoLayout()
//        imageView = UIImageView.newAutoLayout()
//        topLabel = UILabel.newAutoLayout()
//        bottomLabel = UILabel.newAutoLayout()

        addSubview(topSpace)
        addSubview(bottomSpace)
        addSubview(imageView)
        addSubview(topLabel)
        addSubview(bottomLabel)
    }

    func setupImageView(image: UIImage) {
        imageView.image = image
        imageView.tintColor = topColor
    }

    func setupLabels(top: String, bottom: String) {
        topLabel.text = top
        topLabel.textColor = topColor
        topLabel.font = topFont

        bottomLabel.text = bottom
        bottomLabel.textColor = bottomColor
        bottomLabel.font = bottomFont
        bottomLabel.numberOfLines = 0
        bottomLabel.textAlignment = .center
    }

    override func updateConstraints() {
        if !didSetupConstraints {
//            topSpace.autoAlignAxis(toSuperviewAxis: .vertical)
//            topSpace.autoPinEdge(toSuperviewEdge: .top)
//            bottomSpace.autoAlignAxis(toSuperviewAxis: .vertical)
//            bottomSpace.autoPinEdge(toSuperviewEdge: .bottom)
//            topSpace.autoSetDimension(.height, toSize: spacing, relation: .greaterThanOrEqual)
//            topSpace.autoMatch(.height, to: .height, of: bottomSpace)
//
//            imageView.autoPinEdge(.top, to: .bottom, of: topSpace)
//            imageView.autoAlignAxis(toSuperviewAxis: .vertical)
//            imageView.autoSetDimension(.height, toSize: imageViewHeight, relation: .lessThanOrEqual)
//
//            topLabel.autoAlignAxis(toSuperviewAxis: .vertical)
//            topLabel.autoPinEdge(.top, to: .bottom, of: imageView, withOffset: spacing)
//
//            bottomLabel.autoAlignAxis(toSuperviewAxis: .vertical)
//            bottomLabel.autoPinEdge(.top, to: .bottom, of: topLabel, withOffset: spacing)
//            bottomLabel.autoPinEdge(.bottom, to: .top, of: bottomSpace)
//            bottomLabel.autoSetDimension(.width, toSize: bottomLabelWidth)

            didSetupConstraints = true
        }

        super.updateConstraints()
    }
}


class UIXTabBarStyle : UITabBar{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
  
    }
}


class UIXnavigationStyle : UINavigationBar{
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        self.layer.shadowRadius = 4

    }
}

extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}




extension UINavigationItem {

  func setTitle(_ title: String, subtitle: String) {
    let appearance = UINavigationBar.appearance()
    let textColor = appearance.titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor ?? .black

    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
    titleLabel.textColor = textColor

    let subtitleLabel = UILabel()
    subtitleLabel.text = subtitle
    subtitleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
    subtitleLabel.textColor = textColor.withAlphaComponent(0.75)

    let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    stackView.distribution = .equalCentering
    stackView.alignment = .center
    stackView.axis = .vertical

    self.titleView = stackView
  }
}
extension String {
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "EN")
            formatter.numberStyle = .currency
            formatter.currencySymbol = "$"

            formatter.maximumFractionDigits = 0
            if let str = formatter.string(for: value) {
                return "\(str)"
            }
        }
        return ""
    }
    
    func NumberFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "EN")
            formatter.numberStyle = .currency
            formatter.currencySymbol = ""

            formatter.maximumFractionDigits = 0
            if let str = formatter.string(for: value) {
                return "\(str)"
            }
        }
        return ""
    }
    
    func currencyFormattingIQD() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "EN")
            formatter.numberStyle = .currency
            formatter.currencySymbol = "IQD"

            formatter.maximumFractionDigits = 0
            if let str = formatter.string(for: value) {
                return "\(str)"
            }
        }
        return ""
    }
}






import CoreLocation

class XLocations : NSObject , CLLocationManagerDelegate{
    
    static var Shared = XLocations()
    
    var LocationManager : CLLocationManager!
    
    func GetUserLocation(){
        
        LocationManager = CLLocationManager()
        
        LocationManager.delegate = self
        
        LocationManager.requestWhenInUseAuthorization()
        
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        if CLLocationManager.locationServicesEnabled(){
           LocationManager.startUpdatingLocation()
        }
        
        

    }
    
    var longtude : Double = 0
    var latitude : Double = 0
    var GotLocation : (()->())?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.longtude = locations[0].coordinate.longitude
        self.latitude = locations[0].coordinate.latitude
        
        GotLocation?()
        
    }
    
}







extension String {
    private static let formatter = NumberFormatter()

    func clippingCharacters(in characterSet: CharacterSet) -> String {
        components(separatedBy: characterSet).joined()
    }

    func convertedDigitsToLocale(_ locale: Locale = .current) -> String {
        let digits = Set(clippingCharacters(in: CharacterSet.decimalDigits.inverted))
        guard !digits.isEmpty else { return self }

        Self.formatter.locale = locale
        let maps: [(original: String, converted: String)] = digits.map {
            let original = String($0)
            guard let digit = Self.formatter.number(from: String($0)) else {
                assertionFailure("Can not convert to number from: \(original)")
                return (original, original)
            }
            guard let localized = Self.formatter.string(from: digit) else {
                assertionFailure("Can not convert to string from: \(digit)")
                return (original, original)
            }
            return (original, localized)
        }

        var converted = self
        for map in maps { converted = converted.replacingOccurrences(of: map.original, with: map.converted) }
        return converted
    }
}






extension String {
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
    
}



extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}



enum ResponderStandardEditActions {
    case cut, copy, paste, select, selectAll, delete
    case makeTextWritingDirectionLeftToRight, makeTextWritingDirectionRightToLeft
    case toggleBoldface, toggleItalics, toggleUnderline
    case increaseSize, decreaseSize

    var selector: Selector {
        switch self {
            case .cut:
                return #selector(UIResponderStandardEditActions.cut)
            case .copy:
                return #selector(UIResponderStandardEditActions.copy)
            case .paste:
                return #selector(UIResponderStandardEditActions.paste)
            case .select:
                return #selector(UIResponderStandardEditActions.select)
            case .selectAll:
                return #selector(UIResponderStandardEditActions.selectAll)
            case .delete:
                return #selector(UIResponderStandardEditActions.delete)
            case .makeTextWritingDirectionLeftToRight:
                return #selector(UIResponderStandardEditActions.makeTextWritingDirectionLeftToRight)
            case .makeTextWritingDirectionRightToLeft:
                return #selector(UIResponderStandardEditActions.makeTextWritingDirectionRightToLeft)
            case .toggleBoldface:
                return #selector(UIResponderStandardEditActions.toggleBoldface)
            case .toggleItalics:
                return #selector(UIResponderStandardEditActions.toggleItalics)
            case .toggleUnderline:
                return #selector(UIResponderStandardEditActions.toggleUnderline)
            case .increaseSize:
                return #selector(UIResponderStandardEditActions.increaseSize)
            case .decreaseSize:
                return #selector(UIResponderStandardEditActions.decreaseSize)
        }
    }
}

class TextField: UITextField {

    private var editActions: [ResponderStandardEditActions: Bool]?
    private var filterEditActions: [ResponderStandardEditActions: Bool]?

    func setEditActions(only actions: [ResponderStandardEditActions]) {
        if self.editActions == nil { self.editActions = [:] }
        filterEditActions = nil
        actions.forEach { self.editActions?[$0] = true }
    }

    func addToCurrentEditActions(actions: [ResponderStandardEditActions]) {
        if self.filterEditActions == nil { self.filterEditActions = [:] }
        editActions = nil
        actions.forEach { self.filterEditActions?[$0] = true }
    }

    private func filterEditActions(actions: [ResponderStandardEditActions], allowed: Bool) {
        if self.filterEditActions == nil { self.filterEditActions = [:] }
        editActions = nil
        actions.forEach { self.filterEditActions?[$0] = allowed }
    }

    func filterEditActions(notAllowed: [ResponderStandardEditActions]) {
        filterEditActions(actions: notAllowed, allowed: false)
    }

    func resetEditActions() { editActions = nil }

    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if let actions = editActions {
            for _action in actions where _action.key.selector == action { return _action.value }
            return false
        }

        if let actions = filterEditActions {
            for _action in actions where _action.key.selector == action { return _action.value }
        }

        return super.canPerformAction(action, withSender: sender)
    }
}

extension UITextField {
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.paste(_:)) ?
            false : super.canPerformAction(action, withSender: sender)
    }
}



import CoreGraphics

@IBDesignable
class CornerView: UIView {

    @IBInspectable
    var sizeMultiplier : CGFloat = 0.2{
        didSet{
            self.draw(self.bounds)
        }
    }

    @IBInspectable
    var lineWidth : CGFloat = 4{
        didSet{
            self.draw(self.bounds)
        }
    }

    @IBInspectable
    var lineColor : UIColor = UIColor.black{
        didSet{
            self.draw(self.bounds)
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }

    func drawCorners()
    {
        let currentContext = UIGraphicsGetCurrentContext()

        currentContext?.setLineWidth(lineWidth)
        currentContext?.setStrokeColor(lineColor.cgColor)

        //first part of top left corner
        currentContext?.beginPath()
        currentContext?.move(to: CGPoint(x: 0, y: 0))
        currentContext?.addLine(to: CGPoint(x: self.bounds.size.width*sizeMultiplier, y: 0))
        currentContext?.strokePath()

        //top rigth corner
        currentContext?.beginPath()
        currentContext?.move(to: CGPoint(x: self.bounds.size.width - self.bounds.size.width*sizeMultiplier, y: 0))
        currentContext?.addLine(to: CGPoint(x: self.bounds.size.width, y: 0))
        currentContext?.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height*sizeMultiplier))
        currentContext?.strokePath()

        //bottom rigth corner
        currentContext?.beginPath()
        currentContext?.move(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height - self.bounds.size.height*sizeMultiplier))
        currentContext?.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height))
        currentContext?.addLine(to: CGPoint(x: self.bounds.size.width - self.bounds.size.width*sizeMultiplier, y: self.bounds.size.height))
        currentContext?.strokePath()

        //bottom left corner
        currentContext?.beginPath()
        currentContext?.move(to: CGPoint(x: self.bounds.size.width*sizeMultiplier, y: self.bounds.size.height))
        currentContext?.addLine(to: CGPoint(x: 0, y: self.bounds.size.height))
        currentContext?.addLine(to: CGPoint(x: 0, y: self.bounds.size.height - self.bounds.size.height*sizeMultiplier))
        currentContext?.strokePath()

        //second part of top left corner
        currentContext?.beginPath()
        currentContext?.move(to: CGPoint(x: 0, y: self.bounds.size.height*sizeMultiplier))
        currentContext?.addLine(to: CGPoint(x: 0, y: 0))
        currentContext?.strokePath()
    }


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        self.drawCorners()
    }


}
