class JiraIssue
  def initialize(csv_values)
    @values = csv_values
  end

  def done?
    state == 'Done'
  end

  def bug?
    @values[4] == 'Bug'
  end

  def epic?
    @values[4] == 'Epic'
  end

  def state
    @values[4]
  end

  def title
    @values[0]
  end

  def body
    (@values[27]).to_s
  end

  def jira_key
    @values[1]
  end

  def labels
    []
  end

  def assignee
    return nil

    'jmadkins'
  end

  def to_s
    "#{title} - #{jira_key}"
  end

  def to_params
    {
      title: to_s,
      body: body,
      assignee: assignee,
      labels: labels
    }
  end
end
