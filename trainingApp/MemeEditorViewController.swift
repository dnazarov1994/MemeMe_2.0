//
//  ViewController.swift
//  trainingApp
//
//  Created by Dzhavid Babakishiiev on 1/6/19.
//  Copyright © 2019 Dzhavid. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var toolBarBottom: UIToolbar!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var textFieldTop: UITextField!
    
    @IBOutlet weak var textFieldBottom: UITextField!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.strokeWidth: -2.5,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.isEnabled = false
    
        setup(textField: textFieldTop)
        setup(textField: textFieldBottom)
        
        textFieldTop.text = "TOP"
        textFieldBottom.text = "BOTTOM"
    }
    
    func setup(textField: UITextField) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func save() {
        let meme = Meme(textTop: textFieldTop.text!, textBottom: textFieldBottom.text!, image: imagePickerView.image!, memedImage: generateMemedImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    
    }
    
    @IBAction func shareTheMeme()   {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = { (_,isCompleted,_,_) in
            if isCompleted {
                self.save()
            }
        }
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelTheImage()  {
        textFieldTop.text = "TOP"
        textFieldBottom.text = "BOTTOM"
        imagePickerView.image = nil
        
        shareButton.isEnabled = false
    }
    

    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        presentImagePicker(with: .photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
   
    func generateMemedImage() -> UIImage {
        
        navigationBar.isHidden = true
        toolBarBottom.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationBar.isHidden = false
        toolBarBottom.isHidden = false
        
        return memedImage
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentImagePicker(with: .camera)
    }
    
    func presentImagePicker(with type: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }
}

extension MemeEditorViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if textFieldBottom.isFirstResponder {
           view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notificatioin: Notification)  {
        self.view.frame.origin.y = 0.0
    }
    
}



