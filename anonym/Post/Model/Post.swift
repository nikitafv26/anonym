//
//  File.swift
//  anonym
//
//  Created by Nikita Fedorenko on 11.06.2021.
//

import Foundation

struct ContentData: Decodable {
    var id: String?
    //var data: String?
    var type: String?
    var textValue: String?
    
    enum ContentData: String, CodingKey {
        case id, type, data
    }
    
    enum Data: String, CodingKey {
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContentData.self)
        id = try? container.decode(String.self, forKey: .id)
        type = try? container.decode(String.self, forKey: .type)
        
        if type == "TEXT"{
            let data = try? container.nestedContainer(keyedBy: Data.self, forKey: .data)
            if let data = data{
                textValue = try? data.decode(String.self, forKey: .value)
            }
        }
    }
}

struct Post: Decodable {
    
    //MARK: Properties
    var id: String
    var authorName: String?
    var extraSmallImgUrl: String?
    var viewCount: Int?
    var contents: [ContentData]?
    
    enum CodingKeys: String, CodingKey {
        case id, author, stats, contents
    }
    
    enum AuthorKeys: String, CodingKey {
        case name, photo
    }
    
    enum PhotoKeys: String, CodingKey {
        case data
    }
    
    enum DataKeys: String, CodingKey{
        case extraSmall
    }

    enum ExtraSmallKeys: String, CodingKey{
        case url
    }
    
    enum StatsKeys: String, CodingKey{
        case views
    }
    
    enum ViewsKeys: String, CodingKey{
        case count
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        
        let author = try? container.nestedContainer(keyedBy: AuthorKeys.self, forKey: .author)
        self.authorName = try author?.decode(String.self, forKey: .name)
        
        if let author = author {
            let photo = try? author.nestedContainer(keyedBy: PhotoKeys.self, forKey: .photo)
            let data = try? photo?.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
            let extraSmall = try? data?.nestedContainer(keyedBy: ExtraSmallKeys.self, forKey: .extraSmall)
            extraSmallImgUrl = try? extraSmall?.decode(String.self, forKey: .url)
        }
        
        let stats = try? container.nestedContainer(keyedBy: StatsKeys.self, forKey: .stats)
        if let stats = stats{
            let views = try? stats.nestedContainer(keyedBy: ViewsKeys.self, forKey: .views)
            viewCount = try views?.decode(Int.self, forKey: .count)
        }
        
        contents = try? container.decode([ContentData].self, forKey: .contents)
    }
}

struct PostResponse: Decodable {
    
    var items: [Post]
    var cursor: String?
    
    enum CodingKeys: String, CodingKey {
        case data
        case items
        case cursor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        items = try data.decode([Post].self, forKey: .items)
        cursor = try? data.decode(String.self, forKey: .cursor)
    }
}
