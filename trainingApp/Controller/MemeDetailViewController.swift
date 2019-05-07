//
//  MemeDetailViewController.swift
//  trainingApp
//
//  Created by Dzhavid Babakishiiev on 1/27/19.
//  Copyright © 2019 Dzhavid. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!

    @IBOutlet weak var detailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImageView.image = meme.memedImage
    }
    
}
