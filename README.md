# MemeMe 2.0
An app that enables a user to take a picture, and add text at the top and bottom to form a meme. The user is able to share the photo on Facebook and Twitter and also by SMS or email. Memes appeared in a tab view with two tabs: a table view and a collection view.

<img width="394" alt="Screen Shot 2019-08-25 at 12 24 03 PM" src="https://user-images.githubusercontent.com/46335329/63652888-a4950580-c733-11e9-8e87-e6338ccab36d.png">

<img width="395" alt="Screen Shot 2019-08-25 at 12 25 42 PM" src="https://user-images.githubusercontent.com/46335329/63652895-c9897880-c733-11e9-81eb-cd239b7ed283.png">

## App Implementation
The app has three pages of content:
Meme Editor View: Enables a user to add text to an image and share it. 
```
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
```

Sent Memes View: Enables a user to browse sent memes in a table or a grid.
```
class SentMemesTableViewController: UITableViewController  {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

```

Meme Detail View: Displays an image of a sent meme
```
class MemeDetailViewController: UIViewController {
    
    var meme: Meme!

    @IBOutlet weak var detailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImageView.image = meme.memedImage
    }
    
}
```


