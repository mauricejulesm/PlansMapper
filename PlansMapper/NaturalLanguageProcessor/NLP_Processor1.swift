//
//  NLP_Processor.swift
//  PlansMapper
//
//  Created by falcon on 11/1/19.
//  Copyright © 2019 mauricejules. All rights reserved.
//

import Foundation

//MARK: - Quote
let quote = "Here's to the crazy ones. The misfits. The rebels. The troublemakers. The round pegs in the square holes. The ones who see things differently. They're not fond of rules. And they have no respect for the status quo. You can quote them, disagree with them, glorify or vilify them. About the only thing you can't do is ignore them. Because they change things. They push the human race forward. And while some may see them as the crazy ones, we see genius. Because the people who are crazy enough to think they can change the world, are the ones who do. - Steve Jobs (Founder of Apple Inc.)"

let tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]


func determineLanguage(for text: String) {
	tagger.string = text
	let language = tagger.dominantLanguage
	print("The language is \(language!)")
}


func tokenizeText(for text: String) {
	tagger.string = text
	let range = NSRange(location: 0, length: text.utf16.count)
	tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { tag, tokenRange, stop in
		let word = (text as NSString).substring(with: tokenRange)
		print(word)
	}
}


func lemmantisize(for text: String){
	tagger.string = text
	_ = NSRange(location: 0, length: text.utf8.count)
	
	
}
class dn {
	deinit {
		
	}
	
}
