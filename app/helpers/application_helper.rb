module ApplicationHelper
	# def nav_link(name, path)
	# 	class_name = current_page?(path) ? 'bg-gray-700 text-white' : 'text-gray-300 hover:bg-gray-700 hover:text-white'
	# 	link_to name, path, class: "px-3 py-2 rounded-md text-sm font-medium #{class_name}"
	# end

	def nav_link(path, html_options = {}, &block)
		active_class = current_page?(path) ? 'bg-white' : 'text-gray-300'
		html_options[:class] = "#{html_options[:class] || ''} text-sm font-medium #{active_class}".strip
	  
		link_to path, html_options, &block
	end	  
  
end
