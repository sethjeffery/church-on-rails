class Google::Apis::CalendarV3::Event
  attr_accessor :calendar_index

  def start_time
    if start.date_time
      start.date_time
    else
      start.date
    end
  end

  def end_time
    if self.end.date_time
      self.end.date_time
    else
      self.end.date.to_date - 1.day
    end
  end

  def all_day?
    start.date_time.blank? && start.date.present?
  end

  def simple_time
    if start_time.strftime('%M') == '00'
      start_time.strftime('%-I%P')
    else
      start_time.strftime('%-I.%M%P')
    end
  end
end
