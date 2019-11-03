/*:
# Natural Language Processing In Swift 4
*/
import Foundation
import MapKit

let quote = "Here's to the crazy ones. The misfits. The rebels. Because the people who are crazy enough to think they can change the world, are the ones who do. -Steve Jobs (Founder of Apple Inc.)"

let tagger = NSLinguisticTagger(tagSchemes: [.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]

/*:
## 1. Language Identification
- Note: The first step for most NLP algorithms is determining what language the user is talking/typing in.
*/
func determineLanguage(for text: String) {
	tagger.string = text
	let language = tagger.dominantLanguage
	print("The language is \(language!)")
}
//determineLanguage(for: quote)
/*:
## 2. Tokenization
- Note: Tokenization is the process of splitting sentences, paragraphs, or an entire document in to your choice of length. In this scenario, we'll be splitting the quote above into words.
*/
func tokenizeText(for text:String) {
	let range = NSRange(location: 0, length: text.utf16.count)
	tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { tag, tokenRange, stop in
		let word = (text as NSString).substring(with: tokenRange)
		print(word)
	}
}
//tokenizeText(for: quote)
/*:
## 3. Lemmatization
- Note: Words can be conjugated in many forms. Take the word run for example. It can be running, ran, will run, etc. Since their are many forms of a word, Lemmatization breaks down the word into it's most basic form.
*/
func lemmatization(for text: String) {
	tagger.string = text
	let range = NSRange(location:0, length: text.utf16.count)
	tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { tag, tokenRange, stop in
		if let lemma = tag?.rawValue {
			print(lemma)
		}
	}
}
//lemmatization(for: quote)
/*:
## 4. Parts of Speech
- Note: The function below simply determines the part of speech for each word, whether it's a noun, verb, adjective, etc.
*/
func partsOfSpeech(for text: String) {
	tagger.string = text
	let range = NSRange(location: 0, length: text.utf16.count)
	tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
		if let tag = tag {
			let word = (text as NSString).substring(with: tokenRange)
			print("\(word): \(tag.rawValue)")
		}
	}
}
//partsOfSpeech(for: quote)
/*:
## 5. Named Entity Recognition
- Note: Finally, the function scans the quote for any notable names. Knowing any recognizable places can really give the machine context to understand the quote.
*/
func namedEntityRecognition(for text: String) {
	tagger.string = text
	let range = NSRange(location: 0, length: text.utf16.count)
	let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
	tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, stop in
		if let tag = tag, tags.contains(tag) {
			let name = (text as NSString).substring(with: tokenRange)
			print("\(name): \(tag.rawValue)")
		}
	}
}
//namedEntityRecognition(for: quote)



// TRYING OUT MAP SEARCHES

let searchRequest = MKLocalSearch.Request()
searchRequest.naturalLanguageQuery = "Shopping Mall"

let search = MKLocalSearch(request: searchRequest)

search.start { response, error in
	guard let response = response else {
		print("Error: \(error?.localizedDescription ?? "Unknown error").")
		return
	}
	
	for item in response.mapItems {
		item.name
		item.isCurrentLocation
		item.placemark.coordinate.latitude
		item.placemark.coordinate.longitude
		item.placemark.title
		item.placemark.subtitle
		item.placemark.description
		//item.placemark.region
		item.placemark.subtitle
		//print(item.phoneNumber ?? "No phone number.")
	}
}
