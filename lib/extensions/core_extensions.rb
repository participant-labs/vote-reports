class String
  def ellipsize(len = 9)
    return self if size <= len || size <= 3
    len -= 3
    gsub(%r{(.{#{(len + 1) / 2}}).*(.{#{len / 2}})}, '\1...\2')
  end
end
