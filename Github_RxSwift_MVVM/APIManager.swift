//
//  APIManager.swift
//  Github_RxSwift_MVVM
//
//  Created by KeunHyeong on 2020/11/01.
//  Copyright © 2020 KeunHyeong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class APIManager{
    
    static func repositoriesBy(_ githubID: String) ->Observable<[Repository]>{
        guard !githubID.isEmpty, let url = URL(string: "https://api.github.com/users/\(githubID)/repos") else {
            return Observable.just([])
        }
        return URLSession.shared.rx.json(url: url)
            .retry(3)
//            .catchErrorJustReturn([])
        .map(parse)
    }
    
    static func parse(json:Any)->[Repository]{
        guard let items = json as? [[String:Any]] else {
            return []
        }
        
        var repositories = [Repository]()
        
        items.forEach{
            guard let repoName = $0["name"] as? String,
                let repoURL = $0["html_url"] as? String else {
                    return
            }
            repositories.append(Repository(repoName: repoName, repoURL: repoURL))
        }
         return repositories
    }
}
