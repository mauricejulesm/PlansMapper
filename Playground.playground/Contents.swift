/*:
# Natural Language Processing In Swift 4
*/
import Foundation
import NaturalLanguage
import CoreML

enum LanguageUsed : String {
	case en, fr
	
}

let planTitle = "Go Shopping"
let planDescription = " Go shopping shoes for running next the weekend at Grand Baie and Port Louis Shopping Mall with Jules Maurice"

let fullPlanText = planTitle + planDescription


let quotes = ["Here's to the crazy ones. The misfits. The rebels. Because the people who are crazy enough to think they can change the world, are the ones who do. -Steve Jobs (Founder of Apple Inc.)", "Voici pour les fous. Les inadaptés. Les rebelles. Parce que ce sont les gens qui sont assez fous pour penser qu'ils peuvent changer le monde.", "यह है दीवानों के लिए। द मिसफिट्स। विद्रोही। क्योंकि जो लोग यह सोचने के लिए पागल हैं कि वे दुनिया को बदल सकते हैं, वही हैं जो करते हैं।", "Вот к сумасшедшим. Несоответствия Повстанцы. Потому что люди, которые достаточно сумасшедшие, чтобы думать, что они могут изменить мир, являются теми, кто это делает" ]

let tagger1 = NSLinguisticTagger(tagSchemes: [.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
let options1: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]


// MARK: - Determine the language a plan was written in
func determineLanguage(for text: String) {
	tagger1.string = text
	let usedLanguage = tagger1.dominantLanguage
	let detectedLangauge = Locale.current.localizedString(forIdentifier: usedLanguage!)
	print("This plan was written in: \(detectedLangauge ?? "Unkown Language")")
}

//for quote in quotes { determineLanguage(for: quote) }

// MARK: - Tokenize (splitting) the plans text into words.
func tokenizePlanText(for planText:String) {
	tagger1.string = planText
	let range = NSRange(location: 0, length: planText.utf16.count)
	tagger1.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options1) { tag, tokenRange, stop in
		let word = (planText as NSString).substring(with: tokenRange)
		print(word)
	}
}
//tokenizePlanText(for: fullPlanText)

func lemmatizePlanText(for planText: String) {
	tagger1.string = planText
	let range = NSRange(location:0, length: planText.utf16.count)
	tagger1.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options1) { tag, tokenRange, stop in
		if let lemma = tag?.rawValue {
			print(lemma)
		}
	}
}
//print("\n*** Lemmantisization ***")
//lemmatizePlanText(for: fullPlanText)

func extractPartsOfSpeech(for planText: String) {
	tagger1.string = planText
	let range = NSRange(location: 0, length: planText.utf16.count)
	tagger1.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options1) { tag, tokenRange, _ in
		if let tag = tag {
			let word = (planText as NSString).substring(with: tokenRange)
			print("\(word)\t\t\t: \(tag.rawValue)")
		}
	}
}
//print("\n*** Parts of speech ***")
//extractPartsOfSpeech(for: fullPlanText)

func extractNamedEntities(for planText: String) {
	tagger1.string = planText
	let range = NSRange(location: 0, length: planText.utf16.count)
	let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
	tagger1.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options1) { tag, tokenRange, stop in
		if let tag = tag, tags.contains(tag) {
			let name = (planText as NSString).substring(with: tokenRange)
			print("\(name): \(tag.rawValue)")
		}
	}
}
//print("\n*** Named Entity ***")
//extractNamedEntities(for: fullPlanText)
let list = [1,2,3,4,5]
let findList = [12,32,52]
let listSet = Set(list)
let findListSet = Set(findList)

let allElemsContained = findListSet.isDisjoint(with: listSet)
