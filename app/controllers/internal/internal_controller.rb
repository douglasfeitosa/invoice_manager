module Internal
  class InternalController < ApplicationController
    prepend_before_action :authenticate!
  end
end
