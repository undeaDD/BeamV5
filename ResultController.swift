//
//  ResultController.swift
//  BeamV5
//
//  Created by Us on 02/03/2020.
//  Copyright © 2020 David Arebuwa. All rights reserved.

import UIKit

class ResultController{
    
    let resultList = Bundle.main.decode(_type: [ResultData].self, from: "resultlist 2.json")
    
    //Result
    struct ResultData: Decodable, Hashable{
        let identifier = UUID()
        let id : Int
        let result: String
        let tag : String
        let info: [ResultItemData]
    
        //TODO:We're Going to have to find a way to add supplements
        // let supplements : SupplementCollection
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        static func == (lhs: ResultData, rhs: ResultData) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        
        func contains(_ filter: String?) -> Bool {
            guard let filterText = filter else { return true }
            if filterText.isEmpty {return true}
            let lowercasedFilter = filterText.lowercased()
            
            return result.lowercased().contains(lowercasedFilter)
        }
    }
    
    //Items
    struct ResultItemData: Decodable, Hashable{
        let identifier = UUID()
        var name: String
        var tags: String
        var gif: String
        var details : [ResultItemDetails]
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        
        static func == (lhs: ResultItemData, rhs: ResultItemData) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        
        func contains(_ filter: String?) -> Bool {
            guard let filterText = filter else { return true }
            if filterText.isEmpty {return true}
            let lowercasedFilter = filterText.lowercased()
            return name.lowercased().contains(lowercasedFilter)
        }
    }
    
    //Details
    struct ResultItemDetails: Decodable,Hashable{
        let identifier = UUID()
        let name: String
        let gif : String
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        static func == (lhs: ResultItemDetails, rhs: ResultItemDetails) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        
        func contains(_ filter: String?) -> Bool {
            guard let filterText = filter else { return true }
            if filterText.isEmpty {return true}
            let lowercasedFilter = filterText.lowercased()
            return name.lowercased().contains(lowercasedFilter)
        }
    }
    
    //Supplements
    struct SupplementCollection: Decodable,Hashable{
        let identifier = UUID()
        let title : String
        let supplements: [ResultItemData]
        
        static func == (lhs: SupplementCollection, rhs: SupplementCollection) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        
        func contains(_ filter: String?) -> Bool {
            guard let filterText = filter else { return true }
            if filterText.isEmpty {return true}
            let lowercasedFilter = filterText.lowercased()
            return title.lowercased().contains(lowercasedFilter)
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    var collections : [SupplementCollection] {
        return _collections
    }
    
    init(){
        generateCollections()
    }
    
    fileprivate var _collections = [SupplementCollection]()
    
    //Filter results by tag
    func filteredResults(with filter: String?=nil) -> [ResultData]{
        return resultList.filter { $0.tag == filter }
    }
    
}

extension ResultController {
    func generateCollections(){
        _collections = [
            SupplementCollection(title:
                "Recommended: ", supplements: [
                    ResultItemData(name: "Seated Pectoralis Major Stretch", tags: "chest,stability ball,stretch,assisted", gif: "assisted_seated_pectoralis_major_stretch", details:
                        [ResultItemDetails(name: "Range of Motion", gif: "assisted_seated_pectoralis_major_stretch_range_of_motion"),ResultItemDetails(name: "Time Under Tension", gif: "assisted_seated_pectoralis_major_stretch_time_under_tension")]
                    ),
                    ResultItemData(name: "Chest Stretch", tags: "chest,stability ball,stretch", gif: "chest_stretch_stability_ball", details:
                        [ResultItemDetails(name: "Range of Motion", gif: "chest_stretch_stability_ball_range_of_motion"),ResultItemDetails(name: "Time Under Tension", gif: "chest_stretch_stability_ball_time_under_tension")]
                    ),
                    ResultItemData(name: "Decline Push Up", tags: "chest,stability ball,decline,push up", gif: "decline_push_up_stability_ball", details:
                        [ResultItemDetails(name: "Range of Motion", gif: "decline_push_up_stability_ball_range_of_motion"),ResultItemDetails(name: "Time Under Tension", gif: "decline_push_up_stability_ball_time_under_tension")]
                    ),
                    ResultItemData(name: "Pike Push Up", tags: "chest,stability ball,pike,push up", gif: "pike_push_up_stability_ball", details:
                        [ResultItemDetails(name: "Range of Motion", gif: "pike_push_up_stability_ball_range_of_motion"),ResultItemDetails(name: "Time Under Tension", gif: "pike_push_up_stability_ball_time_under_tension")]
                    ),
                    ResultItemData(name: "Push Up", tags: "chest,stability ball,push up", gif: "decline_push_up_stability_ball", details:
                        [ResultItemDetails(name: "Range of Motion", gif: "decline_push_up_stability_ball_range_of_motion"),ResultItemDetails(name: "Time Under Tension", gif: "decline_push_up_stability_ball_time_under_tension")]
                    )
                    
                    
            ]),
            SupplementCollection(title:
                "Target Area: Chest", supplements: [
                    ResultItemData(name: "Seated Pectoralis Major Stretch", tags: "chest,stability ball,stretch,assisted", gif: "assisted_seated_pectoralis_major_stretch", details:
                        [ResultItemDetails(name: "Range of Motion", gif: "assisted_seated_pectoralis_major_stretch_range_of_motion"),ResultItemDetails(name: "Time Under Tension", gif: "assisted_seated_pectoralis_major_stretch_time_under_tension")]
                    ),
                    ResultItemData(name: "Chest Stretch", tags: "chest,stability ball,stretch", gif: "chest_stretch_stability_ball", details:
                        [ResultItemDetails(name: "Range of Motion", gif: "chest_stretch_stability_ball_range_of_motion"),ResultItemDetails(name: "Time Under Tension", gif: "chest_stretch_stability_ball_time_under_tension")]
                    ),
                    ResultItemData(name: "Decline Push Up", tags: "chest,stability ball,decline,push up", gif: "decline_push_up_stability_ball", details:
                        [ResultItemDetails(name: "Range of Motion", gif: "decline_push_up_stability_ball_range_of_motion"),ResultItemDetails(name: "Time Under Tension", gif: "decline_push_up_stability_ball_time_under_tension")]
                    ),
                    ResultItemData(name: "Pike Push Up", tags: "chest,stability ball,pike,push up", gif: "pike_push_up_stability_ball", details:
                        [ResultItemDetails(name: "Range of Motion", gif: "pike_push_up_stability_ball_range_of_motion"),ResultItemDetails(name: "Time Under Tension", gif: "pike_push_up_stability_ball_time_under_tension")]
                    ),
                    ResultItemData(name: "Push Up", tags: "chest,stability ball,push up", gif: "decline_push_up_stability_ball", details:
                        [ResultItemDetails(name: "Range of Motion", gif: "decline_push_up_stability_ball_range_of_motion"),ResultItemDetails(name: "Time Under Tension", gif: "decline_push_up_stability_ball_time_under_tension")]
                    )
                    
                    
            ]),
            SupplementCollection(title:
                "Experience Level: Beginner", supplements: [
                    ResultItemData(name: "Seated Pectoralis Major Stretch", tags: "chest,stability ball,stretch,assisted", gif: "assisted_seated_pectoralis_major_stretch", details:
                        [ResultItemDetails(name: "Range of Motion", gif: "assisted_seated_pectoralis_major_stretch_range_of_motion"),ResultItemDetails(name: "Time Under Tension", gif: "assisted_seated_pectoralis_major_stretch_time_under_tension")]
                    ),
                    ResultItemData(name: "Chest Stretch", tags: "chest,stability ball,stretch", gif: "chest_stretch_stability_ball", details:
                        [ResultItemDetails(name: "Range of Motion", gif: "chest_stretch_stability_ball_range_of_motion"),ResultItemDetails(name: "Time Under Tension", gif: "chest_stretch_stability_ball_time_under_tension")]
                    ),
                    ResultItemData(name: "Decline Push Up", tags: "chest,stability ball,decline,push up", gif: "decline_push_up_stability_ball", details:
                        [ResultItemDetails(name: "Range of Motion", gif: "decline_push_up_stability_ball_range_of_motion"),ResultItemDetails(name: "Time Under Tension", gif: "decline_push_up_stability_ball_time_under_tension")]
                    ),
                    ResultItemData(name: "Pike Push Up", tags: "chest,stability ball,pike,push up", gif: "pike_push_up_stability_ball", details:
                        [ResultItemDetails(name: "Range of Motion", gif: "pike_push_up_stability_ball_range_of_motion"),ResultItemDetails(name: "Time Under Tension", gif: "pike_push_up_stability_ball_time_under_tension")]
                    ),
                    ResultItemData(name: "Push Up", tags: "chest,stability ball,push up", gif: "decline_push_up_stability_ball", details:
                        [ResultItemDetails(name: "Range of Motion", gif: "decline_push_up_stability_ball_range_of_motion"),ResultItemDetails(name: "Time Under Tension", gif: "decline_push_up_stability_ball_time_under_tension")]
                    )
                    
                    
            ])
            
        ]
    }
    
}

//Filter results items by tags
//    func filteredResultItems(with filter: String?=nil) -> [ResultData]{
//
//        for result in resultList {
//            for info in result.info{
//                let components = info.tags.components(separatedBy: ",")
//                var results = [ResultController.ResultData]()
//                for tag in components{
//                    if tag == filter{
//                        //A match has been found in one of the tags
//                        results.append(result)
//
//                    }
//                }
//            }
//        }
//
//        return resultList.filter { $0.info.first?.components == filter }
//
//          }
