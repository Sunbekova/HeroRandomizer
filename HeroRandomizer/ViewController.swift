//
//  ViewController.swift
//  HeroRandomizer
//
//  Created by Aisha Suanbekova Bakytjankyzy on 21.11.2024.
//

import UIKit
import Kingfisher
import Alamofire

class ViewController: UIViewController {
    
    private let hero = APIHero.self
    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroFullName: UILabel!
    @IBOutlet weak var heroFirstAppearance: UILabel!
    @IBOutlet weak var heroAlignment: UILabel!
    @IBOutlet weak var heroPublisher: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

   
    @IBAction func heroRolled(_ sender: UIButton) {
        let randomId = Int.random(in: 1...563)
        fetchHero(by: randomId)
        
        UIView.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                sender.transform = .identity
            }
        }
    }


    private func fetchHero(by id: Int) {
        let urlString = "https://akabab.github.io/superhero-api/api/id/\(id).json"
        AF.request(urlString).validate().responseDecodable(of: APIHero.self) { response in
            switch response.result {
            case .success(let heroForGetApiRequest):
                self.handleHeroData(with: heroForGetApiRequest)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.heroName.text = "Error: Unable to fetch hero"
                    self.heroImage.image = UIImage(systemName: "exclamationmark.triangle")
                }
                print(error.localizedDescription)
            }
        }
    }
    
    private func handleHeroData(with hero: APIHero) {
        DispatchQueue.main.async {
            self.heroName.text = hero.name
            self.heroFullName.text = hero.biography.fullName
            self.heroFirstAppearance.text = hero.biography.firstAppearance
            self.heroAlignment.text = hero.biography.alignment
            self.heroPublisher.text = hero.biography.publisher
            
            // Use Kingfisher to load the image
            if let imageUrl = URL(string: hero.images.sm) {
                self.heroImage.kf.setImage(with: imageUrl, placeholder: UIImage(systemName: "photo"))
            }
        }
    }
    
}
