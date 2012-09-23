require 'github_api'

class HubEvents
  class << self
    def client
      Github::Events.new
    end

    def events_for_user(name)
      events = client.performed(name)
      pushes = events.select{|x| x.type == 'PullRequestEvent' }
      comments = events.select{|x| x.type == 'IssueCommentEvent' }
      [pushes, comments].flatten[0..4]
    end
    
    def team_events
      res = {}
      %w(shell orendon jeffreybiles balauru timmatheson).each do |user|
        res[user] = events_for_user(user)
      end
      res
    end
  end
end