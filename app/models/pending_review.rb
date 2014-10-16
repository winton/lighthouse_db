class PendingReview
  class << self
    def notify
      pending_reviews = older_than_a_day
      alerts_sent = 0
      alerts_sent = send_alerts_for(pending_reviews) if pending_reviews
    end

    def older_than_a_day
      pending_reviews = GithubIssue
        .where('issue_updated_at > ?', DateTime.now.last_week(:friday))
        .joins(:lighthouse_ticket)
          .merge(LighthouseTicket
            .where(state: 'pending-review'))
            .order('issue_updated_at asc')

      pending_reviews.keep_if { |issue| issue.lighthouse_ticket.time_in_review >= 1.days }
    end

    def send_alerts_for(pending_reviews)
      urgent = "urgent-all: #{pending_reviews.length} tickets have been pending-review for more than 24 hours."
      Slack.post(urgent)

      alerts_sent = 0

      pending_reviews.each do |issue|
        message = "#{issue.lighthouse_ticket.milestone} - <#{issue.url}|#{issue.title_without_long_words}>"
        Slack.post(message)
        alerts_sent += 1
        sleep(1.minutes)
      end

      alerts_sent
    end
  end
end
