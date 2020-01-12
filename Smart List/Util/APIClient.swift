import foundation


protocol APIClient {
	var session: URLSession { get }
	func fetch<T: Decodable> (with request: URLRequest,
							  completion: @escaping (Result<T>) -> Void) 
}

extension APIClient {
	
	private func decodingTask<T: Decodable> (with request: URLRequest,
											decodingType: T.Type,
											completionHandler completion: @escaping (Decodable?) -> Void) -> URLSessionDataTask {

		let task = session.dataTask(with: request) { data, response, _ in 
			guard let httpResponse = response as? HTTPURLResponse else {
				completion(nil)
				return 
			}

			print("API Response Status Code: \(httpResponse.statusCode)")

			if (httpResponse.statusCode == 200) {
				if let data = data {
					do {
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