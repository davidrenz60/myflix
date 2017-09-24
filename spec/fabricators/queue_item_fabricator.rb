Fabricator(:queue_item) do
  video
  user
  position { QueueItem.count + 1 }
end