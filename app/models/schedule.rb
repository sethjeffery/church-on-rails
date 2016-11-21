class Schedule < Schedulable::Model::Schedule
  def recurring?
    rule != 'singular'
  end

  def next_datetime
    (next_occurrence || (date.to_datetime + time&.seconds_since_midnight.to_i.seconds)).to_datetime
  end
end
