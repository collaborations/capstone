module HoursHelper

  # Use parameter if provided, otherwise use instance variable.
  # 
  # Any individual institution pages can use the instance variable, however if
  # there is a loop over multiple institutions (institutions#list), it needs to
  # be provided.
  # 
  # This is absolutely terrible code, but it works for right now.
  def getHours(institution_id = nil)
    @hours_present = false  # Need to set to false in case of looping in a view
    id = (institution_id.present?) ? institution_id : @institution.id
    time_format = t('hours.time.format')
    _days = Date::DAYNAMES

    h = Hours.where(institution_id: id).first
    hours = []
    temp = [ 
              [ h[:sun_open], h[:sun_close] ],
              [ h[:mon_open], h[:mon_close] ],
              [ h[:tue_open], h[:tue_close] ],
              [ h[:wed_open], h[:wed_close] ],
              [ h[:thu_open], h[:thu_close] ],
              [ h[:fri_open], h[:fri_close] ],
              [ h[:sat_open], h[:sat_close] ]
           ]
    
    temp.each_with_index do |t, i|
      open = t[0].present? ? t[0].strftime(time_format) : nil
      close = t[1].present? ? t[1].strftime(time_format) : nil
      if open.present? and close.present?
        @hours_present = true
        hours << open + "-" + close
      else
        hours << "Closed"
      end
    end

    # Whether the institution is current open
    c_time = Time.now
    h_today = temp[c_time.wday]

    if h_today[0].present? and h_today[1].present?
      BusinessTime::Config.work_week = [:sun, :mon, :tue, :wed, :thu, :fri, :sat]
      BusinessTime::Config.beginning_of_workday = h_today[0].strftime(time_format)
      BusinessTime::Config.end_of_workday = h_today[1].strftime(time_format)
    end
    open = c_time.during_business_hours?

    if hours.present?
      render 'shared/hours', hours: hours, open: open
    end
  end
end
