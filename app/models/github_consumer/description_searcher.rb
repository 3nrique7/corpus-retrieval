module GithubConsumer
  module DescriptionSearcher
     extend self
     MAX_PAGES = 10
     PARAMS_COMBINATIONS = [ #best match
       {sort: nil, order: nil},
       {sort: "stars", order: "desc"},
       {sort: "forks", order: "desc"},
       {sort: "stars", order: "asc", reversed: true},
       {sort: "forks", order: "asc", reversed: true}
     ]

     def get_all_description(query)
        repos_url = "https://api.github.com/search/repositories?q=#{query.gsub(" ","+")}+in:readme&per_page=100"
	date_items = []
	client = Client.new
	items = []
	PARAMS_COMBINATIONS.each_with_index do |params, i|
	   url = UrlBuilder.build(repos_url, 1, params[:sort], params[:order])
   	   client.register_request url do |first_page_json|
	      items = get_remaning_pages(repos_url, first_page_json, params)
	      # we get the desired items
	      date_items[i] = elements_of_item(items, params[:reversed])
	      # puts "HIIIIIIIIIIIII #{all_head_urls[i]}"
	      # puts items
	   end
       	end
   	client.run_requests
    	date_items.reduce(:|)
     end

     def elements_of_item(items, is_reversed)#Function to obtain the elements of the hashes of the items
        elements = items.map do |element|
		'{"full_name": "'+element["full_name"].to_s.gsub('"',"")+'", "description": "'+element["description"].to_s.tr("\n"," ").gsub('"',"")+'", "stars": '+element["stargazers_count"].to_s+', "forks": '+element["forks_count"].to_s+', "url": "'+element["html_url"].to_s+'"}'
	end
      	is_reversed ? elements.reverse : elements
     end

     def get_remaning_pages(repos_url, first_page_json, params)
	 total_items = first_page_json["total_count"]
	 total_pages = [total_items / 100, MAX_PAGES].min
      	 items = []
	 items[1] = first_page_json["items"]
	 client = Client.new
	 (2..total_pages).each do |page|
	     page_url = UrlBuilder.build(repos_url, page, params[:sort], params[:order])
	     client.register_request page_url do |json|
		 items[page] = json["items"]
      	     end
     	 end
    	 client.run_requests
	 items.compact.flatten
     end
  end
end
