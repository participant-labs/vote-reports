module Denyhosts

  # Define options for this plugin via the <tt>configure</tt> method
  # in your application manifest:
  #
  #   configure(:denyhosts => {:foo => true})
  #
  # Then include the plugin and call the recipe(s) you need:
  #
  #  plugin :denyhosts
  #  recipe :denyhosts
  def denyhosts(options = {})
    package 'denyhosts', :ensure => :installed
    service 'denyhosts', :ensure => :running, :enable => true, :require => package('denyhosts')

    file '/etc/denyhosts.conf',
      :content => template(File.join(File.dirname(__FILE__), '..', 'templates', 'denyhosts.conf'), binding),
      :mode => '644',
      :require => package('denyhosts'),
      :notify => service('denyhosts')
  end

end
