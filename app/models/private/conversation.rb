class Private::Conversation < ApplicationRecord
	has_many :messages, class_name: "Private::Message", foreign_key: :conversation_id
	belongs_to :sender, class_name: "User", foreign_key: :sender_id
	belongs_to :recipient, class_name: "User", foreign_key: :recipient_id

	scope :between_users, -> (user1_id, user2_id) do
	  where(sender_id: user1_id, recipient_id: user2_id).or(
	    where(sender_id: user2_id, recipient_id: user1_id)
	  )
	end

	def opposed_user(user)
	  user == recipient ? sender : recipient
	end
end
