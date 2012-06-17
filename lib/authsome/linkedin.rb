require 'linkedin'

class AuthsomeLinkedin

  def initialize(keys)
    @client = LinkedIn::Client.new(keys["api"], keys["secret"])
    @client.authorize_from_access(keys["keypair"][0], keys["keypair"][1])  
  end

  def getSummary
    return @client.profile(:fields => %w(first-name last-name headline location specialties educations positions picture-url summary))
  end

end