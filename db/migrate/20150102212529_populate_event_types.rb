class PopulateEventTypes < ActiveRecord::Migration[4.2]
  def up
    EventType.transaction do
      [ 'New hire', 'Individual', 'Group' ].each { |t| EventType.create!(title: t) }
      group = EventType.find_by_title('Group')
      Event.where(event_type_id: nil).find_each { |e| e.update_attributes!(type: group) }
    end
  end

  def down
    [ 'New hire', 'Individual', 'Group' ].each { |t| EventType.find_by_title(t).destroy! }
  end
end
