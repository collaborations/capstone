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
      open = t[0].present? ? t[0] : nil
      close = t[1].present? ? t[1] : nil

      if open.present? and close.present?
        @hours_present = true
        hours << open.strftime(time_format_print) + "-" + close.strftime(time_format_print)
        work_days[weekdays[i]] = [open.strftime(time_format_compare), close.strftime(time_format_compare)]
      else
        hours << "Closed"
      end
    end

    # Whether the institution is current open
    c_time = Time.now.strftime(time_format_compare)
    # h_today = temp[c_time.wday]

    # if h_today[0].present? and h_today[1].present?
    #   BusinessTime::Config.work_week = work_days
    #   BusinessTime::Config.beginning_of_workday = h_today[0].strftime(time_format_compare)
    #   BusinessTime::Config.end_of_workday = h_today[1].strftime(time_format_compare)
    # end
    
    
    @open = Time.parse(c_time).during_business_hours?

    puts "\n"*20
    puts "="*20
    puts work_days.to_json
    puts "\n"
    puts c_time
    puts "\n"
    puts Time.parse(c_time)
    puts "\n"
    puts BusinessTime::Config.work_week
    puts "="*20
    puts "\n"*20

    if hours.present?
      render 'shared/hours', hours: hours
    end
  end
end


# %div.row
#   %h5.columns.small-4.large-12= t('hours.default')
#   %div.columns.small-8.large-12
#     - if open
#       %p.label.success= t('hours.open')
#     - else
#       %p.label.alert= t('hours.closed')
