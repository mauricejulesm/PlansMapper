//
//  NLP_Manamager.swift
//  PlansMapper
//
//  Created by falcon on 11/7/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import Foundation
import NaturalLanguage

class NLP_Manager : NSObject {

	let planTitle = "mountain Rwanda"
	let planDescription = " go to see my grandma"
	var fullPlanText = String()
	override init() {
		fullPlanText = planTitle + planDescription
	}
	
	let shoppingCategory = ["shop", "mall", "store", "buy", "purchase"]
	let travelCategory = ["flight tickets", "booking", "airport","airplane","aeroplane"]
	let sportsCategory = ["run", "jog", "swimming", "workout", "hike", "walk", "sport", "football", "soccer", "recreation center"]
	let swimmingCategor = ["swim","swimming pool"]
	let hikingCategory = ["Hike","hiking", "mountain"]
	let foodCategory = ["food", "restaurant", "hotel", "cook", "manger", "eat", "drink"]
	let otherCategory = [""]

	
	let quotes = ["Here's to the crazy ones. The misfits. The rebels. Because the people who are crazy enough to think they can change the world, are the ones who do. -Steve Jobs (Founder of Apple Inc.)", "Voici pour les fous. Les inadaptés. Les rebelles. Parce que ce sont les gens qui sont assez fous pour penser qu'ils peuvent changer le monde.", "यह है दीवानों के लिए। द मिसफिट्स। विद्रोही। क्योंकि जो लोग यह सोचने के लिए पागल हैं कि वे दुनिया को बदल सकते हैं, वही हैं जो करते हैं।", "Вот к сумасшедшим. Несоответствия Повстанцы. Потому что люди, которые достаточно сумасшедшие, чтобы думать, что они могут изменить мир, являются теми, кто это делает" ]
	
	let tagger = NSLinguisticTagger(tagSchemes: [.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
	let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
	
	// MARK: - Determine the language a plan was written in
	func determineLanguage(for text: String) {
		tagger.string = text
		let usedLanguage = tagger.dominantLanguage
		let detectedLangauge = Locale.current.localizedString(forIdentifier: usedLanguage!)
		print("My Debug: This plan was written in: \(detectedLangauge ?? "Unkown Language")")
	}
	//for quote in quotes { determineLanguage(for: quote) }
	
	// MARK: - Tokenize (splitting) the plans text into words.
	func tokenizePlanText(for planText:String) {
		tagger.string = planText
		let range = NSRange(location: 0, length: planText.utf16.count)
		tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { tag, tokenRange, stop in
			let word = (planText as NSString).substring(with: tokenRange)
			print(word)
		}
	}
	
	func lemmatizePlanText(for partsOfSpeech: [String]) ->[String] {
		let planText = partsOfSpeech.joined(separator: " ")
		
		var foundCategoriesLemma = [String]()
		print("\n*** Lemmantisization ***")
		tagger.string = planText
		let range = NSRange(location:0, length: planText.utf16.count)
		tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { tag, tokenRange, stop in
			if let lemma = tag?.rawValue {
				foundCategoriesLemma.append(lemma.lowercased())
			}
		}
		print("My Debug: Lemma: \(foundCategoriesLemma)")
		return foundCategoriesLemma
	}
	
	func extractPartsOfSpeech(for planText: String) ->[String] {
		var relevantPartsOfSpeech = [String]()
		print("\n*** Parts of speech ***")
		tagger.string = planText
		let range = NSRange(location: 0, length: planText.utf16.count)
		tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
			if let tag = tag {
				let word = (planText as NSString).substring(with: tokenRange)
				if tag.rawValue == "Verb" || tag.rawValue == "Noun"{
					relevantPartsOfSpeech.append(word.lowercased())
				}
			}
		}
		print("My Debug: found relevant PoS: \(relevantPartsOfSpeech)")
		return relevantPartsOfSpeech
	}
	
	func extractNamedEntities(for planText: String) -> [String] {
		var foundNames = [String]()
		print("\n*** Named Entity ***")
		tagger.string = planText
		let range = NSRange(location: 0, length: planText.utf16.count)
		let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
		tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, stop in
			if let tag = tag, tags.contains(tag) {
				let name = (planText as NSString).substring(with: tokenRange)
				foundNames.append(name)
			}
		}
		print("My Debug: found place names \(foundNames)")
		return foundNames
	}
	
	//MARK:-  Helper methods
	
	func generateMapSearchTerms(for fullPlanText:String) -> [String] {
		var mapSearchTerms = [String]()
		
		determineLanguage(for: fullPlanText)
		let lemmas = lemmatizePlanText(for: extractPartsOfSpeech(for: fullPlanText))
		let lemmasSet = Set(lemmas)

		if !lemmasSet.isDisjoint(with: shoppingCategory) {
			mapSearchTerms = shoppingCategory
		}else if !lemmasSet.isDisjoint(with: sportsCategory) {
			mapSearchTerms = sportsCategory
		}else if !lemmasSet.isDisjoint(with: travelCategory) {
			mapSearchTerms = travelCategory
		}else if !lemmasSet.isDisjoint(with: foodCategory) {
			mapSearchTerms = foodCategory
		}else if !lemmasSet.isDisjoint(with: swimmingCategor) {
			mapSearchTerms = swimmingCategor
		}else if !lemmasSet.isDisjoint(with: hikingCategory) {
			mapSearchTerms = hikingCategory
		}else { mapSearchTerms = [""] }
		return mapSearchTerms
	}
}


