def route_matches(path, method, params)
  it "maps #{params.inspect} to #{path.inspect}" do
    expect(method => path).to route_to(params)
  end
end
