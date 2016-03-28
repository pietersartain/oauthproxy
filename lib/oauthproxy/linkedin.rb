require 'linkedin'

class OauthproxyLinkedin

  def initialize(keys)
    @client = LinkedIn::Client.new(keys["api"], keys["secret"])
    @client.authorize_from_access(keys["keypair"][0], keys["keypair"][1])  
  end

  def linkedin_getSummary
    summary = @client.profile(:fields => %w(first-name last-name headline location specialties positions picture-url summary))

    summary['summary'].gsub!("\n",'<br />')

    summary['positions']['all'].each do |p|
      p['summary'].gsub!("\n",'<br />')
    end

    return summary
  end

end