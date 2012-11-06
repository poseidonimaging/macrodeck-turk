namespace :macrodeck do
	namespace :mturk do
		desc "Creates pending HITs"
		task :create_hits do
			# Create the new question.
			SpecialPhoto.view("by_turk_unanswered", :reduce => false, :include_docs => true).each do |obj|
				puts "#{obj.id}:"

				# Create a new HIT type for the pending question.
				hit_type = RTurk::RegisterHITType(:title => "Answer a Question (#{obj.title})", :description => "You must answer a single question.", :reward => @cfg.turk_reward, :currency => "USD")

				# Build the notification structure.
				notification = RTurk::Notification.new
				notification.transport = 'REST'
				notification.destination = "#{@cfg.base_url}/turk/notification_receptor"
				notification.event_type = %w{AssignmentAccepted AssignmentAbandoned AssignmentReturned AssignmentSubmitted HITReviewable HITExpired}

				# Subscribe to notifications.
				RTurk::SetHITTypeNotification(:hit_type_id => hit_type.type_id, :notification => notification, :active => true)

				obj.pending_turk_tasks.each do |tt|
					if tt.prerequisites.length == 0
						puts "- #{tt.id}: #{tt.title}"
						hit = RTurk::Hit.create do |h|
							h.hit_type_id = hit_type.type_id
							h.assignments = 2
							h.lifetime = 604800
							h.note = { "item_id" => obj.id, "path" => "/" + tt.id }.to_json
							h.question("#{@cfg.base_url}/turk/#{obj.id}")
							h.hit_review_policy("SimplePlurality/2011-09-01", @cfg.hit_review_policy_defaults)
						end
						puts hit.inspect
					end
				end
			end
		end
	end
end
