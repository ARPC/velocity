Groupdate.week_start = :thu
Time.now.dst? ? Groupdate.day_start = 17 : Groupdate.day_start = 18
# Day starts at 1:00PM Eastern time, which is 5:00PM UTC (17:00) during daylight savings, 18:00 when not daylight savings
