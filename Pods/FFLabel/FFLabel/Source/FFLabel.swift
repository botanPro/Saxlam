//
//  FFLabel.swift
//  FFLabel
//
//  Created by 刘凡 on 15/7/18.
//  Copyright © 2015年 joyios. All rights reserved.
//

import UIKit

@objc
public protocol FFLabelDelegate: NSObjectProtocol {
    @objc optional func labelDidSelectedLinkText(label: FFLabel, text: String)
}

public class FFLabel: UILabel {

    public var linkTextColor = UIColor.blue
    public var selectedBackgroudColor = UIColor.lightGray
    public weak var labelDelegate: FFLabelDelegate?
    
    // MARK: - override properties
    override public var text: String? {
        didSet {
            updateTextStorage()
        }
    }
    
    override public var attributedText: NSAttributedString? {
        didSet {
            updateTextStorage()
        }
    }
    
    override public var font: UIFont! {
        didSet {
            updateTextStorage()
        }
    }
    
    override public var textColor: UIColor! {
        didSet {
            updateTextStorage()
        }
    }
    
    // MARK: - upadte text storage and redraw text
    private func updateTextStorage() {
        if attributedText == nil {
            return
        }

        let attrStringM = addLineBreak(attrString: attributedText!)
        regexLinkRanges(attrString: attrStringM)
        addLinkAttribute(attrStringM: attrStringM)
        
        textStorage.setAttributedString(attrStringM)
        
        setNeedsDisplay()
    }
    
    /// add link attribute
    private func addLinkAttribute(attrStringM: NSMutableAttributedString) {
        if attrStringM.length == 0 {
            return
        }
        
        var range = NSRange(location: 0, length: 0)
        var attributes = attrStringM.attributes(at: 0, effectiveRange: &range)
        
        attributes[NSAttributedString.Key.font] = font!
        attributes[NSAttributedString.Key.foregroundColor] = textColor
        attrStringM.addAttributes(attributes, range: range)
        
        attributes[NSAttributedString.Key.foregroundColor] = linkTextColor
        
        for r in linkRanges {
            attrStringM.setAttributes(attributes, range: r)
        }
    }
    
    /// use regex check all link ranges
    private let patterns = ["[a-zA-Z]*://[a-zA-Z0-9/\\.-]*", "#.*?#","@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"]
    private func regexLinkRanges(attrString: NSAttributedString) {
        linkRanges.removeAll()
        let regexRange = NSRange(location: 0, length: attrString.string.count)
        
        for pattern in patterns {
            let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
            let results = regex.matches(in: attrString.string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: regexRange)
            
            for r in results {
                linkRanges.append(r.range(at: 0))
            }
        }
    }
    
    /// add line break mode
    private func addLineBreak(attrString: NSAttributedString) -> NSMutableAttributedString {
        let attrStringM = NSMutableAttributedString(attributedString: attrString)
        
        if attrStringM.length == 0 {
            return attrStringM
        }
        
        var range = NSRange(location: 0, length: 0)
        var attributes = attrStringM.attributes(at: 0, effectiveRange: &range)
        var paragraphStyle = attributes[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle
        
        if paragraphStyle != nil {
            paragraphStyle!.lineBreakMode = NSLineBreakMode.byWordWrapping
        } else {
            // iOS 8.0 can not get the paragraphStyle directly
            paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle!.lineBreakMode = NSLineBreakMode.byWordWrapping
            attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            
            attrStringM.setAttributes(attributes, range: range)
        }
        
        return attrStringM
    }
    
    public override func drawText(in rect: CGRect) {
        let range = glyphsRange()
        let offset = glyphsOffset(range: range)

        layoutManager.drawBackground(forGlyphRange: range, at: offset)
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPointZero)
    }
    
    private func glyphsRange() -> NSRange {
        return NSRange(location: 0, length: textStorage.length)
    }
    
    private func glyphsOffset(range: NSRange) -> CGPoint {
        let rect = layoutManager.boundingRect(forGlyphRange: range, in: textContainer)
        let height = (bounds.height - rect.height) * 0.5
        
        return CGPoint(x: 0, y: height)
    }
    
    // MARK: - touch events

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        
        selectedRange = linkRangeAtLocation(location: location)
        modifySelectedAttribute(isSet: true)
    }
    

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        
        if let range = linkRangeAtLocation(location: location) {
            if !(range.location == selectedRange?.location && range.length == selectedRange?.length) {
                modifySelectedAttribute(isSet: false)
                selectedRange = range
                modifySelectedAttribute(isSet: true)
            }
        } else {
            modifySelectedAttribute(isSet: false)
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if selectedRange != nil {
            let text = (textStorage.string as NSString).substring(with: selectedRange!)
            labelDelegate?.labelDidSelectedLinkText!(label: self, text: text)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.modifySelectedAttribute(isSet: false)
            }
        }
    }
    

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        modifySelectedAttribute(isSet: false)
    }
    
    private func modifySelectedAttribute(isSet: Bool) {
        if selectedRange == nil {
            return
        }
        
        var attributes = textStorage.attributes(at: 0, effectiveRange: nil)
        attributes[NSAttributedString.Key.foregroundColor] = linkTextColor
        let range = selectedRange!
        
        if isSet {
            attributes[NSAttributedString.Key.backgroundColor] = selectedBackgroudColor
        } else {
            attributes[NSAttributedString.Key.backgroundColor] = UIColor.clear
            selectedRange = nil
        }
        
        textStorage.addAttributes(attributes, range: range)
        
        setNeedsDisplay()
    }
    
    private func linkRangeAtLocation(location: CGPoint) -> NSRange? {
        if textStorage.length == 0 {
            return nil
        }
        
        let offset = glyphsOffset(range: glyphsRange())
        let point = CGPoint(x: offset.x + location.x, y: offset.y + location.y)
        let index = layoutManager.glyphIndex(for: point, in: textContainer)
        
        for r in linkRanges {
            if index >= r.location && index <= r.location + r.length {
                return r
            }
        }
        
        return nil
    }
    
    // MARK: - init functions
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareLabel()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareLabel()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        textContainer.size = bounds.size
    }
    
    private func prepareLabel() {
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
        textContainer.lineFragmentPadding = 0
        
        isUserInteractionEnabled = true
    }
    
    // MARK: lazy properties
    private lazy var linkRanges = [NSRange]()
    private var selectedRange: NSRange?
    private lazy var textStorage = NSTextStorage()
    private lazy var layoutManager = NSLayoutManager()
    private lazy var textContainer = NSTextContainer()
}
