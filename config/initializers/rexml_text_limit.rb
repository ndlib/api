# https://www.ruby-lang.org/en/news/2013/02/22/rexml-dos-2013-02-22/
# Setting the text limit to a larger value solves a "RuntimeError (entity expansion has grown too large)" when parsing large amounts of xml
if REXML::Document.respond_to?(:entity_expansion_text_limit)
  REXML::Document.entity_expansion_text_limit = 20480
end

