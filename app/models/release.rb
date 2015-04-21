class Release
  def self.fetch(release_id, discogs)
    self.new JSON.parse(discogs.get(
      "https://api.discogs.com/releases/#{release_id}",
      {"User-Agent" => "BuyOrNot"}
    ).body)
  end

  def initialize(json)
    @json = json
  end

  def discogs_url
    @json['uri']
  end
end
