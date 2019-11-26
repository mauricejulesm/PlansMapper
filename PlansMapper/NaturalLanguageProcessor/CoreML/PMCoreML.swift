/*:
# Building Machine Learning Custom models to classfy texts
*/
import Foundation
import NaturalLanguage


@available(iOS 12.0, *)
class PlansCategoryTagger {
	// Custom scheme
	private let scheme = NLTagScheme("PlansData")
	private let options: NLTagger.Options = [.omitPunctuation]
	
	private lazy var tagger: NLTagger? = {
		
		do {
			let url = Bundle.main.url(forResource: "PlansCategorizer", withExtension: "mlmodelc")!
			let model = try NLModel(contentsOf: url)  // MLModel -> NLModel
			let tagger = NLTagger(tagSchemes: [scheme])
			tagger.setModels([model], forTagScheme: scheme) // Associating custom model with custom scheme
			return tagger
		} catch {
			return nil
		}
	}()
	
	func predictCategory(for text: String) -> String? {
		tagger?.string = text
		let range = text.startIndex ..< text.endIndex
		tagger?.setLanguage(.english, range: range)
		return tagger?.tags(in: range,
							unit: .document,
							scheme: scheme,
							options: options)
			.compactMap { tag, _ -> String? in
				return tag?.rawValue
			}
			.first
	}
}

