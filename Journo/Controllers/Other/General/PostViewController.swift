//
//  PostViewController.swift
//  Journo
//
//  Created by Dragos Albastroiu on 04.05.2022.
//

import UIKit

class PostViewController: UIViewController {

    private let model: UserPost?
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = nil
        
        return imageView
    }()
    
    init(model: UserPost?) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(photoImageView)
        photoImageView.frame = CGRect(x: 10, y: 100, width: view.width - 20, height: view.width - 20)
        
        photoImageView.sd_setImage(with: URL(string:model!.pictureUrl))
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
