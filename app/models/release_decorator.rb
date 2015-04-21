class ReleaseDecorator
  def initialize(json)
    @json = json
  end

  def artists
    @json['basic_information']['artists'].map { |a| a['name'] }.join(', ')
  end

  def title
    @json['basic_information']['title']
  end

  def discogs_id
    @json['basic_information']['id']
  end

  def text
    "#{artists} - #{title}"
  end
end