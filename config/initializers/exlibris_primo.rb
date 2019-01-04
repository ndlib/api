module Exlibris
  module Primo
    class RequestLinks < Link; end
  end
end

module Exlibris
  module Primo
    module Pnx
      #
      # Handle links in links tags.
      #
      module Links

        def request_links
          @request_links ||=
            links("linktorequest").collect { |link_attributes|
              Exlibris::Primo::RequestLinks.new link_attributes }
        end
      end
    end
  end
end
