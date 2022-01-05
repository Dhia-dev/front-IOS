//
//  Second.swift
//  Geochat
//
//  Created by Apple Esprit on 29/12/2021.
//

import Foundation

protocol SecondModalTransitionListener {
    func popoverDismissed()
}

class SecondModalTransitionMediator {
    /* Singleton */
    class var instance: SecondModalTransitionMediator {
        struct Static {
            static let instance: SecondModalTransitionMediator = SecondModalTransitionMediator()
        }
        return Static.instance
    }
    
    private var listener: SecondModalTransitionListener?
    
    private init() {
        
    }
    
    func setListener(listener: SecondModalTransitionListener) {
        self.listener = listener
    }
    
    func sendPopoverDismissed(modelChanged: Bool) {
        listener?.popoverDismissed()
    }
}
