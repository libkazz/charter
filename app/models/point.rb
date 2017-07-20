module Point
  class Base
    def initialize(type: '', content: [])
      @type = type
      @content = content
    end

    def title
      @type
    end

    def body
      @content.join('<br>').html_safe
    end

    def to_partial_path
      'points/point'
    end
  end

  # 問題点
  class Issue < Base
  end

  # 目的
  class Objective < Base
  end

  # KPI
  class Kpi < Base
  end

  # Todo
  class Todo < Base
    def list
      Nokogiri::HTML.parse(body).search('li').map { |li| ::Todo.new(li.text.strip) }
    end
  end

  class << self
    MAP = {
      '問題' => Issue,
      'KPI' => Kpi,
      '目的' => Objective,
      'Todo' => Todo
    }.freeze

    def build(type: '', content: [])
      (MAP[type] || Base).new(type: type, content: content)
    end
  end
end
