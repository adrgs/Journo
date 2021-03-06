//
//  ExploreViewController.swift
//  Journo
//
//  Created by Dragos Albastroiu on 04.05.2022.
//

import UIKit
import FirebaseAuth

class ExploreViewController: UIViewController {

    private let searchBar: UISearchBar = {
       
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
        
    }()
    
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.topItem?.titleView = searchBar
        
        /*
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame:.zero, collectionViewLayout: layout)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let collectionView = collectionView else {
            return
        }
        
        view.addSubview(collectionView)
        //vc.view.frame = CGRect(x: 0, y: searchBar.bottom, width: collectionView.width, height: collectionView.height)
         */
        
        let uid = DatabaseManager.shared.getId(email: Auth.auth().currentUser!.email!)
        
        let data = DatabaseManager.shared.getUsers(uid: uid)
        
        let vc = ListViewController(data: data)
        
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        addChild(vc)
        vc.didMove(toParent: self)
        
        // Do any additional setup after loading the view.
    }

    
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
