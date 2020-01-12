import foundation


protocol APIClient {
	var session: URLSession { get }
	func fetch<T: Decodable> (with request: URLRequest,
							  completion: @escaping (Result<T>) -> Void) 
}

extension APIClient {

	/// Creates a dataTask with a trailing completion that makes a request to the given URLRequest.
	/// > Uses the JSONDecoder to decode the json received from the request and decodes it to the given Generic
	/// - Parameters:
	///		- request: The URLRequest used in the urlSession.dataTask
	/// - Returns: the dataTask that will fetch the json
	private func decodingTask<T: Decodable> (with request: URLRequest,
											decodingType: T.Type,
											completionHandler completion: @escaping (Decodable?) -> Void) -> URLSessionDataTask {

		let task = session.dataTask(with: request) { data, response, _ in 
			guard let httpResponse = response as? HTTPURLResponse else {
				completion(nil)
				return 
			}

			print("API Response Status Code: \(httpResponse.statusCode)")

			// If valid response from the API
			if (httpResponse.statusCode == 200) {
				if let data = data {
					do {
						// Decode the json and call completion with the decoded data
						let decoder = JSONDecoder()
						decoder.keyDecodingStrategy = .convertFromSnakeCase
						let genericModel = try decoder.decode(decodingType, from: data)
						completion(genericModel)
					} catch {
						print(error)
						completion(nil)
					}
				} else {
					completion(nil)
				}
			} else {
				completion(nil)
			}
		}

		return task
	}
}