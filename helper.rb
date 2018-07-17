class Helper
  def self.slug(title)
    title.downcase.strip.tr(' ', '-').gsub(/[^\w-]/, '').slice(0,40)
  end
end
