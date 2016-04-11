module ApplicationHelper

	def time_ago_or_date(date, max_ago=2.days.ago, format="%B %d, %Y")
		if date < max_ago
			date.strftime(format)
		else
			time_ago_in_words(date) + " ago"
		end
	end

end
