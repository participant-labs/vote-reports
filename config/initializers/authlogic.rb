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

  module Session # :nodoc:
    module ValidationWhichDoesntBlowUp
      def valid?
        errors.clear
        self.attempted_record = nil

        before_validation
        new_session? ? before_validation_on_create : before_validation_on_update
        validate
        ensure_authentication_attempted

        if errors.size == 0
          new_session? ? after_validation_on_create : after_validation_on_update
          after_validation
        end

        errors.size == 0
      end
    end

    # This is the base class Authlogic, where all modules are included. For information on functiionality see the various
    # sub modules.
    class Base
      include ValidationWhichDoesntBlowUp
    end
  end
end
