//
//  CameraViewController.swift
//  Journo
//
//  Created by Dragos Albastroiu on 04.05.2022.
//

import UIKit
import FirebaseAuth

class CameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(photoImageView)
        view.addSubview(statusLabel)
        photoImageView.frame = CGRect(x: 10, y: 100, width: view.width - 20, height: view.width - 20)
        statusLabel.frame = CGRect(x: 10, y: photoImageView.bottom + 20, width: view.width - 20, height: view.width - 20)
        // Do any additional setup after loading the view.
    }
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = nil
        
        return imageView
    }()
    
    @IBOutlet var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    
    override func viewDidAppear(_ animated: Bool) {
        self.statusLabel.text = "Waiting..."
        
        ImagePickerManager().pickImage(self){ image in
                
            self.photoImageView.image = image
            
            StorageManager.shared.uploadMedia(image: image) {url in
                if url != nil {
                    self.statusLabel.text = "Uploaded image!"
                    
                    let uid = DatabaseManager.shared.getId(email: Auth.auth().currentUser!.email!)
                    let postid = DatabaseManager.shared.createPost(uid: uid, url: url!)
                    print("Post id: \(postid)")
                    
                } else {
                    self.statusLabel.text = "Failed to upload image!"
                }
            }
            
        }
    }

}

