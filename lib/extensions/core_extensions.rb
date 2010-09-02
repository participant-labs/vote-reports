class String
  def ellipsize(len = 9)
    len -= 3
    gsub(%r{(.{#{len / 2}}).*(.{#{len / 2}})}, '\1...\2')
  end
end
