//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Jeff Morhous on 5/6/20.
//  Copyright © 2020 Jeff Morhous. All rights reserved.
//

import UIKit

class GFAvatarImageView: UIImageView {

    let placeHolderImage = UIImage(named: "avatar-placeholder")
    let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from urlString: String){
        //If the image is cached, don't do any network calls
        if let image = cache.object(forKey: NSString(string: urlString)) {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil { return }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return } //data is an optional so just in case
            
            guard let image = UIImage(data: data) else { return }
            
            self.cache.setObject(image, forKey: NSString(string: urlString))
            
            // UI updates have to be done on the main thread
            DispatchQueue.main.async {
                self.image = image
            }
            
        }
        
        task.resume()
    }
    
}
