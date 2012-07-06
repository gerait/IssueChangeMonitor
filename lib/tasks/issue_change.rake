namespace :issue_change_monitor do
  desc "Mark all as read"
  task :mark_all_read => :environment do
    puts "Mark all as read..."
    begin
      count = 0
      transaction_count = 0
      Project.active.each do |project|
        members = project.members
        project.issues.includes(:status).where(["#{IssueStatus.table_name}.is_closed = ?", false]).find_each do |issue|
          members.each do |member|
            if transaction_count == 0
              IssueChange.connection.begin_db_transaction
              IssueChange.connection.increment_open_transactions
            end
            issue_change = IssueChange.where(:issue_id => issue.id, :member_id => member.id).first ||
                           IssueChange.create(:issue_id => issue.id, :member_id => member.id, :updated => false)
            puts "Error member #{member.id} of issue #{issue.id}: #{issue_change.errors.full_messages}" unless issue_change.errors.blank?
          
            transaction_count += 1
            count += 1
            if transaction_count == 10
              IssueChange.connection.decrement_open_transactions
              IssueChange.connection.commit_db_transaction
              puts "Updated #{count} issue changes"
              transaction_count = 0
            end
          end
        end
      end
      IssueChange.connection.decrement_open_transactions
      IssueChange.connection.commit_db_transaction
    rescue => e
      puts "ERROR!!! Next exception occurred #{e.inspect} #{e.backtrace}"
      raise
    end
    puts "Updated all finished"
  end
end