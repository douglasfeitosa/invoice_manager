module API
  class APIController < APIController
    prepend_before_action :authenticate!
  end
end
