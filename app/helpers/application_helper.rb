# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def document_write(&block)
      output=capture(&block).rstrip
      buf=""
      output.each do |x|
        next if x.blank?
        buf << 'document.write("' + escape_javascript(x) + '");' + "\n"
      end
      concat(buf,block.binding)
    end
end
