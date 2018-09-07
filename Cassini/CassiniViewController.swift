//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Sneh on 05/09/18.
//  Copyright © 2018 The Gateway Corp. All rights reserved.
//

import UIKit

class CassiniViewController: VCLLoggingViewController {

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //segue is obj that has ref of 3 buttons...
        
        //var destination = segue.destination
        
        //This code will still works even if there is no Nav. Controller
        //        if let navcon = destination as? UINavigationController{
        //            destination = navcon.visibleViewController ?? navcon
        //        }
        //
        //Above code can be optimized by using extension
        
        
        // This IF-LET condition is to check whether the identifier is not nil
        if let identifier = segue.identifier{
            if let url = DemoURLs.NASA[identifier]{
                if let imageVC = segue.destination.contents as? ImageViewController{
                    //Line before we have to put title on Detail MVC of split view controller
                    // if let imageVC = segue.destination as? ImageViewController{
                    //Line before extension part...
                    //if let imageVC = destination as? ImageViewController{
                    
                    imageVC.imageURL = url
                    imageVC.title = (sender as? UIButton)?.currentTitle
                }
            }
        }
    }

}

//Same code can be used for tab bar controller, if I need to get current tab then add else if condition for Tabbar Controller...
extension UIViewController{
    var contents: UIViewController{
        if let navcon = self as? UINavigationController{
           return navcon.visibleViewController ?? self
        } else {
            return self
        }
        
    }
}
