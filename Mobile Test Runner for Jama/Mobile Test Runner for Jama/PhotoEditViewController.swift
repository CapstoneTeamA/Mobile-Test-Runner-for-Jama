//
//  PhotoEditViewController.swift
//  Mobile Test Runner for Jama
//
//  Created by Will Huiras on 8/20/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

class PhotoEditViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var SubmitPhotoButton: UIButton!
    @IBOutlet weak var TakePhotoButton: UIButton!
    @IBOutlet weak var RemovePhotoButton: UIButton!
    @IBOutlet weak var NoPhotoMessage: UILabel!
    
    var photoToAttach: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        if photoToAttach == nil {
            NoPhotoMessage.isHidden = false
        } else {
            NoPhotoMessage.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    

    
}
