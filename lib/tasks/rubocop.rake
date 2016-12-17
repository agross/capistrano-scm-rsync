require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = %w(--format html --out build/lint/rubocop/rubocop.html
                 --format progress)
  t.verbose = true
end
