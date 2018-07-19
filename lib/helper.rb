class Helper
  def self.slug(title)
    title.downcase.strip.tr(' ', '-').gsub(/[^\w-]/, '')
  end
end
