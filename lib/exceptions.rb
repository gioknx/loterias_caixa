module LoteriasCaixa
  class ContestNotFound < StandardError
    def initialize(msg="I couldn't reach the contest you're looking for")
      super
    end
  end
end
