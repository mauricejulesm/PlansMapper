//
//  NLP_Manamager.swift
//  PlansMapper
//
//  Created by falcon on 11/7/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//
import Foundation
import NaturalLanguage

class NLP_Manager {
	
	let shoppingCategory = ["shop", "store", "grocery", "purchase"]
	let sportsCategory = [ "sport", "run", "jog", "workout", "walk", "football", "soccer", "recreation center"]
	let foodCategory = ["restaurant", "food",  "hotel", "grocery", "cook", "manger", "eat", "drink"]
	
	let plansMapperTaggertagger = NSLinguisticTagger(tagSchemes: [.tokenType, .language, .lexicalClass, .nameType, .lemma],options: 0)
	let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
	
	// MARK: - Determine the language a plan was written in
	func determinePlanLanguage(for planText: String) {
		plansMapperTaggertagger.string = planText
		let usedLanguage = plansMapperTaggertagger.dominantLanguage
		let detectedLangauge = Locale.current.localizedString(forIdentifier: usedLanguage!)
		print("Debug: This plan was written in: \(detectedLangauge ?? "Unkown Language")")
	}
	//for quote in quotes { determineLanguage(for: quote) }
	
	
	// MARK: - extracting parts of speech from plan's text.
	func extractPartsOfSpeech(for planText: String) ->[String] {
		var relevantPartsOfSpeech = [String]()
		plansMapperTaggertagger.string = planText
		let range = NSRange(location: 0, length: planText.utf16.count)
		plansMapperTaggertagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
			if let tag = tag {
				let word = (planText as NSString).substring(with: tokenRange)
				if tag.rawValue == "Verb" || tag.rawValue == "Noun"{
					relevantPartsOfSpeech.append(word.lowercased()) }
			}}
		print("Debug: found relevant PoS: \(relevantPartsOfSpeech)")
		return relevantPartsOfSpeech
	}
	
	// MARK: - Lemmatize plan's text.
	func lemmatizePlanText(for partsOfSpeech: [String]) ->[String] {
		let planText = partsOfSpeech.joined(separator: " ")
		var foundCategoriesLemma = [String]()
		plansMapperTaggertagger.string = planText
		let range = NSRange(location:0, length: planText.utf16.count)
		plansMapperTaggertagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { tag, tokenRange, stop in
			if let lemma = tag?.rawValue {
				foundCategoriesLemma.append(lemma.lowercased())}
		}
		print("Debug: Lemma: \(foundCategoriesLemma)")
		return foundCategoriesLemma
	}
	
	
	
	func extractNamedEntities(for planText: String) -> [String] {
		var foundNames = [String]()
		plansMapperTaggertagger.string = planText
		let range = NSRange(location: 0, length: planText.utf16.count)
		let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
		plansMapperTaggertagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, stop in
			if let tag = tag, tags.contains(tag) {
				let name = (planText as NSString).substring(with: tokenRange)
				foundNames.append(name) }
		}
		print("Debug: found place names are: \(foundNames)")
		return foundNames
	}
	
	//MARK:-  Generate map search terms function
	func generateMapSearchTerms(for fullPlanText:String) -> [String] {
		var mapSearchTerms = [String]()
		var mapSearchPlaces = [String]()
		var langugeUsed = determinePlanLanguage(for: fullPlanText)
		
		let lemmas = lemmatizePlanText(for: extractPartsOfSpeech(for: fullPlanText))
		let lemmasSet = Set(lemmas)
		if !lemmasSet.isDisjoint(with: shoppingCategory) {
			mapSearchTerms = shoppingCategory
		}else if !lemmasSet.isDisjoint(with: sportsCategory) {
			mapSearchTerms = sportsCategory
		}else if !lemmasSet.isDisjoint(with: foodCategory) {
			mapSearchTerms = foodCategory
		}else { mapSearchTerms = [""] }
		
//		DataManager.setMapSearchPlaces( places : mapSearchPlaces)
//		DataManager.setPlanLanguage( lang : langugeUsed)
		return mapSearchTerms
	}
}


