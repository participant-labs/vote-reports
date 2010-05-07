class Moonshine::Manifest::Rails < Moonshine::Manifest
  def validate_platform
    Facter.loadfacts
    unless Facter.lsbdistid == 'Ubuntu' && Facter.lsbdistrelease.to_f >= 8.04
      raise NotImplementedError, <<-ERROR

      Moonshine::Manifest::Rails is currently only supported on Ubuntu 8.04
      or greater. If you'd like to see your favorite distro supported, fork
      Moonshine on GitHub!
      ERROR
    end
  end
end
