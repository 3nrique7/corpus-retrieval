module GithubConsumer
  extend self

  def get_readmes(query)
    repositories_urls = RepositoriesSearcher.get_all_repositories_urls(query)
    ReadmesSearcher.get_readmes_of_repositories(repositories_urls)
  end

  #Function added to get the description
  def get_descriptions(query)
    descriptions = DescriptionSearcher.get_all_description(query)
    #We convert the string stored in json
    elements = descriptions.each_with_index do |element,i|
       descriptions[i] = JSON.parse(element) 
    end
    [
      {
        filename: "Descriptions.json",
	content: elements.to_json,
      }
    ]          	
  end

  def get_issues(query)
    issues = IssuesSearcher.get_all_issues(query)
    [
      {
        filename: "issues.json",
        content: JSON.dump(issues),
      }
    ]
  end
end

