module Authlogic
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
