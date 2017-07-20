class ProjectDefinition < Github::Client
  REPOS = "#{ENV['ORGANIZATION_NAME']}/#{ENV['PROJECT_NAME']}".freeze
  PROJECT_LABEL = 'Epic'.freeze

  class << self
    def all
      issues(REPOS, labels: PROJECT_LABEL).map { |i| new(i) }
    end

    def find(id)
      new(issue(REPOS, id))
    end
  end

  delegate :title, :body, :number, :labels, :milestone, to: :issue
  attr_reader :issue

  def initialize(issue)
    @issue = issue
  end

  def to_partial_path
    'project'
  end

  def doc
    CommonMarker.render_doc(issue.body)
  end

  def points
    @points ||= parse_doc(doc).map { |n| Point.build(n) }
  end

  def points_with_hash
    points.each_with_object({}) do |point, c|
      c[point.class.name.underscore.sub('point/', '')] = point
    end
  end

  %w(issue objective kpi todo).each do |point|
    define_method point.pluralize do
      points[point]
    end
  end

  def github_url
    "https://github.com/#{REPOS}/issues/#{number}"
  end

  private

  def parse_doc(doc)
    [].tap do |c|
      doc.each do |node|
        if node.type == :header && node.header_level == 1
          c << { type: node.to_plaintext.chomp, content: [] }
        else
          c << { type: :base, content: [] } unless c.last
          c.last[:content] << node.to_html.chomp
        end
      end
    end
  end
end
