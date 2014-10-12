module Authlogic
  module Regex
    # Authlogic's implementation doesn't accept all the characters for the local section outlined in RFC 3696
    # https://github.com/Empact/authlogic/commit/52e8e0f6d63c97627ef3c0de7b77139292a04a7b
    def self.email
      @email_regex ||= begin
        email_name_regex  = %{[A-Z0-9!#$\%&'*+/=?^_`{|}~\\-.]+}
        domain_head_regex = '(?:[A-Z0-9\-]+\.)+'
        domain_tld_regex  = '(?:[A-Z]{2,13})'
        /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i
      end
    end
  end
end
