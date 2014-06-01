module ApplicationHelper

  # json return format
  def self.jsonResponseFormat(responseCode, responseMessage, result)
    return { :responseCode => responseCode,
             :responseMessage => responseMessage,
             :result => result }
  end

end
