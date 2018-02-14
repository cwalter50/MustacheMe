//
//  ViewController.swift
//  MustacheMe
//
//  Created by  on 4/1/16.
//  Copyright © 2016 DocsApps. All rights reserved.
//

import UIKit

// add UIImagePickerControllerDelegate and UINavigationControllerDelegate for imagePicker

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var myImageView: UIImageView!
    
    // create global variable for UIImagePicker
    let picker = UIImagePickerController()
    
    let screenWidth = UIScreen.main.bounds.width
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set imagePickers delegate to self
        picker.delegate = self
    }
    
    // load imagePickerController
    @IBAction func loadImage(_ sender: UIBarButtonItem) {
        let sheet = UIAlertController(title: "Select where to get image from", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let libraryAction = UIAlertAction(title: "PHOTO LIBRARY", style: UIAlertActionStyle.default) { (action) -> Void in
            self.picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.picker.delegate = self
            self.picker.modalPresentationStyle = .popover
            
            self.present(self.picker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "CAMERA", style: UIAlertActionStyle.default) { (action) -> Void in
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil
            {
                self.picker.sourceType = UIImagePickerControllerSourceType.camera
                self.picker.allowsEditing = true
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.picker.delegate = self
                
                self.present(self.picker, animated: true, completion: nil)
            }
            else{
                self.noCamera()
            }
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel)
        {(action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        sheet.addAction(libraryAction)
        sheet.addAction(cameraAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }
    
    // dsiplays alert if device does not have a camera
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate Methods
    
    // Dismiss imagePicker if user hits cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker.dismiss(animated: true, completion: nil)
    }
    
    // add Method to set image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if picker.sourceType == .camera
        {
            // get the image the user selected
            if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage
            {
                // set imageview's image and make aspect fit
                myImageView.contentMode = .scaleAspectFit
                myImageView.image = pickedImage
            }
        }
        else
        {
            // get the image the user selected
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                // set imageview's image and make aspect fit
                myImageView.contentMode = .scaleAspectFit
                myImageView.image = pickedImage
            }
        }
        // dismiss imagePickerController
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func addAMust(_ sender: UITapGestureRecognizer)
    {
        let point = sender.location(in: myImageView)
        let width = screenWidth / 5.0
        let height = width / 2.0
        let mustacheImageView = UIImageView(frame: CGRect(x: point.x, y: point.y, width: width, height: height))
        mustacheImageView.contentMode = .scaleAspectFit
        mustacheImageView.center = point
        mustacheImageView.tag = 2
        mustacheImageView.image = UIImage(named: "Mustache")
        mustacheImageView.isUserInteractionEnabled = true
        view.addSubview(mustacheImageView)
        
        // add pan Gesture to move location of view
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        pan.delegate = self
        mustacheImageView.addGestureRecognizer(pan)

        // add PinchGesture to scale imageview
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
        pinch.delegate = self
        mustacheImageView.addGestureRecognizer(pinch)
        
        // add rotation gesture to rotate imageview
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(sender:)))
        rotation.delegate = self
        mustacheImageView.addGestureRecognizer(rotation)

    }
    
    // func that handles pan gesture
    func handlePan(sender: UIPanGestureRecognizer? = nil) {
        let location = sender?.location(in: view)
        let imageView = sender?.view as! UIImageView
        imageView.center = location!

        
    }
    
    // func that gets called with pinch Gesture Recognizer
    func handlePinch(sender: UIPinchGestureRecognizer? = nil) {
    
        let scale = sender?.scale
        let imageView = sender?.view as! UIImageView
        imageView.transform = imageView.transform.scaledBy(x: scale!, y: scale!)
        sender?.scale = 1
        
    }
    
    // handle rotation Gesture
    func handleRotation(sender: UIRotationGestureRecognizer? = nil) {
        let rotation = sender?.rotation
        let imageView = sender?.view as! UIImageView
        imageView.transform = imageView.transform.rotated(by: rotation!)
        sender?.rotation = 0
    }
    
    var numberOfTaps: Int = 0
    
    @IBAction func switchPrincipalButtonSelected(_ sender: UIBarButtonItem) {
        if numberOfTaps % 3 == 0 {
            myImageView.image = #imageLiteral(resourceName: "LynnewoodPrincipal")
        } else if numberOfTaps % 3 == 1 {
            myImageView.image = #imageLiteral(resourceName: "CoopertownPrincipal")
        } else {
            myImageView.image = #imageLiteral(resourceName: "CoopertownStaff")
        }
        numberOfTaps += 1
        
    }
    @IBAction func clearButton(_ sender: UIBarButtonItem)
    {
        for view in self.view.subviews
        {
            if view.tag == 2
            {
                view.removeFromSuperview()
            }
        }
    }
}




