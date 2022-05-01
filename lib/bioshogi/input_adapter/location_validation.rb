# frozen-string-literal: true

module Bioshogi
  module InputAdapter
    concern :LocationValidation do
      def hard_validations
        super

        if location_info
          if player.location_info != location_info
            errors_add DifferentTurnCommonError, "#{player.call_name}の手番で#{player.opponent_player.call_name}が着手しました"
          end
        end
      end

      private

      def location_info
        LocationInfo.fetch_if(input[location_key])
      end
    end
  end
end
