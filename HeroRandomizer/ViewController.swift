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
            case .failure(Error):
                print(Error.localizedDescription)
            }
        }
    }
    
    private func handleHeroData(data: Data) {
        do {
            // Decode the data into the APIHero struct
            let heroForGetApiRequest = try JSONDecoder().decode(APIHero.self, from: data)

            // Fetch the hero image using the URL in heroForGetApiRequest.images.sm
            guard let heroImage = self.getImageFromUrl(string: heroForGetApiRequest.images.sm) else {
                return
            }

            // Update UI elements on the main thread
            DispatchQueue.main.async {
                self.heroName.text = heroForGetApiRequest.name
                self.heroFullName.text = heroForGetApiRequest.biography.fullName
                self.heroFirstAppearance.text = heroForGetApiRequest.biography.firstAppearance
                self.heroAlignment.text = heroForGetApiRequest.biography.alignment
                self.heroPublisher.text = heroForGetApiRequest.biography.publisher
                self.heroImage.image = heroImage
            }
        } catch {
            DispatchQueue.main.async {
                self.heroName.text = "Error: \(error.localizedDescription)"
                self.heroFullName.text = ""
                self.heroFirstAppearance.text = ""
                self.heroAlignment.text = ""
                self.heroPublisher.text = ""
                self.heroImage.image = nil
            }
        }
    }
    
    private func getImageFromUrl(string: String) -> UIImage? {
        guard
            let heroImageURL = URL(string: string),
            let imageData = try? Data(contentsOf: heroImageURL)
        else {
            return nil
        }
        return UIImage(data: imageData)
    }

    private func handleErrorIfNeeded(error: Error?) -> Bool {
        guard let error else {
            return false
        }
        print(error.localizedDescription)
        return true
    }
}

