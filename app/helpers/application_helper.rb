module ApplicationHelper
	def nav_link(path, html_options = {}, &block)
		current = if path == '/'
								request.path == '/'
							else
								request.path.starts_with?(path)
							end

		active_class = current ? 'bg-white text-gray-700' : 'text-gray-300'
		html_options[:class] = "#{html_options[:class] || ''} text-sm font-medium #{active_class}".strip
		link_to path, html_options, &block
	end

	def sortable(column, title = nil)
		title ||= column.titleize
		direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"

		icon = if column == params[:sort]
				params[:direction] == "asc" ? "▲" : "▼"
				else
				"⇅" # Neutral icon when not sorted
				end

		link_to request.params.merge(sort: column, direction: direction, page: nil), class: "inline-flex items-center gap-1 hover:underline" do
			content_tag(:span, title) +
			content_tag(:span, icon, class: "text-xs text-gray-500")
		end
	end

end
