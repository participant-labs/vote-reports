module Vote::Support
  def supported
    where("votes.vote = '+'")
  end
  alias supporting supported

  def opposed
    where("votes.vote = '-'")
  end
  alias opposing opposed
end
