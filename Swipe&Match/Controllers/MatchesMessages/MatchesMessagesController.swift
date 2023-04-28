//
//  MatchesMessagesController.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 17.04.2023.
//

import LBTATools
import Firebase

struct Match {
    let name, profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}

class MatchCell: LBTAListCell<Match> {
    
    let profileImageView = UIImageView(image: Placeholder.image, contentMode: .scaleAspectFill)
    let userNameLabel = UILabel(text: "Username", font: .systemFont(ofSize: 14, weight: .semibold), textColor: .darkGray, textAlignment: .center, numberOfLines: 2)
    
    override var item: Match! {
        didSet {
            userNameLabel.text = item.name
            profileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
        }
    }
    
    override func setupViews() {
        super.setupViews()
        profileImageView.clipsToBounds = true
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.layer.cornerRadius = 40
        stack(stack(profileImageView, alignment: .center), userNameLabel)
    }
}

class MatchesMessagesController: LBTAListController<MatchCell, Match>, UICollectionViewDelegateFlowLayout {
    
    let customNavigationBar = MatchesNavigationBar()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 140)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chatLogController = ChatLogController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureCustomNavBar()
        fetchMatches()
    }
    
    private func fetchMatches() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("matches_messages").document(currentUserID).collection("matches").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("failed to fetch", err)
                return
            }
            
            var matches = [Match]()
            
            querySnapshot?.documents.forEach({ (documentSnapshot) in
                let dictionary = documentSnapshot.data()
                matches.append(.init(dictionary: dictionary))
            })
            self.items = matches
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = 150
    }
    
    private func configureCustomNavBar() {
        customNavigationBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        view.addSubview(customNavigationBar)
        customNavigationBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
    }
    
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}
