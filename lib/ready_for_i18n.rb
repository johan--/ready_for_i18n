class I18nExtractor
  ERB_TAG = /<%(.*?)%>/
  HTML_TAG = /<(.*?)>/
  SEPERATOR = '_@@@_'
  SKIP_TAGS = [[/<script/i,/<\/script>/i],[/<%/,/%>/],[/<style/i,/\/style>/i]]
 
  def initialize(filename)
    @filename = filename
    @stack = []
    @result = []
  end
 
  def extract
    File.open(@filename).each_with_index do |line,i|
      next if in_script_block?(line)
      text = line.gsub(ERB_TAG, SEPERATOR).gsub(HTML_TAG,SEPERATOR).strip
      arr = text.split SEPERATOR
      arr.each { |e| @result << [i+1,e.strip] if e.strip.size > 1  }
    end
    @result
  end
 
private
  def in_script_block?(s)
    return true if s.nil? || s.strip.size == 0 
    jump_in_tag = SKIP_TAGS.find{ |start_tag,end_tag| s =~ start_tag}
    @stack.push jump_in_tag[1] if jump_in_tag
    if @stack.last
      end_tag_match = s.match(@stack.last) 
      if end_tag_match
        @stack.pop 
        return in_script_block?(end_tag_match.post_match)
      end
    end
    return !@stack.empty?
  end
 
end
 

