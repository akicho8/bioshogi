# frozen-string-literal: true

module Warabi
  module InputAdapter
    concern :LocationValidation do
      def perform_validations
        super

        if location
          if player.location != location
            raise DifferentTurnCommonError, "#{player.call_name}の手番で#{player.flip_player.call_name}が着手しました"
          end
        end
      end

      private

      def location
        Location.fetch_if(input[location_key])
      end
    end
  end
end
