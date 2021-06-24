//
//  UIImage+Ext.swift
//  ItsGonnaRain
//
//  Created by Ezra Black on 6/23/21.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
let cachedImages = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageFromURL(url: String) {
        self.image = nil
        guard let URL = URL(string: url) else {
            print("No Image For this url", url)
            return
        }
        if let cachedImage  = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image      = cachedImage
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data                 = try? Data(contentsOf: URL) {
                if let image            = UIImage(data: data) {
                    let imageTocache    = image
                    imageCache.setObject(imageTocache, forKey: url as AnyObject)
                    
                    DispatchQueue.main.async {
                        self?.image = imageTocache
                    }
                }
            }
        }
    }
    
    //Fetch image profile from a URL Using URLSession and DispatchQueue main async
    func loadImageUsingCacheWithUrlString(urlString:String) {
        
        self.image = nil
    
        //Check cache
        if let cacheImage = cachedImages.object(forKey: urlString as NSString)  {
            self.image = cacheImage
            return
        }
        //New Download
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage  = UIImage(data:data!){
                    cachedImages.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image          = downloadedImage
                }
            }
        })
        task.resume()
    }
}
