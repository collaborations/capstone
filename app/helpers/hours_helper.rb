module HoursHelper

  # Use parameter if provided, otherwise use instance variable.
  # 
  # Any individual institution pages can use the instance variable, however if
  # there is a loop over multiple institutions (institutions#list), it needs to
  # be provided.
  # 
  # This is absolutely terrible code, but it works for right now.
  def getHours(institution_id = nil)
    # Need to set to false in case of looping in a view
    @hours_present = false
    @open = false

    id = (institution_id.present?) ? institution_id : @institution.id
    time_format_print = t('hours.time_format.print')
    time_format_compare = t('hours.time_format.compare')
    weekdays = [:sun, :mon, :tue, :wed, :thu, :fri, :sat]

    h = Hours.where(institution_id: id).first
    temp = [ 
              [ h[:sun_open], h[:sun_close] ],
              [ h[:mon_open], h[:mon_close] ],
              [ h[:tue_open], h[:tue_close] ],
              [ h[:wed_open], h[:wed_close] ],
              [ h[:thu_open], h[:thu_close] ],
              [ h[:fri_open], h[:fri_close] ],
              [ h[:sat_open], h[:sat_close] ]
           ]

    hours = []
    work_days = Hash.new

    temp.each_with_index do |t, i|
      open = (t[0].present?) ? t[0] : nil
      close = (t[1].present?) ? t[1] : nil

      if open.present? and close.present?
        @hours_present = true
        hours << open.strftime(time_format_print) + "-" + close.strftime(time_format_print)
        work_days[weekdays[i]] = [open.strftime(time_format_compare), close.strftime(time_format_compare)]
      else
        hours << "Closed"
      end
    end
    BusinessTime::Config.new
    BusinessTime::Config.work_hours = work_days
    puts BusinessTime::Config.work_hours.to_s

    # Whether the institution is currently open
    if @hours_present
      @open = Time.now.during_business_hours?
      @hours = hours
    end
    return hours
  end
end
