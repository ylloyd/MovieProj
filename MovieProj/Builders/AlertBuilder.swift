//
//  AlertBuilder.swift
//  MovieProj
//
//  Created by Yvan Elessa on 09/04/2018.
//  Copyright © 2018 Yvan Elessa. All rights reserved.
//

import Foundation
import UIKit

class AlertBuilder {
    private var preferredStyle: UIAlertControllerStyle = .alert
    private var title: String? = nil
    private var message: String? = nil
    private var actions: [UIAlertAction] = [UIAlertAction]()
    
    
    
    func preferredStyle(_ style:UIAlertControllerStyle) -> AlertBuilder {
        self.preferredStyle = style
        return self
    }
    
    func withTitle(_ title:String?) -> AlertBuilder {
        self.title = unwrapStringAndLocalize(title)
        return self
    }
    
    func withMessage(_ message:String?) -> AlertBuilder {
        self.message = unwrapStringAndLocalize(message)
        return self
    }
    
    func addOkAction(handler:((UIAlertAction) -> Swift.Void)? = nil) -> AlertBuilder {
        return addDefaultActionWithTitle("OK", handler: handler)
    }
    
    func addDeleteAction(handler:((UIAlertAction) -> Swift.Void)? = nil) -> AlertBuilder {
        return addDestructiveActionWithTitle("Delete", handler: handler)
    }
    
    func addCancelAction(handler:((UIAlertAction) -> Swift.Void)? = nil) -> AlertBuilder {
        return addCancelActionWithTitle("Cancel", handler: handler)
    }
    
    func addDefaultActionWithTitle(_ title:String, handler:((UIAlertAction) -> Swift.Void)? = nil) -> AlertBuilder {
        return addActionWithTitle(title, style: .default, handler: handler)
    }
    
    func addDestructiveActionWithTitle(_ title:String, handler:((UIAlertAction) -> Swift.Void)? = nil) -> AlertBuilder {
        return addActionWithTitle(title, style: .destructive, handler: handler)
    }
    
    func addCancelActionWithTitle(_ title:String, handler:((UIAlertAction) -> Swift.Void)? = nil) -> AlertBuilder {
        return addActionWithTitle(title, style: .cancel, handler: handler)
    }
    
    func addActionWithTitle(_ title:String, style:UIAlertActionStyle, handler:((UIAlertAction) -> Swift.Void)?) -> AlertBuilder {
        let action = UIAlertAction(title: NSLocalizedString(title, comment: ""), style: style, handler: handler)
        actions.append(action)
        return self
    }
    
    func show(in viewController:UIViewController, animated:Bool = true, completion:(() -> Swift.Void)? = nil) {
        viewController.present(build(), animated: animated, completion: completion)
    }
    
    func build() -> UIAlertController {
        let alert = UIAlertController(title: self.title, message: self.message, preferredStyle: self.preferredStyle)
        
        actions.forEach { (action) in
            alert.addAction(action)
        }
        
        return alert
    }
    
    private func unwrapStringAndLocalize(_ value:String?) -> String? {
        guard let value = value else { return nil }
        return NSLocalizedString(value, comment: "")
    }
}
