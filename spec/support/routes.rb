def route_matches(path, method, params)
  it "maps #{params.inspect} to #{path.inspect}" do
    params.should route_to(method => path)
  end
end
