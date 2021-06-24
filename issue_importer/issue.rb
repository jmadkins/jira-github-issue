require 'csv'

class Issue
  def initialize(input)
    @input = CSV.parse(input)[0]
  end

  def owner
    @input[0]
  end

  def state; end

  def title
    @input[0]
  end

  def body
    (@input[28]).to_s
  end

  def assignee; end

  def labels
    ''
  end

  def owner
    'jmadkins'
  end

  def assignees
    ['jmadkins']
  end
end
