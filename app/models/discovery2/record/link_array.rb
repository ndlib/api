class Discovery2::Record::LinkArray
  include Enumerable

  attr_reader :links
  private :links

  delegate :each,
    :delete,
    :unshift,
    :uniq!,
    :first,
    :last,
    to: :links

  def initialize
    @links = []
  end

  def push(*args)
    links.push(*args)
    self
  end
  alias_method :<<, :push

  def unshift(*args)
    links.unshift(*args)
    self
  end

  def merge(other_links)
    push(*other_links)
    deduplicate!
    self
  end

  def reverse_merge(other_links)
    links.unshift(*other_links)
    deduplicate!
    self
  end

  def deduplicate!
    links.uniq!{|link| "#{link.base_url}#{link.title}#{link.notes.join}" }
  end

  def link_hashes
    links.collect{|link| link.to_hash}
  end
end
