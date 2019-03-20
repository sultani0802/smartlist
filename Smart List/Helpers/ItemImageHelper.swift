//
//  ItemImageHelper.swift
//  Smart List
//
//  Created by Haamed Sultani on Mar/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class ItemImageHelper {
    static let shared = ItemImageHelper()
    private init() {} // Prevents creation of another instances
    
    
    
    /// This method parses the words the user entered for the Item's name
    /// Goes through each word and checks for a match to one of the image names in Assets.xcassets
    /// It sorts those matches by how close the word is to matching each image file name
    /// and assigns the best matching image name to the Item's imageName property.
    ///
    ///
    /// - Parameter item: is the Item entity we are editing
    func getMatchedImage(item: Item) -> String {
        // Create a [String] of all the words in the Item's name
        guard let enteredWords : [String] = item.name?.components(separatedBy: " ") else {return "groceries"}
        // The pairs of user words that matched to the image names
        var matchedWords = [String:String]()
        
        // Go through the words in [String]
        for word in enteredWords {
            var bestImageName = ""                                  // Keep track of the image name that best matches the word

            // Go through all the image file names saved to Assets.xcassets
            for img in Constants.ItemImages {
                if word.levenshteinDistanceScore(to: img) > word.levenshteinDistanceScore(to: bestImageName)
                {
                    bestImageName = img
                }
            }
            
            
            // Once we have the best match, only use it if it's a 80%+ match
            if word.levenshteinDistanceScore(to: bestImageName) >= (0.8) {
                matchedWords[word] = bestImageName
            }
        }
        
        
        // If we found any matches of 80%+
        if matchedWords.count > 0 {
            // Add the Item name and its corresponding image name to the dictionary
            return matchedWords[sortMatchedWords(pairs: matchedWords)]!
        } else {
            // Otherwise, set it to a default image
            
            switch item.category?.name {
            case Constants.DefaultCategories.Produce:
                return "groceries"
            case Constants.DefaultCategories.Bakery:
                return "bread"
            case Constants.DefaultCategories.Dairy:
                return "milk"
            case Constants.DefaultCategories.Frozen:
                return "popsicles"
            case Constants.DefaultCategories.MeatSeafood:
                return "steak"
            case Constants.DefaultCategories.PackagedCanned:
                return "canned food"
            default:
                return "groceries"
            }
        }
    }
    
    
    // Use insertion sort to return the highest scoring pair of words
    // Insertion because it's a small data set
    func sortMatchedWords(pairs: [String:String]) -> String {
        var i = 1
        var keys : [String] = Array(pairs.keys)
        
        while i < keys.count {
            var j = i
            
            while j > 0 && keys[j-1].levenshteinDistanceScore(to: pairs[keys[j-1]]!) > keys[j].levenshteinDistanceScore(to: pairs[keys[j]]!) {
                let temp = keys[j]
                keys[j] = keys[j-1]
                keys[j-1] = temp
                
                j = j - 1
            }
            
            i = i + 1
        }
        
        return keys.last!
    }
    
}
