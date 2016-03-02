//
//  NibDesignable.swift
//  CocoaHeadsApp
//
//  Created by Bruno Bilescky on 06/11/15.
//  Copyright © 2015 CocoaHeads Brasil. All rights reserved.
//

import UIKit

/**
 A NibDesignable is a view wrapper tha loads a XIB with the same name of the class and add it to itself.
 You should use mainly in storyboards, to avoid modifying views inside the storyboard
*/
@IBDesignable
public class NibDesignable: UIView {
    
    // MARK: - Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }
    
    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
    
    // MARK: - Nib loading
    
    /**
    Called in init(frame:) and init(aDecoder:) to load the nib and add it as a subview.
    */
    internal func setupNib() {
        let view = self.loadNib()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views: bindings))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views: bindings))
        viewDidLoad()
    }
    
    public func viewDidLoad() {
        
    }
    
    /**
     Called to load the nib in setupNib().
     
     - returns: UIView instance loaded from a nib file.
     */
    public func loadNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: self.nibName(), bundle: bundle)
        
        guard let view = nib.instantiateWithOwner(self, options: nil).first as? UIView  else {
            fatalError("You're trying to load a NibDesignable withou the respective nib file")
        }
        
        return view
    }
    
    /**
     Called in the default implementation of loadNib(). Default is class name.
     
     - returns: Name of a single view nib file.
     */
    public func nibName() -> String {
        guard let name = self.dynamicType.description().componentsSeparatedByString(".").last else {
            fatalError("Invalid module name")
        }
        return name
    }
}
