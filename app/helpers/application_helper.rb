module ApplicationHelper
	def nav_link(path, html_options = {}, &block)
		current = if path == '/'
								request.path == '/'
							else
								request.path.starts_with?(path)
							end

		active_class = current ? 'bg-white text-gray-900' : 'text-gray-300'
		html_options[:class] = "#{html_options[:class] || ''} text-sm font-medium #{active_class}".strip
		link_to path, html_options, &block
	end

	def sortable(column, title = nil)
		title ||= column.titleize
		direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
		icon = if column == params[:sort]
				params[:direction] == "asc" ? "▲" : "▼"
				else
				""
				end
		link_to "#{title} #{icon}".html_safe, request.params.merge(sort: column, direction: direction, page: nil)
	end
end
