class CollectionDecorator
  def initialize(json)
    @json = JSON.parse(json)
  end

  def essentials
    {
      total: total,
      page: page,
      total_pages: total_pages,
      num: num,
      releases: release_essentials
    }
  end

  def release_essentials
    releases.map { |r|
      { artists: r.artists, title: r.title }
    }
  end

  def total
    @json['pagination']['items']
  end

  def page
    @json['pagination']['page']
  end

  def total_pages
    @json['pagination']['pages']
  end

  def num
    releases.count
  end

  def releases
    @releases ||= @json['releases'].map { |r| ReleaseDecorator.new(r) }
  end
end