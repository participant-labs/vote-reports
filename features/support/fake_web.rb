module FakeWebSupport
  require Rails.root.join('spec/support/fake_web')
end

World(FakeWebSupport)
