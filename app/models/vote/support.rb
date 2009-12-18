module Vote::Support
  def supported
    scoped(:conditions => "votes.vote = '+'")
  end
  alias supporting supported

  def opposed
    scoped(:conditions => "votes.vote = '-'")
  end
  alias opposing opposed
end