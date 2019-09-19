module Waff
  class Issue
    attr_reader :repository, :number, :title, :labels, :body

    def initialize(repository, data)
      @repository = repository
      @number = data['number']
      @title = data['title']
      @body = data['body']
      parse_labels data
    end

    def create_local_branch!
      branch_name = "#{number}-#{slug}"
      puts "Creating branch #{branch_name}"
      `git checkout -b '#{branch_name}'`
    end

    def assign_to_self!
      repository.assign_issue number
    end

    def mark_in_progress!
      labels.delete Config.ready_label
      labels << Config.in_progress_label
      labels.uniq!

      repository.export_labels self
    end

    def mark_ready!
      labels << Config.ready_label
      labels.delete Config.in_progress_label
      labels.uniq!

      repository.export_labels self
    end

    private

    def parse_labels(data)
      @labels = data['labels'].map { |label| label['name'] }
    end

    def slug
      title.downcase.strip.tr(' ', '-').gsub(/[^\w-]/, '')
    end
  end
end
