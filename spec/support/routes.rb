def route_matches(path, method, params)
  it "maps #{params.inspect} to #{path.inspect}" do
    {method => path}.should route_to(params)
  end
end
